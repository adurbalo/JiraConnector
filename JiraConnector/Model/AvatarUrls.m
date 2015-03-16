//
//  AvatarUrls.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "AvatarUrls.h"

@implementation AvatarUrls

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"x16": @"16x16",
             @"x24": @"24x24",
             @"x32": @"32x32",
             @"x48": @"48x48"
             };
}

+ (NSValueTransformer *)x16JSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)x24JSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)x32JSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)x48JSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
