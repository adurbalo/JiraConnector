//
//  JCCreateIssueViewController.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/5/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCBaseViewController.h"

@class Project;

@interface JCCreateIssueViewController : JCBaseViewController

-(instancetype)initWithProject:(Project*)project;

@end
