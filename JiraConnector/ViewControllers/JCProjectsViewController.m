//
//  JCProjectsViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/1/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCProjectsViewController.h"
#import "NetworkManager.h"
#import "JCCreateIssueViewController.h"

@interface JCProjectsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSArray *projects;

@end

@implementation JCProjectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Projects";
    
    [self loadProjects];
}

- (void)loadProjects
{
    [[NetworkManager sharedManager] receiveProjectsCompletionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self showError:error];
        } else {
            self.projects = responseArray;
            [self.theTableView reloadData];
        }
    }];
}

#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    Project *project = self.projects[indexPath.row];
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.key;
    
#warning !!!! Implement project avatars UI
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Project *project = self.projects[indexPath.row];
    
    JCCreateIssueViewController *createIssueVC = [JCCreateIssueViewController new];
    createIssueVC.project = project;
    [self.navigationController pushViewController:createIssueVC animated:YES];
}

@end
