//
//  FabricHomeVC.m
//  PatternBox
//
//  Created by mac on 4/13/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricHomeVC.h"
#import "FabricViewController.h"
#import "Define.h"

@interface FabricHomeVC ()

@end

@implementation FabricHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
        FabricViewController *target = (FabricViewController *)segue.destinationViewController;
        target.m_ViewMode = VM_Bookmarks;
    }else if([segue.identifier isEqualToString:@"segueProject"]){
        FabricViewController *target = (FabricViewController *)segue.destinationViewController;
        target.m_isAddToProject = true;
    }
}

#pragma mark - Commons
- (void)initialUIAtLaunch {
    
    self.view.backgroundColor = KColorBackground;
    
    self.m_btnScan.layer.cornerRadius = 20;
    self.m_btnScan.layer.borderWidth = 2;
    self.m_btnScan.layer.borderColor = KColorBasic.CGColor;
    self.m_btnScan.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnMyFabric.layer.cornerRadius = 20;
    self.m_btnMyFabric.layer.borderWidth = 2;
    self.m_btnMyFabric.layer.borderColor = KColorBasic.CGColor;
    self.m_btnMyFabric.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnBookmark.layer.cornerRadius = 20;
    self.m_btnBookmark.layer.borderWidth = 2;
    self.m_btnBookmark.layer.borderColor = KColorBasic.CGColor;
    self.m_btnBookmark.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
    self.m_btnAddToProject.layer.cornerRadius = 20;
    self.m_btnAddToProject.layer.borderWidth = 2;
    self.m_btnAddToProject.layer.borderColor = KColorBasic.CGColor;
    self.m_btnAddToProject.layer.backgroundColor = KColorButtonBackGround.CGColor;
    
}

@end
