//
//  JCContentContainer.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 3/27/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCContentContainer : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *fileName;
@property(nonatomic, strong) NSString *mimeType;
@property(nonatomic, strong) NSData *data;

@end
