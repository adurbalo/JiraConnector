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



@end

#define ANIMATION_DURATION 0.15
#define VOLUME_BUTTON_PRESSED_NOTIFICATION @"AVSystemController_SystemVolumeDidChangeNotification"

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
        
        self.motionSensivity = 10;
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
                                                    
                                                    if ( (ABS(data.rotationRate.x) > weakSelf.motionSensivity) || (ABS(data.rotationRate.y) > weakSelf.motionSensivity) || (ABS(data.rotationRate.z) > weakSelf.motionSensivity) ) {
                                                        
                                                        [[JiraConnector sharedManager] showWithCompletionBlock:nil];
                                                    }
                                                }];
    } else {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

-(void)setEnableDetectVolumeChanging:(BOOL)enableDetectVolumeChanging
{
//TODO: volume buttons pressed    
    if (enableDetectVolumeChanging) {
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:)
                                                     name:VOLUME_BUTTON_PRESSED_NOTIFICATION
                                                   object:nil];
    } else {

        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:VOLUME_BUTTON_PRESSED_NOTIFICATION
                                                      object:nil];
    }
}

-(void)volumeChanged:(NSNotification*)notification
{
    [self showWithCompletionBlock:nil];
}

#pragma mark - Public

-(void)showWithCompletionBlock:(void(^)())completionBlock
{
    if (self.active) {
        return;
    }
    
    self.active = YES;
    
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

@end
