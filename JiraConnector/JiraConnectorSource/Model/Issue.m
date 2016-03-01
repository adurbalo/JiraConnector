//
//  Issue.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/25/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "Issue.h"
#import <UIKit/UIKit.h>

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
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Fields.class];
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

-(void)generateEnvironment
{
    NSMutableString *enviromentString = [[NSMutableString alloc] init];
    UIDevice *device = [UIDevice currentDevice];
    [enviromentString appendFormat:@"%@ - %@\n", device.model, device.name];
    [enviromentString appendFormat:@"%@ %@", device.systemName, device.systemVersion];
    self.fields.environment = enviromentString;
}

@end
