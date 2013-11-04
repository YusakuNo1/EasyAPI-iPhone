//
//  DlUtils.m
//  EasyAPI-iPhone
//
//  Created by David Wu on 2/11/2013.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import "DlUtils.h"

@implementation DlUtils

+ (DlUtils *)sharedUtils {
	static DlUtils *_sharedUtils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = [[self alloc] init];
    });
    return _sharedUtils;
}

- (void)showMessage:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:msg
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
