//
//  AppDelegate.m
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "AppDelegate.h"
#import "Define.h"
#import "LoginViewController.h"
#import "SlideViewController.h"
#import "AppManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initFigure];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication*)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if(url != nil ){
        if(![url isFileURL]) return false;
        [AppManager sharedInstance].openInURL = url.absoluteString;
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if(state == UIApplicationStateActive || state == UIApplicationStateInactive){
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SlideViewController"];
        }else{
           [self initFigure];
        }
    }
    return YES;
}
-(void)initFigure{
    
    NSMutableArray *scanPattern = [[NSUserDefaults standardUserDefaults] objectForKey:KTypeScan];
    if (scanPattern == nil) {
        scanPattern = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:scanPattern forKey:KTypeScan];
    }
    NSMutableArray *pdfsPattern = [[NSUserDefaults standardUserDefaults] objectForKey:KTypePDF];
    if (pdfsPattern == nil) {
        pdfsPattern = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:pdfsPattern forKey:KTypePDF];
    }
    
    NSString* token = [[AppManager sharedInstance] userAuthenticationToken];
    if (!token || [token isEqualToString:@""]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = loginViewController;
    }
    
    
    
    NSString *show = [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"];
    if ([show isEqualToString:@"YES"]) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"tutorial"];
    UIStoryboard *tutorialStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    // Instantiate the initial view controller object from the storyboard
    UIViewController *initialViewController = [tutorialStoryBoard instantiateInitialViewController];
    [self.window setRootViewController:initialViewController];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.backgroundColor = [UIColor whiteColor];
}
#pragma mark - Global
- (void)setTitleViewOfNavigationBar:(UINavigationItem *)navigationItem {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 54.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:2];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Euphenmia-Bold" size:19]];
    [label setText:@"PATTERN BOX"];
    navigationItem.titleView = label;

}

- (void)setTitleViewOfNavigationBarWithTitle:(NSString *)title navi:(UINavigationItem *)navigationItem {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 54.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:2];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Cochine-Bold" size:19]];
    [label setText:title];
    navigationItem.titleView = label;
    
}

-(void)setViewMovedUp:(BOOL)movedUp view:(UIView*)view offset:(CGFloat)offset {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= offset;
        //        rect.size.height += 100;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += offset;
        //        rect.size.height -= 100;
    }
    view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)changeStoryboard {
    //if (![PFUser currentUser]) {
    if (![[AppManager sharedInstance] userAuthenticationToken]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = loginViewController;
        return;
    }

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // Instantiate the initial view controller object from the storyboard
    UIViewController *initialViewController = [mainStoryBoard instantiateInitialViewController];
    [self.window setRootViewController:initialViewController];
    
}
-(void)logout{
    [[AppManager sharedInstance] setUserAuthenticationToken:@""];
    [[AppManager sharedInstance] setUserID:0];
    [AppManager sharedInstance].isLoadInitData = false;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.window.rootViewController = loginViewController;

}
@end
