//
//  IssueTypeList.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "IssueTypeList.h"

@implementation IssueTypeList

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.targetClass = [IssueType class];
    }
    return self;
}

@end
