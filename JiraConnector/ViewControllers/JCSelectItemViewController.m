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

@end

@implementation JCSelectItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.backgroundColor = JIRA_DEFAULT_COLOR;
    self.separatorViw.backgroundColor = JIRA_DEFAULT_COLOR;
    
    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeToRight];
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}

-(void)hide
{
    if ([self.delegate respondsToSelector:@selector(selectItemViewControllerShouldBeHidden)]) {
        [self.delegate selectItemViewControllerShouldBeHidden];
    }
}

#pragma mark - Public

-(void)updateContent
{
    [self.theTableView reloadData];
}

#pragma mark - Table Configuration

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    id itemObject = self.items[indexPath.row];
    
    cell.textLabel.text = indexPath.description;
    cell.textLabel.text = [itemObject valueForKeyPath:self.itemTitleKeyPath];
 //   cell.accessoryType = [self.filteredArray[indexPath.row] isEqual:self.currentItem]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
#warning Current selected 
    
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
    
    if ([self.delegate respondsToSelector:@selector(selectItemViewControllerSelectValue:forKeyPath:)]) {
        [self.delegate selectItemViewControllerSelectValue:self.items[indexPath.row] forKeyPath:self.targetValueKeyPath];
    }
}

#pragma mark - IBActions

- (IBAction)hideButtonPressed:(id)sender
{
    [self hide];
}

- (IBAction)deleteButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectItemViewControllerDeleteValueForKeyPath:)]) {
        [self.delegate selectItemViewControllerDeleteValueForKeyPath:self.targetValueKeyPath];
    }
}


@end
