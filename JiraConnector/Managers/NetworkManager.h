//
//  NetworkManager.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "IssueTypeList.h"
#import "ProjectList.h"
#import "PriorityList.h"

@interface NetworkManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(NetworkManager, sharedManager)

@property(nonatomic, strong) NSString *jiraServerBaseUrlString;

-(BOOL)isUserAuthorized;

-(NSOperation*)loginToJiraWithLogin:(NSString*)login andPassword:(NSString*)password completionBlock:(void (^)(id responseObject, NSError* error))completionBlock;

-(NSOperation*)receiveProjectsCompletionBlock:(void (^)(ProjectList *responseObject, NSError* error))completionBlock;

//Issue Prepearing
-(NSOperation*)issueTypesCompletionBlock:(void (^)(IssueTypeList *responseObject, NSError* error))completionBlock;
-(NSOperation*)issuePrioritiesCompletionBlock:(void (^)(PriorityList *responseObject, NSError* error))completionBlock;

@end
