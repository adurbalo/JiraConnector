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

#import "JCButton.h"

#import "JCSelectItemViewController.h"

@interface JCCreateIssueViewController () <JCSelectItemViewControllerDelgate>

@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;

@property (weak, nonatomic) IBOutlet JCTextField *summaryTextField;

@property (weak, nonatomic) IBOutlet JCButton *issueTypeButton;
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

@property (nonatomic, strong) Issue *issue;
@property (nonatomic, strong) NSArray *issueTypeResponseData;
@property (nonatomic, strong) NSArray *assigneeResponseData;
@property (nonatomic, strong) NSArray *priorityResponseData;
@property (nonatomic, strong) NSArray *versionResponseData;
@property (nonatomic, strong) NSArray *componentResponseData;

@end



@implementation JCCreateIssueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Create Issue";
    
    self.issue = [[Issue alloc] init];
    self.issue.fields = [[Fields alloc] init];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createIssue:)];
    
    [self configurateSelectItemVC];
    
    [self updateUIContent];
    
}

-(void)updateUIContent
{
    self.issueTypeButton.titleText = self.issue.fields.issueType.name;
    self.assigneeButton.titleText = self.issue.fields.assignee.displayName;
    self.priorityButton.titleText = self.issue.fields.priority.name;
//    self.fixVersionButton.titleText = self.issue.fields.issueType.name;
//    self.affectsVersionButton.titleText = self.issue.fields.issueType.name;
//    self.componentButton.titleText = self.issue.fields.issueType.name;
}

-(void)createIssue:(id)sender
{
    return;
    
    self.issue.fields.summary = self.summaryTextField.text;
    self.issue.fields.project = self.project;
//    self.issue.fields.environment = self.environmentTextField.text;
    
//    JCContentContainer *container = [JCContentContainer new];
//    container.name = @"att1";
//    container.fileName = @"filename";
//    container.mimeType = @"image/png";
//    container.data = UIImagePNGRepresentation([self screenshot]);
    
    [self pushActivityIndicator];
    
    [[NetworkManager sharedManager] createIssue:self.issue completionBlock:^(Issue *responseObject, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            return;
        }
        [self loadCreatedIssueByKey:responseObject.key];
    }];
}

-(void)loadCreatedIssueByKey:(NSString*)issueKey
{
    
    [self popActivityIndicator];
    
    [[NetworkManager sharedManager] issueByKey:issueKey completionBlock:^(Issue *responseObject, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            NSLog(@"issue: %@", responseObject);
        }
    }];
}

#pragma mark - IBActions

- (IBAction)issueTypeButtonSelected:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {

        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(IssueType.new, name);
        weakSelf.selectItemVC.itemImageUrlKeyPath = @keypath(IssueType.new, iconUrl);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.issueType);
        weakSelf.selectItemVC.title = @"Select Issue Type";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenu];
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

- (IBAction)assigneeButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(User.new, displayName);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.assignee);
        weakSelf.selectItemVC.itemImageUrlKeyPath = @keypath(User.new, avatarUrls.x48);
        weakSelf.selectItemVC.title = @"Select Assignee";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenu];
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
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Priority.new, name);
        weakSelf.selectItemVC.itemImageUrlKeyPath = @keypath(Priority.new, iconUrl);
        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.priority);
        weakSelf.selectItemVC.title = @"Select Priority";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenu];
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
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Version.new, name);
//        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.fixVersions);
        weakSelf.selectItemVC.title = @"Select Fix Version";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenu];
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
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Version.new, name);
        //        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.fixVersions);
        weakSelf.selectItemVC.title = @"Select Affects Version";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenu];
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
    
}

- (IBAction)componentButtonPressed:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    void(^completionBlock)(NSArray *arrayWithData) = ^(NSArray *arrayWithData) {
        
        weakSelf.selectItemVC.items = arrayWithData;
        weakSelf.selectItemVC.itemTitleKeyPath = @keypath(Component.new, name);
//        weakSelf.selectItemVC.targetValueKeyPath = @keypath(Issue.new, fields.components);
        weakSelf.selectItemVC.title = @"Select Issue Type";
        [weakSelf.selectItemVC updateContent];
        
        [weakSelf showMenu];
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
    
}

#pragma mark - Internal

- (UIImage*)screenshot
{
    BOOL withStatusBar = YES;
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;

    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            // Restore the context
            CGContextRestoreGState(context);
            if (!withStatusBar)
                CGContextClearRect(context, CGRectMake(0, 0, window.bounds.size.width, 20));
        }
    }
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Right Side Menu

-(void)configurateSelectItemVC
{
    self.selectItemVC = [JCSelectItemViewController new];
    self.selectItemVC.delegate = self;
    
    [self addChildViewController:self.selectItemVC];
    self.selectItemVC.view.frame = self.rightSideBaseView.bounds;
    [self.rightSideBaseView addSubview:self.selectItemVC.view];
    
    [self.view layoutSubviews];
}

-(void)showMenu
{
    self.theScrollView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:jcAnimationDuration animations:^{
    
        self.rightSideBaseViewLeftConstraint.constant = CGRectGetWidth(self.view.frame)*0.1;
        self.rightSideBaseViewWidthConstraint.constant = CGRectGetWidth(self.view.frame)*0.9;
        
        self.theScrollView.alpha = 0.5f;
        
        [self.view layoutSubviews];
    
    }];
}

-(void)hideMenu
{
    [UIView animateWithDuration:jcAnimationDuration animations:^{
    
        self.rightSideBaseViewLeftConstraint.constant = CGRectGetWidth(self.view.frame);
        
        self.theScrollView.alpha = 1.f;
        
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        
        self.theScrollView.userInteractionEnabled = YES;
    
    }];
    
    [self.view endEditing:YES];
}

#pragma mark - JCSelectItemViewControllerDelgate

-(void)selectItemViewControllerSelectValue:(id)value forKeyPath:(NSString*)keypath
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, value, keypath);
    
#warning CHecking???
    [self.issue setValue:value forKeyPath:keypath];
    [self updateUIContent];
    [self hideMenu];
}

-(void)selectItemViewControllerDeleteValueForKeyPath:(NSString*)keypath
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, keypath);
    
#warning CHecking???
    [self.issue setValue:nil forKeyPath:keypath];
    [self hideMenu];
    [self updateUIContent];
}

-(void)selectItemViewControllerShouldBeHidden;
{
    [self hideMenu];
}

@end
