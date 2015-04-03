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
#import "UIKit+AFNetworking.h"

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
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] receiveProjectsCompletionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        
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
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Project *project = self.projects[indexPath.row];
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.key;
   
    NSURLRequest *request = [NSURLRequest requestWithURL:project.avatarUrls.x48];
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                   } failure:nil];
    
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
