//
//  PatternInfoViewController.m
//  PatternBox
//
//  Created by youandme on 26/08/15.
//  Updated by Kristaps Kuzmins on 04/04/2017.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternInfoViewController.h"
#import "Define.h"
#import "PurchaseController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>

@interface PatternInfoViewController ()

@end

@implementation PatternInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    _backTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTappedAction:)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)actionSave:(id)sender {
    

    if (![self checkValid]) return;
    
    NSString *time =[NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    NSString *frontImageName = [NSString stringWithFormat:@"%@_f.jpg",time];
    NSString *backImageName = [NSString stringWithFormat:@"%@_b.jpg",time];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData* frontImageData = UIImageJPEGRepresentation(self.m_imgFrontPattern, 0.5);
    NSData* backImageData = UIImageJPEGRepresentation(self.m_imgBackPattern, 0.5);
    NSArray* data = @[
                      @{@"name":frontImageName,@"data":frontImageData},
                      @{@"name":backImageName,@"data":backImageData}];
    
    NSDictionary * newPattern = @{
                                  KPatternIsPDF:@NO,
                                  KPatternName:self.m_txtPatternName.text,
                                  KPatternKey:self.m_txtPatternID.text,
                                  KPatternInfo:self.m_txtNotes.text,
                                  KPatternCategories:self.m_categories,
                                  KPatternFronPic:frontImageName,
                                  KPatternBackPic:backImageName,
                                  };
    
    [[AppManager sharedInstance] uploadFile:@"upload" data:data parameter:newPattern withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                
                NSString* pattern_id = [response objectForKey:@"pattern_id"];
                PatternModel* newModel = [[PatternModel alloc] initWithData:newPattern];
                newModel.fid = [pattern_id integerValue];
                [[AppManager sharedInstance].patternList addObject:newModel];
                
                //[AppManager sharedInstance].purchaseStatus =[[response objectForKey:@"purchase"] integerValue];
                [self showMessageWithTitle:@"" message:@"PATTERN SAVED" isAction:true];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

#pragma mark - TextView Delegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) return YES;
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollViewYPos:-130];
    [self.view addGestureRecognizer:_backTapGesture];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self scrollViewYPos:0];
    [self.view removeGestureRecognizer:_backTapGesture];
}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:_backTapGesture];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.view removeGestureRecognizer:_backTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)backTappedAction:(UITapGestureRecognizer *)tap {
    [self.m_txtPatternName becomeFirstResponder];
    [self.m_txtPatternName resignFirstResponder];
}


#pragma mark - Common
-(BOOL) checkValid{
    if ([self.m_txtPatternName.text isEqualToString:@""]) {
        [self showMessageWithTitle:@"" message:@"Please enter pattern name." isAction:false];
        return NO;
    }
    
    if ([self.m_txtPatternID.text isEqualToString:@""]) {
        [self showMessageWithTitle:@"" message:@"Please enter pattern id." isAction:false];
        return NO;
    }
    
    return YES;
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message isAction:(Boolean)action {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(action) [self performSegueWithIdentifier:@"segueSaved" sender:self];
    }];
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

-(void)initUI{
    self.m_txtNotes.layer.masksToBounds = YES;
    self.m_txtNotes.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.m_txtNotes.layer.borderWidth = 1;
    self.m_txtNotes.layer.cornerRadius = 3;
    self.m_txtNotes.placeholder = @"NOTES";
    
    self.m_txtPatternName.layer.masksToBounds = YES;
    self.m_txtPatternName.layer.cornerRadius = 3;
    
    self.m_txtPatternID.layer.masksToBounds = YES;
    self.m_txtPatternID.layer.cornerRadius = 3;
}
@end
