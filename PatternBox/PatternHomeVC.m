//
//  ViewController.m
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternHomeVC.h"
#import "Define.h"
#import "PatternViewController.h"
#import "SearchPatternsViewController.h"
#import "AppManager.h"

@interface PatternHomeVC ()

@end

@implementation PatternHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialUIAtLaunch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueBookmark"]) {
        PatternViewController *target = (PatternViewController *)segue.destinationViewController;
        target.m_ViewMode = VM_Bookmarks;
        target.m_indexOfCategory = -1;
    }else if([segue.identifier isEqualToString:@"segueProject"]){
        PatternViewController *target = (PatternViewController *)segue.destinationViewController;
        target.m_isAddToProject = true;
    }
}

#pragma mark - Commons
- (void)initialUIAtLaunch {

    self.view.backgroundColor = KColorBackground;
    
    self.m_btnScanPattern.layer.cornerRadius = 20;
    self.m_btnScanPattern.layer.borderWidth = 2;
    self.m_btnScanPattern.layer.borderColor = KColorBasic.CGColor;
    self.m_btnScanPattern.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnMyPatterns.layer.cornerRadius = 20;
    self.m_btnMyPatterns.layer.borderWidth = 2;
    self.m_btnMyPatterns.layer.borderColor = KColorBasic.CGColor;
    self.m_btnMyPatterns.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnSearchPatterns.layer.cornerRadius = 20;
    self.m_btnSearchPatterns.layer.borderWidth = 2;
    self.m_btnSearchPatterns.layer.borderColor = KColorBasic.CGColor;
    self.m_btnSearchPatterns.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnBookMarks.layer.cornerRadius = 20;
    self.m_btnBookMarks.layer.borderWidth = 2;
    self.m_btnBookMarks.layer.borderColor = KColorBasic.CGColor;
    self.m_btnBookMarks.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnAddToProject.layer.cornerRadius = 20;
    self.m_btnAddToProject.layer.borderWidth = 2;
    self.m_btnAddToProject.layer.borderColor = KColorBasic.CGColor;
    self.m_btnAddToProject.layer.backgroundColor = KColorButtonBackGround.CGColor;

}

@end
