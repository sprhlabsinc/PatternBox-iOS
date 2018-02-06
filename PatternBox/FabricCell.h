//
//  FabricCell.h
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"


@interface FabricCell : UICollectionViewCell

@property (nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *imgFabric;
@property (weak, nonatomic) IBOutlet UIImageView *imgBookMark;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;




@end
