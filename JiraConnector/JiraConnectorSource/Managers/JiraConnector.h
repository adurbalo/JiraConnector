//
//  JiraConnector.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/16/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface JiraConnector : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(JiraConnector, sharedManager)

@property(nonatomic, readonly) NSString *predefinedProjectKey;
@property(nonatomic) BOOL enableDetectMotion;
@property(nonatomic) double motionSensivity;

-(void)configurateWithBaseURL:(NSString*)baseUrl andPredefinedProjectKey:(NSString*)projectKey;

-(void)showWithCompletionBlock:(void(^)())completionBlock;
-(void)hideWithCompletionBlock:(void(^)())completionBlock;

@end
