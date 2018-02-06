//
//  TutorialViewController.m
//  PatternBox
//
//  Created by youandme on 22/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialContentController.h"
#import "Define.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.m_pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageController"];
    self.m_pageViewController.delegate = self;
    self.m_pageViewController.dataSource = self;
    
    TutorialContentController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.m_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.m_pageViewController];
    UIView *view = self.m_pageViewController.view;
    //[self.view addSubview:view];
    [self.view insertSubview:view belowSubview:self.m_btnSkipTutorial];
    
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor redColor]];
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
#pragma mark - PageViewController Delegate
- (TutorialContentController *)viewControllerAtIndex:(NSUInteger)index {
    // Create a new view controller and pass suitable data.
    
    NSString *identifier = [NSString stringWithFormat:@"Tutorial_%d", (int)index];
    TutorialContentController *pageContentViewController = (TutorialContentController *)[self.storyboard instantiateViewControllerWithIdentifier:identifier];
    pageContentViewController.m_currentPage = index;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialContentController*) viewController).m_currentPage;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialContentController*) viewController).m_currentPage;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 10) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 10;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    //    strVal=[[strVal componentsSeparatedByString:@"***#$ "] lastObject];
    //    self.navigationItem.title=strVal;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (!completed) return;
}

#pragma mark -
#pragma mark - Actions
- (IBAction)actionToMainStoryBoard:(id)sender {
    [APPDELEGATE changeStoryboard];
}
@end
