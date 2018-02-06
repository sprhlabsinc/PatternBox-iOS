//
//  PatternViewCell.h
//  PatternBox
//
//  Created by mac on 4/6/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@protocol PatternViewCellCellDelegate<NSObject>

-(void)patternViewCellSelected:(NSInteger)index;
@end


@interface PatternViewCell : UICollectionViewCell


@property (nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *imgPattern;
@property (weak, nonatomic) IBOutlet UIImageView *imgBookMark;
@property (weak, nonatomic) IBOutlet CustomLabel *lblName;
@property (weak, nonatomic) IBOutlet CustomLabel *lblType;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSelect;
@property (nonatomic, weak) id <PatternViewCellCellDelegate> delegate;


- (IBAction)actionSelect:(id)sender;

@end
