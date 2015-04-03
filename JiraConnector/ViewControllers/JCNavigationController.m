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

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setBarTintColor:JIRA_DEFAULT_COLOR];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setTintColor:JC_NAVIGATION_BAR_ELEMENTS_COLOR];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName : JC_NAVIGATION_BAR_ELEMENTS_COLOR }];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
