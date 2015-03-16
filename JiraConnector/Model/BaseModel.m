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

#pragma mark -

+(NSDictionary *)dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        Class classObject = NSClassFromString([key capitalizedString]);
        if (classObject) {
            id subObj = [self dictionaryWithPropertiesOfObject:[obj valueForKey:key]];
            [dict setObject:subObj forKey:key];
        }
        else
        {
            id value = [obj valueForKey:key];
            if(value) [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


@end
