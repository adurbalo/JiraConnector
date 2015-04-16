//
//  NetworkManager.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};

@interface NetworkManager ()
{
    AFHTTPRequestOperationManager *_manager;
    dispatch_queue_t _mappingQueue;
}
@end

#define udLoginKey @"udJCLoginKey"
#define udPasswordKey @"udJCPasswordKey"

@implementation NetworkManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(NetworkManager, sharedManager)

-(instancetype)init
{
    self = [super init];
    if (self) {
        _mappingQueue = dispatch_queue_create("NetworkManager.mappingQueue", DISPATCH_QUEUE_CONCURRENT);
        [self setupRequestOperationManager];
    }
    return self;
}

- (void)setupRequestOperationManager
{
    NSString *serverUrlString = self.jiraServerBaseUrlString;
#warning HARDCODE HERE!!!
    
//#if TARGET_IPHONE_SIMULATOR
//    serverUrlString = @"http://localhost:8080";
//#else
//    serverUrlString = @"http://192.168.10.13:8080";
//#endif
    
    NSURL *baseURL = [NSURL URLWithString:serverUrlString];
    
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)configurateAuthorizationHeader
{
    [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[self login] password:[self pass]];
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
    [self setupRequestOperationManager];
}

#pragma mark - Private methods

- (void)handleResponse:(id)responseObject outputObjectClass:(Class)outputObjectClass forURLRequest:(NSURLRequest *)request callBlock:(void(^)(id response, NSError *error))responseBlock
{
    if ( responseBlock ){
        dispatch_async(_mappingQueue, ^{
            
            id resultObject = nil;
            NSError *error = nil;
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                resultObject = [MTLJSONAdapter modelsOfClass:outputObjectClass fromJSONArray:responseObject error:&error];
            } else {
                resultObject = [MTLJSONAdapter modelOfClass:outputObjectClass fromJSONDictionary:responseObject error:&error];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(resultObject, error);
            });
        });
    }
}

- (void)handleError:(NSError*)error forRequestOperation:(AFHTTPRequestOperation *)operation callBlock:(ResponseWithObjectBlock)responseBlock
{
    NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
    if (responseString) {
        error = [[NSError alloc] initWithDomain:@"JiraConnector" code:-1 userInfo:@{NSLocalizedDescriptionKey : responseString}];
    }
    
    NSLog(@" <<<<<<<<<<< Failure Response: \n%@\n%@", error, operation.request);
    
    if (responseBlock) {
        responseBlock(nil, error);
    }
}

- (AFHTTPRequestOperation*)makeRequestWithMethod:(RequestMethod)method
                                         URLPath:(NSString *)urlPath
                                 inputParameters:(NSDictionary*)parameters
                            HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                               outputObjectClass:(Class)outputObjectClass
                                   responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:method URLPath:urlPath inputParameters:parameters useCredential:YES HTTPHeaderParameters:HTTPHeaderParameters outputObjectClass:outputObjectClass responseBlock:responseBlock];
}

- (AFHTTPRequestOperation*)makeRequestWithMethod:(RequestMethod)method
                                         URLPath:(NSString *)urlPath
                                 inputParameters:(NSDictionary*)parameters
                                   useCredential:(BOOL)useCredential
                            HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                               outputObjectClass:(Class)outputObjectClass
                                   responseBlock:(void (^)(id, NSError *))responseBlock
{
    return [self makeRequestWithMethod:method URLPath:urlPath inputParameters:parameters useCredential:useCredential HTTPHeaderParameters:HTTPHeaderParameters outputObjectClass:outputObjectClass contentContainer:nil responseBlock:responseBlock];
}

- (AFHTTPRequestOperation*)makeRequestWithMethod:(RequestMethod)method
                                         URLPath:(NSString *)urlPath
                                 inputParameters:(NSDictionary*)parameters
                                   useCredential:(BOOL)useCredential
                            HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                               outputObjectClass:(Class)outputObjectClass
                                contentContainer:(NSArray*)content
                                   responseBlock:(void (^)(id, NSError *))responseBlock

{
    void(^successBlock)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n <<<<<<<<<<< Success Response: \n%@\n%@\n\n", operation.response, responseString);
        [self handleResponse:responseObject outputObjectClass:(Class)outputObjectClass forURLRequest:operation.request callBlock:responseBlock];
    };
    void(^failureBlock)(AFHTTPRequestOperation*, NSError*) = ^(AFHTTPRequestOperation *operation, NSError *error) {
       [self handleError:error forRequestOperation:operation callBlock:responseBlock];
    };
    
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
    
    if (useCredential) {
        [self configurateAuthorizationHeader];
    }
//os_authType=basic
    [_manager.requestSerializer setValue:@"basic" forHTTPHeaderField:@"os_authType"];
    
    NSMutableURLRequest *request = [_manager.requestSerializer requestWithMethod:requestMethodString
                                                                                       URLString:[[NSURL URLWithString:urlPath relativeToURL:_manager.baseURL] absoluteString]
                                                                                      parameters:parameters
                                                                                           error:nil];
    
    
    [HTTPHeaderParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:successBlock failure:failureBlock];
    
    [_manager.operationQueue addOperation:operation];
    
    NSLog(@"\n\n >>>>>>>>>>>>>> Request: \n%@ %@\n\n", operation.request, [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    return operation;
}

#pragma mark ---


-(NSOperation*)loginToJiraWithLogin:(NSString*)login andPassword:(NSString*)password completionBlock:(void (^)(id responseObject, NSError* error))completionBlock
{
    [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:login password:password];
    
    return [_manager GET:@"/rest/auth/1/session" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:login forKey:udLoginKey];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:udPasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

-(NSOperation*)receiveProjectsCompletionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:@"/rest/api/2/project"
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                    outputObjectClass:[Project class]
                         responseBlock:completionBlock];
}


#pragma mark - Issue Prepearing

-(NSOperation*)issueTypesCompletionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:@"/rest/api/2/issuetype"
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                    outputObjectClass:[IssueType class]
                         responseBlock:completionBlock];
}

-(NSOperation*)issuePrioritiesCompletionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:@"/rest/api/2/priority"
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                    outputObjectClass:[Priority class]
                         responseBlock:completionBlock];
}

-(NSOperation *)issueAssignableSearchForProject:(NSString*)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (projectKey) {
        [params setObject:projectKey forKey:@"project"];
        [params setObject:@"10000" forKey:@"maxResults"];
    }
    
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:@"/rest/api/2/user/assignable/search"
                       inputParameters:params
                  HTTPHeaderParameters:nil
                     outputObjectClass:[User class]
                         responseBlock:completionBlock];
}

-(NSOperation*)issueByKey:(NSString*)issueKey completionBlock:(ResponseWithObjectBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:[NSString stringWithFormat:@"/rest/api/2/issue/%@", issueKey]
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Issue class]
                         responseBlock:completionBlock];
}

-(NSOperation*)createIssue:(Issue*)issue completionBlock:(ResponseWithObjectBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodPOST
                               URLPath:@"/rest/api/2/issue"
                       inputParameters:[MTLJSONAdapter JSONDictionaryFromModel:issue]
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Issue class]
                         responseBlock:completionBlock];
}

-(NSOperation *)versionsForProject:(NSString *)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:[NSString stringWithFormat:@"/rest/api/2/project/%@/versions?expand", projectKey]
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Version class]
                         responseBlock:completionBlock];
}

-(NSOperation *)componentsForProject:(NSString *)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock
{
    return [self makeRequestWithMethod:RequestMethodGET
                               URLPath:[NSString stringWithFormat:@"/rest/api/2/project/%@/components", projectKey]
                       inputParameters:nil
                  HTTPHeaderParameters:nil
                     outputObjectClass:[Component class]
                         responseBlock:completionBlock];
}

@end
