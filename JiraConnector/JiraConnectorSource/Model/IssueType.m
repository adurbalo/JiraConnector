//
//  IssueType.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "IssueType.h"

@implementation IssueType

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink": @"self",
             @"idValue": @"id",
             @"descriptionValue": @"description",
             @"iconUrl": @"iconUrl",
             @"name" : @"name",
             @"subtask" : @"subtask"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)iconUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)subtaskJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
