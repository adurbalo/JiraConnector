//
//  Component.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/30/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"

@interface Component : BaseModel

@property(nonatomic, strong) NSURL *selfLink;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *descriptionValue;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) User *lead;
@property(nonatomic, strong) NSString *assigneeType;
@property(nonatomic, strong) User *assignee;
@property(nonatomic, strong) NSString *realAssigneeType;
@property(nonatomic, strong) User *realAssignee;
@property(nonatomic) BOOL isAssigneeTypeValid;
@property(nonatomic, strong) NSString *project;
@property(nonatomic, strong) NSNumber *projectId;

@end
