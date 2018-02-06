//
//  FabricCell.m
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricCell.h"
#import "AppManager.h"

@implementation FabricCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = KColorBasic.CGColor;
    self.layer.cornerRadius = 6;
//    self.layer.shadowOffset = CGSizeMake(2, 2);
//    self.layer.shadowOpacity = 0.2;
     
    self.imgCheck.layer.cornerRadius = self.imgCheck.frame.size.width / 2;
    self.imgCheck.layer.masksToBounds = YES;
}

@end
