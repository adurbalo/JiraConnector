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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loginTextField.text = [[NetworkManager sharedManager] login];
    self.passwordTextField.text = [[NetworkManager sharedManager] pass];
}

#pragma mark - IBActions

- (IBAction)signInButtonPressed:(id)sender
{
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] loginToJiraWithLogin:self.loginTextField.text
                                             andPassword:self.passwordTextField.text
                                         completionBlock:^(Authorization *responseObject, NSError *error) {
                                             
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
