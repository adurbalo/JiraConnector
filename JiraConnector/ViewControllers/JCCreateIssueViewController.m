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
    
    [[NetworkManager sharedManager] issueTypesCompletionBlock:^(BaseModelList *responseObject, NSError *error) {
        
        self.itemTypeDropDownControl.enableLoadingMode = NO;
        
        if (!error) {
            self.itemTypeDropDownControl.titles = [responseObject.items valueForKeyPath:@"name"];
        }
        
    }];
    
    self.priorityDropDownControl.enableLoadingMode = YES;
    [[NetworkManager sharedManager] issuePrioritiesCompletionBlock:^(PriorityList *responseObject, NSError *error) {
        self.priorityDropDownControl.enableLoadingMode = NO;
        if (!error) {
            self.priorityDropDownControl.titles = [responseObject.items valueForKey:@"name"];
        }
    }];
}

@end
