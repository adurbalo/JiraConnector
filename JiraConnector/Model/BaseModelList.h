//
//  BaseList.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface BaseModelList : NSObject

@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) NSArray *items;

-(void)mapValuesFromArray:(NSArray*)object;

@end
