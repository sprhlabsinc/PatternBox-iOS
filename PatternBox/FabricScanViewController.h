//
//  FabricScanViewController.h
//  PatternBox
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FabricInfo.h"
#import "FabricInfoTableViewCell.h"
#import "AppManager.h"
#import "FabricModel.h"
#import "CustomIOS7AlertView.h"
#import "MGImageViewer.h"


@interface FabricScanViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, FabricInfoTableViewCellDelegate, CustomIOS7AlertViewDelegate,MGImageViewerDelegate>{
    
    FabricInfo* _fabricInfo;
    NSMutableArray* _categories;
    NSMutableArray* _selectedList;
    Boolean      _isUpdatedImage;
    Boolean      _isUpdateFabric;
    MGImageViewer *_imgViewer;
    
}


@property (weak, nonatomic) IBOutlet UIImageView *m_fabricView;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
@property (weak, nonatomic) IBOutlet UITableView *fabricInfoTableView;

@property (strong, nonatomic) FabricModel *m_fabricModel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnBookMark;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBookMark;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnSave;


- (IBAction)actionCapture:(id)sender;
- (IBAction)actionImportFromGallery:(id)sender;
- (IBAction)actionSavePattern:(id)sender;
- (IBAction)actionRotate:(id)sender;
- (IBAction)actionBookMark:(id)sender;

@end
