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
             @"reporter" : @"reporter",
             @"environment" : @"environment",
             @"fixVersions" : @"fixVersions",
             @"affectsVersions" : @"versions",
             @"components" : @"components"
             };
}

+ (NSValueTransformer *)issueTypeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:IssueType.class];
}

+ (NSValueTransformer *)projectJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Project.class];
}

+ (NSValueTransformer *)priorityJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Priority.class];
}

+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)creatorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)reporterJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (NSValueTransformer *)fixVersionsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:Version.class];
}

+ (NSValueTransformer *)affectsVersionsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:Version.class];
}

+ (NSValueTransformer *)componentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:Component.class];
}

@end
