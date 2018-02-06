//
//  ZipperCell.h
//  PatternBox
//
//  Created by mac on 4/5/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZipperCellDelegate<NSObject>
-(void)zipperCell:(NSString*)value index:(NSInteger)index;
@end
@interface ZipperCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtSize;
@property (weak, nonatomic) IBOutlet UITextField *txtColor;
@property (weak, nonatomic) IBOutlet UITextField *txtHowmany;
@property (nonatomic, weak) id <ZipperCellDelegate> delegate;
@end
