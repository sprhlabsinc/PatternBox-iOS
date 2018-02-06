//
//  PDFViewController.h
//  PatternBox
//
//  Created by youandme on 01/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface PDFViewController : UIViewController <UIWebViewDelegate, UIPrintInteractionControllerDelegate>

@property (strong, nonatomic) NSString *m_pdfUrl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnPrint;
@property (weak, nonatomic) IBOutlet UIWebView *m_webView;


- (IBAction)actionPrint:(id)sender;
@end
