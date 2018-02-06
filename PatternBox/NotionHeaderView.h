//
//  NotionHeaderView.h
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NotionHeaderView;

@protocol NotionHeaderViewDelegate <NSObject>

- (void)notionHeaderView:(NotionHeaderView*)view didCollapseTable:(Boolean)isCollapse section:(NSInteger)section;
- (void)notionHeaderView:(NotionHeaderView*)view didAddNotions:(NSInteger)section;

@end

@interface NotionHeaderView : UIView{

}
@property (nonatomic) NSInteger section;
@property (nonatomic) Boolean isCollapsed;

@property (weak, nonatomic) IBOutlet UIButton *btnArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) id <NotionHeaderViewDelegate> delegate;

- (IBAction)actionArrow:(id)sender;
- (IBAction)actionAdd:(id)sender;
- (id)initWithNibName:(NSString*)nibNameOrNil;


@end
