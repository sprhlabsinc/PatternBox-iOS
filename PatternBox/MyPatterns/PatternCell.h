//
//  PatternCell.h
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ParseUI/ParseUI.h>

@interface PatternCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *m_containerView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBookMark;
@property (weak, nonatomic) IBOutlet UILabel *m_patternName;
@property (weak, nonatomic) IBOutlet UILabel *m_patternID;
@property (weak, nonatomic) IBOutlet UILabel *m_categoryName;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBookMark;

@property (nonatomic, copy) void (^m_actionBookMark)(id sender);

- (IBAction)actionBookMark:(id)sender;

@end
