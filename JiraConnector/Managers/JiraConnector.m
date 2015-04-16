//
//  JiraConnector.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/16/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
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
        
        JCNavigationController *rootVC = [JCNavigationController new];
        rootVC.navigationBarHidden = YES;

        self.jiraConnectorWindow.rootViewController = rootVC;
        
        JCLoginViewController *loginVC = [JCLoginViewController new];
        self.navigationController = [[JCNavigationController alloc] initWithRootViewController:loginVC];
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
        self.motionManager.deviceMotionUpdateInterval = 0.1f;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *data, NSError *error) {
                                                    
                                                    if ( data.rotationRate.y < -8.f) {
                                                        [self show];
                                                    }
                                                }];
    } else {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

#pragma mark - Public

-(void)show
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
    }];
}

-(void)hide
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
    }];
}

@end
