//
//  JCBaseViewController.h
//  JiraConnector
//
//  Created by Andrey Durbalo on 4/1/15.
//  Copyright (c) 2015 Andrey Durbalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface JCBaseViewController : UIViewController

-(void)showError:(NSError*)error;
-(void)pushActivityIndicator;
-(void)popActivityIndicator;

@end
