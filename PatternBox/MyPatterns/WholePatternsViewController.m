//
//  WholePatternsViewController.m
//  PatternBox
//
//  Created by youandme on 03/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "WholePatternsViewController.h"
#import "Define.h"
#import "PatternDetailViewController.h"
#import "PatternView.h"
#import "PatternHighlightViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PatternEditViewController.h"
#import "AppManager.h"
#import <SDWebImage/SDImageCache.h>

@interface WholePatternsViewController ()

@end

@implementation WholePatternsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString* title = [self.m_pattern.name uppercaseString];
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:title navi:self.navigationItem];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _patterns = [[NSMutableArray alloc] initWithObjects:self.m_pattern, nil];
    [self initPages];
    [self layoutScrollView];
    [self loadVisiblePages];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PatternModel* model = _patterns[_curIndex];
    if ([segue.identifier isEqualToString:@"seguePatternDetail"]) {
        PatternDetailViewController *target = (PatternDetailViewController *)segue.destinationViewController;
        if (self.m_ViewMode == VM_Bookmarks) {
            if (model.isPDF == 1) {
                target.m_ViewMode = VM_PDFs;
            } else {
                target.m_ViewMode = VM_Scans;
            }
        } else {
            target.m_ViewMode = self.m_ViewMode;
        }
    } else if ([segue.identifier isEqualToString:@"seguePatternHighlight"]) {
        PatternHighlightViewController *target = (PatternHighlightViewController *)segue.destinationViewController;
        if (self.m_ViewMode == VM_Bookmarks) {
            if (model.isPDF == 1) {
                target.m_ViewMode = VM_PDFs;
            } else {
                target.m_ViewMode = VM_Scans;
            }
        } else {
            target.m_ViewMode = self.m_ViewMode;
        }
        
        target.m_isFront = _isFront;
        target.m_pattern = model;
    } else if ([segue.identifier isEqualToString:@"seguePatternEditFromWhole"]) {
        PatternEditViewController *target = (PatternEditViewController *)segue.destinationViewController;
        if (self.m_ViewMode == VM_Bookmarks) {
            if (model.isPDF == 1) {
                target.m_ViewMode = VM_PDFs;
            } else {
                target.m_ViewMode = VM_Scans;
            }
        } else {
            target.m_ViewMode = self.m_ViewMode;
        }
        target.m_pattern = model;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    // First, determine which page is currently visible
    float pageWidth = self.m_scrollView.frame.size.width;
    _curIndex = floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0));
    
    [self loadVisiblePages];
}

#pragma mark - PatternView Delegate
- (void)PatternView:(PatternView*)view didPressedButton:(UIButton*)button {
    
    PatternModel* model = _patterns[_curIndex];
    
    view.m_isFrontImage = !view.m_isFrontImage;
    
    [UIView animateWithDuration:0.4 animations:^(void) {
        view.m_imgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        NSString *strUrl;
        if (view.m_isFrontImage) {
            //view.m_imgView.image = nil;
            strUrl = model.frontImage;


        } else {
            //view.m_imgView.image = nil;
            strUrl = model.backImage;
            
        }
        if(strUrl) {
            UIImage *placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
            [view.m_imgView sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:strUrl] placeholderImage:placeholderImage];
            
        }
        [UIView animateWithDuration:0.4 animations:^{
            view.m_imgView.alpha = 1.0;
        }];
    }];
    
}

- (void)PatternView:(PatternView*)view didPressedBookmarkButton:(UIButton*)button {
    NSInteger isbookmark = 1;
    NSString *bookmarkIcon;
    
    PatternModel* model = _patterns[_curIndex];
    
    if (model.isBookMark == 1) {
        isbookmark = 0;
        bookmarkIcon = @"icon_BookmarkNo.png";
    } else {
        isbookmark = 1;
        bookmarkIcon = @"icon_BookmarkYes.png";
    }
    model.isBookMark = isbookmark;
 
    NSDictionary* parameter = @{@"is_bookmark":[NSNumber numberWithInteger:model.isBookMark]};
    NSString* tag = [NSString stringWithFormat:@"bookmark/%ld",(long)model.fid];
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
                [view.m_btnBookmark setImage:[UIImage imageNamed:bookmarkIcon] forState:UIControlStateNormal];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}

- (void)PatternView:(PatternView*)view didPressedEditButton:(UIButton*)button {
    _isFront = view.m_isFrontImage;
    [self performSegueWithIdentifier:@"seguePatternHighlight" sender:self];
}

- (void)PatternView:(PatternView *)view didPressedDeleteButton:(UIButton *)button {
    [self showAlertWithTitle:@"" message:@"DELETE PATTERN?" tag:101];
}

- (void)PatternView:(PatternView*)view didPressedInfoEditButton:(UIButton*)button {
    [self performSegueWithIdentifier:@"seguePatternEditFromWhole" sender:self];
}

#pragma mark - Common
- (void)takePatternsFrom {
    _patterns = [[NSMutableArray alloc] init];

    NSString *patternType;
    if (self.m_ViewMode == VM_PDFs) patternType = KTypePDF;
    else if (self.m_ViewMode == VM_Scans) patternType = KTypeScan;
    else {
        NSMutableArray *pdfPatterns = [[[NSUserDefaults standardUserDefaults] objectForKey:KTypePDF] mutableCopy];
        NSMutableArray *scanPatterns = [[[NSUserDefaults standardUserDefaults] objectForKey:KTypeScan] mutableCopy];
        
        for (NSInteger i = 0; i < pdfPatterns.count; i++) {
            NSMutableDictionary *dic = [pdfPatterns[i] mutableCopy];
            if ([dic objectForKey:KPatternBookMark] &&
                [[dic objectForKey:KPatternBookMark] isEqualToString:@"yes"]) {
                [dic setObject:[NSNumber numberWithInteger:i] forKey:@"index"];
                [_patterns addObject:dic];
            }
        }
        
        for (NSInteger i = 0; i < scanPatterns.count; i++) {
            NSMutableDictionary *dic = [scanPatterns[i] mutableCopy];
            if ([dic objectForKey:KPatternBookMark] &&
                [[dic objectForKey:KPatternBookMark] isEqualToString:@"yes"]) {
                [dic setObject:[NSNumber numberWithInteger:i] forKey:@"index"];
                [_patterns addObject:dic];
            }
        }
        
        [self initPages];
        return;
    }

}

- (void)initPages {
    _visiblePatternViews = [[NSMutableArray alloc] init];
    
    [self.m_scrollView setContentSize:CGSizeMake(_patterns.count*self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    
    for(int i = 0; i < _patterns.count; i++) {
        [_visiblePatternViews addObject:[NSNull null]];
    }

}

- (void)layoutScrollView {
    CGSize pagesScrollViewSize = self.m_scrollView.frame.size;
    self.m_scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * _patterns.count, pagesScrollViewSize.height);
    
    [self.m_scrollView setContentOffset:CGPointMake(pagesScrollViewSize.width * _curIndex, 0) animated:YES];
}

- (void)loadPage:(NSInteger)index {
    if (index < 0 || index >= _patterns.count) return;
    
   if (_visiblePatternViews[index] == [NSNull null]) {
        CGRect frame = self.m_scrollView.bounds;
        frame.origin.x = frame.size.width * index;
        frame.origin.y = 0.0;
        
        PatternView *patternView = [[PatternView alloc] initWithNibName:@"PatternView"];
        [patternView setFrame:frame];
        [self.m_scrollView addSubview:patternView];
       
        PatternModel* model = _patterns[_curIndex];
       
        patternView.m_lblPatternName.text = [NSString stringWithFormat:@"NAME: %@", model.name];
        patternView.m_lblPatternID.text = [NSString stringWithFormat:@"ID: %@", model.type];
        patternView.m_txtNote.text = [NSString stringWithFormat:@"NOTE:\n%@", model.notes];
       

       NSString *imgUrl = model.frontImage;
       UIImage *placeholderImage;
       NSInteger isPDF = model.isPDF;
       if(isPDF == 0) {
           placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
           
       } else {
           placeholderImage = [UIImage imageNamed:@"icon_PDFdoc.png"];
       }
       
       [patternView.m_imgView sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:imgUrl] placeholderImage:placeholderImage];
       

       
        if (model.isBookMark == 1) {
            [patternView.m_btnBookmark setImage:[UIImage imageNamed:@"icon_BookmarkYes.png"] forState:UIControlStateNormal];
        } else {
            [patternView.m_btnBookmark setImage:[UIImage imageNamed:@"icon_BookmarkNo.png"] forState:UIControlStateNormal];
        }

        patternView.delegate = self;
        _visiblePatternViews[index] = patternView;
    }

}

- (void)purgePage:(NSInteger)index {
    if (index < 0 || index >= _patterns.count) return;

    if (_visiblePatternViews[index] != [NSNull null]) {
        [_visiblePatternViews[index] removeFromSuperview];
        _visiblePatternViews[index] = [NSNull null];
    }
}

- (void)loadVisiblePages {
    NSInteger firstPage = _curIndex - 1;
    NSInteger lastPage = _curIndex + 1;
    
    
    // Purge anything before the first page
    for (NSInteger i = 0; i < firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in our range
    for (NSInteger i = firstPage; i <= lastPage ; i++) {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i = (lastPage+1); i < _patterns.count; i++) {
        [self purgePage:i];
    }
}

- (void)deletePattern {

    PatternModel* model = _patterns[_curIndex];

    NSString* tag = [NSString stringWithFormat:@"patterns/%ld",model.fid];
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
                
                [[AppManager sharedInstance].patternList removeObject:model];
                
                [_patterns removeObjectAtIndex:_curIndex];
                if (_patterns.count == 0) {
                    [self.m_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                }
                
                [self initPages];
                [self loadVisiblePages];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(tag == 101) {
            [self deletePattern];
        }
    }];
    UIAlertAction * noAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    if (tag > 0 ) {
        [alert addAction:noAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
@end
