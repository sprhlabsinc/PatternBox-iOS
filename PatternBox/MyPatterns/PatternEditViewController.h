//
//  PatternEditViewController.h
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternModel.h"

@interface PatternEditViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITapGestureRecognizer *_bgTapGesture;
    NSMutableDictionary *_pattern;
    
    NSMutableArray * _categories;
    NSMutableArray* _selectedList;

    BOOL _isFrontPattern;
    UIImage *_imgFrontPattern;
    UIImage *_imgBackPattern;

}

@property (nonatomic) int m_ViewMode;
@property (nonatomic, strong) NSArray *m_PDFUrls;
@property (nonatomic, strong) NSData *m_PDFData;
@property (nonatomic) BOOL isOpenInURL;
@property (nonatomic) BOOL isZIPFile;
@property (nonatomic) PatternModel *m_pattern;

@property (weak, nonatomic) IBOutlet UITextField *m_txtPatternName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPatternID;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCategory;
@property (weak, nonatomic) IBOutlet UIView *m_viwNotes;
@property (weak, nonatomic) IBOutlet UITextView *m_txtNotes;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFrontImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBackImage;
@property (weak, nonatomic) IBOutlet UIView *m_viewPatternImage;
@property (weak, nonatomic) IBOutlet UIView *m_viewBottomBar;


- (IBAction)actionPatternSave:(id)sender;
- (IBAction)actionFrontImage:(id)sender;
- (IBAction)actionBackImage:(id)sender;

@end
