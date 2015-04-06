//
//  JCSelectItemViewController.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/2/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCSelectItemViewController.h"
#import "UIKit+AFNetworking.h"

@interface JCSelectItemViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *theSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (weak, nonatomic) IBOutlet UIView *separatorViw;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) NSArray *filteredItems;
@property (nonatomic, strong) NSMutableArray *currentItemsArray;

@end

@implementation JCSelectItemViewController

//RightSideControllerProtocol
@synthesize delegate = _delegate;
@synthesize currentItem = _currentItem;
@synthesize targetValueKeyPath = _targetValueKeyPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentItemsArray = [NSMutableArray new];
    
    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeToRight];
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    self.filteredItems = [_items copy];
}

-(void)hide
{
    if ([self.delegate respondsToSelector:@selector(rightSideControllerShouldBeHidden)]) {
        [self.delegate rightSideControllerShouldBeHidden];
    }
}

#pragma mark - RightSideControllerProtocol

-(void)reset
{
    self.currentItem = nil;
    self.items = nil;
    self.itemTitleKeyPath = nil;
    self.itemImageUrlKeyPath = nil;
    self.targetValueKeyPath = nil;
    self.isArray = NO;
    
    [self.currentItemsArray removeAllObjects];
}

-(void)updateContent
{
    if (self.isArray) {
        [self.currentItemsArray removeAllObjects];
        [self.currentItemsArray addObjectsFromArray:self.currentItem];
    }
    
    [self.theTableView reloadData];
    
    if (self.title.length > 0) {
        self.theSearchBar.placeholder = [NSString stringWithFormat:@"Filter or %@...", self.title];
    }
    
    if (self.isArray) {
        [self.rightButton setTitle:@"Done" forState:UIControlStateNormal];
        self.rightButton.enabled = YES;
    } else {
        [self.rightButton setTitle:@"Remove" forState:UIControlStateNormal];
        self.rightButton.enabled = (self.currentItem != nil);
    }
}

#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    id itemObject = self.filteredItems[indexPath.row];
    
    cell.textLabel.text = indexPath.description;
    cell.textLabel.text = [itemObject valueForKeyPath:self.itemTitleKeyPath];
    cell.imageView.image = nil;
    
    if (self.isArray) {
        cell.accessoryType = [self.currentItemsArray containsObject:itemObject]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = (self.currentItem == itemObject)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }
    
    if (self.itemImageUrlKeyPath) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[itemObject valueForKeyPath:self.itemImageUrlKeyPath]];
        __weak UITableViewCell *weakCell = cell;
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.imageView.image = image;
                                           [weakCell setNeedsLayout];
                                       } failure:nil];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isArray) {
        
        id targetObject = self.filteredItems[indexPath.row];
        if ([self.currentItemsArray containsObject:targetObject]) {
            [self.currentItemsArray removeObject:targetObject];
        } else {
            [self.currentItemsArray addObject:targetObject];
        }
        
        [tableView reloadData];
        
    } else {
        if ([self.delegate respondsToSelector:@selector(rightSideControllerDidSelectValue:forKeyPath:)]) {
            [self.delegate rightSideControllerDidSelectValue:self.filteredItems[indexPath.row] forKeyPath:self.targetValueKeyPath];
        }
    }
}

#pragma mark - IBActions

- (IBAction)leftButtonPressed:(id)sender
{
     [self hide];
}

- (IBAction)rightButtonPressed:(id)sender
{
    if (self.isArray) {
        if ([self.delegate respondsToSelector:@selector(rightSideControllerDidSelectValue:forKeyPath:)]) {
            [self.delegate rightSideControllerDidSelectValue:[self.currentItemsArray mutableCopy] forKeyPath:self.targetValueKeyPath];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(rightSideControllerRemoveValueForKeyPath:)]) {
            [self.delegate rightSideControllerRemoveValueForKeyPath:self.targetValueKeyPath];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        self.filteredItems = [self.items copy];
        [self.theTableView reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSRange rangeOfText = [[evaluatedObject valueForKeyPath:self.itemTitleKeyPath] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        return (rangeOfText.location != NSNotFound);
    }];
    self.filteredItems = [self.items filteredArrayUsingPredicate:predicate];
    [self.theTableView reloadData];
}


@end
