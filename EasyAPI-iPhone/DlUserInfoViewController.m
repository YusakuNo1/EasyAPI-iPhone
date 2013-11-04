//
//  DlUserInfoViewController.m
//  EasyAPI-iPhone
//
//  Created by David Wu on 2/11/2013.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import "DlUserInfoViewController.h"
#import "DlAPIManager.h"


@interface DlUserInfoViewController () {
    BOOL userInfoIsUpdating;
}

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateUserInfoButton;

@property (nonatomic, strong) NSDictionary *userInfo;

@end


@implementation DlUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUIVisibility];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.userId == 0 || self.userId == kInvalidUserId || !self.navigationController) {
        self.userId = [DlAPIManager sharedManager].userId;
        [self updateUIVisibility];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUIVisibility {
    const BOOL isCurrentUser = _userId == [DlAPIManager sharedManager].userId;
    self.updateUserInfoButton.hidden = !isCurrentUser;
    self.emailTextField.enabled = isCurrentUser;
    self.passwordTextField.enabled = isCurrentUser;
    self.confirmPasswordTextField.enabled = isCurrentUser;
}

- (void)setUserId:(NSUInteger)userId {
    _userId = userId;
    [self updateUIVisibility];
    
    if (!userInfoIsUpdating) {
        [self displayUserInfo];
    }
}

- (void)displayUserInfo {
    [[DlAPIManager sharedManager] userInfo:self.userId callback:^(BOOL success, id response) {
        if (success && [response isKindOfClass:[NSData class]]) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            self.userInfo = responseDict;

            self.userIdLabel.text = [[self.userInfo objectForKey:@"id"] description];
            self.usernameLabel.text = [self.userInfo objectForKey:@"username"];
            self.emailTextField.text = [self.userInfo objectForKey:@"email"];

            return;
        }
        
        NSLog(@"%@", [response localizedDescription]);
        [[DlUtils sharedUtils] showMessage:[response localizedDescription]];
    }];
}

- (IBAction)onRefresh:(id)sender {
    [self displayUserInfo];
}

- (IBAction)onUpdateUserInfo:(id)sender {
    if (!self.userInfo) {
        [[DlUtils sharedUtils] showMessage:@"Please refresh to get current user info first"];
        return;
    }

    if (self.passwordTextField.text.length > 0 && ![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [[DlUtils sharedUtils] showMessage:@"Your password doesn't match password confirm field!"];
        return;
    }

    userInfoIsUpdating = YES;
    
    NSMutableDictionary *userInfo = [@{ @"id":       [self.userInfo objectForKey:@"id"],
                                        @"username": [self.userInfo objectForKey:@"username"],
                                        @"email":    self.emailTextField.text } mutableCopy];
    
    if (self.passwordTextField.text.length > 0) {
        // Need to change password as well
        [userInfo setObject:self.passwordTextField.text forKey:@"password"];
    }
    
    [[DlAPIManager sharedManager] updateUserInfo:userInfo
                                        callback:^(BOOL success, id response) {
                                            userInfoIsUpdating = NO;
                                            [[DlUtils sharedUtils] showMessage:success ? @"User info updated!" : @"Failed to update user info!"];
                                        }];
}

@end
