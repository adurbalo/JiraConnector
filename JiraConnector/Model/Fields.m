//
//  Fields.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/25/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Fields.h"

@implementation Fields

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"issueType" : @"issuetype",
             @"descriptionValue": @"description",
             @"project": @"project",
             @"summary": @"summary",
             
             @"priority" : @"priority",
             @"assignee" : @"assignee",
             
             
             @"creator" : @"creator",
             @"reporter" : @"reporter"
             };
}

+ (NSValueTransformer *)issueTypeJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:IssueType.class];
}

+ (NSValueTransformer *)projectJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Project.class];
}

+ (NSValueTransformer *)priorityJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Priority.class];
}

+ (NSValueTransformer *)assigneeJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)creatorJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)reporterJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

@end
