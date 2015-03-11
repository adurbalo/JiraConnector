//
//  Priority.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/12/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Priority.h"

@implementation Priority

- (NSDictionary*)mappingDictionary
{
    return @{@"self" : KZProperty(selfLink),
             @"id" : KZProperty(idValue),
             @"statusColor" : KZProperty(statusColor),
             @"description" : KZProperty(descriptionValue),
             @"iconUrl" : KZProperty(iconUrl),
             @"name" : KZProperty(name)
             };
}

@end
