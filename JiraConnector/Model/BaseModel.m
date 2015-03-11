//
//  BaseEntity.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

#pragma mark - BaseModalProtocol

-(NSDictionary *)mappingDictionary
{
    NSLog(@"Have to be overriden in subclass: %@", NSStringFromClass([self class]));
    return @{};
}

#pragma mark - Public

-(BOOL)mapValuesFromObject:(id)object
{
   return [KZPropertyMapper mapValuesFrom:object toInstance:self usingMapping:[self mappingDictionary]];
}

@end
