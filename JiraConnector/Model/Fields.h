//
//  Fields.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/25/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"
#import "IssueType.h"
#import "Project.h"
#import "User.h"
#import "Priority.h"

@interface Fields : BaseModel

@property(nonatomic, strong) IssueType *issueType;
@property(nonatomic, strong) NSString *descriptionValue;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) NSString *summary;

@property(nonatomic, strong) Priority *priority;
@property(nonatomic, strong) User *assignee;

@property(nonatomic, strong) User *creator;
@property(nonatomic, strong) User *reporter;

@end
