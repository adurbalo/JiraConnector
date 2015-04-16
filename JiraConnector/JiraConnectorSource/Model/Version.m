//
//  Version.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/30/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Version.h"

@implementation Version

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"selfLink" : @"self",
             @"idValue" : @"id",
             @"descriptionValue": @"description",
             @"name" : @"name",
             @"archived" : @"archived",
             @"released" : @"released",
             @"releaseDate" : @"releaseDate",
             @"overdue" : @"overdue",
             @"userReleaseDate" : @"userReleaseDate",
             @"projectId" : @"projectId"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)archivedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)releasedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)overdueValidJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


@end
