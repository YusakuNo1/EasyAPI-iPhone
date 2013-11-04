//
//  DlLoginViewController.m
//  EasyAPI-iPhone
//
//  Created by David Wu on 2/11/2013.
//  Copyright (c) 2013 DigitLegend. All rights reserved.
//

#import "DlLoginViewController.h"
#import "DlAPIManager.h"


@interface DlLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end


@implementation DlLoginViewController

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
    
#ifdef DEBUG
    self.usernameTextField.text = @"testUser";
    self.passwordTextField.text = @"test";
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButtonPressed:(id)sender {
    if (self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [[DlUtils sharedUtils] showMessage:@"Please input your user name & password!"];
        return;
    }
    
    [[DlAPIManager sharedManager] userLogin:self.usernameTextField.text password:self.passwordTextField.text callback:^(BOOL success, id response) {
        [[DlUtils sharedUtils] showMessage:success ? @"Login successful!" : @"Login failed!"];
    }];
}

@end
