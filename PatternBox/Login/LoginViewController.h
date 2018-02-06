//
//  LoginViewController.h
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "InsetTextField.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    UITapGestureRecognizer *_bgTapGesture;

}


@property (weak, nonatomic) IBOutlet UIView *m_viewInput;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtUserName;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLogin;

- (IBAction)actionLogin:(id)sender;

@end
