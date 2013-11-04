//
//  DlUtils.h
//  EasyAPI-iPhone
//
//  Created by David Wu on 2/11/2013.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DlUtils : NSObject

+ (DlUtils *)sharedUtils;
- (void)showMessage:(NSString *)msg;

@end
