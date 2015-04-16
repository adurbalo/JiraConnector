//
//  JCButton.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/3/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCButton.h"
#import "Constants.h"

@implementation JCButton

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
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 3.f;
    self.layer.borderColor = [JIRA_DEFAULT_COLOR CGColor];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat offset = 5.f;
    return CGRectMake( offset, contentRect.origin.y, contentRect.size.width-2*offset, contentRect.size.height);
}

#pragma mark - Public

-(void)setTitleText:(NSString *)titleText
{
    [self setTitle:titleText forState:UIControlStateNormal];
    [self setTitle:titleText forState:UIControlStateSelected];
    [self setTitle:titleText forState:UIControlStateHighlighted];
    [self setTitle:titleText forState:UIControlStateDisabled];
}

@end
