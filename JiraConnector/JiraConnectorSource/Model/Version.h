//
//  Version.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/30/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"

@interface Version : BaseModel

@property(nonatomic, strong) NSURL *selfLink;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *descriptionValue;
@property(nonatomic, strong) NSString *name;
@property(nonatomic) BOOL archived;
@property(nonatomic) BOOL released;
@property(nonatomic, strong) NSString *releaseDate;
@property(nonatomic) BOOL overdue;
@property(nonatomic, strong) NSString *userReleaseDate;
@property(nonatomic, strong) NSNumber *projectId;

@end
