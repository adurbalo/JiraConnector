//
//  NetworkManager.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "NetworkManager.h"
#import "APIConstants.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};

@interface NetworkManager ()
{
    NSURLSession *_session;
    dispatch_queue_t _mappingQueue;
}
@end

static inline NSString* HTTPMethod(RequestMethod method)
{
    NSString *requestMethodString = nil;
    switch (method) {
        case RequestMethodGET:
            requestMethodString = @"GET";
            break;
        case RequestMethodPOST:
            requestMethodString = @"POST";
            break;
        case RequestMethodPUT:
            requestMethodString = @"PUT";
            break;
        case RequestMethodDELETE:
            requestMethodString = @"DELETE";
            break;
        default:
            break;
    }
    return requestMethodString;
}

#define udLoginKey @"udJCLoginKey"
#define udPasswordKey @"udJCPasswordKey"

@implementation NetworkManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(NetworkManager, sharedManager)

-(instancetype)init
{
    self = [super init];
    if (self) {
        _mappingQueue = dispatch_queue_create("NetworkManager.mappingQueue", DISPATCH_QUEUE_CONCURRENT);
        [self setupSession];
    }
    return self;
}

- (void)setupSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
}

-(NSString*)baseServerURLString
{
    return self.jiraServerBaseUrlString;
}

-(NSString *)login
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:udLoginKey];
}

-(NSString *)pass
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:udPasswordKey];
}

-(void)removeCredentials
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:udLoginKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:udPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setJiraServerBaseUrlString:(NSString *)jiraServerBaseUrlString
{
    _jiraServerBaseUrlString = jiraServerBaseUrlString;
    [self setupSession];
}

#pragma mark - Private methods

- (NSURLSessionDataTask *)makeRequestWithMethod:(RequestMethod)method
                                         URLPath:(NSString *)urlPath
                                 inputParameters:(NSDictionary*)parameters
                            HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                               outputObjectClass:(Class)outputObjectClass
                                   responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:method URLPath:urlPath inputParameters:parameters useCredential:YES HTTPHeaderParameters:HTTPHeaderParameters outputObjectClass:outputObjectClass responseBlock:responseBlock];
}

- (NSURLSessionDataTask *)makeRequestWithMethod:(RequestMethod)method
                                         URLPath:(NSString *)urlPath
                                 inputParameters:(NSDictionary*)parameters
                                   useCredential:(BOOL)useCredential
                            HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                               outputObjectClass:(Class)outputObjectClass
                                   responseBlock:(void (^)(id, NSError *))responseBlock
{
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [self URLwithPath:urlPath];
    request.HTTPMethod = HTTPMethod(method);
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (useCredential) {
        [self addCredentionalToURLRequest:request];
    }
    
    [self addParameters:parameters ToURLRequest:request];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handlerResponse:response data:data error:error objClass:outputObjectClass withCompletionBlock:responseBlock];
    }];
    [task resume];
    return task;
}

-(void)handlerResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error objClass:(Class)objClass withCompletionBlock:(void (^)(id, NSError *))completionBlock
{
    if (error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil, error);
            }
        });
        
    } else {
        
        NSError *jsonError = nil;
        id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:&jsonError];
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(nil, jsonError);
                }
            });
        } else {
            dispatch_async(_mappingQueue, ^{
                
                id resultObject = nil;
                NSError *error = nil;
                
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    resultObject = [MTLJSONAdapter modelsOfClass:objClass fromJSONArray:responseObject error:&error];
                } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSArray *errorMessages = [responseObject objectForKey:@"errorMessages"];
                    if ( [errorMessages isKindOfClass:[NSArray class]] && (errorMessages.count > 0) ) {
                        error = [[NSError alloc] initWithDomain:@"JiraConnector" code:-1 userInfo:@{NSLocalizedDescriptionKey : errorMessages.description?:@""}];
                    } else {
                        resultObject = [MTLJSONAdapter modelOfClass:objClass fromJSONDictionary:responseObject error:&error];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock) {
                        completionBlock(resultObject, error);
                    }
                });
            });
        }
    }
}

#pragma mark - Internal


-(NSURL*)URLwithPath:(NSString*)path
{
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:self.jiraServerBaseUrlString]];
}

-(void)addCredentionalToURLRequest:(NSMutableURLRequest*)request
{
    [self addCredentionalToURLRequest:request username:[self login] andPassword:[self pass]];
}

-(void)addCredentionalToURLRequest:(NSMutableURLRequest*)request username:(NSString *)username andPassword:(NSString *)password
{
    //os_authType=basic
    //    [_manager.requestSerializer setValue:@"basic" forHTTPHeaderField:@"os_authType"];
    
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *data = [basicAuthCredentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:kNilOptions];
    [request addValue:[NSString stringWithFormat:@"Basic %@", base64String] forHTTPHeaderField:@"Authorization"];
}

-(void)addParameters:(NSDictionary*)parameters ToURLRequest:(NSMutableURLRequest*)request
{
    if (!parameters) {
        return;
    }
    
    NSArray *HTTPMethodsEncodingParametersInURI = @[HTTPMethod(RequestMethodGET), HTTPMethod(RequestMethodDELETE)];
    
    if ( [HTTPMethodsEncodingParametersInURI containsObject:request.HTTPMethod] ) {
       
        NSMutableString *queryString = [NSMutableString new];
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (queryString.length == 0) {
                [queryString appendString:@"?"];
            } else {
                [queryString appendString:@"&"];
            }
            [queryString appendFormat:@"%@=%@", key, obj];
        }];
        
        request.URL = [NSURL URLWithString:queryString relativeToURL:request.URL];
       
    } else {
     
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:kNilOptions error:&error];
        if (error) {
            NSLog(@"Serialization parameters error: %@", error);
        } else {
            request.HTTPBody = data;
        }
    }
}

#pragma mark - Request

-(NSURLSessionDataTask*)loginToJiraWithLogin:(NSString*)login andPassword:(NSString*)password completionBlock:(void (^)(id responseObject, NSError* error))completionBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [self URLwithPath:kJCAuthPath];
    request.HTTPMethod = HTTPMethod(RequestMethodGET);
    [self addCredentionalToURLRequest:request username:login andPassword:password];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handlerResponse:response data:data error:error objClass:[Authorization class] withCompletionBlock:completionBlock];
    }];
    [task resume];
    return task;
}

-(NSURLSessionDataTask*)receiveProjectsCompletionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:kJCGetProjectPath
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                    outputObjectClass:[Project class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask*)issueTypesCompletionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:kJCGetIssueTypePath
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                    outputObjectClass:[IssueType class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask*)issuePrioritiesCompletionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:kJCGetPriorityPath
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                    outputObjectClass:[Priority class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask *)issueAssignableSearchForProject:(NSString*)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (projectKey) {
        [params setObject:projectKey forKey:@"project"];
        [params setObject:@"10000" forKey:@"maxResults"];
    }
    
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:kJCGetAssignablePath
                       inputParameters:params
                  HTTPHeaderParameters:nil
                     outputObjectClass:[User class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask*)issueByKey:(NSString*)issueKey completionBlock:(ResponseWithObjectBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:[NSString stringWithFormat:kJCGetIssueByKeyPath, issueKey]
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Issue class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask*)createIssue:(Issue*)issue completionBlock:(ResponseWithObjectBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodPOST
                               URLPath:kJCPostIssuePath
                       inputParameters:[MTLJSONAdapter JSONDictionaryFromModel:issue error:nil]
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Issue class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask *)versionsForProject:(NSString *)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:[NSString stringWithFormat:kJCGetVersionsForProjectPath, projectKey]
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Version class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask *)componentsForProject:(NSString *)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:[NSString stringWithFormat:kJCGetComponentsPath, projectKey]
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Component class]
                         responseBlock:completionBlock];
}

-(NSURLSessionDataTask *)addAttachments:(NSArray<JiraAttachment *>*)attachments toIssueWithKey:(NSString *)issueKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [self URLwithPath:[NSString stringWithFormat:kJCPostAttachmentsIssueByKeyPath, issueKey]];
    [request setHTTPMethod:HTTPMethod(RequestMethodPOST)];
    
    NSString *boundary = [self boundaryString];
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self addCredentionalToURLRequest:request];
    NSString *xAtlassianTokenKey = @"X-Atlassian-Token";
    [request setValue:@"nocheck" forHTTPHeaderField:xAtlassianTokenKey];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:[self createBodyWithBoundary:boundary forAttachments:attachments]];

    NSURLSessionDataTask *task = [_session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handlerResponse:response data:data error:error objClass:[Attachment class] withCompletionBlock:completionBlock];
    }];
    
    [task resume];
    return task;
}

- (NSString *)boundaryString
{
    NSString *uuidStr = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"Boundary-%@", uuidStr];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                    forAttachments:(NSArray<JiraAttachment*> *)attachment
{
    NSMutableData *httpBody = [NSMutableData data];
    
    for (JiraAttachment *ja in attachment) {
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"file", ja.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", ja.mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:ja.attachmentData];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

@end
