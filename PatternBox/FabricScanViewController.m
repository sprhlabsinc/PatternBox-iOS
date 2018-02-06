//
//  FabricScanViewController.m
//  PatternBox
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricScanViewController.h"
#import "CategoryCell.h"
#import "FabricCategoryInfo.h"
#import "FabricCategoryTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectModel.h"

@interface FabricScanViewController ()

@end

@implementation FabricScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* _photoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTappedAction:)];
    [self.m_fabricView addGestureRecognizer:_photoTapGesture];
 
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadCategoryView];
}

#pragma mark - Actions
- (IBAction)actionCapture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    if (TARGET_IPHONE_SIMULATOR) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)actionImportFromGallery:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)actionSavePattern:(id)sender {
    // Check DELETE
    if ([self.m_btnSave.title isEqualToString:@"Delete"]) {
        
        UIAlertController * alert =  [UIAlertController alertControllerWithTitle:@"WARNING!" message:@"Are you sure to delete this fabric?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteFabric];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    if (![self checkValid]) return;
    
    
    NSString *time =[NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    NSString *fabricImageName = self.m_fabricModel? self.m_fabricModel.imageUrl:[NSString stringWithFormat:@"%@_fabric.jpg",time];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData* fabricImageData = UIImageJPEGRepresentation(self.m_fabricView.image, 0.5);

    NSArray* data = @[
                      @{@"name":fabricImageName,@"data":fabricImageData},
                      ];
    
    if (self.m_fabricModel && !_isUpdatedImage) {
        data = @[];
    }
    
    NSMutableArray* categories = [[NSMutableArray alloc] init];

    for (int i = 0; i < _selectedList.count; i++) {
        SelectModel* sel = _selectedList[i];
        if(sel.isSelected){
            FabricCategoryInfo* item = _categories[i];
            [categories addObject:[NSString stringWithFormat:@"%@", item.fid]];
        }
            
    }
    
    NSString* strCat = [categories componentsJoinedByString:@","];
    NSMutableDictionary* newFabric = [[NSMutableDictionary alloc] initWithDictionary:[_fabricInfo getDictionaryData]];
    [newFabric setObject:strCat forKey:KFabricCategories];
    [newFabric setObject:fabricImageName forKey:KFabricImageName];
    
    
    // Check UPDATEING or CREATE
    
    if(self.m_fabricModel){
        [newFabric setObject:@YES forKey:@"is_update"];
        [newFabric setObject:[NSNumber numberWithInteger: self.m_fabricModel.fid] forKey:KFabricId];
        [newFabric setObject:self.m_fabricModel.imageUrl forKey:KFabricImageName];
    }
    

    
    [[AppManager sharedInstance] uploadFile:@"upload_fabric" data:data parameter:newFabric withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                if (self.m_fabricModel) {
                    self.m_fabricModel.info = _fabricInfo;
                    self.m_fabricModel.categories = categories;
                }else{
                    NSString* fabric_id = [response objectForKey:@"fabric_id"];
                    FabricModel* newModel = [[FabricModel alloc] initWithData:newFabric];
                    newModel.fid = [fabric_id integerValue];
                    [[AppManager sharedInstance].fabricList addObject:newModel];
                }
                NSString* message = [response objectForKey:@"message"];
                [self showMessageWithTitle:@"" message:message isAction:true];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}
- (void)deleteFabric {
    
    NSString* tag = [NSString stringWithFormat:@"fabrics/%ld",(long)self.m_fabricModel.fid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] deleteRequest:tag parameter:nil withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                [[AppManager sharedInstance].fabricList removeObject:self.m_fabricModel];
                NSString* message = [response objectForKey:@"message"];
                [self showMessageWithTitle:@"" message:message isAction:true];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}
- (IBAction)actionRotate:(id)sender {
    UIImage *chosenImage;// = [self rotate:self.m_patternView.image orientation:UIImageOrientationLeft];
    
    chosenImage = [self rotateUIImage:self.m_fabricView.image clockwise:NO];
    self.m_fabricView.image = chosenImage;
    _isUpdatedImage = YES;
    

   
}

- (IBAction)actionBookMark:(id)sender {
    NSInteger isbookmark = 1;
    if (self.m_fabricModel.isBookMark) {
        isbookmark = 0;
    } else {
        isbookmark = 1;
    }
   
    NSDictionary* parameter = @{@"is_bookmark":[NSNumber numberWithInteger:isbookmark]};
    NSString* tag = [NSString stringWithFormat:@"fabric_bookmark/%ld",(long)self.m_fabricModel.fid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] putRequest:tag  parameter:parameter withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                self.m_fabricModel.isBookMark = isbookmark;
                self.m_imgBookMark.hidden = !self.m_fabricModel.isBookMark;
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

#pragma mark- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fabricInfo.keyList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FabricInfoTableViewCell* cell = [self.fabricInfoTableView dequeueReusableCellWithIdentifier:@"fabricInfoCell"];
    NSString* key  = _fabricInfo.keyList[indexPath.row];
    NSString* value = [_fabricInfo getValueWithKey:key];
    cell.lblName.text = [key uppercaseString];
    
    cell.delegate = self;
    cell.index = indexPath.row;
    
    if (indexPath.row == _fabricInfo.keyList.count - 1) {
        cell.textView.text = value;
        cell.txtValue.hidden = YES;
        cell.textView.hidden = NO;
    }else{
        cell.txtValue.text = value;
        cell.txtValue.hidden = NO;
        cell.textView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _fabricInfo.keyList.count - 1) {
      return 200;
    }else{
      return 44;
    }
    
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _categories.count + 1;
}

#pragma mark - CollectionView Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    if (indexPath.row == _categories.count) {
        cell.m_imgCategoryIcon.image = [UIImage imageNamed:@"c_plus"];
        cell.m_lableCategoryName.text = @"";
        [cell setCellSelect:false];
    }else{
        FabricCategoryInfo* item = _categories[indexPath.row];
        NSString* categoryName = item.name;
        cell.m_lableCategoryName.text = [categoryName uppercaseString];
        cell.m_imgCategoryIcon.image = nil;
       
        SelectModel* sel = _selectedList[indexPath.row];
        [cell setCellSelect:sel.isSelected];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _categories.count) {
        [collectionView deselectItemAtIndexPath:indexPath animated:true];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Fabric" bundle:[NSBundle mainBundle]];
        FabricCategoryTableViewController *newView = [storyboard instantiateViewControllerWithIdentifier:@"FabricCategoryTableViewController"];
        [self.navigationController pushViewController:newView animated:YES];
    }else{
        
        SelectModel* item = _selectedList[indexPath.row];
        item.isSelected = !item.isSelected;
        
        CategoryCell *cell = (CategoryCell *)[self.m_collectionView cellForItemAtIndexPath:indexPath];
        [cell setCellSelect:item.isSelected];
        
        [self changeSaveStatus];
    }
    [self.m_collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



#pragma mark - FabricInfoTableViewCellDelegate
-(void)updateValue:(NSString *)value index:(NSInteger)index{
    [_fabricInfo setValueWithIndex:index value:value];
    [self changeSaveStatus];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.m_fabricView.image = chosenImage;
    _isUpdatedImage = YES;
    [self changeSaveStatus];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)photoTappedAction:(UITapGestureRecognizer *)tap {
    if (!self.m_fabricView.image) return;

    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    alertView.parentView = self.view;
    [alertView setContainerView:[self createContainerViewForPatternImg]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"DONE", nil]];
    [alertView setDelegate:self];
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

#pragma mark - MGImageViewer Delegate
-(void) MGImageViewer:(MGImageViewer *)_imageViewer didCreateRawScrollView:(MGRawScrollView *)rawScrollView atIndex:(int)index{
    
    UIImage* image = self.m_fabricView.image;
    
    rawScrollView.imageView.image = image;
    CGRect rect = rawScrollView.imageView.frame;
    rect.size = image.size;
    rawScrollView.imageView.frame = rect;
    
    CGFloat newZoomScale = rawScrollView.frame.size.width / rawScrollView.imageView.frame.size.width;
    rawScrollView.minimumZoomScale = newZoomScale;
    [rawScrollView setZoomScale:newZoomScale animated:YES];
  
    [_imgViewer centerScrollViewContents:rawScrollView];
}
#pragma mark - CustomAlertView delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    [alertView close];
}
- (UIView *)createContainerViewForPatternImg {
    CGRect frame = self.view.frame;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*0.9, frame.size.height*0.7)];
    CGFloat itemPanding = 10;
    CGFloat itemWidth = frame.size.width*0.9-itemPanding*2;
    CGFloat itemHeight = frame.size.height*0.7-itemPanding*2;
    
    _imgViewer = [[MGImageViewer alloc] initWithFrame:CGRectMake(itemPanding, itemPanding, itemWidth, itemHeight)];
    _imgViewer.imageViewerDelegate = self;
    _imgViewer.imageCount = 1;
    [_imgViewer setNeedsReLayout];
    [_imgViewer setPage:0];
    
    [containerView addSubview:_imgViewer];
    
    return containerView;
}
- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise {
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(BOOL) checkValid{
    if (!self.m_fabricView.image) {
        [[AppManager sharedInstance] showMessageWithTitle:@"" message:@"Please take a photo of fabric." view:self ];
        return NO;
    }
    if ([_fabricInfo.name isEqualToString:@""]) {
        [[AppManager sharedInstance] showMessageWithTitle:@"" message:@"Please type a fabric's name." view:self ];
        return NO;
    }

    BOOL valid = NO;
    for (int i = 0; i < _selectedList.count; i++) {
        SelectModel* item = _selectedList[i];
        if(item.isSelected){
            valid = YES;
            break;
        }
    }
    if (!valid) {
        [[AppManager sharedInstance] showMessageWithTitle:@"" message:@"Please select a category at least." view:self];
        return NO;
    }
    
    return YES;
}
-(void)initUI{
    NSString* title;
    if (self.m_fabricModel) {
        title = self.m_fabricModel.info.name;
        self.m_btnBookMark.enabled = true;
        self.m_imgBookMark.hidden = !self.m_fabricModel.isBookMark;
        self.m_btnSave.title = @"Delete";
    }else{
        title = @"SCAN FABRIC";
        self.m_btnBookMark.enabled = false;
        self.m_imgBookMark.hidden = YES;
        self.m_btnSave.title = @"Save";
    }
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:title navi:self.navigationItem];
    
    self.m_collectionView.allowsMultipleSelection = YES;
    _isUpdatedImage = NO;
    _isUpdateFabric = false;
    
    if (self.m_fabricModel) {
        _fabricInfo = self.m_fabricModel.info;
        NSString *imgUrl = self.m_fabricModel.imageUrl;
        UIImage *placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
        [self.m_fabricView sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:imgUrl] placeholderImage:placeholderImage];
    }else{
        _fabricInfo = [[FabricInfo alloc] init];
    }

}
-(void)changeSaveStatus{
    if ([self.m_btnSave.title isEqualToString: @"Delete"]) {
        self.m_btnSave.title = @"Save";
    }
}
- (void)reloadCategoryView {
    
    _categories = [AppManager sharedInstance].fabricCategoryList;
    [self.m_collectionView reloadData];
    
    if (!_selectedList) {
        _selectedList = [[NSMutableArray alloc] init];
        for (FabricCategoryInfo* info in _categories) {
            [_selectedList addObject:[[SelectModel alloc] initWithName:info.fid]];
        }
        
        if (self.m_fabricModel) {
            for (NSInteger i = 0; i < _selectedList.count; i++) {
                SelectModel* sel = _selectedList[i];
                for (NSString* fid in self.m_fabricModel.categories) {
                    if ([fid isEqualToString:sel.key]) {
                        sel.isSelected = YES;
                        break;
                    }
                }
                
            }
        }
    }else{
        NSMutableArray* tempList = [[NSMutableArray alloc] initWithArray:_selectedList];
        [_selectedList removeAllObjects];
        
        for (FabricCategoryInfo* info in _categories) {
            SelectModel* newItem = [[SelectModel alloc] initWithName:info.fid];
            for (SelectModel* model in tempList) {
                if ([model.key isEqualToString:newItem.key]) {
                    newItem.isSelected = model.isSelected;
                    break;
                }
            }
            [_selectedList addObject:newItem];
        }
    }
    
    for (NSInteger i = 0; i < _selectedList.count; i++) {
        SelectModel* sel = _selectedList[i];
        if (sel.isSelected) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.m_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }

    
    
}
- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message isAction:(Boolean)isAction {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(isAction == true) {
          [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
