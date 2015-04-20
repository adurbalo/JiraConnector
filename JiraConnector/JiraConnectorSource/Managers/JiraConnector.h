//
//  JiraConnector.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/16/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "JiraAttachment.h"

typedef NSArray* (^AddCustomAttachmentsBlock)();

@interface JiraConnector : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(JiraConnector, sharedManager)

/**
 Predefined Project Key
 */
@property(nonatomic, readonly) NSString *predefinedProjectKey;

/**
 Attachments for current create issue dialog
 @return Array with JiraAttachment objects.
 */
@property(nonatomic, readonly) NSArray *attachments;

/**
 Ability call create issue dialog using device motion
 */
@property(nonatomic) BOOL enableDetectMotion;

/**
 Sensitivity of handling device motion. Default value - 10
 */
@property(nonatomic) double motionSensitivity;

/**
 Ability to create screenshot and adding it to attachments list
 */
@property(nonatomic) BOOL enableScreenCapturer;

/**
 A block define custom attachments, which will be added to issue
 @return Array with JiraAttachment objects.
 */
@property(nonatomic, copy) AddCustomAttachmentsBlock customAttachmentsBlock;

/**
 Common configuration for JiraConnector
 
 @param baseUrl The web address of your JIRA server. Examples: http://www.example.com:8080, http://jira.example.com ...
 @param projectKey Project with this key, will be on top of available projects list.
 */
-(void)configurateWithBaseURL:(NSString*)baseUrl andPredefinedProjectKey:(NSString*)projectKey;

/**
 Manually show create issue dialog
 
 @param completionBlock A block that defines end of showing animation.
 */
-(void)showWithCompletionBlock:(void(^)())completionBlock;

/**
 Manually hide create issue dialog
 
 @param completionBlock A block that defines end of hiding animation.
 */
-(void)hideWithCompletionBlock:(void(^)())completionBlock;

@end
