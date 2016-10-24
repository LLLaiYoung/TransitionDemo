# TransitionDemo
####Timi记账时光轴界面到添加账单(修改账单)界面的转场动画(对应class`LYPushTransition`,`LYPopTransition`)
使用的是自定义的转场动画,具体如何使用请看[喵神](https://onevcat.com/2013/10/vc-transition-in-ios7/) 和 [KittenYang](http://kittenyang.com/uiviewcontrollertransitioning/) 的blog,推荐[几句代码快速集成自定义转场效果+全手势驱动](https://github.com/wazrx/XWTransition)
1.首先定一个`class`,继承至`NSObject`,遵守`UIViewControllerAnimatedTransitioning`协议。
2.需要实现两个方法

```
/** 动画时间 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext

/** 转场动画内容(怎么转) */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
```
#####Push代码细节讲解(是一个反向prensent转场动画)
```
/** 动画时间 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}
/** 动画内容(如何转场) */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    /**
     *
    1.transitionContext 过渡内容上下文,可以通过它调用`viewControllerForKey:`拿到对应的过渡控制器
        key:UITransitionContextToViewControllerKey 目的控制器
            UITransitionContextFromViewControllerKey 开始控制器
    2.拿到对应的过渡控制器之后需要设置view的frame
        `finalFrameForViewController:` 可以拿到最后的frame,最后即完成动画后的frame
        `initialFrameForViewController:` 拿到初始化的frame,开始动画之前的frame
    3.然后添加到`transitionContext的containerView`
    
    4.设置动画的其他附带属性动画
     
    5.做动画... `UIView的block动画`
     
    6.在动画结束后我们必须向context报告VC切换完成，是否成功。系统在接收到这个消息后，将对VC状态进行维护。
     *
     */
    
    //1...
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    
    //2...
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    //(dx, dy) eg:dx偏移多少
    toView.frame = CGRectOffset(finalFrame, 0, -SCREEN_SIZE.height);
    //3....
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    //4...
    
    //5...
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       toView.frame = finalFrame;
    } completion:^(BOOL finished) {
        //6...
        [transitionContext completeTransition:YES];
    }];
}
```
#####Pop做Push的相反操作即可
...
#### 3. ViewController如何使用自定义转场动画
* pushViewController
	在push的控制器设置`navigationController`的`delegate`为`self`
	
	```
	self.navigationController.delegate = self;
	```
	实现协议方法
	
	```
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
	```
通过`operation`判断是`push`操作还是`pop`操作,然后然后对于的动画即可
`pop`控制器不需要做任何操作
如果使用`push`,则会发现`NavigationBar`没有变化,会一直处于那个地方,很丑...
然而使用`present`就可以避免这种现象
* presentViewController
 设置`presentViewController`的`ViewController`的`transitioningDelegate`为`self`
 注意,如果是present的`UINavigationController`,则需要设置`NavigationController`的`transitioningDelegate`为`self`
  
	```
	UIStoryboard *storyboard = [UIStoryboard 	storyboardWithName:@"Main" bundle:nil];
	SecondViewController *secondVC = [storyboard instantiateViewControllerWithIdentifier:@"second"];
	secondVC.delegate = self;
	//* present */
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:secondVC];
//* 如果present的NavigationController则需要设置NavigationController的transitioningDelegate为self */
navi.transitioningDelegate = self;
[self presentViewController:navi animated:YES completion:nil];
```
实现`transitioningDelegate`协议方法

	```
	/** prensent */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.push;
}
/** dismiss */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.pop;
}
```

	`dismiss`控制器则需要写一个代理,告诉`present`的那个控制器`dismiss`即可
	
Note：如果`presentViewController`、`dismissViewControllerAnimated`或者`pushViewController`、`popViewControllerAnimated` 的`animated`设置为`NO`的话，就可能导致不会执行你的动画代理函数，也就意味着不会有转场动画


