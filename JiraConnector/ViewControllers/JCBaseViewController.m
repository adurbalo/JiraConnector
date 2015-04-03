//
//  JCBaseViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/1/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCBaseViewController.h"

@interface JCBaseViewController ()

@property(nonatomic, strong) UILabel *errorLabel;
@property(nonatomic, strong) NSMutableArray *errorsArray;
@property(nonatomic) BOOL errorVisible;

@property(nonatomic) NSInteger activityIndicatorCounter;
@property(nonatomic, strong) UIView *activityIndicatorBaseView;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

#define JIRA_BLUE_COLOR [UIColor colorWithRed:59./255. green:115./255. blue:175./255. alpha:1.f]

@end

@implementation JCBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.errorsArray = [NSMutableArray new];
    
    [self configurateNavigationBar];
    [self configurateErrorLabel];
    [self configurateActivityIndicator];
}

-(void)configurateNavigationBar
{
    return;
    self.navigationController.navigationBar.barTintColor = JIRA_BLUE_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)configurateErrorLabel
{
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.75];
    self.errorLabel.textColor = [UIColor whiteColor];
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.alpha = 0.f;
    [self.view addSubview:self.errorLabel];
}

-(void)configurateActivityIndicator
{
    self.activityIndicatorBaseView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorBaseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.activityIndicatorBaseView.userInteractionEnabled = NO;
    self.activityIndicatorBaseView.backgroundColor = [JIRA_BLUE_COLOR colorWithAlphaComponent:0.3];
    self.activityIndicatorBaseView.alpha = 0.f;
    [self.view addSubview:self.activityIndicatorBaseView];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    activityIndicatorView.center = self.activityIndicatorBaseView.center;
    [activityIndicatorView startAnimating];
    [self.activityIndicatorBaseView addSubview:activityIndicatorView];
}

-(void)showError:(NSError *)error
{
    if (error) {
        [self.errorsArray addObject:error];
        [self showNextError];
    }
}

-(void)showNextError
{
    if (self.errorVisible || self.errorsArray.count == 0) {
        return;
    }
    
    NSError *error = [self.errorsArray firstObject];
    
    self.errorLabel.text = [NSString stringWithFormat:@"Error\n%@", error.localizedDescription];
    
    CGSize sizeOfText = [self.errorLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame), FLT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName : self.errorLabel.font}
                                                           context:nil].size;
    CGRect invisibleRect = CGRectMake(0, -MAX(CGRectGetHeight(self.view.frame), sizeOfText.height), CGRectGetWidth(self.view.frame), sizeOfText.height+10);
    self.errorLabel.frame = invisibleRect;
    self.errorLabel.alpha = 0.f;
    
    NSTimeInterval animationDuration = 0.15f;
    NSTimeInterval delay = 3;
    
    CGRect visibleRect = invisibleRect;
    visibleRect.origin.y = 0;
    
    self.errorVisible = YES;
    self.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.errorLabel.frame = visibleRect;
        self.errorLabel.alpha = 1.f;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:animationDuration delay:delay options:0 animations:^{
            
            self.errorLabel.frame = invisibleRect;
            self.errorLabel.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            [self.errorsArray removeObject:error];
            
            self.errorVisible = NO;
            self.view.userInteractionEnabled = YES;
            
            [self showNextError];
            
        }];
        
    }];
}

#pragma mark - Activity indicator

-(void)setActivityIndicatorCounter:(NSInteger)activityIndicatorCounter
{
    _activityIndicatorCounter = activityIndicatorCounter;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.activityIndicatorBaseView.alpha = (_activityIndicatorCounter > 0)?1.f:0.f;
        self.view.userInteractionEnabled = (_activityIndicatorCounter == 0);
    }];
}

-(void)pushActivityIndicator
{
    self.activityIndicatorCounter++;
}

-(void)popActivityIndicator
{
    self.activityIndicatorCounter--;
}

@end
