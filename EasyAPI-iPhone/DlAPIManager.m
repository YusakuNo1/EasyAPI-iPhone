//
//  DlAPIManager.m
//  EasyAPI-iPhone
//
//  Created by David Wu on 29/10/13.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import "DlAPIManager.h"


//NSString *kServerUrl = @"http://127.0.0.1:8000/";
//NSString *kServerUrl = @"http://192.168.90.114:8000/";
NSString *kServerUrl = @"http://192.168.1.105:8000/";
//NSString *kServerUrl = @"http://192.168.1.105/";


@interface DlAPIManager ()

@property (nonatomic, strong) NSURL *serverUrl;

@end



@implementation DlAPIManager

#pragma mark - Core Functions

+ (DlAPIManager *)sharedManager {
	static DlAPIManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		NSURL *url = [NSURL URLWithString:kServerUrl];
        _sharedManager = [[self alloc] initWithBaseURL:url];
    });
    return _sharedManager;
}

- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		self.serverUrl = url;
        _userId = kInvalidUserId;
	}
	
	return self;
}



#pragma mark - AFNetworking - AFHTTPClient

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
//    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    
//    NSString *csrfToken = [self cookie:kCSRFToken];
//    [newParameters setObject:csrfToken forKey:@"csrfmiddlewaretoken"];
//
//    return [super requestWithMethod:method path:path parameters:newParameters];
    
    NSString *csrfToken = [self cookie:kCSRFToken];
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [request setValue:csrfToken forHTTPHeaderField:@"X_CSRFTOKEN"];
    return request;
}



#pragma mark - Demo Functions

- (void)userRegister:(NSString *)username
            password:(NSString *)password
               email:(NSString *)email
            callback:(callbackFunc)callback {
	NSDictionary *param = @{ @"username":username, @"email":email, @"password":password };
	[self postPath:@"users/create/"
		parameters:param
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
               // TODO: User create callback
               NSLog(@"New user created");
               
               [self processLogin:responseObject];
               if (callback) {
                   callback(YES, responseObject);
               }
		   }
		   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // TODO: User failed to login callback
               NSLog(@"Failed to create new user");
               
               if (callback) {
                   callback(NO, error);
               }
		   }];
}


- (void)userLogin:(NSString *)username
         password:(NSString *)password
         callback:(callbackFunc)callback {
	NSDictionary *param = @{ @"username":username, @"password":password };
	[self postPath:@"users/login/"
		parameters:param
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
               // TODO: User login callback
               NSLog(@"User login successful");
               
               [self processLogin:responseObject];
               if (callback) {
                   callback(YES, responseObject);
               }
		   }
		   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // TODO: User failed to login callback
               NSLog(@"Failed to login");
               
               if (callback) {
                   callback(NO, error);
               }
		   }];
}


- (void)userInfo:(NSUInteger)userId callback:(callbackFunc)callback {
    if (userId == kInvalidUserId) {
        if (callback) {
            callback(NO, [NSError errorWithDomain:@"" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"Current user is nil" }]);
        }
        return;
    }
    
    NSString *queryPath = [@"users/" stringByAppendingFormat:@"%d/", userId];
    [self getPath:queryPath
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // TODO: User info callback
              NSLog(@"User info is ready");
              
              if (callback) {
                  callback(YES, responseObject);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // TODO: User info query failed callback
              NSLog(@"Failed to query user info");
              
              if (callback) {
                  callback(NO, error);
              }
          }
     ];
}


- (void)updateUserInfo:(NSDictionary *)userInfo callback:(callbackFunc)callback {
    NSString *queryPath = [@"users/" stringByAppendingFormat:@"%d/", self.userId];
    [self putPath:queryPath
       parameters:userInfo
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
               // TODO: Update user info callback
               NSLog(@"User info is updated");
               
               if (callback) {
                   callback(YES, responseObject);
               }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // TODO: User info update failed callback
               NSLog(@"Failed to update user info");
               
               if (callback) {
                   callback(NO, error);
               }
          }];
}


- (void)userListWithCallback:(callbackFunc)callback {
	[self getPath:@"users/?format=json"
	   parameters:nil
		  success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // TODO: Got user list callback
              NSLog(@"Retrieved user list");
              
              if (callback) {
                  callback(YES, responseObject);
              }
		  }
		  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // TODO: Failed to get user list callback
              NSLog(@"Failed to retrieve user list");
              
              if (callback) {
                  callback(NO, error);
              }
		  }];
}



#pragma mark - Utils

- (NSArray *)cookies {
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kServerUrl]];
    return cookies;
}

- (NSString *)cookie:(NSString *)name {
    NSArray *cookies = [self cookies];
    if (cookies) {
        for (NSHTTPCookie *cookie in cookies) {
            if ([cookie.name isEqualToString:name]) {
                return cookie.value;
            }
        }
    }
    return @"";
}


- (void)processLogin:(id)responseObject {
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        id idValue = [responseDict objectForKey:@"id"];
        if (idValue && [idValue isKindOfClass:[NSNumber class]]) {
            _userId = [idValue unsignedIntegerValue];
        }
        else {
            _userId = kInvalidUserId;
        }
    }
}

@end
