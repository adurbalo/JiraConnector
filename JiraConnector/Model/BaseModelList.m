//
//  BaseList.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModelList.h"
#import "BaseModel.h"

@implementation BaseModelList

-(void)mapValuesFromArray:(NSArray *)array
{
    NSMutableArray *resultItemsArray = [NSMutableArray new];
    for (id innerObject in array) {
        id mappedObject = [self.targetClass new];
        if (![[mappedObject class] isSubclassOfClass:[BaseModel class]]) {
            NSLog(@"%@ is not subclass of BaseModel class", NSStringFromClass(self.targetClass));
            continue;
        }
        [mappedObject mapValuesFromObject:innerObject];
        [resultItemsArray addObject:mappedObject];
    }
    self.items = resultItemsArray;
}

@end
