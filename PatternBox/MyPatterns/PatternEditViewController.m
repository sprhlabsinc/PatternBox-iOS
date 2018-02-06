//
//  PatternEditViewController.m
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternEditViewController.h"
#import "Define.h"
#import "CategoryCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import "SelectModel.h"
#import "PatternCategoryInfo.h"
#import "PurchaseController.h"

@interface PatternEditViewController ()

@end

@implementation PatternEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];
    [self initialUIAtLaunch];
    [self takePatternFrom];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect viewFrame = self.m_viwNotes.frame;
    viewFrame.size.height = self.view.frame.size.height - 100 - viewFrame.origin.y;
    //self.m_viwNotes.frame = viewFrame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadCategoryView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _categories.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == _categories.count) {
        cell.m_imgCategoryIcon.image = [UIImage imageNamed:@"c_plus"];
        cell.m_lableCategoryName.text = @"";
        [cell setCellSelect:false];
    }else{
        PatternCategoryInfo* item = _categories[indexPath.row];
        NSString* categoryName = item.name;
        cell.m_lableCategoryName.text = [categoryName uppercaseString];
        if (item.isDefault) {
            UIImage* image = [UIImage imageNamed:item.icon];
            cell.m_imgCategoryIcon.image = image;
        }else{
            cell.m_imgCategoryIcon.image = [[AppManager sharedInstance] createInitial:item.name];
        }
        
        SelectModel* sel = _selectedList[indexPath.row];
        [cell setCellSelect:sel.isSelected];
    }
    
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _categories.count) {
        [collectionView deselectItemAtIndexPath:indexPath animated:true];
        [self performSegueWithIdentifier:@"sequeCategory" sender:self];
    }else{
        SelectModel* item = _selectedList[indexPath.row];
        item.isSelected = !item.isSelected;
        
        CategoryCell *cell = (CategoryCell *)[self.m_collectionView cellForItemAtIndexPath:indexPath];
        [cell setCellSelect:item.isSelected];
    }
    [self.m_collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    int width = self.m_collectionView.frame.size.width/2 - 15;
    int height = width * 0.8;
    return CGSizeMake(width, height);
}
*/
#pragma mark - Actions
- (IBAction)actionPatternSave:(id)sender {
    if (![self checkValid]) return;
    
    [self savePattern];
}

- (IBAction)actionFrontImage:(id)sender {
    _isFrontPattern = YES;
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

- (IBAction)actionBackImage:(id)sender {
    _isFrontPattern = NO;
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

#pragma mark - TextField Delegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:_bgTapGesture];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.m_txtNotes becomeFirstResponder];
    return YES;
}

#pragma mark - TextView Delegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [APPDELEGATE setViewMovedUp:YES view:self.view offset:240];
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [APPDELEGATE setViewMovedUp:NO view:self.view offset:240];
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.m_txtNotes becomeFirstResponder];
    [self.m_txtNotes resignFirstResponder];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (_isFrontPattern) {
        _imgFrontPattern = chosenImage;
        [self.m_btnFrontImage setImage:chosenImage forState:UIControlStateNormal];
    } else {
        _imgBackPattern = chosenImage;
        [self.m_btnBackImage setImage:chosenImage forState:UIControlStateNormal];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(tag == 101) {
          [self performSegueWithIdentifier:@"seguePDFSaved" sender:self];
        }else if (tag == 102) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initialUIAtLaunch {
    self.m_btnCategory.layer.cornerRadius = 4;
    self.m_btnCategory.layer.borderWidth = 0.1;
    self.m_btnCategory.layer.borderColor = self.m_txtPatternName.layer.borderColor;
    
    self.m_viwNotes.layer.cornerRadius = 4;
    self.m_viwNotes.layer.borderWidth = 0.1;
    self.m_viwNotes.layer.borderColor = self.m_txtPatternName.layer.borderColor;
    
    self.m_btnFrontImage.layer.cornerRadius = 3;
    self.m_btnFrontImage.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    self.m_btnFrontImage.layer.borderWidth = 1;
    self.m_btnFrontImage.layer.masksToBounds = YES;
    
    self.m_btnBackImage.layer.cornerRadius = 3;
    self.m_btnBackImage.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    self.m_btnBackImage.layer.borderWidth = 1;
    self.m_btnBackImage.layer.masksToBounds = YES;

    self.m_collectionView.allowsMultipleSelection = YES;
    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];

    if (self.m_ViewMode == VM_PDFs) self.m_viewBottomBar.hidden = YES;
    else self.m_viewBottomBar.hidden = NO;
    self.m_viewBottomBar.hidden = YES;
}

- (void)buttonImgAndTitleAdjust:(UIButton *)button andWidth:(CGFloat)width{
    button.imageEdgeInsets = UIEdgeInsetsMake(14, width-10-14, 14, 10);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
}

- (void)takePatternFrom {
    
    _categories = [AppManager sharedInstance].patternCategoryList;
   
    self.m_txtPatternName.text = self.m_pattern.name;
    self.m_txtPatternID.text = self.m_pattern.type;
    self.m_txtNotes.text = self.m_pattern.notes;
}

- (void)reloadCategoryView {
    
    _categories = [AppManager sharedInstance].patternCategoryList;
    [self.m_collectionView reloadData];
    
    if (!_selectedList) {
        _selectedList = [[NSMutableArray alloc] init];
        for (PatternCategoryInfo* info in _categories) {
            [_selectedList addObject:[[SelectModel alloc] initWithName:info.fid]];
        }
        
        if (self.m_pattern) {
            for (NSInteger i = 0; i < _selectedList.count; i++) {
                SelectModel* sel = _selectedList[i];
                for (NSString* fid in self.m_pattern.categories) {
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
        
        for (PatternCategoryInfo* info in _categories) {
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

- (void)savePattern {
    


    NSMutableArray* categories = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _selectedList.count; i++) {
        SelectModel* sel = _selectedList[i];
        if(sel.isSelected){
            PatternCategoryInfo* item = _categories[i];
            [categories addObject:[NSString stringWithFormat:@"%@", item.fid]];
        }
        
    }
    
    NSString* strCategories = [categories componentsJoinedByString:@","];
    
    NSMutableDictionary * newPattern = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                         KPatternName:self.m_txtPatternName.text,
                                                                                         KPatternKey:self.m_txtPatternID.text,
                                                                                         KPatternInfo:self.m_txtNotes.text,
                                                                                         KPatternCategories:strCategories
                                                                                         }];
    
    if (self.m_ViewMode == VM_NewPDF) {
         NSString *time =[NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        [newPattern setValue:@YES forKey:KPatternIsPDF];
        [newPattern setValue:[self.m_PDFUrls componentsJoinedByString:@","] forKey:KPatternUrls];
        NSMutableArray* data = [[NSMutableArray alloc] init];

        if(self.isZIPFile){

            
            NSInteger count = self.m_PDFUrls.count;
            if (count == 0) {
                [self showMessageWithTitle:@"" message:@"Pattern Save failed." tag:0];
                return;
            }
            
            
            NSData* pdfData = [[NSFileManager defaultManager] contentsAtPath:self.m_PDFUrls[0]];
            NSString *thumbnailName = [NSString stringWithFormat:@"%@_t.jpg",time];
            NSData* thumbData = UIImageJPEGRepresentation([[AppManager sharedInstance] getThumbnailFromPDF:pdfData], 1);
            
            [newPattern setValue:thumbnailName forKey:KPatternFronPic];
            [data addObject:@{@"name":thumbnailName,@"data":thumbData}];
            
            NSMutableArray* urls = [[NSMutableArray alloc] init];
            for (int i = 0; i< count; i++) {
               NSString *pdfFileName = [NSString stringWithFormat:@"%@_%d.pdf",time,i];
               NSData* pdfData = [[NSFileManager defaultManager] contentsAtPath:self.m_PDFUrls[i]];
               [data addObject:@{@"name":pdfFileName,@"data":pdfData}];
                
                NSString* pdfUrl = [[AppManager sharedInstance] downloadUrlWithFileName:pdfFileName].absoluteString;
                [urls addObject:pdfUrl];
            }
            
            [newPattern setValue:[urls componentsJoinedByString:@","] forKey:KPatternUrls];
            
            NSFileManager* fileManager = [NSFileManager defaultManager];
            for (NSString *path in self.m_PDFUrls) {
                if(path){
                    [fileManager removeItemAtPath:path error:nil];
                }
            }
            
        }else if(self.m_PDFData){
         
             NSString *thumbnailName = [NSString stringWithFormat:@"%@_t.jpg",time];
             NSData* thumbData = UIImageJPEGRepresentation([[AppManager sharedInstance] getThumbnailFromPDF:self.m_PDFData], 1);
             [newPattern setValue:thumbnailName forKey:KPatternFronPic];
             [data addObject:@{@"name":thumbnailName,@"data":thumbData}];
             
             if(self.isOpenInURL){
                 // When PDF file is local file, Upload PDF file and Thumbnail image on FireBase.com
                 NSString *pdfFileName = [NSString stringWithFormat:@"%@.pdf",time];
                 [data addObject:@{@"name":pdfFileName,@"data":self.m_PDFData}];
                 
                 NSString* pdfUrl = [[AppManager sharedInstance] downloadUrlWithFileName:pdfFileName].absoluteString;
                 [newPattern setValue:pdfUrl forKey:KPatternUrls];
  
             }
      

         }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AppManager sharedInstance] uploadFile:@"upload" data:data parameter:newPattern withCallback:^(NSDictionary *response, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                bool fail = [[response objectForKey:@"error"] boolValue];
                if (fail || !response) {
                    NSString* message = [response objectForKey:@"message"];
                    message = [message isEqualToString:@""] || !message ? @"File exceeds the limit" : message;
                    [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                }else{
                    NSString* pattern_id = [response objectForKey:@"pattern_id"];
                    PatternModel* newModel = [[PatternModel alloc] initWithData:newPattern];
                    newModel.fid = [pattern_id integerValue];
                    [[AppManager sharedInstance].patternList addObject:newModel];
                    
                    //[AppManager sharedInstance].purchaseStatus =[[response objectForKey:@"purchase"] integerValue];
                    [self showMessageWithTitle:@"" message:@"PATTERN SAVED" tag:101];
                    
                }
            } else {
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
            }
        }];

    }else{
        
        NSString* tag = [NSString stringWithFormat:@"patterns/%ld",(long)self.m_pattern.fid];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AppManager sharedInstance] putRequest:tag  parameter:newPattern withCallback:^(NSDictionary *response, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                bool fail = [[response objectForKey:@"error"] boolValue];
                if (fail || !response) {
                    NSString* message = [response objectForKey:@"message"];
                    message = [message isEqualToString:@""] || !message ? @"fail" : message;
                    [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                }else{
                    
                    self.m_pattern.name = self.m_txtPatternName.text;
                    self.m_pattern.type = self.m_txtPatternID.text;
                    self.m_pattern.notes = self.m_txtNotes.text;
                    self.m_pattern.categories = categories;
                    [self showMessageWithTitle:@"" message:@"PATTERN SAVED" tag:102];
                }
            } else {
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
            }
        }];
    }

}



- (void)downloadAndSavePDFs:(NSMutableDictionary *)pattern {
    for (NSURL *url in self.m_PDFUrls) {
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:url];
        if (!pdfData) break;
        
        // Store the Data locally as PDF File
        NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                      [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                      stringByAppendingPathComponent:@"Documents"
                                                                      ]];
        
        NSString *filePath = [resourceDocPath
                              stringByAppendingPathComponent:@"myPDF.pdf"];
        [pdfData writeToFile:filePath atomically:YES];

    }
}

- (BOOL)checkValid{
    if ([self.m_txtPatternName.text isEqualToString:@""]) {
        [self showMessageWithTitle:@"" message:@"Please enter pattern name." tag:0];
        return NO;
    }
    
    if ([self.m_txtPatternID.text isEqualToString:@""]) {
        [self showMessageWithTitle:@"" message:@"Please enter pattern id." tag:0];
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
        [self showMessageWithTitle:@"" message:@"Please select a category at least." tag:0];
        return NO;
    }
    
    return YES;
}

@end
