//
//  JiraConnector.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/16/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVAudioSession.h>
#import "JiraConnector.h"
#import "JCNavigationController.h"
#import "JCLoginViewController.h"
#import "NetworkManager.h"

@interface JiraConnector ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) UIWindow *jiraConnectorWindow;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *predefinedProjectKey;

@property (nonatomic, strong) JCNavigationController *navigationController;

@property (nonatomic) BOOL active;

@property (atomic, strong) NSMutableArray *currentAttachments;

@end

#define ANIMATION_DURATION 0.15

@implementation JiraConnector

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(JiraConnector, sharedManager)

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.motionManager = [[CMMotionManager alloc] init];
        
        self.jiraConnectorWindow = [[UIWindow alloc] init];
        self.jiraConnectorWindow.frame = [[UIScreen mainScreen] bounds];
        self.jiraConnectorWindow.windowLevel = UIWindowLevelAlert+1;
        self.jiraConnectorWindow.rootViewController = [[UIViewController alloc] init];
        
        JCLoginViewController *loginVC = [JCLoginViewController new];
        self.navigationController = [[JCNavigationController alloc] initWithRootViewController:loginVC];
        self.navigationController.view.autoresizingMask = UIViewAutoresizingNone;
        
        self.motionSensitivity = 10;
        
        self.currentAttachments = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)configurateWithBaseURL:(NSString *)baseUrl andPredefinedProjectKey:(NSString *)projectKey
{
    self.baseUrl = baseUrl;
    self.predefinedProjectKey = projectKey;
    
    [[NetworkManager sharedManager] setJiraServerBaseUrlString:baseUrl];
}

-(void)setEnableDetectMotion:(BOOL)enableDetectMotion
{
    _enableDetectMotion = enableDetectMotion;
    
    if (_enableDetectMotion) {
        
        __weak __typeof(self)weakSelf = self;
        
        self.motionManager.deviceMotionUpdateInterval = 0.1f;
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *data, NSError *error) {
                                                    
                                                    if ( (ABS(data.rotationRate.x) > weakSelf.motionSensitivity) || (ABS(data.rotationRate.y) > weakSelf.motionSensitivity) || (ABS(data.rotationRate.z) > weakSelf.motionSensitivity) ) {
                                                        
                                                        [[JiraConnector sharedManager] showWithCompletionBlock:nil];
                                                    }
                                                }];
    } else {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

-(NSArray *)attachments
{
    return self.currentAttachments;
}

#pragma mark - Public

-(void)showWithCompletionBlock:(void(^)())completionBlock
{
    if (self.active) {
        return;
    }
    
    self.active = YES;
    
    [self configurateAttachments];
    
    CGRect rootWindowVCRect = self.jiraConnectorWindow.rootViewController.view.bounds;
    
    CGFloat offset = 20.f;
    CGFloat maxWidth = 540.f;
    CGFloat maxHeight = 620.f;
    
    CGFloat width = MIN( CGRectGetWidth(rootWindowVCRect)-2*offset, maxWidth);
    CGFloat height = MIN( CGRectGetHeight(rootWindowVCRect)-2*offset, maxHeight);
    
    CGRect frame = CGRectMake( (CGRectGetWidth(rootWindowVCRect) - width)/2, CGRectGetHeight(rootWindowVCRect), width, height);
    self.navigationController.view.frame = frame;
    
    [self.jiraConnectorWindow.rootViewController.view addSubview:self.navigationController.view];
    
    [self.jiraConnectorWindow makeKeyAndVisible];
    
    frame.origin.y = (CGRectGetHeight(rootWindowVCRect) - height)/2;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.navigationController.view.frame = frame;
        self.jiraConnectorWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

-(void)hideWithCompletionBlock:(void(^)())completionBlock
{
    CGRect frame = self.navigationController.view.frame;
    
    frame.origin.y = CGRectGetHeight(self.jiraConnectorWindow.rootViewController.view.frame);
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.navigationController.view.frame = frame;
        self.jiraConnectorWindow.backgroundColor = [UIColor clearColor];
    
    } completion:^(BOOL finished) {
        
        [self.navigationController.view removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [self.jiraConnectorWindow setHidden:YES];
        
        self.active = NO;
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark --- Attachments

-(UIImage*)screenCaptureImage
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) imageSize = [UIScreen mainScreen].bounds.size;
    else imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(NSString*)screenCaptureFileName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd' at 'HH:mm:ss";
    return [NSString stringWithFormat:@"Screen Shot %@.png", [dateFormatter stringFromDate:[NSDate date]]];
}

-(JiraAttachment*)screenCaptureAttachment
{
    JiraAttachment *attachment = [JiraAttachment new];
    attachment.fileName = [self screenCaptureFileName];
    attachment.mimeType = kAttachmentMimeTypeImagePng;
    attachment.attachmentData = UIImagePNGRepresentation([self screenCaptureImage]);
    return attachment;
}

-(void)configurateAttachments
{
    [self.currentAttachments removeAllObjects];
    
    if (self.enableScreenCapturer) {
        [self.currentAttachments addObject:[self screenCaptureAttachment]];
    }
    
    if (self.customAttachmentsBlock) {
        NSArray *customAttachments = self.customAttachmentsBlock();
        for (NSInteger index = 0; index < customAttachments.count; index++) {
            JiraAttachment *attachment = customAttachments[index];
            if ([attachment isKindOfClass:[JiraAttachment class]]) {
                [self.currentAttachments addObject:attachment];
            } else {
                NSLog(@"Unexpected class in Custom Attachments. Expect [JiraAttachment class], but receive %@", attachment);
            }
        }
    }
}

@end
