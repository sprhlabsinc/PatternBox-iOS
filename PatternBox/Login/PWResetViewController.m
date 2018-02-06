//
//  PWResetViewController.m
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PWResetViewController.h"
#import "AppManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface PWResetViewController ()

@end

@implementation PWResetViewController

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
- (IBAction)actionSend:(id)sender {
    if (![self checkValid]) return;
    
//    [PFUser requestPasswordResetForEmailInBackground:self.m_txtEmail.text block:^(BOOL succeeded, NSError *error) {
//        UIAlertView *display;
//        if(succeeded){
//            display=[[UIAlertView alloc] initWithTitle:@"Password email" message:@"Please check your email for resetting the password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            
//        }else{
//            display=[[UIAlertView alloc] initWithTitle:@"Email" message:@"Email doesn't exists in our database" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
//        }
//        [display show];
//    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] postRequest:@"reset" parameter:@{@"email":self.m_txtEmail.text} withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                [self showAlertWithTitle:@"" message:message];
            }else{
                NSString* message = [response objectForKey:@"message"];
                [self showAlertWithTitle:@"" message:message];
            }
        } else {
            [self showAlertWithTitle:@"" message:[error localizedDescription]];
        }
    }];
    
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
    [self scrollViewYPos:-60];
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self scrollViewYPos:0];
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    [self.m_txtEmail becomeFirstResponder];
    [self.m_txtEmail resignFirstResponder];
}

#pragma mark - Commmon
- (void)initialUIAtLaunch {
    self.view.backgroundColor = KColorBackground;
    
    self.m_viewInput.layer.cornerRadius = 3;
    self.m_btnSend.layer.cornerRadius = 3;
    
    self.m_txtEmail.leftViewMode = UITextFieldViewModeAlways;
    self.m_txtEmail.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mail"]];

}

- (BOOL)checkValid {
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
