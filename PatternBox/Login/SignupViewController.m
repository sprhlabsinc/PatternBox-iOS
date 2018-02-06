//
//  SignupViewController.m
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SignupViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

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
- (IBAction)actionSignup:(id)sender {
    if ([self checkValid]) {
        [self registerUser];
    }
}

- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (textField == self.m_txtConfirmPW) {
        [self scrollViewYPos:(-_scrollOffset*2)];
    } else if (textField == self.m_txtEmail) {
        [self scrollViewYPos:(-_scrollOffset*3)];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:_bgTapGesture];
    [self scrollViewYPos:0];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    [self.m_txtEmail becomeFirstResponder];
    [self.m_txtEmail resignFirstResponder];
}

#pragma mark - Commmon
- (void)initialUIAtLaunch {
    _scrollOffset = self.m_viewEmail.frame.origin.y - self.m_viewEmail.frame.origin.y;
    self.view.backgroundColor = KColorBackground;
    //Register
    self.m_viewPW.layer.cornerRadius = 3;
    self.m_viewConfirmPW.layer.cornerRadius = 3;
    self.m_viewEmail.layer.cornerRadius = 3;
    self.m_btnSignup.layer.cornerRadius = 3;
    
    
    self.m_txtEmail.leftViewMode = UITextFieldViewModeAlways;
    self.m_txtEmail.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mail"]];
    
    self.m_txtPW.leftViewMode = UITextFieldViewModeAlways;
    self.m_txtPW.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
    
    self.m_txtConfirmPW.leftViewMode = UITextFieldViewModeAlways;
    self.m_txtConfirmPW.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
}

- (void)registerUser {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Sign up...";
    
    NSDictionary * parameters = @{@"email":self.m_txtEmail.text, @"password":self.m_txtPW.text};
    [[AppManager sharedInstance] postRequest:@"register" parameter:parameters withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            NSString* message = [response objectForKey:@"message"];
            if (fail || !response) {
                 [self showAlertWithTitle:@"" message:message];
            }else{
                 NSString* token = [response objectForKey:@"apiKey"];
                 [[AppManager sharedInstance] setUserAuthenticationToken:token];
                 NSInteger userID = [[response objectForKey:@"user_id"] integerValue];
                 [[AppManager sharedInstance] setUserID:userID];
                

                 [self showAlertWithTitle:@"" message:message];
                 [self performSegueWithIdentifier:@"segueSignuped" sender:self];

              }
            
        } else {
            [self showAlertWithTitle:@"" message:[error localizedDescription]];
        }
    }];
}

-(void)syncPatterns:(NSInteger)nPatterns userId:(NSInteger)userId{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:@"Server is copying your previouse %ld patterns on database of PatternBoxPlus. it will take some minutes.",nPatterns];
    
    NSDictionary * parameters = @{@"email":self.m_txtEmail.text, @"user_id":[NSNumber numberWithInteger:userId]};
    [[AppManager sharedInstance] getRequestWithDictonary:@"sync" parameter:parameters withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            NSString* message = [response objectForKey:@"message"];
            if (fail || !response) {
                [self showAlertWithTitle:@"" message:message];
            }else{
                    [self performSegueWithIdentifier:@"segueSignuped" sender:self];
            }
            [self showAlertWithTitle:@"" message:message];
        } else {
            [self showAlertWithTitle:@"" message:[error localizedDescription]];
        }
    }];
}
- (BOOL)checkValid {
    
    if ([self.m_txtPW.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your password."];
        return NO;
    }
    
    if ([self.m_txtPW.text length] < 6) {
        [self showAlertWithTitle:@"" message:@"Your password is too easy to guess."];
        return NO;
    }
    
    if ([self.m_txtConfirmPW.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your password again for confirm."];
        return NO;
    }
    
    if (![self.m_txtConfirmPW.text isEqualToString:self.m_txtPW.text]) {
        [self showAlertWithTitle:@"" message:@"Please check your password."];
        return NO;
    }
    
    if ([self.m_txtEmail.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your correct email address."];
        return NO;
    }
    
    if (![self validateEmailWithString:self.m_txtEmail.text]) {
        [self showAlertWithTitle:@"" message:@"Please enter your correct email address."];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)scrollViewYPos:(int)yPos {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    rect.origin.y = yPos;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
