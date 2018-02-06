//
//  CategoryCell.m
//  PatternBox
//
//  Created by youandme on 01/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "CategoryCell.h"
#import "Define.h"

@implementation CategoryCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.backView.layer.cornerRadius = self.backView.frame.size.width / 2;
    //    self.layer.shadowOffset = CGSizeMake(2, 2);
    //    self.layer.shadowOpacity = 0.2;
    
    self.backView.backgroundColor = KColorBackground;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = KColorBasic.CGColor;
    self.backView.layer.borderWidth = 2;
}

-(void)setCellSelect:(Boolean)isSelected{
    
    UIImage* image = [self.m_imgCategoryIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.m_imgCategoryIcon.image = image;
    
    if (isSelected) {
        self.imgCheck.hidden = false;
        self.backView.backgroundColor = KColorBasic;
        self.m_imgCategoryIcon.tintColor = UIColor.whiteColor;
        if (image == nil) {
            self.m_lableCategoryName.textColor = UIColor.whiteColor;
        }
    }else{
        self.imgCheck.hidden = true;
        self.backView.backgroundColor = KColorBackground;
        self.m_imgCategoryIcon.tintColor = UIColor.blackColor;
        if (image == nil) {
            self.m_lableCategoryName.textColor = UIColor.blackColor;
        }
    }
}
@end
