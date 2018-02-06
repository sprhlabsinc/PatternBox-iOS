//
//  PatternDetailViewController.h
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "CustomIOS7AlertView.h"
#import "MGImageViewer.h"
#import "PatternModel.h"

@interface PatternDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CustomIOS7AlertViewDelegate, MGImageViewerDelegate> {
    MGImageViewer *_imgViewer;
    BOOL _isFrontView;
    NSIndexPath *_curPDFIndex;
    NSArray* _pdfUrls;
}

@property (nonatomic) int m_ViewMode;
@property (nonatomic) PatternModel *m_pattern;

@property (weak, nonatomic) IBOutlet UIImageView *m_patternView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBookMark;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternID;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCategory;
@property (weak, nonatomic) IBOutlet UIView *m_ViewOfCaptured;
@property (weak, nonatomic) IBOutlet UIView *m_ViewOfPDFs;
@property (weak, nonatomic) IBOutlet UITableView *m_tableViewOfPDFs;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFront;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBack;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBookMark;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_naviItemBookMark;
@property (weak, nonatomic) IBOutlet UITextView *m_txtNotes;


- (IBAction)actionFrontView:(id)sender;
- (IBAction)actionBackView:(id)sender;
- (IBAction)actionBookMark:(id)sender;
- (IBAction)actionEditInfo:(id)sender;
- (IBAction)actionSavePattern:(id)sender;

@end
