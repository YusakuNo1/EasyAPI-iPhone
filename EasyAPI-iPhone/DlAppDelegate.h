//
//  DlAppDelegate.h
//  EasyAPI-iPhone
//
//  Created by David Wu on 29/10/13.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DlAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)addLog:(id)obj;
- (void)clearLog;

@end
