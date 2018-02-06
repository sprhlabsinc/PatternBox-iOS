//
//  MenuTableController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "MenuTableController.h"

// --- Defines ---;
// MenuTableController Class;
@interface MenuTableController ()

@end

@implementation MenuTableController

// Functions;
#pragma mark - MenuTableController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(didHome)]) {
                [self.delegate performSelector:@selector(didHome) withObject:nil];
            }
            break;
            
        case 1:
            if ([self.delegate respondsToSelector:@selector(didHowToUse)]) {
                [self.delegate performSelector:@selector(didHowToUse) withObject:nil];
            }
            break;
            
        case 2:
            if ([self.delegate respondsToSelector:@selector(didPrivacyPolicy)]) {
                [self.delegate performSelector:@selector(didPrivacyPolicy) withObject:nil];
            }
            break;
            
        case 3:
            if ([self.delegate respondsToSelector:@selector(didTerms)]) {
                [self.delegate performSelector:@selector(didTerms) withObject:nil];
            }
            break;
            
        case 4:
            if ([self.delegate respondsToSelector:@selector(didAbout)]) {
                [self.delegate performSelector:@selector(didAbout) withObject:nil];
            }
            break;
        case 5:
            if ([self.delegate respondsToSelector:@selector(didLogout)]) {
                [self.delegate performSelector:@selector(didLogout) withObject:nil];
            }
            break;
        default:
            break;
    }
}

@end
