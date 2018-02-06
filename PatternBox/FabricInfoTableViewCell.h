//
//  FabricInfoTableViewCell.h
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FabricInfoTableViewCellDelegate<NSObject>
-(void)updateValue:(NSString*)value index:(NSInteger)index;
@end

@interface FabricInfoTableViewCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) NSInteger index;

@property (nonatomic, weak) id <FabricInfoTableViewCellDelegate> delegate;

@end
