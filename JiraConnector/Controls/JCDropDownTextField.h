//
//  JCDropDownTextField.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCTextField.h"

static NSUInteger const jcDropDownTextFieldTag = 101010;

@class JCDropDownTextField;
typedef void(^JCDropDownTextFieldEditingBlock)(JCDropDownTextField *dropDownTextField, NSUInteger selectedItemIndex);

@interface JCDropDownTextField : JCTextField

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSString *selectedItem;
@property(nonatomic, copy) JCDropDownTextFieldEditingBlock editingBlock;

@end
