//
//  FirstViewController.m
//  3DTransitioningAnimation
//
//  Created by chairman on 16/6/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "LYPushTransition3D.h"
#import "LYPushTransition.h"
#import "LYPopTransition.h"
@interface FirstViewController ()
<
UINavigationControllerDelegate,
UIViewControllerTransitioningDelegate,
SecondViewControllerDelegate
>
@property (nonatomic, strong) LYPopTransition *pop;
@property (nonatomic, strong) LYPushTransition *push;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First";
    self.pop = [LYPopTransition new];
    self.push = [LYPushTransition new];
    self.navigationController.delegate = self;
    
}

- (IBAction)pushOrPresentBtn:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *secondVC = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    secondVC.delegate = self;
    //* present */
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:secondVC];
    //* 如果present的NavigationController则需要设置NavigationController的transitioningDelegate为self */
    navi.transitioningDelegate = self;
    [self presentViewController:navi animated:YES completion:nil];
    
    //* push */
//    [self.navigationController pushViewController:secondVC animated:YES];
}
#pragma mark - SecondViewControllerDelegate
-(void)secondViewControllerDidClickedDismissBtn:(SecondViewController *)viewControllr {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate present
/** prensent */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.push;
}
/** dismiss */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.pop;
}

#pragma mark - UINavigationControllerDelegate push

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        LYPushTransition *push = [LYPushTransition new];
        return push;
    } else if (operation == UINavigationControllerOperationPop) {
        LYPopTransition *pop = [LYPopTransition new];
        return pop;
    }else {
        return nil;
    }
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
