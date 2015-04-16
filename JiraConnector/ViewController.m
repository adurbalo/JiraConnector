//
//  ViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/2/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "ViewController.h"
#import "JiraConnector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[JiraConnector sharedManager] configurateWithBaseURL:@"https://menswearhouse.atlassian.net/" andPredefinedProjectKey:@"TUXMOBILE"];
}

#pragma mark -

- (IBAction)show:(id)sender
{
    [[JiraConnector sharedManager] show];
}

- (IBAction)hide:(id)sender
{
    [[JiraConnector sharedManager] hide];
}

@end
