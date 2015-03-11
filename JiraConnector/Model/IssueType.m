//
//  IssueType.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "IssueType.h"

@implementation IssueType

- (NSDictionary*)mappingDictionary
{
    return @{@"self" : KZProperty(selfLink),
             @"id" : KZProperty(idValue),
             @"description" : KZProperty(descriptionValue),
             @"iconUrl" : KZProperty(iconUrl),
             @"name" : KZProperty(name),
             @"subtask" : KZProperty(subtask)
             };
}

@end
