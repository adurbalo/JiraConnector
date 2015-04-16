//
//  Issue.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/25/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "Fields.h"

@interface Issue : BaseModel

#warning - Attachment model required

@property(nonatomic, strong) NSString *expand;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSURL *selfLink;
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) Fields *fields;

@end