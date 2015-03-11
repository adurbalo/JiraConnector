//
//  Project.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Project.h"

@implementation Project



- (NSDictionary*)mappingDictionary
{
    return @{@"self" : KZProperty(selfLink),
             @"id" : KZProperty(idValue),
             @"key" : KZProperty(key),
             @"name" : KZProperty(name),
             @"avatarUrls" : @"@Selector(avatarsFromDict:, avatarUrls)"
             };
}

- (AvatarUrls*)avatarsFromDict:(NSDictionary*)avatarsDict
{
    AvatarUrls *avatarsUrls = [AvatarUrls new];
    [avatarsUrls mapValuesFromObject:avatarsDict];
    return avatarsUrls;
}

@end
