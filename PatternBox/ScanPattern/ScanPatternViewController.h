//
//  ScanPatternViewController.h
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Updated by Kristaps Kuzmins on 04/04/2017
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "CustomIOS7AlertView.h"
#import "MGImageViewer.h"

@interface ScanPatternViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomIOS7AlertViewDelegate, UITextViewDelegate, UITextFieldDelegate, MGImageViewerDelegate, UIAlertViewDelegate> {
    BOOL _isFrontPattern;
    UIImage *_imgFrontPattern;
    UIImage *_imgBackPattern;
    
    NSMutableArray * _categories;
    NSMutableArray* _selectedList;

    UITapGestureRecognizer *_photoTapGesture;
    MGImageViewer *_imgViewer;
    NSInteger _popupType;
}

@property (weak, nonatomic) IBOutlet UIView *m_patternBackView;
@property (weak, nonatomic) IBOutlet UIImageView *m_patternView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUploadingPattern;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFront;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBack;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imgLeftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow;



- (IBAction)actionCapture:(id)sender;
- (IBAction)actionImportFromGallery:(id)sender;
- (IBAction)actionSelFrontPattern:(id)sender;
- (IBAction)actionSelBackPattern:(id)sender;
- (IBAction)actionSavePattern:(id)sender;
- (IBAction)actionRotate:(id)sender;

@end
