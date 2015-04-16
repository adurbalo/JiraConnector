//
//  JCSelectItemViewController.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/2/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import "JCBaseViewController.h"
#import "Protocols.h"

@interface JCSelectItemViewController : JCBaseViewController <JCRightSideControllerProtocol>

@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) NSString *itemTitleKeyPath;
@property(nonatomic, strong) NSString *itemImageUrlKeyPath;
@property(nonatomic) BOOL isArray;

@end
