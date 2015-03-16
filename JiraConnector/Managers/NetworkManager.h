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

-(BOOL)isUserAuthorized;

-(NSOperation*)loginToJiraWithLogin:(NSString*)login andPassword:(NSString*)password completionBlock:(void (^)(id responseObject, NSError* error))completionBlock;

/*[Project]*/
-(NSOperation*)receiveProjectsCompletionBlock:(ResponseWithArrayBlock)completionBlock;

//Issue Prepearing
-(NSOperation*)issueTypesCompletionBlock:(ResponseWithArrayBlock)completionBlock;
-(NSOperation*)issuePrioritiesCompletionBlock:(ResponseWithArrayBlock)completionBlock;

@end
