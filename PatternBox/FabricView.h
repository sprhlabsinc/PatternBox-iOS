//
//  FabricView.h
//  PatternBox
//
//  Created by mac on 3/31/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FabricView;

@protocol FabricViewDelegate <NSObject>

- (void)FabricView:(FabricView*)view didPressedBookmarkButton:(UIButton*)button;
- (void)FabricView:(FabricView*)view didPressedEditButton:(UIButton*)button;
- (void)FabricView:(FabricView*)view didPressedInfoEditButton:(UIButton*)button;
- (void)FabricView:(FabricView*)view didPressedDeleteButton:(UIButton*)button;

@end

@interface FabricView : UIView

@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternID;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBookmark;
@property (weak, nonatomic) IBOutlet UITextView *m_txtNote;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWidth;
@property (weak, nonatomic) IBOutlet UILabel *m_lblColor;
@property (weak, nonatomic) IBOutlet UILabel *m_lblStretch;



- (IBAction)actionEdit:(id)sender;
- (IBAction)actionBookmark:(id)sender;
- (IBAction)actionInfoEdit:(id)sender;
- (IBAction)actionDelete:(id)sender;

@property (nonatomic, strong) id <FabricViewDelegate> delegate;
- (id)initWithNibName:(NSString*)nibNameOrNil;
@end
