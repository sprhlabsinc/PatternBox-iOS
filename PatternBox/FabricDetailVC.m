//
//  FabricDetailVC.m
//  PatternBox
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricDetailVC.h"
#import "Define.h"
#import "FabricCategoryInfo.h"
#import "FabricInfoTableViewCell.h"
#import "AppManager.h"
#import "FabricScanViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FabricDetailVC ()

@end

@implementation FabricDetailVC

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueEdit"]) {
        FabricScanViewController *target = (FabricScanViewController *)segue.destinationViewController;
        target.m_fabricModel = self.m_fabricModel;
    }
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

-(void)initUI{
    NSString* title = self.m_fabricModel.info.name;
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:title navi:self.navigationItem];
    NSString* strCat = [NSString stringWithFormat:@"CATEGORY: %@", [self.m_fabricModel.getCategoryNameList componentsJoinedByString:@","]];
    self.m_lblCategory.text = strCat;
    _fabricInfo = self.m_fabricModel.info;
    
    self.m_imgBookMark.hidden = !self.m_fabricModel.isBookMark;
    
    NSString *imgUrl = self.m_fabricModel.imageUrl;
    UIImage *placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
    [self.m_fabricView sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:imgUrl] placeholderImage:placeholderImage];
    
}
@end
