//
//  PatternCell.m
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternCell.h"

@implementation PatternCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.m_imgView.layer.borderWidth = 0.2;
    self.m_imgView.layer.borderColor = [UIColor redColor].CGColor;
    self.m_imgView.layer.cornerRadius = 3;
    self.m_imgView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    
    CGRect containerFrame = self.m_containerView.frame;
    containerFrame.size.width = frame.size.width;
    containerFrame.origin.y = 10;
    containerFrame.size.height = frame.size.height - 20;
    self.m_containerView.frame = containerFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionBookMark:(id)sender {
    if (self.m_actionBookMark)
        self.m_actionBookMark(self);
}

@end
