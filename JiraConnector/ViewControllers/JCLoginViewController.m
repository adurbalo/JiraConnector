//
//  JCLoginViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCLoginViewController.h"
#import "NetworkManager.h"
#import "JCCreateIssueViewController.h"
#import "UIImageView+AFNetworking.h"

@interface JCLoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) ProjectList *projectsList;

@end

@implementation JCLoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self loadProjects];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createIssue:)];
}

- (void)createIssue:(id)sender
{
    JCCreateIssueViewController *createIssueVC = [JCCreateIssueViewController new];
    [self.navigationController pushViewController:createIssueVC animated:YES];
}

- (void)loadProjects
{
    [[NetworkManager sharedManager] receiveProjectsCompletionBlock:^(ProjectList *responseObject, NSError *error) {
        if (!error) {
            self.projectsList = responseObject;
            [self.theTableView reloadData];
        }
    }];
}

#pragma mark - IBActions

- (IBAction)signInButtonPressed:(id)sender
{
    self.errorLabel.text = nil;
    
    [[NetworkManager sharedManager] loginToJiraWithLogin:self.loginTextField.text
                                             andPassword:self.passwordTextField.text
                                         completionBlock:^(id responseObject, NSError *error) {
                                             
                                                 if (error) {
                                                     self.errorLabel.text = error.localizedDescription;
                                                 } else {
                                                     [self loadProjects];
                                                 }
                                                 
                                             }];
}


#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectsList.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    Project *project = self.projectsList.items[indexPath.row];

    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.key;
    [cell.imageView setImageWithURL:[NSURL URLWithString:project.avatarUrls.x32]];
    return cell;
}

@end
