//
//  ZipperCell.m
//  PatternBox
//
//  Created by mac on 4/5/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "ZipperCell.h"

@implementation ZipperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.txtType addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtSize addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtColor addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtHowmany addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFieldDidChange :(UITextField *) textField{
    NSInteger index = -1;
    if (textField == self.txtType) {
        index = 0;
    }else if (textField == self.txtSize){
        index = 1;
    }else if (textField == self.txtColor){
        index = 2;
    }else if (textField == self.txtHowmany){
        index = 3;
    }
    [self.delegate zipperCell:textField.text index:index];
}
@end
