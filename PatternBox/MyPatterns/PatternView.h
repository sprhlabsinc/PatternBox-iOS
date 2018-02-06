//
//  PatternView.h
//  PatternBox
//
//  Created by youandme on 03/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PatternView;

@protocol PatternViewDelegate <NSObject>

- (void)PatternView:(PatternView*)view didPressedButton:(UIButton*)button;
- (void)PatternView:(PatternView*)view didPressedBookmarkButton:(UIButton*)button;
- (void)PatternView:(PatternView*)view didPressedEditButton:(UIButton*)button;
- (void)PatternView:(PatternView*)view didPressedInfoEditButton:(UIButton*)button;
- (void)PatternView:(PatternView*)view didPressedDeleteButton:(UIButton*)button;

@end

@interface PatternView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) id <PatternViewDelegate> delegate;

@property (nonatomic) BOOL m_isFrontImage;

@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternID;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBookmark;
@property (weak, nonatomic) IBOutlet UITextView *m_txtNote;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgView;

- (IBAction)actionEdit:(id)sender;
- (IBAction)actionBookmark:(id)sender;
- (IBAction)actionInfoEdit:(id)sender;
- (IBAction)actionDelete:(id)sender;
- (IBAction)actionTurnImage:(id)sender;

- (id)initWithNibName:(NSString*)nibNameOrNil;

@end
