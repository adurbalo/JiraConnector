//
//  Issue.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/25/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Issue.h"

@implementation Issue

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"expand" : @"expand",
             @"idValue": @"id",
             @"selfLink": @"self",
             @"key": @"key",
             @"fields" : @"fields"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)fieldsJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Fields.class];
}

#pragma mark - Init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.fields = [Fields new];
    }
    return self;
}

@end
