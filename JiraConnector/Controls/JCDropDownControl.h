//
//  JCDropDownControl.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/5/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCDropDownControl;
typedef void(^JCDropDownControlEditingBlock)(JCDropDownControl *dropDownControl, NSInteger selectedItemIndex);

@interface JCDropDownControl : UIButton

@property(nonatomic, strong) IBInspectable NSString *placeholder;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSString *selectedItem;
@property(nonatomic, copy) JCDropDownControlEditingBlock editingBlock;
@property(nonatomic, assign) BOOL enableLoadingMode;

@end
