//
//  MyPatternsViewController.m
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "MyPatternsViewController.h"
#import "Define.h"
#import "CategoriesViewController.h"

@interface MyPatternsViewController ()

@end

@implementation MyPatternsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"PATTERNS" navi:self.navigationItem];
    [self initialUIAtLaunch];
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
    CategoriesViewController *target = (CategoriesViewController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"segueShowCAPTERED"]) {
        target.m_ViewMode = VM_Scans;
    } else if ([segue.identifier isEqualToString:@"segueShowPDFs"]) {
        target.m_ViewMode = VM_PDFs;
    }
    
}

- (IBAction)actionGoPdfs:(id)sender {
    
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    self.m_btnPDF.layer.shadowOffset = CGSizeMake(4, 4);
    self.m_btnPDF.layer.shadowOpacity = 0.2;
    self.m_btnPDF.layer.cornerRadius = 20;
    self.m_btnPDF.layer.borderWidth = 2;
    self.m_btnPDF.layer.borderColor = KColorBasic.CGColor;
    self.m_btnPDF.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    
    self.m_btnCaptured.layer.cornerRadius = 20;
    self.m_btnCaptured.layer.borderWidth = 2;
    self.m_btnCaptured.layer.borderColor = KColorBasic.CGColor;
    self.m_btnCaptured.layer.backgroundColor = KColorButtonBackGround.CGColor;
    self.m_btnCaptured.layer.shadowOffset = CGSizeMake(4, 4);
    self.m_btnCaptured.layer.shadowOpacity = 0.2;
}

@end
