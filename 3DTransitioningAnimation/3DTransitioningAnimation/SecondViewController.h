//
//  SecondViewController.h
//  3DTransitioningAnimation
//
//  Created by chairman on 16/6/21.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondViewController;
@protocol SecondViewControllerDelegate <NSObject>
@required
- (void)secondViewControllerDidClickedDismissBtn:(SecondViewController *)viewControllr;
@optional

@end
@interface SecondViewController : UIViewController
@property (nonatomic, weak) id<SecondViewControllerDelegate> delegate;

@end
