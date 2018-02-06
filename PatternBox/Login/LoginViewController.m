//
//  LoginViewController.m
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self initialUIAtLaunch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions
- (IBAction)actionLogin:(id)sender {
    if ([self checkValid]) {
        [self loginUser];
    }
}

#pragma mark - TextField Delegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) return YES;
    
    if (range.location == 0) {
        if ([string isEqualToString:@"0"]) return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    [self.m_txtUserName becomeFirstResponder];
    [self.m_txtUserName resignFirstResponder];
}

#pragma mark - Commmon
- (void)initialUIAtLaunch {
    //Signin
    self.m_viewInput.layer.cornerRadius = 3;
    self.m_btnLogin.layer.cornerRadius = 3;
    self.view.backgroundColor = KColorBackground;
    
    
    self.m_txtUserName.leftViewMode = UITextFieldViewModeAlways;
    self.m_txtUserName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mail"]];
    
    self.m_txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.m_txtPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
}

- (void)loginUser {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Log in...";
    
    NSDictionary * parameters = @{@"email":self.m_txtUserName.text, @"password":self.m_txtPassword.text};
    [[AppManager sharedInstance] postRequest:@"login" parameter:parameters withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                [self showAlertWithTitle:@"" message:message];
            }else{
                NSString* token = [response objectForKey:@"apiKey"];
                [[AppManager sharedInstance] setUserAuthenticationToken:token];
                
                NSInteger userID = [[response objectForKey:@"user_id"] integerValue];
                [[AppManager sharedInstance] setUserID:userID];
                [self performSegueWithIdentifier:@"segueLogined" sender:self];
            }
        } else {
            [self showAlertWithTitle:@"" message:[error localizedDescription]];
        }
    }];
   
}

- (BOOL)checkValid {
    if ([self.m_txtUserName.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your name."];
        return NO;
    }
    
    if ([self.m_txtPassword.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your password."];
        return NO;
    }
    
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
