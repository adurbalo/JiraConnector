//
//  JCDropDownControl.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/5/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCDropDownControl.h"

@interface JCDropDownControl () <UITableViewDelegate, UITableViewDataSource>
{
    UIWindow *_prevWindow;
    UIWindow *_controlWindow;
}

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

#define ANIMATION_DURATION 0.15f
#define MAX_COUNT_ITEMS_TO_SHOW 5

@implementation JCDropDownControl

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

-(void)initialization
{
    [self addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height;
    frame.size.height = 0;
    
    self.theTableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.theTableView.dataSource = self;
    self.theTableView.delegate = self;
    self.theTableView.alpha = 0.f;
    self.theTableView.rowHeight = CGRectGetHeight(self.bounds);
    [self addSubview:self.theTableView];
    
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 2.f;
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self updateTitle];
}

-(void)updateTitle
{
    NSString *titleString = self.selectedItem?self.selectedItem:self.placeholder;
   [self setTitle:titleString forState:UIControlStateNormal];
}

-(void)setSelectedItem:(NSString *)selectedItem
{
    _selectedItem = selectedItem;
    [self updateTitle];
}

-(void)setEnableLoadingMode:(BOOL)enableLoadingMode
{
    _enableLoadingMode = enableLoadingMode;
    
    if (_enableLoadingMode) {
        if (self.activityIndicatorView.superview != self) {
            [self addSubview:self.activityIndicatorView];
            self.activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            [self.activityIndicatorView startAnimating];
        }
    } else {
        [self.activityIndicatorView removeFromSuperview];
    }
    self.enabled = !enableLoadingMode;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self updateTitle];
}

#pragma mark - Override

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

-(void)tintColorDidChange
{
    [super tintColorDidChange];
    [self setNeedsDisplay];
}

#pragma mark -

-(void)show
{
    [self.theTableView reloadData];
    
    _prevWindow = [[UIApplication sharedApplication] keyWindow];
    [_prevWindow endEditing:YES];
    
    _controlWindow = [[UIWindow alloc] init];
    _controlWindow.frame = [UIApplication sharedApplication].keyWindow.frame;
    _controlWindow.windowLevel = UIWindowLevelNormal;
    _controlWindow.rootViewController = [[UIViewController alloc] init];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissControl) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.frame = _controlWindow.rootViewController.view.bounds;
    [_controlWindow.rootViewController.view addSubview:dismissButton];
    
    [_controlWindow.rootViewController.view addSubview:self.theTableView];
    
    CGRect sourceFrame = [self.superview convertRect:self.frame toView:[[UIApplication sharedApplication] keyWindow]];
    self.theTableView.frame = sourceFrame;
    
    [_controlWindow makeKeyAndVisible];
    [_controlWindow setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [_prevWindow setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    
    CGRect targetRect = sourceFrame;
    targetRect.size.height = (self.titles.count > MAX_COUNT_ITEMS_TO_SHOW)?MAX_COUNT_ITEMS_TO_SHOW:self.titles.count * self.theTableView.rowHeight;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        _controlWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        self.theTableView.frame = targetRect;
        self.theTableView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissControl
{
    [_prevWindow setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.theTableView.frame = [self.superview convertRect:self.frame toView:self.window];
        self.theTableView.alpha = 0.f;
        _controlWindow.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        self.theTableView.alpha = 1.f;
        [_prevWindow makeKeyAndVisible];
        _controlWindow = nil;
    }];
}

#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = [self.titles[indexPath.row] isEqualToString:self.selectedItem]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = self.titles[indexPath.row];
    [tableView reloadData];
    
    __weak __typeof(self)weakSelf = self;
    if (self.editingBlock) {
        self.editingBlock(weakSelf, indexPath.row);
    }
    [self dismissControl];
}

@end
