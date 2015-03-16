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
#import "EXTKeyPathCoding.h"

@interface JCCreateIssueViewController ()

@property (weak, nonatomic) IBOutlet JCDropDownControl *itemTypeDropDownControl;
@property (weak, nonatomic) IBOutlet JCDropDownControl *priorityDropDownControl;

@end

@implementation JCCreateIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.itemTypeDropDownControl.enableLoadingMode = YES;
    
    [[NetworkManager sharedManager] issueTypesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        self.itemTypeDropDownControl.enableLoadingMode = NO;
        
        if (!error) {
            self.itemTypeDropDownControl.titles = [responseArray valueForKeyPath:@keypath( IssueType.new, name )];
        }
    }];
    
    
    self.priorityDropDownControl.enableLoadingMode = YES;
    
    [[NetworkManager sharedManager] issuePrioritiesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        self.priorityDropDownControl.enableLoadingMode = NO;
        
        if (!error) {
            self.priorityDropDownControl.titles = [responseArray valueForKeyPath:@keypath( Priority.new, name )];
        }
    }];
}

@end
