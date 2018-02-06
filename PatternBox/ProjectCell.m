//
//  ProjectCell.m
//  PatternBox
//
//  Created by mac on 4/11/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imvProject.layer.masksToBounds = NO;
    self.imvProject.layer.shadowOffset = CGSizeMake(2, 2);
    self.imvProject.layer.shadowOpacity = 0.5;
    self.imvProject.layer.shadowRadius = 3;
    
    self.imvPattern.layer.masksToBounds = YES;
    self.imvPattern.layer.cornerRadius = self.imvPattern.frame.size.width/2;

 

    [[self.viewFabrics subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
