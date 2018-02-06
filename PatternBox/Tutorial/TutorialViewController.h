//
//  TutorialViewController.h
//  PatternBox
//
//  Created by youandme on 22/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *m_pageViewController;
@property (strong, nonatomic) UIViewController *m_currentContentController;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSkipTutorial;

- (IBAction)actionToMainStoryBoard:(id)sender;

@end
