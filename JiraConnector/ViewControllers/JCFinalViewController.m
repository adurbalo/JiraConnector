//
//  JCFinalViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/7/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCFinalViewController.h"

@interface JCFinalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation JCFinalViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configurateStatusLabel];
}

-(void)configurateStatusLabel
{
    NSString *issueDetails = [NSString stringWithFormat:@"%@ - %@", self.issue.key, self.issue.fields.summary];
    NSString *text = [NSString stringWithFormat:@"Issue %@ has been successfully created.", issueDetails];
    
    NSRange range = [text rangeOfString:issueDetails];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.statusLabel.font.pointSize] range:range];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        self.statusLabel.attributedText = attributedStr;
    }
}

#pragma mark - IBActions

- (IBAction)openInBrowserButtonPressed:(id)sender
{
    NSString *baseUrl = [self.issue.selfLink.absoluteString stringByReplacingOccurrencesOfString:[self.issue.selfLink path] withString:@""];
    NSURL *browserLink = [NSURL URLWithString:[baseUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"browse/%@", self.issue.key]]];
    [[UIApplication sharedApplication] openURL:browserLink];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
