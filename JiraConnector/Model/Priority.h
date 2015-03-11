//
//  Priority.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/12/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"

@interface Priority : BaseModel

@property(nonatomic, strong) NSString *selfLink;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *statusColor;
@property(nonatomic, strong) NSString *descriptionValue;
@property(nonatomic, strong) NSString *iconUrl;
@property(nonatomic, strong) NSString *name;

@end
