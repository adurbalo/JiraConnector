//
//  JCNavigationController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/2/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCNavigationController.h"
#import "Constants.h"

@interface JCNavigationController ()

@end

@implementation JCNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setBarTintColor:JIRA_DEFAULT_COLOR];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setTintColor:JC_NAVIGATION_BAR_ELEMENTS_COLOR];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName : JC_NAVIGATION_BAR_ELEMENTS_COLOR }];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
