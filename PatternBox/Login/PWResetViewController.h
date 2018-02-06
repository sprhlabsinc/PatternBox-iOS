//
//  PWResetViewController.h
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"

@interface PWResetViewController : UIViewController <UITextFieldDelegate> {
    UITapGestureRecognizer *_bgTapGesture;
}

@property (weak, nonatomic) IBOutlet UIView *m_viewInput;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSend;

- (IBAction)actionSend:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
