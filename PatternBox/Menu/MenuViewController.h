//
//  MenuViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// MenuViewController Class;

@interface MenuViewController : UIViewController
{
    IBOutlet UILabel *lblForName;
    IBOutlet UILabel *lblForUsername;
}
@property (weak, nonatomic) IBOutlet UIView *viewMenu;

@end
