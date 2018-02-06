//
//  NotionCell.h
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotionCellDelegate<NSObject>
-(void)notionCell:(NSInteger)index;
@end

@interface NotionCell : UITableViewCell

@property (nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UIButton *btnNotionCategory;

@property (nonatomic, weak) id <NotionCellDelegate> delegate;
- (IBAction)actionTapCategory:(id)sender;

@end
