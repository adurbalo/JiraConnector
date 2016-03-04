//
//  NetworkManager.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "Models.h"

typedef void(^ResponseWithObjectBlock)(id responseObject, NSError *error);
typedef void(^ResponseWithArrayBlock)(NSArray *responseArray, NSError *error);

@interface NetworkManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(NetworkManager, sharedManager)

@property(nonatomic, strong) NSString *jiraServerBaseUrlString;

-(NSString*)login;
-(NSString*)pass;
-(void)removeCredentials;

-(NSURLSessionDataTask*)loginToJiraWithLogin:(NSString*)login andPassword:(NSString*)password completionBlock:(void (^)(id responseObject, NSError* error))completionBlock;

/*[Project]*/
-(NSURLSessionDataTask*)receiveProjectsCompletionBlock:(ResponseWithArrayBlock)completionBlock;
/*[IssueType]*/
-(NSURLSessionDataTask*)issueTypesCompletionBlock:(ResponseWithArrayBlock)completionBlock;
/*[Priority]*/
-(NSURLSessionDataTask*)issuePrioritiesCompletionBlock:(ResponseWithArrayBlock)completionBlock;
/*[User]*/
-(NSURLSessionDataTask*)issueAssignableSearchForProject:(NSString*)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock;
/*Issue*/
-(NSURLSessionDataTask*)issueByKey:(NSString*)issueKey completionBlock:(ResponseWithObjectBlock)completionBlock;
-(NSURLSessionDataTask*)createIssue:(Issue*)issue completionBlock:(ResponseWithObjectBlock)completionBlock;
/*[Version]*/
-(NSURLSessionDataTask *)versionsForProject:(NSString *)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock;
/*[Component]*/
-(NSURLSessionDataTask *)componentsForProject:(NSString *)projectKey completionBlock:(ResponseWithArrayBlock)completionBlock;
/*[Attachment]*/
-(NSURLSessionDataTask *)addAttachments:(NSArray<JiraAttachment *>*)attachments toIssueWithKey:(NSString *)issueKey completionBlock:(ResponseWithArrayBlock)completionBlock;

@end
