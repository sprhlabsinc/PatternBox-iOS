//
//  PatternViewCell.m
//  PatternBox
//
//  Created by mac on 4/6/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "PatternViewCell.h"
#import "Define.h"

@implementation PatternViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = true;
    self.layer.borderWidth = 5;
    self.layer.borderColor = KColorBasic.CGColor;
    self.layer.cornerRadius = 6;
//    self.layer.shadowOffset = CGSizeMake(4, 4);
//    self.layer.shadowOpacity = 0.8;
    
   UIColor* backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    self.m_btnSelect.layer.cornerRadius = self.m_btnSelect.frame.size.width / 2;
    [self.m_btnSelect setBackgroundColor:backgroundColor];
    self.m_btnSelect.layer.masksToBounds = YES;
    
    
    UIImage *image = [[UIImage imageNamed:@"goto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.m_btnSelect setImage:image forState:UIControlStateNormal];
    
    [self.m_btnSelect setTintColor:KColorBasic];

}
- (IBAction)actionSelect:(id)sender {

    [self.delegate patternViewCellSelected:self.index];
}

@end
