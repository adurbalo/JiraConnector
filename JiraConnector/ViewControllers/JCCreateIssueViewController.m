//
//  JCCreateIssueViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/5/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCCreateIssueViewController.h"
#import "NetworkManager.h"
#import "JCDropDownControl.h"
#import "JCDropDownTextField.h"
#import "EXTKeyPathCoding.h"

@interface JCCreateIssueViewController ()

@property (weak, nonatomic) IBOutlet JCDropDownTextField *issueTypeDropDownTextField;
@property (weak, nonatomic) IBOutlet JCDropDownTextField *summaryTextField;
@property (weak, nonatomic) IBOutlet JCDropDownTextField *assigneeDropDownTextField;
@property (weak, nonatomic) IBOutlet JCDropDownTextField *priorityDropDownTextField;

@end

@implementation JCCreateIssueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NetworkManager sharedManager] issueTypesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self.issueTypeDropDownTextField setError:error];
        } else {
            self.issueTypeDropDownTextField.titles = [responseArray valueForKeyPath:@keypath( IssueType.new, name )];
        }
    }];
    
    [[NetworkManager sharedManager] issuePrioritiesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self.priorityDropDownTextField setError:error];
        } else {
            self.priorityDropDownTextField.titles = [responseArray valueForKeyPath:@keypath( IssueType.new, name )];
        }
    }];
    
    [[NetworkManager sharedManager] issueAssignableSearchForProject:self.projectKey completionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self.assigneeDropDownTextField setError:error];
        } else {
            self.assigneeDropDownTextField.titles = [responseArray valueForKeyPath:@keypath( User.new, displayName )];
        }
    }];
}

@end
