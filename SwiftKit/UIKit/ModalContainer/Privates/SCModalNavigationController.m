//
//  SCModalNavigationController.m
//  SCBusinessFoundation
//
//  Created by CookiesChen on 2021/6/23.
//

#import "SCModalNavigationController.h"
#import "UIImage+BTDAdditions.h"
#import "NSArray+BTDAdditions.h"

@interface SCModalNavigationController() <UIGestureRecognizerDelegate>

@end

@implementation SCModalNavigationController

+ (UIColor *)navigationBarColor {
    UIColor *color = UIColor.whiteColor;
    return color;
}

+ (NSDictionary *)titleTextConfig {
    return @{
        NSForegroundColorAttributeName:UIColor.blackColor,
        NSFontAttributeName:[UIFont systemFontOfSize:17]
    };
}

+ (void)initialize {
    if (@available(iOS 15, *)){
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.titleTextAttributes = [SCModalNavigationController titleTextConfig];
        appearance.backgroundColor = [SCModalNavigationController navigationBarColor];
        appearance.shadowColor = UIColor.clearColor;
        appearance.shadowImage = [[UIImage alloc] init];
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // 清空导航栏背景色
        [self.navigationBar setBackgroundImage:[UIImage btd_imageWithColor:[SCModalNavigationController navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
        
        // 设置导航栏标题font和颜色
        [self.navigationBar setTitleTextAttributes:[SCModalNavigationController titleTextConfig]];
        
        // present出来手势无效，重新设置代理
        self.interactivePopGestureRecognizer.delegate = self;
        self.navigationBar.hidden = YES;
    }
    return self;
}

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 防止冻屏需要viewControllers.count > 1才响应手势
    return self.viewControllers.count > 1;
}

#pragma mark -- SCModalNavigation Event

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationDelegate willPushToViewController:viewController];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.navigationDelegate willPopToViewController:[self.viewControllers btd_objectAtIndex:self.viewControllers.count - 2]];
    return [super popViewControllerAnimated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self.navigationDelegate willSetViewControllersWithTopController:viewControllers.lastObject];
    [super setViewControllers:viewControllers animated:animated];
}

- (void)updateHeight:(CGFloat)height animation:(BOOL)animation completion:(nullable dispatch_block_t)completion {
    if ([self.navigationDelegate respondsToSelector:@selector(updateHeight:animation:completion:)]) {
        [self.navigationDelegate updateHeight:height animation:animation completion:completion];
    }
}

@end
