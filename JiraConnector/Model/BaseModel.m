//
//  BaseEntity.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <objc/runtime.h>
#import "BaseModel.h"

@implementation BaseModel

#pragma mark - BaseModalProtocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSLog(@"\n\n[%@ %@] - have to be implemented\n\n",  NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSAssert(NO, @"");
    return @{};
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];
    
    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }
    
    return [modifiedDictionaryValue copy];
}


@end
