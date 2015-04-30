//
//  JCAttachmentsViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/20/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCAttachmentsViewController.h"
#import "JCFinalViewController.h"
#import "NetworkManager.h"
#import "JiraConnector.h"

@interface JCAttachmentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *currentSelectedAttachments;
@property (weak, nonatomic) IBOutlet UIButton *addAttachmentButton;

@end

@implementation JCAttachmentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Attachments";
    [self.navigationItem setHidesBackButton:YES];
    [self configurateCurrentSelectedAttachments];
}

-(void)configurateCurrentSelectedAttachments
{
    self.currentSelectedAttachments = [[NSMutableArray alloc] init];
    [self.currentSelectedAttachments addObjectsFromArray:[[JiraConnector sharedManager] attachments]];
    
    [self updateAddAttachmentsButtonState];
}

-(void)updateAddAttachmentsButtonState
{
    self.addAttachmentButton.enabled = self.currentSelectedAttachments.count > 0;
}

-(void)showFinalVC
{
    JCFinalViewController *finalVC = [JCFinalViewController new];
    finalVC.issue = self.issue;
    [self.navigationController pushViewController:finalVC animated:YES];
}

#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[JiraConnector sharedManager] attachments] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    JiraAttachment *attachment = [[JiraConnector sharedManager] attachments][indexPath.row];
    cell.textLabel.text = attachment.fileName;
    cell.accessoryType = [self.currentSelectedAttachments containsObject:attachment]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JiraAttachment *attachment = [[JiraConnector sharedManager] attachments][indexPath.row];
    
    if ([self.currentSelectedAttachments containsObject:attachment]) {
        [self.currentSelectedAttachments removeObject:attachment];
    } else {
        [self.currentSelectedAttachments addObject:attachment];
    }
    [tableView reloadData];
    [self updateAddAttachmentsButtonState];
}

#pragma mark - IBActions

-(IBAction)addAttachmentsButtonPressed:(id)sender
{
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] addAttachments:self.currentSelectedAttachments toIssueWithKey:self.issue.key completionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        if (error) {
            [self showError:error];
        } else {
            [self showFinalVC];
        }
    }];
}

- (IBAction)skipButtonPressed:(id)sender
{
    [self showFinalVC];
}

@end
