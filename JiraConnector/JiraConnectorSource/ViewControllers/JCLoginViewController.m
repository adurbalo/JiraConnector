//
//  JCLoginViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCLoginViewController.h"
#import "NetworkManager.h"
#import "JCProjectsViewController.h"
#import "JiraConnector.h"

@interface JCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation JCLoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Login";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loginTextField.text = [[NetworkManager sharedManager] login];
    self.passwordTextField.text = [[NetworkManager sharedManager] pass];
}

-(void)cancelButtonPressed:(UIBarButtonItem*)item
{
    [[JiraConnector sharedManager] hideWithCompletionBlock:nil];
}

-(void)addAttachments
{
    NSString *key = @"TUXMOBILE-9138";
    
    JiraAttachment *ja = [JiraAttachment new];
    ja.fileName = @"Screen Shot.png";
    ja.mimeType = kAttachmentMimeTypeImagePng;
    ja.attachmentData = UIImagePNGRepresentation([UIImage imageNamed:@"Screen Shot 2015-04-17 at 17.37.05.png"]);
    
    JiraAttachment *ja2 = [JiraAttachment new];
    ja2.fileName = @"CallStackSymbols.txt";
    ja2.mimeType = kAttachmentMimeTypePlaneTxt;
    ja2.attachmentData = [[[NSThread callStackSymbols] componentsJoinedByString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] addAttachments:@[ja, ja2] toIssueWithKey:key completionBlock:^(NSArray *responseArray, NSError *error) {
       
        [self popActivityIndicator];
        
        if (error) {
            [self showError:error];
        }
        
    }];
}

#pragma mark - IBActions

- (IBAction)signInButtonPressed:(id)sender
{
    [self addAttachments];
    return;
    
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] loginToJiraWithLogin:self.loginTextField.text
                                             andPassword:self.passwordTextField.text
                                         completionBlock:^(id responseObject, NSError *error) {
                                             
                                             [self popActivityIndicator];
                                             
                                                 if (error) {
                                                     [self showError:error];
                                                 } else {
                                                     [self showProjects];
                                                 }
                                                 
                                             }];
}

-(void)showProjects
{
    JCProjectsViewController *projectVC = [JCProjectsViewController new];
    [self.navigationController pushViewController:projectVC animated:YES];
}

@end
