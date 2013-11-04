//
//  DlAPIManager.h
//  EasyAPI-iPhone
//
//  Created by David Wu on 29/10/13.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import "AFHTTPClient.h"


@interface DlAPIManager : AFHTTPClient

@property (nonatomic, readonly) NSUInteger userId;

+ (DlAPIManager *)sharedManager;

- (NSArray *)cookies;

- (void)userRegister:(NSString *)username password:(NSString *)password email:(NSString *)email callback:(callbackFunc)callback;
- (void)userLogin:(NSString *)username password:(NSString *)password callback:(callbackFunc)callback;
- (void)userInfo:(NSUInteger)userId callback:(callbackFunc)callback;
- (void)updateUserInfo:(NSDictionary *)userInfo callback:(callbackFunc)callback;
- (void)userListWithCallback:(callbackFunc)callback;

@end
