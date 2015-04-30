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
#import "JiraConnector.h"

@interface JCProjectsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSArray *allProjects;
@property (nonatomic, strong) NSArray *filtereProjects;
@property (nonatomic, strong) Project *predefinedProject;

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
            self.allProjects = responseArray;
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Project *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject.key isEqualToString:[[JiraConnector sharedManager] predefinedProjectKey]];
            }];
            self.predefinedProject = [[self.allProjects filteredArrayUsingPredicate:predicate] firstObject];
            [self.theTableView reloadData];
        }
    }];
}

-(void)setAllProjects:(NSArray *)allProjects
{
    _allProjects = allProjects;
    self.filtereProjects = [_allProjects copy];
}

#pragma mark - Table Configuration

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Predefined";
    }
    
    return @"Other";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.predefinedProject?1:0;
    }
    
    return self.filtereProjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    Project *project = nil;
    
    if (indexPath.section == 0) {
        project = self.predefinedProject;
    } else {
        project = self.filtereProjects[indexPath.row];
    }
    
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
    
    Project *project = nil;
    
    if (indexPath.section == 0) {
        project = self.predefinedProject;
    } else {
        project = self.filtereProjects[indexPath.row];
    }
    
    JCCreateIssueViewController *createIssueVC = [[JCCreateIssueViewController alloc] initWithProject:project];
    [self.navigationController pushViewController:createIssueVC animated:YES];
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        self.filtereProjects = [self.allProjects copy];
        [self.theTableView reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Project *evaluatedObject, NSDictionary *bindings) {
        NSRange rangeOfName = [evaluatedObject.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange rangeOfKey = [evaluatedObject.key rangeOfString:searchText options:NSCaseInsensitiveSearch];
        return (rangeOfName.location != NSNotFound) || (rangeOfKey.location != NSNotFound);
    }];
    self.filtereProjects = [self.allProjects filteredArrayUsingPredicate:predicate];
    [self.theTableView reloadData];
}

@end
