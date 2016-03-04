//
//  LoginInfo.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/4/16.
//  Copyright © 2016 Andrey Durbalo. All rights reserved.
//

#import "LoginInfo.h"

@implementation LoginInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"failedLoginCount": @"failedLoginCount",
             @"lastFailedLoginTime": @"lastFailedLoginTime",
             @"loginCount": @"loginCount",
             @"previousLoginTime" : @"previousLoginTime"
             };
}

@end
