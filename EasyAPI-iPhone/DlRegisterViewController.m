//
//  DlViewController.m
//  EasyAPI-iPhone
//
//  Created by David Wu on 29/10/13.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import "DlRegisterViewController.h"
#import "DlAPIManager.h"


@interface DlRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation DlRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef DEBUG
    self.usernameTextField.text = @"testUser";
    self.emailTextField.text = @"testUser@test.com";
    self.passwordTextField.text = @"test";
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLoginPressed:(id)sender {
    if (self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [[DlUtils sharedUtils] showMessage:@"Please input username & password!"];
        return;
    }
    
	[[DlAPIManager sharedManager] userRegister:self.usernameTextField.text
                                      password:self.passwordTextField.text
                                         email:self.emailTextField.text
                                      callback:^(BOOL success, id response) {
                                          [[DlUtils sharedUtils] showMessage:success ? @"New user created!" : @"Failed to create user."];
                                       }];
}

@end
