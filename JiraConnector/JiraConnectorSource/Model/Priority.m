//
//  Priority.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/12/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Priority.h"

@implementation Priority


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink": @"self",
             @"idValue": @"id",
             @"statusColor": @"statusColor",
             @"descriptionValue": @"description",
             @"iconUrl": @"iconUrl",
             @"name" : @"name"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)iconUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
