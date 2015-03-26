//
//  JCDropDownTextField.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCDropDownTextField.h"

@interface JCDropDownTextField () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSArray *filteredArray;

@end

#define MAX_VISIBLE_ROWS_COUNT 4

@implementation JCDropDownTextField

#pragma mark - Init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
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
    self.theTableView = [[UITableView alloc] init];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.layer.borderWidth = 0.5f;
    self.theTableView.layer.borderColor = self.tintColor.CGColor;
    
    [self addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    self.filteredArray = [_items copy];
}

#pragma mark - Override

-(BOOL)resignFirstResponder
{
    [self dismissControl];
    return [super resignFirstResponder];
}

#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    id itemObject = self.filteredArray[indexPath.row];
    
    cell.textLabel.text = [itemObject valueForKeyPath:self.keypathForDisplay];
    cell.accessoryType = [self.filteredArray[indexPath.row] isEqual:self.selectedItem]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = self.filteredArray[indexPath.row];
    [tableView reloadData];
    
    NSUInteger indexOfObject = [self.items indexOfObject:self.selectedItem];
    
    __weak __typeof(self)weakSelf = self;
    if (self.editingBlock) {
        self.editingBlock(weakSelf, indexOfObject);
    }
    [self resignFirstResponder];
}

#pragma mark -

-(void)show
{
    self.theTableView.rowHeight = CGRectGetHeight(self.frame);
    
    UIView *superview = self.superview;
    if (self.theTableView.superview && (self.theTableView.superview==superview) ) {
        return;
    }
    [self filteredWithString:[self.selectedItem valueForKeyPath:self.keypathForDisplay]];
    [self setupTableViewFrame];
    [superview addSubview:self.theTableView];
}

-(void)setupTableViewFrame
{
    CGRect targetRect = self.frame;
    targetRect.origin.y += CGRectGetHeight(self.frame);
    CGFloat numberOfVisibleRows = (self.filteredArray.count <= MAX_VISIBLE_ROWS_COUNT)?self.filteredArray.count:(MAX_VISIBLE_ROWS_COUNT+0.5f);
    targetRect.size.height = self.theTableView.rowHeight*numberOfVisibleRows;
    self.theTableView.frame = targetRect;
    
    [self.theTableView reloadData];
}

-(void)textFieldEditingChanged:(UITextField*)textField
{
    [self filteredWithString:textField.text];
}

-(void)filteredWithString:(NSString*)string
{
    if (string.length == 0) {
        self.filteredArray = [self.items copy];
    } else {
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSRange range = [[evaluatedObject valueForKeyPath:self.keypathForDisplay] rangeOfString:string];
            return range.location != NSNotFound;
        }];
        self.filteredArray = [self.items filteredArrayUsingPredicate:pred];
    }
    [self setupTableViewFrame];
}

-(void)dismissControl
{
    self.text = [self.selectedItem valueForKeyPath:self.keypathForDisplay];
    [self.theTableView removeFromSuperview];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.selectedItem = nil;
    [self filteredWithString:textField.text];
    __weak __typeof(self)weakSelf = self;
    if (self.editingBlock) {
        self.editingBlock(weakSelf, NSNotFound);
    }
    return YES;
}

@end
