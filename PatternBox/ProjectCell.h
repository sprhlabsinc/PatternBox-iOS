//
//  ProjectCell.h
//  PatternBox
//
//  Created by mac on 4/11/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imvProject;
@property (weak, nonatomic) IBOutlet UIImageView *imvPattern;
@property (weak, nonatomic) IBOutlet UIView *viewFabrics;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFor;
@property (weak, nonatomic) IBOutlet UITextView *txtNote;

@end
