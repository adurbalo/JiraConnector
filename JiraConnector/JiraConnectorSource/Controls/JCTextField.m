//
//  JCTextField.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/23/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCTextField.h"

@interface JCTextField () <UITextFieldDelegate>

@end

@implementation JCTextField

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self baseInitialization];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInitialization];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInitialization];
    }
    return self;
}

-(void)baseInitialization
{
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.returnKeyType = UIReturnKeyDone;
    self.delegate = self;
    
    self.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - Override

-(BOOL)becomeFirstResponder
{
    self.layer.borderColor = [self.tintColor CGColor];
    return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    return [super resignFirstResponder];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 5);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark - Public

-(void)setError:(NSError *)error
{
    self.text = error.localizedDescription;
    self.textColor = [UIColor redColor];
    self.enabled = NO;
}


@end
