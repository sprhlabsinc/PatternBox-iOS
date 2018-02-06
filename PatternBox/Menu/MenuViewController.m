//
//  MenuViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "MenuViewController.h"
#import "MenuTableController.h"

#import "SlideViewController.h"
#import "NavigationController.h"

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import "AppDelegate.h"
// --- Defines ---;
// MenuViewController Class;
@interface MenuViewController ()

@end

@implementation MenuViewController

// Functions;
#pragma mark - MenuViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];

}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    
    // Load;
    //[self performSelector:@selector(didUserLogin)];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = self.viewMenu.frame;
    rect.origin.x = screenRect.size.width - rect.size.width;
//    self.viewMenu.frame = rect;
}

-(void)viewWillAppear:(BOOL)animated {
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MenuTableController"]) {
        MenuTableController *viewController = segue.destinationViewController;
        viewController.delegate = (SlideViewController *)self.slidingViewController;
    }
}


@end
