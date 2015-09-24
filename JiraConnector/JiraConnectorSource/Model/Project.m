//
//  Project.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Project.h"
#import "MTLValueTransformer.h"

@implementation Project

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink": @"self",
             @"idValue": @"id",
             @"name": @"name",
             @"key": @"key",
             @"avatarUrls" : @"avatarUrls"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarUrlsJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:AvatarUrls.class];
}



@end
