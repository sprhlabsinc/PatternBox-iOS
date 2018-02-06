//
//  HomeViewController.m
//  PatternBox
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "HomeViewController.h"
#import "FabricViewController.h"
#import "NotionHomeVC.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];

    [self initialUIAtLaunch];
    [self takeCustomizedCategoryFrom];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)actionMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
#pragma mark - Commons
- (void)initialUIAtLaunch {


    self.m_btnPatterns.layer.cornerRadius = 30;
    self.m_btnPatterns.layer.borderWidth = 2;
    self.m_btnPatterns.layer.borderColor = [UIColor blackColor].CGColor;
    self.m_btnPatterns.layer.shadowOffset = CGSizeMake(2, 2);
    self.m_btnPatterns.layer.shadowOpacity = 0.8;
    
    
    self.m_btnFabric.layer.cornerRadius = 30;
    self.m_btnFabric.layer.borderWidth = 2;
    self.m_btnFabric.layer.borderColor = [UIColor blackColor].CGColor;
    self.m_btnFabric.layer.shadowOffset = CGSizeMake(2, 2);
    self.m_btnFabric.layer.shadowOpacity = 0.8;
    
    
    self.m_btnNotions.layer.cornerRadius = 30;
    self.m_btnNotions.layer.borderWidth = 2;
    self.m_btnNotions.layer.borderColor = [UIColor blackColor].CGColor;
    self.m_btnNotions.layer.shadowOffset = CGSizeMake(2, 2);
    self.m_btnNotions.layer.shadowOpacity = 0.8;
    
    
    self.m_btnProjects.layer.cornerRadius = 30;
    self.m_btnProjects.layer.borderWidth = 2;
    self.m_btnProjects.layer.borderColor = [UIColor blackColor].CGColor;
    self.m_btnProjects.layer.shadowOffset = CGSizeMake(2, 2);
    self.m_btnProjects.layer.shadowOpacity = 0.8;
    
    self.view.backgroundColor = KColorBackground;
}

#pragma mark - Roading Custom Category Data from Server
- (void)takeCustomizedCategoryFrom {
    
    if ([AppManager sharedInstance].isLoadInitData) {
        if([AppManager sharedInstance].openInURL && ![[AppManager sharedInstance].openInURL isEqualToString:@""]){
            [self performSegueWithIdentifier:@"segueSearchPatterns" sender:self];
        }
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AppManager sharedInstance] loadInitDataFromServer:^(NSDictionary *response, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                if([AppManager sharedInstance].openInURL && ![[AppManager sharedInstance].openInURL isEqualToString:@""]){
                    [self performSegueWithIdentifier:@"segueSearchPatterns" sender:self];
                }
            } else {
                [APPDELEGATE logout];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
            }
        }];
        
    }
    
}
- (IBAction)showFabric:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Fabric" bundle:nil];
    FabricViewController *fabircVC = (FabricViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FabricHomeViewController"];
     [self.navigationController pushViewController:fabircVC animated:YES];
}
- (IBAction)showNotion:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Fabric" bundle:nil];
    NotionHomeVC *notionVC = (NotionHomeVC *)[storyboard instantiateViewControllerWithIdentifier:@"NotionHomeVC"];
    [self.navigationController pushViewController:notionVC animated:YES];
}
- (IBAction)showProject:(id)sender{
    
}
@end
