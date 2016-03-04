//
//  Authorization.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/4/16.
//  Copyright © 2016 Andrey Durbalo. All rights reserved.
//

#import "Authorization.h"

@implementation Authorization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink": @"self",
             @"name": @"name",
             @"loginInfo": @"loginInfo"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)loginInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:LoginInfo.class];
}


@end
