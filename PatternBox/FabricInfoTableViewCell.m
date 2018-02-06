//
//  FabricInfoTableViewCell.m
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricInfoTableViewCell.h"

@implementation FabricInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.txtValue.delegate = self;
    self.textView.delegate = self;
    
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate updateValue:textField.text index:self.index];
}
- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    [self.delegate updateValue:textView.text index:self.index];
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) return YES;
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
