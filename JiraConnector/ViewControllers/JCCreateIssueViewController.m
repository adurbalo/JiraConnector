//
//  JCCreateIssueViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/5/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCCreateIssueViewController.h"
#import "NetworkManager.h"
#import "JCDropDownTextField.h"
#import "EXTKeyPathCoding.h"

@interface JCCreateIssueViewController ()

@property (weak, nonatomic) IBOutlet JCDropDownTextField *issueTypeDropDownTextField;
@property (weak, nonatomic) IBOutlet JCTextField *summaryTextField;
@property (weak, nonatomic) IBOutlet JCDropDownTextField *assigneeDropDownTextField;
@property (weak, nonatomic) IBOutlet JCDropDownTextField *priorityDropDownTextField;

@property (nonatomic, strong) Issue *issue;

@end

@implementation JCCreateIssueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.issue = [[Issue alloc] init];
    self.issue.fields = [[Fields alloc] init];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createIssue:)];
    
    __weak __typeof(self)weakSelf = self;
    
    self.issueTypeDropDownTextField.keypathForDisplay = @keypath( IssueType.new, name );
    self.issueTypeDropDownTextField.editingBlock = ^(JCDropDownTextField *dropDownTextField, NSUInteger selectedItemIndex) {
        weakSelf.issue.fields.issueType = dropDownTextField.selectedItem;
    };
    
    self.priorityDropDownTextField.keypathForDisplay = @keypath( Priority.new, name );
    self.priorityDropDownTextField.editingBlock = ^(JCDropDownTextField *dropDownTextField, NSUInteger selectedItemIndex) {
        weakSelf.issue.fields.priority = dropDownTextField.selectedItem;
    };
    
    self.assigneeDropDownTextField.keypathForDisplay = @keypath( User.new, displayName );
    self.assigneeDropDownTextField.editingBlock = ^(JCDropDownTextField *dropDownTextField, NSUInteger selectedItemIndex) {
        weakSelf.issue.fields.assignee = dropDownTextField.selectedItem;
    };
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NetworkManager sharedManager] issueTypesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self.issueTypeDropDownTextField setError:error];
        } else {
            self.issueTypeDropDownTextField.items = responseArray;
        }
    }];
    
    [[NetworkManager sharedManager] issuePrioritiesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self.priorityDropDownTextField setError:error];
        } else {
            self.priorityDropDownTextField.items = responseArray;
        }
    }];
    
    [[NetworkManager sharedManager] issueAssignableSearchForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
        if (error) {
            [self.assigneeDropDownTextField setError:error];
        } else {
            self.assigneeDropDownTextField.items = responseArray;
        }
    }];
}

-(void)createIssue:(id)sender
{
    self.issue.fields.summary = self.summaryTextField.text;
    self.issue.fields.project = self.project;
    
    [[NetworkManager sharedManager] createIssue:self.issue completionBlock:^(Issue *responseObject, NSError *error) {
        if (error) {
            return;
        }
        [self loadCreatedIssueByKey:responseObject.key];
    }];
}

-(void)loadCreatedIssueByKey:(NSString*)issueKey
{
    [[NetworkManager sharedManager] issueByKey:issueKey completionBlock:^(Issue *responseObject, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            NSLog(@"issue: %@", responseObject);
        }
    }];
}

@end
