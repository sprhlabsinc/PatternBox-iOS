//
//  CategoryCell.h
//  PatternBox
//
//  Created by youandme on 01/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgCategoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_lableCategoryName;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

-(void)setCellSelect:(Boolean)isSelected;

@end
