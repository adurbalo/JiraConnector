//
//  Protocols.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/7/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#ifndef JiraConnector_Protocols_h
#define JiraConnector_Protocols_h

@protocol JCRightSideControllerDelegate;

@protocol JCRightSideControllerProtocol <NSObject>

@required

@property(nonatomic, weak) id<JCRightSideControllerDelegate> delegate;
@property(nonatomic, copy) id currentItem;
@property(nonatomic, strong) NSString *targetValueKeyPath;

-(void)reset;
-(void)updateContent;

@end


@protocol JCRightSideControllerDelegate <NSObject>
@required
-(void)rightSideControllerDidSelectValue:(id)value forKeyPath:(NSString*)keypath;
-(void)rightSideControllerRemoveValueForKeyPath:(NSString*)keypath;
-(void)rightSideControllerShouldBeHidden;
@end

#endif
