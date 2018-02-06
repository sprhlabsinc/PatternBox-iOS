//
//  SignupViewController.h
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "InsetTextField.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate> {
    UITapGestureRecognizer *_bgTapGesture;
    int _scrollOffset;
}


@property (weak, nonatomic) IBOutlet UIView *m_viewPW;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtPW;
@property (weak, nonatomic) IBOutlet UIView *m_viewConfirmPW;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtConfirmPW;
@property (weak, nonatomic) IBOutlet UIView *m_viewEmail;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSignup;

- (IBAction)actionSignup:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
