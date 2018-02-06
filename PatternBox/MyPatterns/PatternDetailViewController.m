//
//  PatternDetailViewController.m
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternDetailViewController.h"
#import "Define.h"
#import "PatternEditViewController.h"
#import "PDFViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PatternDetailViewController ()

@end

@implementation PatternDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];
    [self initialUIAtLaunch];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self takePatternFrom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueEditInfo"]) {
        PatternEditViewController *target = (PatternEditViewController *)segue.destinationViewController;
        target.m_ViewMode = self.m_ViewMode;
        target.m_pattern = self.m_pattern;
    } else if ([segue.identifier isEqualToString:@"seguePDFDetail"]) {
        PDFViewController *target = (PDFViewController *)segue.destinationViewController;
        target.m_pdfUrl = _pdfUrls[_curPDFIndex.row];
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _curPDFIndex = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"seguePDFDetail" sender:self];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [_pdfUrls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *path = _pdfUrls[indexPath.row];
    path = [path lastPathComponent];
    NSString *fileName = [path componentsSeparatedByString:@".pdf"][0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@.pdf", fileName];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:134.0/255.0 blue:185.0/255.0 alpha:1.0];
    
    return cell;
}

#pragma mark - Actions
- (IBAction)actionFrontView:(id)sender {
    _isFrontView = YES;
    
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

- (IBAction)actionBackView:(id)sender {
    _isFrontView = NO;
    
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

- (IBAction)actionBookMark:(id)sender {
    [self bookMarkPattern];
}

- (IBAction)actionEditInfo:(id)sender {
}

- (IBAction)actionSavePattern:(id)sender {
}

#pragma mark - CustomAlertView delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
    
    if (buttonIndex == 1) {
        
    }
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

    if (self.m_pattern.frontImage) {
        NSString* strUrl;
        if (_isFrontView) {
            strUrl = self.m_pattern.frontImage;
        } else {
            strUrl = self.m_pattern.backImage;
        }
        if(strUrl) {

            UIImage *placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
            NSURL* url = [[AppManager sharedInstance] downloadUrlWithFileName:strUrl];
            [rawScrollView.imageView sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGRect rect = rawScrollView.imageView.frame;
                rect.size = image.size;
                rawScrollView.imageView.frame = rect;
                
                CGFloat newZoomScale = rawScrollView.frame.size.width / rawScrollView.imageView.frame.size.width;
                rawScrollView.minimumZoomScale = newZoomScale;
                [rawScrollView setZoomScale:newZoomScale animated:YES];
                [_imgViewer centerScrollViewContents:rawScrollView];
            }];
         }
    }
   
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    self.m_patternView.layer.borderColor = [UIColor redColor].CGColor;
    self.m_patternView.layer.borderWidth = 0.3;
    self.m_patternView.layer.cornerRadius = 4;
    self.m_patternView.layer.masksToBounds = YES;
    
    self.m_btnFront.layer.cornerRadius = 6;
    self.m_btnFront.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    self.m_btnFront.layer.borderWidth = 4;
    self.m_btnFront.layer.masksToBounds = YES;
    
    self.m_btnBack.layer.cornerRadius = 6;
    self.m_btnBack.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    self.m_btnBack.layer.borderWidth = 4;
    self.m_btnBack.layer.masksToBounds = YES;
    
    if (self.m_ViewMode == VM_PDFs) {
        self.m_ViewOfCaptured.hidden = YES;
        self.m_ViewOfPDFs.hidden = NO;
    } else {
    }
    
    UIBarButtonItem *btnBookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_naviBookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bookMarkPattern)];
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPattern)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnEdit, btnBookmark, nil]];
}

- (void)takePatternFrom {

    NSMutableArray *totalPatternsOf;
    if (self.m_ViewMode == VM_PDFs) totalPatternsOf = [[[NSUserDefaults standardUserDefaults] objectForKey:KTypePDF] mutableCopy];
    else if (self.m_ViewMode == VM_Scans) totalPatternsOf = [[[NSUserDefaults standardUserDefaults] objectForKey:KTypeScan] mutableCopy];
    else {
        totalPatternsOf = [[[NSUserDefaults standardUserDefaults] objectForKey:KTypePDF] mutableCopy];
        [totalPatternsOf addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:KTypeScan]];
    }

    
    NSString *imgUrl;
    UIImage *placeholderImage;
    NSInteger isPDF = self.m_pattern.isPDF;
    imgUrl = self.m_pattern.frontImage;
    
    if(isPDF == 0) {
         placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
        
    } else {
        placeholderImage = [UIImage imageNamed:@"icon_PDFdoc.png"];
    }
    
    [self.m_patternView  sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:imgUrl] placeholderImage:placeholderImage];
    
    self.m_lblPatternName.text = [NSString stringWithFormat:@"NAME: %@", self.m_pattern.name];
    self.m_lblPatternID.text = [NSString stringWithFormat:@"ID: %@", self.m_pattern.type];

    
    NSString *categories = [[self.m_pattern getCategoryNameList] componentsJoinedByString:@","];
    self.m_lblCategory.text = [NSString stringWithFormat:@"CATEGORY: %@", categories];
    
    if (self.m_pattern.isBookMark == 1) {
        self.m_imgBookMark.hidden = NO;
    } else {
        self.m_imgBookMark.hidden = YES;
    }
    
    self.m_txtNotes.text = self.m_pattern.notes;
  
    _pdfUrls = self.m_pattern.pdfUrls;
}

- (void)bookMarkPattern {
   
    BOOL isMarked = FALSE;
    if (self.m_pattern.isBookMark == 1) {
        self.m_pattern.isBookMark = 0;
        isMarked = TRUE;
    } else {
        self.m_pattern.isBookMark = 1;
        isMarked = FALSE;
    }
    
    NSDictionary* parameter = @{@"is_bookmark": [NSNumber numberWithInteger:self.m_pattern.isBookMark]};
    NSString* tag = [NSString stringWithFormat:@"bookmark/%ld",(long)self.m_pattern.fid];
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
                self.m_imgBookMark.hidden = isMarked;
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

- (void)editPattern {
    [self performSegueWithIdentifier:@"segueEditInfo" sender:self];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
