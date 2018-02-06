//
//  SearchPatternsViewController.h
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface SearchPatternsViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_pdfUrls;
    NSMutableArray* _recentUrlList;
    NSArray* _matchedUrlList;
    NSData* _pdfFileData;
    BOOL _isOpenInURL;
    BOOL _isZIPFil;
}

@property (weak, nonatomic) IBOutlet UIWebView *m_webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnGoBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnStopLoading;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnRefresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnGoForward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnSaveLink;
@property (weak, nonatomic) IBOutlet UISearchBar *m_UrlSearchBar;
@property (strong) IBOutlet NSString *m_Mime;
@property (strong) IBOutlet NSString *m_DefaultSearchURLString;
@property (weak, nonatomic) IBOutlet UITableView *m_tbUrlList;

- (IBAction)actionPDFSave:(id)sender;
- (IBAction)actionSaveLink:(id)sender;
@end
