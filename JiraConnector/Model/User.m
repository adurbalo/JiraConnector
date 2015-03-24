//
//  User.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink": @"self",
             @"name": @"name",
             @"key": @"key",
             @"emailAddress" : @"emailAddress",
             @"avatarUrls" : @"avatarUrls",
             @"displayName" : @"displayName",
             @"active" : @"active",
             @"timeZone" : @"timeZone",
             @"locale" : @"locale",
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarUrlsJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:AvatarUrls.class];
}

+ (NSValueTransformer *)activeJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}



@end
