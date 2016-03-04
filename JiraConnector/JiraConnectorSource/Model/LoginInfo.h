//
//  LoginInfo.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/4/16.
//  Copyright © 2016 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"

@interface LoginInfo : BaseModel

@property(nonatomic, strong) NSNumber *failedLoginCount;
@property(nonatomic, strong) NSString *lastFailedLoginTime;
@property(nonatomic, strong) NSNumber *loginCount;
@property(nonatomic, strong) NSString *previousLoginTime;

@end
