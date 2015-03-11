//
//  Project.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "AvatarUrls.h"

@interface Project : BaseModel

@property(nonatomic, strong) NSString *selfLink;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) AvatarUrls *avatarUrls;

@end
