//
//  IssueType.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/10/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "BaseModel.h"

@interface IssueType : BaseModel

@property(nonatomic, strong) NSString *selfLink;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *descriptionValue;
@property(nonatomic, strong) NSString *iconUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic) BOOL subtask;

@end
