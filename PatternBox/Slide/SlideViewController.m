//
//  SlideViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "SlideViewController.h"
#import "LoginViewController.h"
#import "AppManager.h"

// --- Defines ---;
// SlideViewController Class;
@interface SlideViewController ()

// Properties;



@end

@implementation SlideViewController

// Functions;
#pragma mark - AppDelegate
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Controllers;
    self.menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    self.mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"Homeview"];
    self.privacyController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyView"];
    self.termsController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsView"];
    self.aboutController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];

    // Menu Controller;
    self.underLeftViewController = self.menuController;
    //self.underRightViewController = self.menuController;
    // Top Controller;
    self.topViewController = self.mainController;
    
    // Set;
    //self.anchorRightRevealAmount = 270;
    self.anchorLeftRevealAmount = 50;
    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MenuTableControllerDelegate
- (void)didSelectController:(UIViewController *)viewController
{
    // Top Controller;
    self.topViewController = viewController;
    
    // Reset;
    [self resetTopViewAnimated:YES];
}

-(void)didHome
{
    
    [self performSelector:@selector(didSelectController:) withObject:self.mainController];
}

- (void)didHowToUse
{
    UIStoryboard *tutorialStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    // Instantiate the initial view controller object from the storyboard
    UIViewController *initialViewController = [tutorialStoryBoard instantiateInitialViewController];
    [APPDELEGATE.window setRootViewController:initialViewController];
}

-(void)didPrivacyPolicy
{
    [self performSelector:@selector(didSelectController:) withObject:self.privacyController];
}

-(void)didTerms
{
    [self performSelector:@selector(didSelectController:) withObject:self.termsController];
}

-(void)didAbout
{
    if ([MFMailComposeViewController canSendMail])
    {
         MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        //[mailView setSubject:subject];
        //[mailView setMessageBody:message isHTML:YES];
        [mailView setToRecipients:@[@"Patternboxapp@gmail.com"]];
        
        [self presentViewController:mailView animated:YES completion:nil];
        
    }else{
        [[AppManager sharedInstance] showMessageWithTitle:@"Warning" message:@"Your device is unable to send email." view:self.topViewController];
        return;
    }
}
-(void)didLogout
{
    [APPDELEGATE logout];

}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{

    [controller dismissViewControllerAnimated:YES completion:^{
        if(result == MFMailComposeResultSent){
            [[AppManager sharedInstance] showMessageWithTitle:@"Welcome!" message:@"Thank you for contacting us!" view:self.topViewController];
        }else if(result == MFMailComposeResultFailed){
            [[AppManager sharedInstance] showMessageWithTitle:@"Error" message:error.description view:self.topViewController];
        }
        [self didHome];
    }];
    
    /* MFMailComposeResultCancelled,
     MFMailComposeResultSaved,
     MFMailComposeResultSent,
     MFMailComposeResultFailed*/
    
}
@end
