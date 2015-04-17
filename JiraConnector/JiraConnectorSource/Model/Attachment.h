//
//  Attachment.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/17/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"

@interface Attachment : BaseModel

@property(nonatomic, strong) NSURL *selfLink;
@property(nonatomic, strong) NSString *filename;
@property(nonatomic, strong) User *author;
@property(nonatomic, strong) NSString *created;
@property(nonatomic, strong) NSNumber *size;
@property(nonatomic, strong) NSString *mimeType;
@property(nonatomic, strong) NSURL *content;
@property(nonatomic, strong) NSURL *thumbnail;

@end
