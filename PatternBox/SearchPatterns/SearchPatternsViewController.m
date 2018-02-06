//
//  SearchPatternsViewController.m
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SearchPatternsViewController.h"
#import "Define.h"
#import "PatternEditViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import "SSZipArchive.h"


const NSInteger ROW_HEIGHT = 30;
const NSInteger MAX_COUNT_URLS = 100;
const NSInteger MAX_HEIGHT_DROP_MENU = 150;
      NSString* Google_Search_Url = @"https://www.google.com/search?q=";

@interface SearchPatternsViewController ()

@end

@implementation SearchPatternsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pdfUrls = [[NSMutableArray alloc] init];
    _isZIPFil = false;
    [self checkOpenInURL];
    self.m_UrlSearchBar.delegate = self;
    self.m_UrlSearchBar.text = self.m_DefaultSearchURLString;

    
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"BUY PATTERNS" navi:self.navigationItem];
    if(self.m_DefaultSearchURLString) [self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_DefaultSearchURLString]]];
    
    self.m_tbUrlList.dataSource = self;
    self.m_tbUrlList.delegate = self;
    [self.m_tbUrlList setHidden:YES];
    _recentUrlList = [[NSMutableArray alloc] initWithArray:[self getRecentUrlList]];
    _matchedUrlList = _recentUrlList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.m_webView stopLoading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueSavePDF"]) {
        PatternEditViewController *target = (PatternEditViewController *)segue.destinationViewController;
        target.m_ViewMode = VM_NewPDF;
        target.m_PDFUrls = _pdfUrls;
        target.m_PDFData = _pdfFileData;
        //target.isOpenInURL = _isOpenInURL || [self isDisplayingPDF];
        target.isOpenInURL = _isOpenInURL;
        target.isZIPFile = _isZIPFil;
    }
}

#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
    NSString* strURL = self.m_webView.request.URL.absoluteString;
    if (strURL && ![strURL isEqualToString:@""]) {
        self.m_UrlSearchBar.text = strURL;
    }
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        if ([[[request.URL pathExtension] lowercaseString] isEqualToString:@"zip"]) {
            NSString* pdfURL =[self unZipWithURL:[request.URL absoluteString]][0];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfURL]]];
            return NO;
        }
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self updateRecentUrlList];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.m_Mime = [response MIMEType];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _matchedUrlList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.m_tbUrlList dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _matchedUrlList[_matchedUrlList.count-indexPath.row - 1];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* url = _matchedUrlList[_matchedUrlList.count-indexPath.row - 1];
    self.m_UrlSearchBar.text = url;
    [self.m_tbUrlList setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.m_UrlSearchBar resignFirstResponder];
}
#pragma mark - SearchBar Delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.m_webView stopLoading];
    [self.m_tbUrlList setHidden:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    NSURL* searchURL;
    NSString* searchString = self.m_UrlSearchBar.text;
    NSURL* url = [NSURL URLWithString:searchString];
    if(url && url.scheme && url.host){
        searchURL = url;
    }else{
        searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        searchString = [NSString stringWithFormat:@"%@%@",Google_Search_Url,searchString];
        searchURL = [NSURL URLWithString:searchString];
        self.m_UrlSearchBar.text = searchString;
    }
    [self.m_tbUrlList setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.m_webView loadRequest:[NSURLRequest requestWithURL:searchURL]];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self setDropTableFrame];
    [self.m_tbUrlList setHidden:NO];
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _matchedUrlList = ([searchText isEqualToString:@""])? _recentUrlList : [self filterArrayUsingSearchText:searchText];
    
    [self setDropTableFrame];
    [self.m_tbUrlList setHidden:NO];
    [self.m_tbUrlList reloadData];
    
}
#pragma mark - Actions
- (IBAction)actionPDFSave:(id)sender {
    if (_pdfUrls.count == 0 && _pdfFileData == nil) {
        [self showMessageWithTitle:@"" message:@"Please download a pdf document at least."];
        return;
    }
    
    [self performSegueWithIdentifier:@"segueSavePDF" sender:self];
}

- (IBAction)actionSaveLink:(id)sender {
   
    //detect whether web content is PDF or not
    // If not PDF, save only web site url.
    // If PDF and OpenIn url(local path), save PDF file on firebase, register download url.
    // if PDF and Web site , save PDF thumbnail on firebase , register download url.
    
    NSString *link = self.m_webView.request.URL.absoluteString;
    if (_isZIPFil) {
        
        NSString *path = [link lastPathComponent];
        NSString *fileName = [path componentsSeparatedByString:@".pdf"][0];
        
        [self showMessageWithTitle:@"" message:[NSString stringWithFormat:@"\"%@.pdf\" saved.", fileName]];
        return;
    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    if([self isDisplayingPDF]){
//        //if (_isOpenInURL) {
//            _pdfFileData = [NSData dataWithContentsOfURL:_m_webView.request.URL];
//        //}
//    }else{
//        NSString* path = [self renderInPDFFile:@"sample.pdf"];
//        _pdfFileData = [[NSFileManager defaultManager] contentsAtPath:path];
//    }
//    [MBProgressHUD hideHUDForView:self.view animated:true];

    if(_isOpenInURL){
        _pdfFileData = [NSData dataWithContentsOfURL:_m_webView.request.URL];
    }else{
        NSString* path = [self renderInPDFFile:@"sample.pdf"];
        _pdfFileData = [[NSFileManager defaultManager] contentsAtPath:path];
    }
    
    NSLog(@"%@", link);
    for (NSString *path in _pdfUrls) {
        if ([link isEqualToString:path]) {
            [self showMessageWithTitle:@"" message:@"This pdf file was downloaded already."];
            return;
        }
    }
    
    [_pdfUrls addObject:link];
    NSString *path = [link lastPathComponent];
    NSString *fileName = [path componentsSeparatedByString:@".pdf"][0];
    
    [self showMessageWithTitle:@"" message:[NSString stringWithFormat:@"\"%@.pdf\" saved.", fileName]];
}


#pragma mark - Common
- (void)updateButtons {
    self.m_btnGoForward.enabled = self.m_webView.canGoForward;
    self.m_btnGoBack.enabled = self.m_webView.canGoBack;
    self.m_btnStopLoading.enabled = self.m_webView.loading;
}

// Check whether web content is PDF file or not.
- (BOOL)isDisplayingPDF {
    NSString* extension = [[self.m_Mime substringFromIndex:([self.m_Mime length] - 3)] lowercaseString];
    BOOL isPDFByRequest = [[[self.m_webView.request.URL pathExtension] lowercaseString] isEqualToString:@"pdf"];
    BOOL isPDFByMime = [extension isEqualToString:@"pdf"];
    return isPDFByRequest || isPDFByMime;
}

- (BOOL)isDownloadZip {
    NSString* extension = [[self.m_Mime substringFromIndex:([self.m_Mime length] - 3)] lowercaseString];
    BOOL isPDFByRequest = [[[self.m_webView.request.URL pathExtension] lowercaseString] isEqualToString:@"zip"];
    BOOL isPDFByMime = [extension isEqualToString:@"zip"];
    return isPDFByRequest || isPDFByMime;
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)checkOpenInURL{
    NSString* strURL = [AppManager sharedInstance].openInURL;
    NSURL *url = [NSURL URLWithString:strURL];
    [AppManager sharedInstance].openInURL = nil;
    
    if (![url filePathURL]) return;
 
    _isOpenInURL = true;
    NSString* extention = [url pathExtension];
    extention = [extention lowercaseString];

    self.m_DefaultSearchURLString = strURL;
    
    if([extention isEqualToString:@"zip"]){
        // return Upzip file path
        _isZIPFil = true;
        NSArray* urls = [self unZipWithURL:strURL];
        if(!urls){
            [self showMessageWithTitle:@"Unknow Format!" message:@"PatterBox doesn't support this file!"];
            return;
        }

        self.m_DefaultSearchURLString = urls[0];

        for (NSString *fileURL in urls) {
            [_pdfUrls addObject:fileURL];
        }
    }
}

- (NSString*)renderInPDFFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Create PDF_Documents directory
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PDF_Documents"];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
    CGRect mediaBox = self.m_webView.bounds;
    CGContextRef ctx = CGPDFContextCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], &mediaBox, NULL);
    
    CGPDFContextBeginPage(ctx, NULL);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -mediaBox.size.height);
    [self.m_webView.layer renderInContext:ctx];
    CGPDFContextEndPage(ctx);
    CFRelease(ctx);
    return filePath;
}


//  UnZip file with URL
-(NSArray*)unZipWithURL:(NSString*) strURL{
    
    NSURL * url = [NSURL URLWithString:strURL];
    NSString *filePath;
    static NSString *pdfPath;
//    if ([url filePathURL]) {
//        filePath = strURL;
//    }else{
        NSData* zipFile = [NSData dataWithContentsOfURL:url];
        if (!zipFile) {
            return nil;
        }
        filePath = [self tempZipPath];
        [zipFile writeToFile:filePath atomically:YES];
   // }

    
    NSString* unzipPath = [self tempUnzipPath];
    BOOL success = [SSZipArchive unzipFileAtPath:filePath
                                   toDestination:unzipPath];
    if (!success) {
        return nil;
    }
    NSError *error = nil;
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:unzipPath
                                          error:&error] mutableCopy];
    if (error) {
        return nil;
    }
    NSMutableArray<NSString *> *paths = [[NSMutableArray alloc] init];

    for (NSString *path in items) {
        if(path){
            pdfPath = [NSString stringWithFormat:@"%@%@",unzipPath,path];
            [paths addObject:pdfPath];
        }
    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    return paths;
}

#pragma mark - Private
- (NSString *)tempZipPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PDF_Documents"];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"pdf.zip"];
    return filePath;
}

- (NSString *)tempUnzipPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"unzip_Documents"];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/", documentsDirectory];
    return filePath;
}

-(NSArray *) filterArrayUsingSearchText:(NSString*) searchText
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    return [_recentUrlList filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark - update url list
-(void)updateRecentUrlList{
    NSURL* url = self.m_webView.request.URL;
    if(!url || !url.scheme || !url.host || url.isFileURL || url.isFileReferenceURL){
        return;
    }
    NSString* newUrl = url.absoluteString;

    if ([newUrl containsString:@"https://www.google."]) {
        return;
    }
    for (NSString* item in _recentUrlList) {
        if ([item isEqualToString:newUrl]) {
            return;
        }
    }
    
    if(_recentUrlList.count > MAX_COUNT_URLS){
        [_recentUrlList removeObjectAtIndex:0];
    }
    [_recentUrlList addObject:newUrl];
    
    NSUserDefaults * userDefaults =  [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_recentUrlList forKey:@"recentUrls"];
    [userDefaults synchronize];
    
}
-(NSArray*)getRecentUrlList{
    NSUserDefaults * userDefaults =  [NSUserDefaults standardUserDefaults];
    NSArray* result = [userDefaults objectForKey:@"recentUrls"];
    return result? result:[[NSArray alloc] init];
}
-(void)setDropTableFrame{
    NSInteger h = _matchedUrlList.count * ROW_HEIGHT;
    NSInteger height = h > MAX_HEIGHT_DROP_MENU ? MAX_HEIGHT_DROP_MENU : h;
    [self.m_tbUrlList setFrame:CGRectMake(self.m_tbUrlList.frame.origin.x, self.m_tbUrlList.frame.origin.y, self.m_tbUrlList.frame.size.width, height)];
}
@end
