//
//  NotionCell.m
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionCell.h"
#import "AppManager.h"

@implementation NotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnNotionCategory.layer.cornerRadius = 20;
    self.btnNotionCategory.layer.borderWidth = 2;
    self.btnNotionCategory.layer.borderColor = KColorBasic.CGColor;
    self.btnNotionCategory.layer.backgroundColor = KColorButtonBackGround.CGColor;
}

- (IBAction)actionTapCategory:(id)sender {
    [self.delegate notionCell:self.index];
}
@end
