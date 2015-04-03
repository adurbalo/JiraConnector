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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorViw;

@property (nonatomic, strong) NSArray *filteredItems;
@property (nonatomic, strong) NSMutableArray *currentItemsArray;

@end

@implementation JCSelectItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.backgroundColor = JIRA_DEFAULT_COLOR;
    self.separatorViw.backgroundColor = JIRA_DEFAULT_COLOR;
    
    self.currentItemsArray = [NSMutableArray new];
    
    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeToRight];
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    self.filteredItems = [_items copy];
}

-(void)hide
{
    if ([self.delegate respondsToSelector:@selector(selectItemViewControllerShouldBeHidden)]) {
        [self.delegate selectItemViewControllerShouldBeHidden];
    }
}

#pragma mark - Public

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
        if ([self.delegate respondsToSelector:@selector(selectItemViewControllerSelectValue:forKeyPath:)]) {
            [self.delegate selectItemViewControllerSelectValue:self.filteredItems[indexPath.row] forKeyPath:self.targetValueKeyPath];
        }
    }
}

#pragma mark - IBActions

- (IBAction)hideButtonPressed:(id)sender
{
    [self hide];
}

- (IBAction)rightButtonPressed:(id)sender
{
    if (self.isArray) {
        if ([self.delegate respondsToSelector:@selector(selectItemViewControllerSelectValue:forKeyPath:)]) {
            [self.delegate selectItemViewControllerSelectValue:self.currentItemsArray forKeyPath:self.targetValueKeyPath];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(selectItemViewControllerDeleteValueForKeyPath:)]) {
            [self.delegate selectItemViewControllerDeleteValueForKeyPath:self.targetValueKeyPath];
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
