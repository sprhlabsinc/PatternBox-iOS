//
//  PatternInfoViewController.h
//  PatternBox
//
//  Created by youandme on 26/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"

@interface PatternInfoViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    UITapGestureRecognizer *_backTapGesture;

}

@property (nonatomic) NSString *m_categories;
@property (nonatomic) UIImage *m_imgFrontPattern;
@property (nonatomic) UIImage *m_imgBackPattern;

@property (weak, nonatomic) IBOutlet InsetTextField *m_txtPatternName;
@property (weak, nonatomic) IBOutlet InsetTextField *m_txtPatternID;
@property (weak, nonatomic) IBOutlet UITextView *m_txtNotes;

- (IBAction)actionSave:(id)sender;
@end
