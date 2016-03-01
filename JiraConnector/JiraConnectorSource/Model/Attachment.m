//
//  Attachment.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Attachment.h"

@implementation Attachment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink" : @"self",
             @"filename" : @"filename",
             @"author": @"author",
             @"created" : @"created",
             @"size" : @"size",
             @"mimeType" : @"mimeType",
             @"content" : @"content",
             @"thumbnail" : @"thumbnail"
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)contentJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbnailJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

@end
