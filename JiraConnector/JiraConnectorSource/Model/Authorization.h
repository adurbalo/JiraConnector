//
//  Authorization.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/4/16.
//  Copyright © 2016 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "LoginInfo.h"

@interface Authorization : BaseModel

@property(nonatomic, strong) NSURL *selfLink;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) LoginInfo *loginInfo;

@end
