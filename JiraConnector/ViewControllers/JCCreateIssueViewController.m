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
@property (weak, nonatomic) IBOutlet JCDropDownTextField *versionDropDownTextField;
@property (weak, nonatomic) IBOutlet JCDropDownTextField *componentDropDownTextField;
@property (weak, nonatomic) IBOutlet JCTextField *environmentTextField;

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
    
    self.versionDropDownTextField.keypathForDisplay = @keypath( Version.new, name );
    self.versionDropDownTextField.editingBlock = ^(JCDropDownTextField *dropDownTextField, NSUInteger selectedItemIndex) {
        if (dropDownTextField.selectedItem) {
             weakSelf.issue.fields.fixVersions = @[dropDownTextField.selectedItem];
#warning ALARM!!!! hardcode!!!11111
            weakSelf.issue.fields.affectsVersions = dropDownTextField.items;
        }
    };
    
    self.componentDropDownTextField.keypathForDisplay = @keypath( Component.new, name );
    self.componentDropDownTextField.editingBlock = ^(JCDropDownTextField *dropDownTextField, NSUInteger selectedItemIndex) {
        if (dropDownTextField.selectedItem) {
            weakSelf.issue.fields.components = @[dropDownTextField.selectedItem];
        }
    };
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self pushActivityIndicator];
    [[NetworkManager sharedManager] issueTypesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            [self.issueTypeDropDownTextField setError:error];
        } else {
            self.issueTypeDropDownTextField.items = responseArray;
        }
    }];
    
    [self pushActivityIndicator];
    [[NetworkManager sharedManager] issuePrioritiesCompletionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            [self.priorityDropDownTextField setError:error];
        } else {
            self.priorityDropDownTextField.items = responseArray;
        }
    }];
    
    [self pushActivityIndicator];
    [[NetworkManager sharedManager] issueAssignableSearchForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            [self.assigneeDropDownTextField setError:error];
        } else {
            self.assigneeDropDownTextField.items = responseArray;
        }
    }];
    
    [self pushActivityIndicator];
    [[NetworkManager sharedManager] versionsForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            [self.versionDropDownTextField setError:error];
        } else {
            self.versionDropDownTextField.items = responseArray;
        }
    }];
    
    [self pushActivityIndicator];
    [[NetworkManager sharedManager] componentsForProject:self.project.key completionBlock:^(NSArray *responseArray, NSError *error) {
        
        [self popActivityIndicator];
        
        if (error) {
            [self.componentDropDownTextField setError:error];
        } else {
            self.componentDropDownTextField.items = responseArray;
        }
    }];
}

-(void)createIssue:(id)sender
{
    self.issue.fields.summary = self.summaryTextField.text;
    self.issue.fields.project = self.project;
    self.issue.fields.environment = self.environmentTextField.text;
    
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


@end
