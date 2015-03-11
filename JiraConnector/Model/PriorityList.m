//
//  PriorityList.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/12/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "PriorityList.h"

@implementation PriorityList

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.targetClass = [Priority class];
    }
    return self;
}

@end
