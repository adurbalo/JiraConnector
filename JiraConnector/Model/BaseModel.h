//
//  BaseEntity.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@protocol BaseModalProtocol <NSObject>
@required
- (NSDictionary*)mappingDictionary;
@end

@interface BaseModel : NSObject <BaseModalProtocol>

-(BOOL)mapValuesFromObject:(id)object;

@end
