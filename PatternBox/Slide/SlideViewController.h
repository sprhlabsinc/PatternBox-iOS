//
//  SlideViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "MenuTableController.h"
#import "MenuViewController.h"
#import "NavigationController.h"
#import "Define.h"
#import <MessageUI/MessageUI.h>
#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>

// --- Defines ---;
// SlideViewController Class;
@interface SlideViewController : ECSlidingViewController <MenuTableControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, strong) NavigationController *mainController;
@property (nonatomic, strong) NavigationController *privacyController;
@property (nonatomic, strong) NavigationController *termsController;
@property (nonatomic, strong) NavigationController *aboutController;
@end
