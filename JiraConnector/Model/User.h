//
//  User.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "AvatarUrls.h"

@interface User : BaseModel

@property(nonatomic, strong) NSURL *selfLink;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *emailAddress;
@property(nonatomic, strong) AvatarUrls *avatarUrls;
@property(nonatomic, strong) NSString *displayName;
@property(nonatomic, strong) NSString *timeZone;
@property(nonatomic, strong) NSString *locale;
@property(nonatomic) BOOL active;

@end
