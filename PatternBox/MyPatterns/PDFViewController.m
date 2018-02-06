//
//  PDFViewController.m
//  PatternBox
//
//  Created by youandme on 01/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PDFViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PDFViewController ()

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.m_pdfUrl]];
    [self.m_webView loadRequest:request];
    self.m_btnPrint.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.m_webView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"Loading...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.m_btnPrint.enabled  = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
- (IBAction)actionPrint:(id)sender {
    [self tryPrintPdf:self.m_pdfUrl];
}

#pragma mark - Common
- (void) tryPrintPdf:(NSString*)path {
    
    NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.m_pdfUrl]];
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if ( pic && [UIPrintInteractionController canPrintData: myData] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
            }
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}
@end
