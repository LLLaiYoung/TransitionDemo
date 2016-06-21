//
//  LYPushTransition.m
//  3DTransitioningAnimation
//
//  Created by chairman on 16/6/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYPushTransition3D.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
@implementation LYPushTransition3D
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.8f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //1
    FirstViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    //2
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    containerView.layer.sublayerTransform = transform;
    
    //3
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    //4
    [self updateAnchorPointAndOffset:CGPointMake(0.0, 0.5) view:fromView];
    
    //5
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = fromView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor
                        ];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(0.8, 0.5);
    
    UIView *shadowView = [[UIView alloc] initWithFrame:fromView.bounds];
    shadowView.backgroundColor = [UIColor clearColor];
    [shadowView.layer insertSublayer:gradient atIndex:1];
    shadowView.alpha = 0.0;
    [fromView addSubview:shadowView];
    
    //6
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //旋转fromView 90˚
        fromView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1.0, 0);
        shadowView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //7
        fromView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        fromView.layer.position = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
        fromView.layer.transform = CATransform3DIdentity;
        [shadowView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
    
    
}

- (void)updateAnchorPointAndOffset:(CGPoint)offset view:(UIView *)view {
    view.layer.anchorPoint = offset;
    view.layer.position    = CGPointMake(0, CGRectGetMidY([UIScreen mainScreen].bounds));
}
@end
