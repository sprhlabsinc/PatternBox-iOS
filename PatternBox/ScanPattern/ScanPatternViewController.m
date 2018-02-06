//
//  ScanPatternViewController.m
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Updated by Kristaps Kuzmins on 04/04/2017.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "ScanPatternViewController.h"
#import "CategoryCell.h"
#import "PatternInfoViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import "SelectModel.h"
#import "PatternCategoryInfo.h"

#define POPUPTYPE_NONE  0
#define POPUPTYPE_IMG   1
#define POPUPTYPE_SAVE  2

@interface ScanPatternViewController ()

@end

@implementation ScanPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFrontPattern = YES;
    //[APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];

   
    [self initialUIAtLaunch];
    _popupType = POPUPTYPE_NONE;
    _photoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTappedAction:)];
    [self.m_patternView addGestureRecognizer:_photoTapGesture];
    self.m_collectionView.allowsMultipleSelection = YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadCategoryView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueNext"]) {
        PatternInfoViewController *target = (PatternInfoViewController *)segue.destinationViewController;
        
        target.m_imgFrontPattern = _imgFrontPattern;
        target.m_imgBackPattern = _imgBackPattern;
        
        NSMutableArray* categories = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _selectedList.count; i++) {
            SelectModel* sel = _selectedList[i];
            if(sel.isSelected){
                PatternCategoryInfo* item = _categories[i];
                [categories addObject:[NSString stringWithFormat:@"%@", item.fid]];
            }
            
        }
        
        NSString* strCategories = [categories componentsJoinedByString:@","];
        target.m_categories = strCategories;
    }
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

- (IBAction)actionSelFrontPattern:(id)sender {
    _isFrontPattern = YES;
    self.m_patternView.image = _imgFrontPattern;
    self.m_btnFront.tintColor = KColorHighlight;
    self.m_btnBack.tintColor = UIColor.whiteColor;
    
    self.imgRightArrow.tintColor = KColorHighlight;
    self.imgLeftArrow.tintColor = UIColor.whiteColor;
}

- (IBAction)actionSelBackPattern:(id)sender {
    _isFrontPattern = NO;
    self.m_patternView.image = _imgBackPattern;
 
    self.m_btnFront.tintColor = UIColor.whiteColor;
    self.m_btnBack.tintColor = KColorHighlight;
    
    self.imgRightArrow.tintColor = UIColor.whiteColor;
    self.imgLeftArrow.tintColor = KColorHighlight;
}

- (IBAction)actionSavePattern:(id)sender {
    if (![self checkValid]) return;
    
    [self performSegueWithIdentifier:@"segueNext" sender:self];
}

- (IBAction)actionRotate:(id)sender {
    UIImage *chosenImage;// = [self rotate:self.m_patternView.image orientation:UIImageOrientationLeft];
    
    chosenImage = [self rotateUIImage:self.m_patternView.image clockwise:NO];
    self.m_patternView.image = chosenImage;
    if (_isFrontPattern) _imgFrontPattern = chosenImage;
    else _imgBackPattern = chosenImage;

}

#pragma mark - CustomAlertView delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
    
    if (buttonIndex == 0 && _popupType == POPUPTYPE_SAVE) {
        UITextField *txtName = (UITextField *)[alertView viewWithTag:101];
        UITextView *infoView = (UITextView *)[alertView viewWithTag:102];
        UITextField *txtID = (UITextField *)[alertView viewWithTag:103];
        
        if ([txtName.text isEqualToString:@""] || [infoView.text isEqualToString:@""] || [txtID.text isEqualToString:@""]) {
            [self showMessageWithTitle:@"" message:@"Please enter pattern name/id/info required in popup dialog."];
            return;
        }
        [self showMessageWithTitle:@"" message:@"PATTERN SAVED"];
    }

    _popupType = POPUPTYPE_NONE;
}

- (UIView *)createContainerView {
    CGRect frame = self.view.frame;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*0.8, frame.size.height*0.6)];
    CGFloat itemPanding = 10;
    CGFloat itemWidth = frame.size.width*0.8-itemPanding*2;

    UILabel *dialogTitle = [[UILabel alloc] initWithFrame:CGRectMake(itemPanding, 20, itemWidth, 30)];
    dialogTitle.text = @"PATTERN INFO";
    dialogTitle.font = [UIFont boldSystemFontOfSize:20];
    dialogTitle.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(itemPanding, 50+10, itemWidth, 21)];
    lblName.text = @"PATTERN NAME";
    lblName.font = [UIFont systemFontOfSize:16];
    lblName.textAlignment = NSTextAlignmentLeft;
    
    UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(itemPanding, 60+21+5, itemWidth, 21)];
    txtName.font = [UIFont systemFontOfSize:15];
    txtName.placeholder = @"Pattern Name";
    txtName.delegate = self;
    [txtName setBorderStyle:UITextBorderStyleRoundedRect];
    txtName.returnKeyType = UIReturnKeyDone;
    
    UILabel *lblId = [[UILabel alloc] initWithFrame:CGRectMake(itemPanding, 86+21+10, itemWidth, 21)];
    lblId.text = @"PATTERN ID";
    lblId.font = [UIFont systemFontOfSize:16];
    lblId.textAlignment = NSTextAlignmentLeft;
    
    UITextField *txtId = [[UITextField alloc] initWithFrame:CGRectMake(itemPanding, 117+21+5, itemWidth, 21)];
    txtId.font = [UIFont systemFontOfSize:15];
    txtId.placeholder = @"Pattern ID";
    txtId.delegate = self;
    [txtId setBorderStyle:UITextBorderStyleRoundedRect];
    txtId.returnKeyType = UIReturnKeyDone;
    
    UILabel *lblInto = [[UILabel alloc] initWithFrame:CGRectMake(itemPanding, 143+21+10, itemWidth, 21)];
    lblInto.text = @"NOTES";
    lblInto.font = [UIFont systemFontOfSize:16];
    lblInto.textAlignment = NSTextAlignmentLeft;
    
    UITextView *noteView = [[UITextView alloc] initWithFrame:CGRectMake(itemPanding, 174+21+5, itemWidth, frame.size.height*0.6-204)];
    noteView.font = [UIFont systemFontOfSize:15];
    noteView.layer.cornerRadius = 7.0f;
    noteView.layer.masksToBounds = YES;
    noteView.layer.borderWidth = 0.2;
    noteView.layer.borderColor = [UIColor grayColor].CGColor;
    noteView.returnKeyType = UIReturnKeyDone;
    
    noteView.delegate = self;

    [containerView addSubview:dialogTitle];
    [containerView addSubview:lblName];
    [containerView addSubview:txtName];
    [containerView addSubview:lblId];
    [containerView addSubview:txtId];
    [containerView addSubview:lblInto];
    [containerView addSubview:noteView];
    txtName.tag = 101;
    noteView.tag = 102;
    txtId.tag = 103;
    
    return containerView;
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

#pragma mark - MGImageViewer Delegate
-(void) MGImageViewer:(MGImageViewer *)_imageViewer didCreateRawScrollView:(MGRawScrollView *)rawScrollView atIndex:(int)index{
    
    UIImage* image;
    
    if (_isFrontPattern)
        image = _imgFrontPattern;
    else
        image = _imgBackPattern;
    
    rawScrollView.imageView.image = image;
    CGRect rect = rawScrollView.imageView.frame;
    rect.size = image.size;
    rawScrollView.imageView.frame = rect;
    
    CGFloat newZoomScale = rawScrollView.frame.size.width / rawScrollView.imageView.frame.size.width;
    rawScrollView.minimumZoomScale = newZoomScale;
    [rawScrollView setZoomScale:newZoomScale animated:YES];
    //                 rawScrollView.contentSize = image.size;
    
    [_imgViewer centerScrollViewContents:rawScrollView];
}

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

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.m_patternView.image = chosenImage;
    if (_isFrontPattern) _imgFrontPattern = chosenImage;
    else _imgBackPattern = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

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


#pragma mark - Tap Gesture Recognizer Delegate
-(void)photoTappedAction:(UITapGestureRecognizer *)tap {
    if (_isFrontPattern) {
        if (_imgFrontPattern == nil) return;
    } else {
        if (_imgBackPattern == nil) return;
    }
    
    _popupType = POPUPTYPE_IMG;
    
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

#pragma mark - Common
- (void)initialUIAtLaunch {
   
    self.m_patternView.layer.masksToBounds = YES;
    
    self.imgLeftArrow.image = [self.imgLeftArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imgRightArrow.image = [self.imgRightArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imgRightArrow.tintColor = KColorHighlight;
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message {
  
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL) checkValid{
    if (!_imgFrontPattern) {
        [self showMessageWithTitle:@"" message:@"Please take a front photo of pattern."];
        return NO;
    }
    
    if (!_imgBackPattern) {
        [self showMessageWithTitle:@"" message:@"Please take a back photo of pattern."];
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
        [self showMessageWithTitle:@"" message:@"Please select a category at least."];
        return NO;
    }
    
    return YES;
}

- (UIImage*)rotate:(UIImage*)src orientation:(UIImageOrientation)orientation {
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90*M_PI/180);
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90*M_PI/180);
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 90*M_PI/180);
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise {
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)reloadCategoryView {
    
    _categories = [AppManager sharedInstance].patternCategoryList;
    [self.m_collectionView reloadData];
    
    if (!_selectedList) {
        _selectedList = [[NSMutableArray alloc] init];
        for (PatternCategoryInfo* info in _categories) {
            [_selectedList addObject:[[SelectModel alloc] initWithName:info.fid]];
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

@end
