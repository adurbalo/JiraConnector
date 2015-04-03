//
//  JCSelectItemViewController.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/2/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCBaseViewController.h"

@protocol JCSelectItemViewControllerDelgate <NSObject>

-(void)selectItemViewControllerSelectValue:(id)value forKeyPath:(NSString*)keypath;
-(void)selectItemViewControllerDeleteValueForKeyPath:(NSString*)keypath;
-(void)selectItemViewControllerShouldBeHidden;

@end

@interface JCSelectItemViewController : JCBaseViewController

@property(nonatomic, weak) id<JCSelectItemViewControllerDelgate> delegate;

@property(nonatomic, strong) id currentItem;
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) NSString *itemTitleKeyPath;
@property(nonatomic, strong) NSString *itemImageUrlKeyPath;
@property(nonatomic, strong) NSString *targetValueKeyPath;

-(void)updateContent;

@end
