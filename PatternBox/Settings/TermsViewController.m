//
//  TermsViewController.m
//  PatternBox
//
//  Created by youandme on 09/10/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "TermsViewController.h"
#import "Define.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"Terms Of Use" navi:self.navigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
