//
//  User.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "User.h"

@implementation User

/*
 @property(nonatomic, strong) NSURL *selfLink;
 @property(nonatomic, strong) NSString *key;
 @property(nonatomic, strong) NSString *name;
 @property(nonatomic, strong) NSString *emailAddress;
 @property(nonatomic, strong) AvatarUrls *avatarUrls;
 @property(nonatomic, strong) NSString *displayName;
 @property(nonatomic, strong) NSString *timeZone;
 @property(nonatomic, strong) NSString *locale;
 @property(nonatomic) BOOL active;
 
 
 {
 "self": "https://menswearhouse.atlassian.net/rest/api/2/user?username=saw3",
 "key": "saw3",
 "name": "saw3",
 "emailAddress": "saw3@tmw.com",
 "avatarUrls": {
 "16x16": "https://menswearhouse.atlassian.net/secure/useravatar?size=xsmall&avatarId=10122",
 "24x24": "https://menswearhouse.atlassian.net/secure/useravatar?size=small&avatarId=10122",
 "32x32": "https://menswearhouse.atlassian.net/secure/useravatar?size=medium&avatarId=10122",
 "48x48": "https://menswearhouse.atlassian.net/secure/useravatar?avatarId=10122"
 },
 "displayName": "Adam Wilder",
 "active": true,
 "timeZone": "America/Los_Angeles",
 "locale": "en_US"
 }
 */

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"selfLink": @"self",
             @"name": @"name",
             @"key": @"key",
             @"emailAddress" : @"emailAddress",
             @"avatarUrls" : @"avatarUrls",
             @"displayName" : @"displayName",
             @"active" : @"active",
             @"timeZone" : @"timeZone",
             @"locale" : @"locale",
             };
}

+ (NSValueTransformer *)selfLinkJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarUrlsJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:AvatarUrls.class];
}

+ (NSValueTransformer *)activeJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}



@end
