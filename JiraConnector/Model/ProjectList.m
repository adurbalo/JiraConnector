//
//  ProjectList.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "ProjectList.h"

@implementation ProjectList

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.targetClass = [Project class];
    }
    return self;
}

@end
