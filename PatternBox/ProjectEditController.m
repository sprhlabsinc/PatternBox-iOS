//
//  ProjectEditController.m
//  PatternBox
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "ProjectEditController.h"

#import "AppManager.h"
#import "FabricViewController.h"
#import "FabricDetailVC.h"
#import "NotionsForProjectVC.h"
#import "PatternViewController.h"
#import "PatternDetailViewController.h"
#import "CustomIOS7AlertView.h"
#import "MGImageViewer.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "PurchaseController.h"



@interface ProjectEditController ()<UICollectionViewDelegate,UICollectionViewDataSource,CustomIOS7AlertViewDelegate,MGImageViewerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate>{
    PatternModel* _pattern;
    NSArray*      _fabrics;
    NSMutableArray*      _notions;
    Boolean       _isUpdate;
    CGFloat       _padding;
    CGFloat       _cellWidth;
    CGFloat       _cellMaxWidth;
    MGImageViewer *_imgViewer;
    UIImage*       _projectImage;
    
    Boolean       _isUpdatedImage;
    
    NSString* Pattern_Button_Title;
    NSString* Fabric_Button_Title ;
    NSString* Notion_Button_Title ;

}

@end

@implementation ProjectEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUpdate = false;
    Pattern_Button_Title = @"Select Pattern";
    Fabric_Button_Title =  @"Select Fabrics";
    Notion_Button_Title =  @"Select Notions";
    
    UITapGestureRecognizer* _photoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapAction:)];
    [self.m_imgProject addGestureRecognizer:_photoTapGesture];
    
    _padding = 5;_cellMaxWidth = 200;
    [self initParameter];
    [self initialUIAtLaunch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGFloat width = self.m_collectionView.frame.size.height - 2* _padding;
    _cellWidth = width > _cellMaxWidth ? _cellMaxWidth:width;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)actionSelectPattern:(id)sender {
    if (_isUpdate) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PatternDetailViewController *patternVC = (PatternDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PatternDetailViewController"];
        patternVC.m_pattern = _pattern;
        if (_pattern.isPDF) {
            patternVC.m_ViewMode = VM_PDFs;
        }else{
            patternVC.m_ViewMode = VM_Scans;
        }
        
        [self.navigationController pushViewController:patternVC animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PatternViewController *patternVC = (PatternViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PatternViewController"];
        patternVC.m_openStatus = PATTERN_STATUS_SELECT;
        patternVC.m_projectEditVC = self;
        patternVC.m_selectedPattern = _pattern;
        patternVC.m_isAddToProject = true;
        [self.navigationController pushViewController:patternVC animated:YES];
    }

}

- (IBAction)actionSelectFabric:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Fabric" bundle:nil];
    FabricViewController *fabircVC = (FabricViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FabricViewController"];
    fabircVC.m_openStatus = PATTERN_STATUS_SELECT;
    fabircVC.m_projectEditVC = self;
    fabircVC.m_selectedFabrics = _fabrics;
    fabircVC.m_isAddToProject = true;
    [self.navigationController pushViewController:fabircVC animated:YES];
}

- (IBAction)actionSelectNotion:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Fabric" bundle:nil];
    NotionsForProjectVC *notionVC = (NotionsForProjectVC *)[storyboard instantiateViewControllerWithIdentifier:@"NotionsForProjectVC"];
    //notionVC.m_openStatus = PATTERN_STATUS_SELECT;
    notionVC.m_projectEditVC = self;
    notionVC.m_notions = _notions;
    [self.navigationController pushViewController:notionVC animated:YES];
}

- (IBAction)actionSaveProject:(id)sender {
    if (_isUpdate) {
        _isUpdate = false;
        [self updateUIWithStatus];
    }else{
        [self saveProject];
    }
}
#pragma mark UPDATE MODELS

-(void)updatePatternModel:(PatternModel *)model{
    if(!_isUpdate){
        _pattern = [model createClone];
        [self updateUIWithStatus];
    }
}
-(void)updateFabricModels:(NSArray *)models{
    if(!_isUpdate){
        NSMutableArray* tempList = [[NSMutableArray alloc] init];
        for (FabricModel* item in models) {
            [tempList addObject:[item createClone]];
        }
        _fabrics = tempList;
        [self updateUIWithStatus];
        [self.m_collectionView reloadData];
    }
    
}

-(void)updateNotionModels:(NSArray *)models isReplace:(Boolean)isReplace{
    if(!_isUpdate){
        NSMutableArray* tempList = [[NSMutableArray alloc] init];
        for (NotionModel* item in models) {
            NotionModel* newModel = [item createClone];
            newModel.howmany = item.howmany;
            [tempList addObject:newModel];
        }
        if (isReplace) {
            _notions = tempList;
        }else{
            [_notions addObjectsFromArray:tempList];
            for (NotionModel* item in tempList) {
                Boolean isExist = false;
                for (NotionModel* old in _notions) {
                    if (item.fid  == old.fid) {
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) {
                    [_notions addObject:item];
                }
            }
        }
        
        [self updateUIWithStatus];
    }
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _fabrics.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImageView* imgBookmark = (UIImageView*)[cell viewWithTag:200];
    UIImageView* imgFabric = (UIImageView*)[cell viewWithTag:100];
    imgFabric.layer.cornerRadius = 4;
    imgFabric.layer.shadowOffset = CGSizeMake(2, 2);
    imgFabric.layer.shadowOpacity = 0.2;
    imgFabric.layer.masksToBounds = YES;
    UILabel* lblName = (UILabel*)[cell viewWithTag:300];
    
    FabricModel* model = _fabrics[indexPath.row];
    [imgBookmark setHidden:!model.isBookMark];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"fabric"];
    [imgFabric sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:model.imageUrl] placeholderImage:placeholderImage];
    
    UIColor* backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [lblName setBackgroundColor:backgroundColor];
    lblName.text = model.info.name;
    
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(_padding, _padding, _padding, _padding);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_cellWidth, _cellWidth);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.m_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Fabric" bundle:nil];
    FabricDetailVC *fabircVC = (FabricDetailVC *)[storyboard instantiateViewControllerWithIdentifier:@"FabricDetailVC"];
    fabircVC.m_fabricModel = _fabrics[indexPath.row];
    [self.navigationController pushViewController:fabircVC animated:YES];
    
}
#pragma mark - CollectionView Delegate

#pragma mark - TextView Delegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) return YES;
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

#pragma mark - TextField Delegate
- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark Project SAVE, UPDATE and DELETE
- (void)saveProject {
    
    if(![self checkValid]) return;
    
   
    NSMutableArray* fabrics = [[NSMutableArray alloc] init];
    for (FabricModel* model in _fabrics) {
        [fabrics addObject:[NSNumber numberWithInteger: model.fid]];
    }
    NSString* strFabrics = [fabrics componentsJoinedByString:@","];
    
    // Make Notion (ID, HowMany) String
    NSMutableArray* notions = [[NSMutableArray alloc] init];
    for (NotionModel* model in _notions) {
        if (model.howmany > 0) {
            NSString* item = [NSString stringWithFormat:@"%ld,%ld",(long)model.fid,(long)model.howmany];
            [notions addObject:item];
        }
    }
    NSString* strNotions = [notions componentsJoinedByString:@":"];
    NSMutableDictionary * newPattern = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                         KProjectName:self.m_txtProjectName.text,
                                                                                         KProjectClient:self.m_txtProjectFor.text,
                                                                                         KProjectMeasurement:self.m_txtProjectMeasurment.text,
                                                                                         KProjectNotes:self.m_txtProjectNote.text,
                                                                                         KProjectPattern:[NSNumber numberWithInteger:_pattern.fid],
                                                                                         KProjectFabrics:strFabrics,
                                                                                         KProjectNotions:strNotions
                                                                                         }];
    NSMutableArray* data = [[NSMutableArray alloc] init];
    
    if(self.m_project){
        [newPattern setValue:[NSNumber numberWithInteger:self.m_project.fid]  forKey:KProjectId];
        [newPattern setValue:@YES forKey:@"is_update"];
        
        if(_isUpdatedImage){
            NSData* imgData = UIImageJPEGRepresentation(self.m_imgProject.image, 0.5);
            [data addObject: @{@"name":self.m_project.image,@"data":imgData}];
        }

        [self updateProject:data parameter:newPattern];

    }else{
        NSString *time =[NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        NSString *imageName = [NSString stringWithFormat:@"%@_pro.jpg",time];
        
        NSData* imgData = UIImageJPEGRepresentation(self.m_imgProject.image, 0.5);
        [data addObject: @{@"name":imageName,@"data":imgData}];
        
        [newPattern setValue:imageName forKey:KProjectImageName];
        [self createProject:data parameter:newPattern];
        return;
    }
    
}
-(void)createProject:(NSArray*)data parameter:(NSDictionary*)parameter{
    

    NSMutableDictionary* newPattern = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    [self updateProject:data parameter:newPattern];
}
-(void)updateProject:(NSArray*)data parameter:(NSDictionary*)parameter{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] uploadFile:@"upload_project" data:data parameter:parameter withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"File exceeds the limit" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                if (data) {
                    // Remove Web Image Cache
                    if (_isUpdatedImage && self.m_project) {
                        NSString* url = [[AppManager sharedInstance] downloadUrlWithFileName:self.m_pattern.frontImage].absoluteString;
                        [[SDImageCache sharedImageCache] removeImageForKey:url];
                    }
                }
                //[AppManager sharedInstance].purchaseStatus =[[response objectForKey:@"purchase"] integerValue];
                [self showMessageWithTitle:@"" message:@"PROJECT SAVED" tag:101];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    _projectImage = chosenImage;
    self.m_imgProject.image = chosenImage;
    _isUpdatedImage = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - Tap Gesture Recognizer Delegate
-(void)photoTapAction:(UITapGestureRecognizer *)tap {
    if (_isUpdate) {
        [self showImageDialog];
    }else{
        [self captureImage];
    }
}
-(void)showImageDialog {
    if (!self.m_imgProject.image) return;
    
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
-(void)captureImage{
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
#pragma mark - MGImageViewer Delegate
-(void) MGImageViewer:(MGImageViewer *)_imageViewer didCreateRawScrollView:(MGRawScrollView *)rawScrollView atIndex:(int)index{
    
    UIImage* image = self.m_imgProject.image;
    
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
#pragma mark custom
-(void)initParameter{
    if (self.m_project) {
        _isUpdate = true;
        _pattern = [[self.m_project getPatternModel] createClone];
        _notions =  [[NSMutableArray alloc] initWithArray:[self.m_project getNotionModels]];
        _fabrics = [self.m_project getFabricModels];
    }else{
        _isUpdate = false;
        _pattern = [[PatternModel alloc] init];
        _fabrics = [[NSArray alloc] init];
        _notions = [[NSMutableArray alloc] init];
    }
    
    if (self.m_pattern) {
        _isUpdate = false;
        //_pattern = [self.m_pattern createClone];
        [self updatePatternModel:self.m_pattern];
    }
    if (self.m_fabrics) {
       // _fabrics = self.m_fabrics;
        _isUpdate = false;
       [self updateFabricModels:self.m_fabrics];
    }
    if (self.m_notions) {
        _isUpdate = false;
        //_notions = self.m_notions;
        [self updateNotionModels:self.m_notions isReplace:false];
    }
}
- (void)initialUIAtLaunch {
    

    
    // Project
    self.m_txtProjectNote.layer.cornerRadius = 6;
    self.m_txtProjectNote.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.m_txtProjectNote.layer.borderWidth = 1;
    self.m_txtProjectNote.layer.masksToBounds = YES;
    self.m_txtProjectNote.placeholder = @"NOTES";
    
    // Notion
    self.m_txtNotion.layer.cornerRadius = 6;
    self.m_txtNotion.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.m_txtNotion.layer.borderWidth = 1;
    self.m_txtNotion.layer.masksToBounds = YES;
    self.m_txtNotion.placeholder = @"NOTES";
    
    
    self.m_imgPattern.layer.cornerRadius = 4;
    self.m_imgPattern.layer.masksToBounds = YES;
    
    [self.m_imgProject setUserInteractionEnabled:YES];
    self.m_imgProject.layer.cornerRadius = 6;
    self.m_imgProject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.m_imgProject.layer.borderWidth = 1;
    self.m_imgProject.layer.masksToBounds = YES;
    
    self.m_imgProject.layer.shadowOffset = CGSizeMake(2, 4);
    self.m_imgProject.layer.shadowOpacity = 0.8;
    self.m_imgProject.layer.shadowRadius = 5;
    
    [self updateUIWithStatus];
}
-(void)updateUIWithStatus{
    
    if (_isUpdate) {
        
        [self.m_txtProjectName setEnabled:false];
        [self.m_txtProjectFor setEnabled:false];
        [self.m_txtProjectMeasurment setEnabled:false];
        [self.m_txtProjectNote setEditable:false];
        
        [self.m_btnPattern setTitle:@"" forState:UIControlStateNormal];
        [self.m_btnFabric setHidden:YES];
        [self.m_btnNotion setTitle:@"" forState:UIControlStateNormal];
        
        
        [self.m_imgPattern setHidden:NO];
        [self.m_imgPatternBookmark setHidden:NO];
        
        [self.m_btnSave setTitle:@"Edit"];
        

    }else{
        
        [self.m_txtProjectName setEnabled:true];
        [self.m_txtProjectFor setEnabled:true];
        [self.m_txtProjectMeasurment setEnabled:true];
        [self.m_txtProjectNote setEditable:true];
       
        
        [self.m_btnFabric setHidden:NO];
        
        [self.m_btnSave setTitle:@"Save"];
    }
    
    if (self.m_project) {
        UIImage* placeholderImage = [UIImage imageNamed:@"project"];
        [self.m_imgProject sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:self.m_project.image] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _projectImage = image;
        }];
        self.m_txtProjectName.text = self.m_project.name;
        self.m_txtProjectFor.text = self.m_project.client;
        self.m_txtProjectMeasurment.text = self.m_project.measurements;
        self.m_txtProjectNote.text = self.m_project.notes;
    }

    
    if (_pattern.fid >= 0) {
        [self.m_imgPattern setHidden:NO];
        [self.m_imgPatternBookmark setHidden:NO];
        [self.m_btnPattern setTitle:@"" forState:UIControlStateNormal];
        
        UIImage *placeholderImage;
        if (_pattern.isPDF) {
            placeholderImage = [UIImage imageNamed:@"icon_PDFdoc.png"];
        }else{
            placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
        }
    
        [self.m_imgPattern sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:_pattern.frontImage] placeholderImage:placeholderImage];
    
        if (_pattern.isBookMark) {
            self.m_imgPatternBookmark.hidden = NO;
        } else {
            self.m_imgPatternBookmark.hidden = YES;
        }
        
        self.m_lblPatternName.text = _pattern.name;
        self.m_lblPatternType.text = _pattern.type;
        self.m_lblPatternCategories.text = [[_pattern getCategoryNameList] componentsJoinedByString:@","];
        
    }else{
        [self.m_imgPattern setHidden:YES];
        [self.m_imgPatternBookmark setHidden:YES];
        [self.m_btnPattern setTitle:Pattern_Button_Title forState:UIControlStateNormal];
    }
    
    
    if (_fabrics.count > 0) {
        [self.m_btnFabric setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.m_btnFabric setTitle:Fabric_Button_Title forState:UIControlStateNormal];
    }
    
    if (_notions.count > 0) {
        [self.m_txtNotion setHidden:NO];
        [self.m_btnNotion setTitle:@"" forState:UIControlStateNormal];
 
        self.m_txtNotion.text = [self getNotionDescription];
    }else{
        [self.m_txtNotion setHidden:YES];
        [self.m_btnNotion setTitle:Notion_Button_Title forState:UIControlStateNormal];
    }
    

}

- (BOOL)checkValid{
    
    if ([self.m_txtProjectName.text isEqualToString:@""]) {
        [self showMessageWithTitle:@"" message:@"Please enter project name." tag:0];
        return NO;
    }
    
    if ([self.m_txtProjectFor.text isEqualToString:@""]) {
        [self showMessageWithTitle:@"" message:@"Please enter 'Project For'." tag:0];
        return NO;
    }

    if (!_pattern || _pattern.fid == -1) {
        [self showMessageWithTitle:@"" message:@"Please select a pattern." tag:0];
        return NO;
    }
//    if (!_fabrics || _fabrics.count == 0 ) {
//        [self showMessageWithTitle:@"" message:@"Please select a fabrics at least." tag:0];
//        return NO;
//    }
//
//    
//    if (!_notions|| _notions.count == 0) {
//        [self showMessageWithTitle:@"" message:@"Please select a notions." tag:0];
//        return NO;
//    }
    
    return YES;
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(tag == 101) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSString*)getNotionDescription{
    NSString* des = @"";
    NSArray* categories = [AppManager sharedInstance].notionCategoryList;

    for (NotionCategoryInfo* info in categories) {
        int sum = 0;
        
        for (NotionModel* model in _notions) {
            if ([info.fid isEqualToString:model.categoryId]) {
                sum += model.howmany;
            }
        }
        if (sum > 0) {
            des =  [NSString stringWithFormat:@"%@,  %@: %d",des,[info.name uppercaseString],sum];
        }
        
    }
    if (des.length > 0) {
        des = [des substringFromIndex:1];
    }
    return des;
}
@end
