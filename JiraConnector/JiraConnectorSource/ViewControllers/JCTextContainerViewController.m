//
//  JCTextContainerViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/6/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCTextContainerViewController.h"

@interface JCTextContainerViewController ()

@property (weak, nonatomic) IBOutlet UITextView *theTextView;

@end

@implementation JCTextContainerViewController

//RightSideControllerProtocol
@synthesize delegate = _delegate;
@synthesize currentItem = _currentItem;
@synthesize targetValueKeyPath = _targetValueKeyPath;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeToRight];
}

-(void)hide
{
    if ([self.delegate respondsToSelector:@selector(rightSideControllerShouldBeHidden)]) {
        [self.delegate rightSideControllerShouldBeHidden];
    }
}

#pragma mark - JCRightSideControllerProtocol

-(void)reset
{
    self.theTextView.text = nil;
    self.currentItem = nil;
    self.targetValueKeyPath = nil;
}

-(void)updateContent
{
    self.theTextView.text = self.currentItem;
}

#pragma mark - IBActions

- (IBAction)leftButtonPressed:(id)sender
{
    [self hide];
}

- (IBAction)rightButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rightSideControllerDidSelectValue:forKeyPath:)]) {
        [self.delegate rightSideControllerDidSelectValue:self.theTextView.text forKeyPath:self.targetValueKeyPath];
    }
}

@end
