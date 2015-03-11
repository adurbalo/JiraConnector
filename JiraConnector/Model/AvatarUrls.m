//
//  AvatarUrls.m
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/11/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "AvatarUrls.h"

@implementation AvatarUrls

- (NSDictionary*)mappingDictionary
{
    return @{@"16x16" : KZProperty(x16),
             @"24x24" : KZProperty(x24),
             @"32x32" : KZProperty(x32),
             @"48x48" : KZProperty(x48)
             };
}

@end
