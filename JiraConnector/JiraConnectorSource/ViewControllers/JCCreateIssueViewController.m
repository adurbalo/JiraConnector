//
//  JCCreateIssueViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/5/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCCreateIssueViewController.h"
#import "NetworkManager.h"
#import "EXTKeyPathCoding.h"
#import "JCButton.h"
#import "JCSelectItemViewController.h"
#import "JCTextContainerViewController.h"
#import "JCAttachmentsViewController.h"
#import "JCFinalViewController.h"
#import "JiraConnector.h"
#import "Project.h"

@interface JCCreateIssueViewController () <JCRightSideControllerDelegate>

@property(nonatomic, strong) Project *project;

@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;

@property (weak, nonatomic) IBOutlet JCButton *issueTypeButton;
@property (weak, nonatomic) IBOutlet JCButton *summaryButton;
@property (weak, nonatomic) IBOutlet JCButton *assigneeButton;
@property (weak, nonatomic) IBOutlet JCButton *priorityButton;
@property (weak, nonatomic) IBOutlet JCButton *fixVersionButton;
@property (weak, nonatomic) IBOutlet JCButton *affectsVersionButton;
@property (weak, nonatomic) IBOutlet JCButton *descriptionButton;
@property (weak, nonatomic) IBOutlet JCButton *componentButton;
@property (weak, nonatomic) IBOutlet JCButton *environmentButton;

@property (weak, nonatomic) IBOutlet UIView *rightSideBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSideBaseViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSideBaseViewWidthConstraint;

@property (nonatomic, strong) JCSelectItemViewController *selectItemVC;
@property (nonatomic, strong) JCTextContainerViewController *textContainerVC;

@property (nonatomic, strong) Issue *issue;
@property (nonatomic, strong) NSArray *issueTypeResponseData;
@property (nonatomic, strong) NSArray *assigneeResponseData;
@property (nonatomic, strong) NSArray *priorityResponseData;
@property (nonatomic, strong) NSArray *versionResponseData;
@property (nonatomic, strong) NSArray *componentResponseData;

@end

@implementation JCCreateIssueViewController

#pragma mark - Init

-(instancetype)initWithProject:(Project *)project
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.project = project;
    }
    return self;
}

#pragma mark - UIView livecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Create Issue";
    
    self.issue = [[Issue alloc] init];
    self.issue.fields.project = self.project;
    [self.issue generateEnvironment];
    
    [self configurateSelectItemVC];
    [self configurateTextContainerVC];
    
    [self updateUIContent];
}

-(void)updateUIContent
{
    self.issueTypeButton.titleText = self.issue.fields.issueType.name;
    self.summaryButton.titleText = self.issue.fields.summary;
    self.assigneeButton.titleText = self.issue.fields.assignee.displayName;
    self.priorityButton.titleText = self.issue.fields.priority.name;
    self.fixVersionButton.titleText = [[self.issue.fields.fixVersions valueForKeyPath:@keypath(Version.new, name)] componentsJoinedByString:@", "];
    self.affectsVersionButton.titleText = [[self.issue.fields.affectsVersions valueForKeyPath:@keypath(Version.new, name)] componentsJoinedByString:@", "];
    self.descriptionButton.titleText = self.issue.fields.descriptionValue;
    self.componentButton.titleText = [[self.issue.fields.components valueForKeyPath:@keypath(Component.new, name)] componentsJoinedByString:@", "];
    self.environmentButton.titleText = self.issue.fields.environment;
}

-(void)handleCreatedIssue
{
    if ([[[JiraConnector sharedManager] attachments] count] > 0) {
        [self showAttachmentsVC];
    } else {
        [self showFinalVC];
    }
}

-(void)showAttachmentsVC
{
    JCAttachmentsViewController *attachmentsVC = [JCAttachmentsViewController new];
    attachmentsVC.issue = self.issue;
    [self.navigationController pushViewController:attachmentsVC animated:YES];
}

-(void)showFinalVC
{
    JCFinalViewController *finalVC = [JCFinalViewController new];
    finalVC.issue = self.issue;
    [self.navigationController pushViewController:finalVC animated:YES];
}

#pragma mark - IBActions

- (IBAction)issueTypeButtonSelected:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {

        [weakSelf.selectItemVC reset];
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.currentItem = weakSelf.issue.fields.issueType;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(IssueType.new, name);
        weakSelf.selectItemVC.itemImageUrlKeyPath = @keypath(IssueType.new, iconUrl);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.issueType);
        weakSelf.selectItemVC.title = @"Select Issue Type";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenuWithController:weakSelf.selectItemVC];
    };
    
    if (self.issueTypeResponseData.count == 0) {
        
        [self pushActivityIndicator];
        
        [[NetworkManager sharedManager] issueTypesCompletionBlock:^(NSArray *responseArray, NSError *error) {
            
            [self popActivityIndicator];
            
            if (error) {
                [self showError:error];
            } else {
                self.issueTypeResponseData = responseArray;
                if (completionBlock) {
                    completionBlock(self.issueTypeResponseData);
                }
            }
        }];

    } else if (completionBlock) {
        completionBlock(self.issueTypeResponseData);
    }
}

- (IBAction)summaryButtonPressed:(id)sender
{
    [self.textContainerVC reset];
    self.textContainerVC.currentItem = self.issue.fields.summary;
    self.textContainerVC.targetValueKeyPath = @keypath(Issue.new, fields.summary);
    [self.textContainerVC updateContent];
    [self showMenuWithController:self.textContainerVC];
}

- (IBAction)assigneeButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        [weakSelf.selectItemVC reset];
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.currentItem = weakSelf.issue.fields.assignee;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(User.new, displayName);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.assignee);
        weakSelf.selectItemVC.itemImageUrlKeyPath = @keypath(User.new, avatarUrls.x48);
        weakSelf.selectItemVC.title = @"Select Assignee";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenuWithController:weakSelf.selectItemVC];
    };
    
    if (self.assigneeResponseData.count == 0) {
        
        [self pushActivityIndicator];
        
        [[NetworkManager sharedManager] issueAssignableSearchForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
            
            [self popActivityIndicator];
            
            if (error) {
                [self showError:error];
            } else {
                self.assigneeResponseData = responseArray;
                if (completionBlock) {
                    completionBlock(self.assigneeResponseData);
                }
            }
        }];
        
    } else if (completionBlock) {
        completionBlock(self.assigneeResponseData);
    }

}

- (IBAction)priorityButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        [weakSelf.selectItemVC reset];
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.currentItem = weakSelf.issue.fields.priority;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Priority.new, name);
        weakSelf.selectItemVC.itemImageUrlKeyPath = @keypath(Priority.new, iconUrl);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.priority);
        weakSelf.selectItemVC.title = @"Select Priority";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenuWithController:weakSelf.selectItemVC];
    };
    
    if (self.priorityResponseData.count == 0) {
        
        [self pushActivityIndicator];
        
        [[NetworkManager sharedManager] issuePrioritiesCompletionBlock:^(NSArray *responseArray, NSError *error) {
            
            [self popActivityIndicator];
            
            if (error) {
                [self showError:error];
            } else {
                self.priorityResponseData = responseArray;
                if (completionBlock) {
                    completionBlock(self.priorityResponseData);
                }
            }
        }];
        
    } else if (completionBlock) {
        completionBlock(self.priorityResponseData);
    }
}

- (IBAction)fixVersionButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        [weakSelf.selectItemVC reset];
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.currentItem = weakSelf.issue.fields.fixVersions;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Version.new, name);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.fixVersions);
        weakSelf.selectItemVC.isArray = YES;
        weakSelf.selectItemVC.title = @"Select Fix Version";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenuWithController:weakSelf.selectItemVC];
    };
    
    if (self.versionResponseData.count == 0) {
        
        [self pushActivityIndicator];
        
        [[NetworkManager sharedManager] versionsForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
            
            [self popActivityIndicator];
            
            if (error) {
                [self showError:error];
            } else {
                self.versionResponseData = responseArray;
                if (completionBlock) {
                    completionBlock(self.versionResponseData);
                }
            }
        }];
        
    } else if (completionBlock) {
        completionBlock(self.versionResponseData);
    }

}

- (IBAction)affectsVersionButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        [weakSelf.selectItemVC reset];
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.currentItem = weakSelf.issue.fields.affectsVersions;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Version.new, name);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.affectsVersions);
        weakSelf.selectItemVC.isArray = YES;
        weakSelf.selectItemVC.title = @"Select Affects Version";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenuWithController:weakSelf.selectItemVC];
    };
    
    if (self.versionResponseData.count == 0) {
        
        [self pushActivityIndicator];
        
        [[NetworkManager sharedManager] versionsForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
            
            [self popActivityIndicator];
            
            if (error) {
                [self showError:error];
            } else {
                self.versionResponseData = responseArray;
                if (completionBlock) {
                    completionBlock(self.versionResponseData);
                }
            }
        }];
        
    } else if (completionBlock) {
        completionBlock(self.versionResponseData);
    }
}

- (IBAction)descriptionButtonPressed:(id)sender
{
    [self.textContainerVC reset];
    self.textContainerVC.currentItem = self.issue.fields.descriptionValue;
    self.textContainerVC.targetValueKeyPath = @keypath(Issue.new, fields.descriptionValue);
    [self.textContainerVC updateContent];
    [self showMenuWithController:self.textContainerVC];
}

- (IBAction)componentButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        [weakSelf.selectItemVC reset];
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.currentItem = weakSelf.issue.fields.components;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Component.new, name);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.components);
        weakSelf.selectItemVC.isArray = YES;
        weakSelf.selectItemVC.title = @"Select Issue Type";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenuWithController:weakSelf.selectItemVC];
    };
    
    if (self.componentResponseData.count == 0) {
        
        [self pushActivityIndicator];
        
        [[NetworkManager sharedManager] componentsForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
            
            [self popActivityIndicator];
            
            if (error) {
                [self showError:error];
            } else {
                self.componentResponseData = responseArray;
                if (completionBlock) {
                    completionBlock(self.componentResponseData);
                }
            }
        }];
        
    } else if (completionBlock) {
        completionBlock(self.componentResponseData);
    }
}

- (IBAction)environmentButtonPressed:(id)sender
{
    [self.textContainerVC reset];
    self.textContainerVC.currentItem = self.issue.fields.environment;
    self.textContainerVC.targetValueKeyPath = @keypath(Issue.new, fields.environment);
    [self.textContainerVC updateContent];
    [self showMenuWithController:self.textContainerVC];
}

- (IBAction)createIssue:(id)sender
{
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] createIssue:self.issue completionBlock:^(Issue *responseObject, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            [self showError:error];
        } else {
            self.issue.idValue = responseObject.idValue;
            self.issue.key = responseObject.key;
            self.issue.selfLink = responseObject.selfLink;
            [self handleCreatedIssue];
        }
    }];
}

#pragma mark - Right Side Menu

-(void)configurateSelectItemVC
{
    self.selectItemVC = [JCSelectItemViewController new];
    self.selectItemVC.delegate = self;
    
    [self addChildViewController:self.selectItemVC];
    self.selectItemVC.view.frame = self.rightSideBaseView.bounds;
    [self.rightSideBaseView addSubview:self.selectItemVC.view];
    self.selectItemVC.view.hidden = YES;
    
    [self.view layoutSubviews];
}

-(void)configurateTextContainerVC
{
    self.textContainerVC = [JCTextContainerViewController new];
    self.textContainerVC.delegate = self;
    
    [self addChildViewController:self.textContainerVC];
    self.textContainerVC.view.frame = self.rightSideBaseView.bounds;
    [self.rightSideBaseView addSubview:self.textContainerVC.view];
    self.textContainerVC.view.hidden = YES;
    
    [self.view layoutSubviews];
}

-(void)showMenuWithController:(UIViewController*)vc
{
    vc.view.hidden = NO;
    
    self.theScrollView.userInteractionEnabled = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [UIView animateWithDuration:jcAnimationDuration animations:^{
    
        self.rightSideBaseViewWidthConstraint.constant = CGRectGetWidth(self.view.frame)*0.9;
        self.rightSideBaseViewLeftConstraint.constant = - CGRectGetWidth(self.view.frame)*0.9;
        
        self.theScrollView.alpha = 0.5f;
        [self.view layoutSubviews];
    }];
}

-(void)hideMenu
{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    [UIView animateWithDuration:jcAnimationDuration animations:^{
    
        self.rightSideBaseViewLeftConstraint.constant = 0.f;
        self.theScrollView.alpha = 1.f;
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        
        self.theScrollView.userInteractionEnabled = YES;
        self.selectItemVC.view.hidden = YES;
        self.textContainerVC.view.hidden = YES;
    }];
    
    [self.view endEditing:YES];
}

#pragma mark - RightSideControllerDelegate

-(void)rightSideControllerDidSelectValue:(id)value forKeyPath:(NSString*)keypath
{
    [self.issue setValue:value forKeyPath:keypath];
    [self updateUIContent];
    [self hideMenu];
}

-(void)rightSideControllerRemoveValueForKeyPath:(NSString*)keypath
{
    [self.issue setValue:nil forKeyPath:keypath];
    [self hideMenu];
    [self updateUIContent];
}

-(void)rightSideControllerShouldBeHidden;
{
    [self hideMenu];
}

@end
