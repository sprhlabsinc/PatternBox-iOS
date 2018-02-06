//
//  PatternHighlightViewController.m
//  PatternBox
//
//  Created by youandme on 03/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternHighlightViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"

@interface PatternHighlightViewController ()

@end

@implementation PatternHighlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self takePatternFrom];
    [self initialUIAtLaunch];
    [self.m_drawingImgView setPencil:5.0 red:255.0 green:255.0 blue:0.0 opacity:0.4];
    [self.m_drawingImgView setMode:mode_PenEdit];
    self.m_scrollView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions
- (IBAction)actionChangeTool:(id)sender {
    if (self.m_segment.selectedSegmentIndex == 0) {
        [self.m_drawingImgView setPencil:5.0 red:255.0 green:255.0 blue:0.0 opacity:0.4];
        [self.m_drawingImgView setMode:mode_PenEdit];
        self.m_scrollView.scrollEnabled = NO;
    } else if (self.m_segment.selectedSegmentIndex == 1) {
        [self.m_drawingImgView setPencil:10.0 red:255.0 green:255.0 blue:255.0 opacity:1.0];
        [self.m_drawingImgView setMode:mode_Erase];
        self.m_scrollView.scrollEnabled = NO;
    } else if (self.m_segment.selectedSegmentIndex == 2) {
        [self.m_drawingImgView setMode:mode_Zoom];
        self.m_scrollView.scrollEnabled = YES;
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [self.m_imgView setImage:chosenImage];
    self.m_drawingImgView.image = nil;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Zoom
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //[self centerScrollViewContents:scrollView];
}

- (void)centerScrollViewContents:(UIScrollView*)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect contentsFrame = self.m_imgView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.m_imgView.frame = contentsFrame;
    self.m_drawingImgView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.m_segment.selectedSegmentIndex != 2) return nil;
    
    return self.m_imgContainterView;
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    UIBarButtonItem *btnCapture = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_naviCapture.png"] style:UIBarButtonItemStyleDone target:self action:@selector(actionPatternCapture)];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnDone, btnCapture, nil]];
    
    [self.m_scrollView setContentSize:self.m_scrollView.frame.size];
    self.m_scrollView.maximumZoomScale = 4.0;
    self.m_scrollView.minimumZoomScale = 1.0;
}

- (void)takePatternFrom {
    
    NSString *strUrl;
    if (self.m_pattern.frontImage && self.m_isFront) {
     
        strUrl = self.m_pattern.frontImage;

    } else if (self.m_pattern.backImage && !self.m_isFront) {
        strUrl = self.m_pattern.backImage;
    }
    
    if(strUrl!=nil) {
        NSURL* url = [[AppManager sharedInstance] downloadUrlWithFileName:strUrl];
        [self.m_imgView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [self fitViewToImage];
            }
        }];
      
        UIImage *placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
        
        [self.m_imgView sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [self fitViewToImage];
            }
        }];
       
    }
}

- (void)actionPatternCapture {
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

- (void)actionDone {
    UIGraphicsBeginImageContext(self.m_imgView.image.size);
    [self.m_imgView.image drawInRect:CGRectMake(0, 0, self.m_imgView.image.size.width, self.m_imgView.image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.m_drawingImgView.image drawInRect:CGRectMake(0, 0, self.m_imgView.image.size.width, self.m_imgView.image.size.height) blendMode:kCGBlendModeNormal alpha:0.4];
    self.m_imgView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.m_drawingImgView.image = nil;
    UIGraphicsEndImageContext();
  
    
    NSString *frontImageName = self.m_pattern.frontImage;
    NSString *backImageName =  self.m_pattern.backImage;
    NSData* imageData = UIImageJPEGRepresentation(self.m_imgView.image, 0.1);
    NSArray* data;
    NSString* imageName;
    NSDictionary* parameter;
    if (self.m_isFront) {
        imageName = frontImageName;
    } else {
        imageName = backImageName;
    }
    data = @[@{@"name":imageName,@"data":imageData}];
    parameter = @{@"is_front":[NSNumber numberWithBool:self.m_isFront]};

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] uploadFile:@"updateimage" data:data parameter:parameter withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                NSString* url = [[AppManager sharedInstance] downloadUrlWithFileName:imageName].absoluteString;
                [[SDImageCache sharedImageCache] removeImageForKey:url];
                
                [self showMessageWithTitle:@"" message:@"PATTERN SAVED" tag:101];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
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
- (void)fitViewToImage {
    CGRect imgViewSize = self.m_imgView.frame;
    CGSize imgRealSize = self.m_imgView.image.size;
    
    if (imgRealSize.height/imgRealSize.width > imgViewSize.size.height/imgViewSize.size.width) {
        imgViewSize.size.width = (int)(imgViewSize.size.height * (imgRealSize.width/imgRealSize.height));
    } else {
        imgViewSize.size.height = (int)(imgViewSize.size.width * (imgRealSize.height/imgRealSize.width));
    }
    
    imgViewSize.origin.x = (self.m_scrollView.frame.size.width-imgViewSize.size.width)/2;
    imgViewSize.origin.y = (self.m_scrollView.frame.size.height-imgViewSize.size.height)/2;
    self.m_imgView.frame = imgViewSize;
    self.m_drawingImgView.frame = imgViewSize;
}

@end
