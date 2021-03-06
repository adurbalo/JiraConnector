//
//  Component.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/30/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Component.h"

@implementation Component

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"selfLink" : @"self",
             @"idValue" : @"id",
             @"descriptionValue": @"description",
             @"name" : @"name",
             @"lead" : @"lead",
             @"assigneeType" : @"assigneeType",
             @"assignee" : @"assignee",
             @"realAssigneeType" : @"realAssigneeType",
             @"realAssignee" : @"realAssignee",
             @"isAssigneeTypeValid" : @"isAssigneeTypeValid",
             @"project": @"project",
             @"projectId" : @"projectId"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)leadJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)realAssigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)reporterJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)isAssigneeTypeValidJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
