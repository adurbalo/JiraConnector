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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[JiraConnector sharedManager] configurateWithBaseURL:@"http://localhost:8080" andPredefinedProjectKey:@"MT"];
    [[JiraConnector sharedManager] setEnableDetectMotion:YES];
    [[JiraConnector sharedManager] setEnableScreenCapturer:YES];
    [[JiraConnector sharedManager] setCustomAttachmentsBlock:^ NSArray* (){
        
        JiraAttachment *jiraAttachment = [JiraAttachment new];
        jiraAttachment.fileName = @"callStackSymbols.txt";
        jiraAttachment.mimeType = kAttachmentMimeTypePlaneTxt;
        jiraAttachment.attachmentData = [[[NSThread callStackSymbols] componentsJoinedByString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
        
        return @[jiraAttachment];
    }];
}

#pragma mark -

- (IBAction)show:(id)sender
{
    [[JiraConnector sharedManager] showWithCompletionBlock:nil];
}

@end
