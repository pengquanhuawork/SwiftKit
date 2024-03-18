//
//  UIViewController+ModalContainer.m
//  SCBusinessFoundation
//
//  Created by CookiesChen on 2021/7/6.
//

#import "UIViewController+ModalContainer.h"
#import "SCModalContainerViewController.h"
#import "SCModalNavigationController.h"
#import "NSDictionary+BTDAdditions.h"
#import "Masonry.h"
#import "UIView+BTDAdditions.h"
#import "ModalContainerDefines.h"
#import "NSObject+BTDAdditions.h"
#import "SCBackgroundView.h"

SCModalConfigurationKey const SCModalHeightConfiguration = @"SCModalHeightConfiguration";
SCModalConfigurationKey const SCModalDefaultHeightConfiguration = @"SCModalDefaultHeightConfiguration";
SCModalConfigurationKey const SCModalMaxHeightConfiguration = @"SCModalMaxHeightConfiguration";
SCModalConfigurationKey const SCModalIndicatorConfiguration = @"SCModalIndicatorConfiguration";
SCModalConfigurationKey const SCModalHeightChangeableConfiguration = @"SCModalHeightChangeableConfiguration";
SCModalConfigurationKey const SCModalIndicatorHeightConfiguration = @"SCModalIndicatorHeightConfiguration"; // NSNumber
SCModalConfigurationKey const SCModalIndicatorColorConfiguration = @"SCModalIndicatorColorConfiguration"; // UIColor
SCModalConfigurationKey const SCModalBackgroudCoverConfiguration = @"SCModalBackgroudCoverConfiguration";
SCModalConfigurationKey const SCModalBackgroundCoverTouchConfiguration = @"SCModalBackgroundCoverTouchConfiguration"; // 背景是否支持点击收起面板
SCModalConfigurationKey const SCModalBackgroundCoverColorConfiguration = @"SCModalBackgroundCoverColorConfiguration"; // UIColor

@implementation UIViewController(ModalContainer)

static CGFloat const kSCModalContainerDefalutTop = 0.f;

- (void)sc_presentViewController:(UIViewController *)rootVC {
    [self sc_presentViewController:rootVC configuration:nil];
}

- (void)sc_presentViewController:(UIViewController *)rootVC configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration {
    [self sc_presentViewController:rootVC configuration:configuration completion:nil];
}

- (void)sc_presentViewController:(UIViewController *)rootVC
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
               dismissCompletion:(nullable SCModelContainerDismissCompletion)dismissCompletion {
    self.sc_dismissCompletion =  dismissCompletion;
    [self sc_presentViewController:rootVC configuration:configuration completion:nil];
}

- (void)sc_presentViewController:(UIViewController *)rootVC
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
                      completion:(nullable void (^)(void))completion {
    [self sc_presentViewController:rootVC animated:YES configuration:configuration completion:completion];
}

- (void)sc_presentViewController:(UIViewController *)rootVC
                        animated:(BOOL)flag
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
                      completion:(nullable void (^)(void))completion {
    if (!rootVC) {
        return;
    }
    UIViewController *presentingVC = [self sc_nestModalContainer] ?: self;
//    if (presentingVC.sc_presentedViewController) {
//        return ;
//    }
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGFloat defaultModalHeight = CGRectGetHeight(screenBounds) - kSCModalContainerDefalutTop;
    NSDictionary *config = configuration;
    if (!config) {
        config = @{};
    }
    
    CGFloat defaultHeight = [config btd_floatValueForKey:SCModalDefaultHeightConfiguration default:defaultModalHeight];
    CGFloat maxHeight = [config btd_floatValueForKey:SCModalMaxHeightConfiguration default:defaultModalHeight];
    BOOL indicatorEnable = [config btd_boolValueForKey:SCModalIndicatorConfiguration default:YES];
    BOOL heightChangeable = [config btd_boolValueForKey:SCModalHeightChangeableConfiguration default:NO];
    CGFloat indicatorHeight = [config btd_floatValueForKey:SCModalIndicatorHeightConfiguration default:28.f];
    UIColor *indicatorColor = [config btd_objectForKey:SCModalIndicatorColorConfiguration default:UIColor.whiteColor];
    BOOL backgroundCoverEnable = [config btd_boolValueForKey:SCModalBackgroudCoverConfiguration default:YES];
    UIColor *backgroundCoverColor = [config btd_objectForKey:SCModalBackgroundCoverColorConfiguration default:UIColor.clearColor];
    
    BOOL backgroundTouchEnable = [config btd_boolValueForKey:SCModalBackgroundCoverTouchConfiguration default:YES];
    
    SCModalContainerViewController *presentedVC = [[SCModalContainerViewController alloc] initWithRootViewController:rootVC
                                                                                                         modalHeight:defaultHeight
                                                                                                     indicatorEnable:indicatorEnable
                                                                                                     indicatorHeight:indicatorHeight
                                                                                                      indicatorColor:indicatorColor];
   
    presentedVC.sc_maxHeight = maxHeight;
    presentedVC.sc_defaultHeight = defaultHeight;
    presentedVC.sc_presentingViewController = presentingVC;
    presentedVC.pi_heightChangeable = heightChangeable;
    presentingVC.sc_presentedViewController = presentedVC;
    
    if (backgroundCoverEnable) {
        SCBackgroundView *backgroundView = [[SCBackgroundView alloc] init];
        backgroundView.presentedViewController = presentedVC;
        presentedVC.pi_backgroundView = backgroundView;
        [presentingVC.view addSubview:backgroundView];
        [backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(presentingVC.view);
        }];
    }
    
    [presentedVC willMoveToParentViewController:presentingVC];
    [presentingVC addChildViewController:presentedVC];
    [presentingVC.view addSubview:presentedVC.view];
    [presentedVC didMoveToParentViewController:presentingVC];
    [presentedVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(presentingVC.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(defaultHeight);
    }];
    
    [presentingVC.view setNeedsLayout];
    [presentingVC.view layoutIfNeeded];
    
    [self begin];
    
    [presentedVC presentAnimation:flag completion:completion];
}

- (void)begin {
    
}

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
               dismissCompletion:(nullable SCModelContainerDismissCompletion)dismissCompletion {
    self.sc_dismissCompletion =  dismissCompletion;
    [self sc_presentViewController:rootVC animated:YES configuration:nil completion:nil];
}

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
                        animated:(BOOL)flag
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
                      completion:(nullable void (^)(void))completion
                dismissCompletion:(nullable SCModelContainerDismissCompletion)dismissCompletion {
    self.sc_dismissCompletion =  dismissCompletion;
    [self sc_presentViewController:rootVC animated:flag configuration:configuration completion:completion];
    
}

- (void)sc_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *presentingVC = nil;
    UIViewController *presentedVC = nil;
    UIViewController *vc = self;
    
    while (vc) {
        if (vc.sc_presentingViewController) {
            presentingVC = vc.sc_presentingViewController;
            presentedVC = vc;
            break;
        } else if (vc.sc_presentedViewController) {
            presentingVC = vc;
            presentedVC = vc.sc_presentedViewController;
            break;
        }
        
        vc = vc.view.superview.btd_viewController;
    }
    
    if (!presentingVC || !presentedVC) {
        return;
    }
    
    [((SCModalContainerViewController *)presentedVC) dismissAnimation:flag completion:completion];
}

- (UIViewController *)sc_topPresentingViewController {
    UIViewController *vc = self;
    UIViewController *presentingVC = nil;
    while (vc) {
        if (vc.sc_presentedViewController) {
            presentingVC = vc;
            break;
        } else if (vc.sc_presentingViewController) {
            presentingVC = vc.sc_presentingViewController;
            break;
        }
        
        if (vc.view.superview.btd_viewController) {
            vc = vc.view.superview.btd_viewController;
        } else if (vc.navigationController) {
            vc = vc.navigationController;
        } else if (vc.tabBarController) {
            vc = vc.tabBarController;
        }
    }
    return presentingVC;
}

- (void)pi_didTapModalContainerViewController {
    
}

- (nullable NSArray <UIView *> *)pi_ignoreViewWhenTapModalContainerViewController {
    return nil;
}

- (nullable NSArray <UIView *> *)pi_ignoreViewWhenPanModalContainerViewController {
    return nil;
}

#pragma mark -- Private

- (UIViewController *)sc_nestModalContainer {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[SCModalContainerViewController class]]) {
        vc = vc.view.superview.btd_viewController;
    }
    return vc;
}

#pragma mark -- Accessor

- (void)setPi_backgroundView:(UIView *)pi_backgroundView {
    [self btd_attachObject:pi_backgroundView forKey:NSStringFromSelector(@selector(pi_backgroundView))];
}

- (UIView *)pi_backgroundView {
    return [self btd_getAttachedObjectForKey:@"pi_backgroundView"];
}

- (void)setPi_position:(PIModalPosition)pi_position {
    [self btd_attachObject:@(pi_position) forKey:NSStringFromSelector(@selector(pi_position))];
}

- (PIModalPosition)pi_position {
    return [[self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(pi_position))] integerValue];
}

- (void)setPi_heightChangeable:(BOOL)pi_heightChangeable {
    [self btd_attachObject:@(pi_heightChangeable) forKey:NSStringFromSelector(@selector(pi_heightChangeable))];
}

- (BOOL)pi_heightChangeable {
    return [[self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(pi_heightChangeable))] boolValue];
}

- (void)setSc_maxHeight:(CGFloat)sc_maxHeight {
    [self btd_attachObject:@(sc_maxHeight) forKey:NSStringFromSelector(@selector(sc_maxHeight))];
}

- (CGFloat)sc_maxHeight {
    return [((NSNumber *)[self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(sc_maxHeight))]) floatValue];
}

- (void)setSc_defaultHeight:(CGFloat)sc_defaultHeight {
    [self btd_attachObject:@(sc_defaultHeight) forKey:NSStringFromSelector(@selector(sc_defaultHeight))];
}

- (CGFloat)sc_defaultHeight {
    return [((NSNumber *)[self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(sc_defaultHeight))]) floatValue];
}

- (SCModelContainerDismissCompletion)sc_dismissCompletion {
    return [self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(sc_dismissCompletion))];
}

- (void)setSc_dismissCompletion:(SCModelContainerDismissCompletion)sc_dismissCompletion {
    [self btd_attachObject:sc_dismissCompletion forKey:NSStringFromSelector(@selector(sc_dismissCompletion))];
}

- (UIViewController *)sc_presentedViewController {
    return [self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(sc_presentedViewController)) isWeak:YES];
}

- (void)setSc_presentedViewController:(UIViewController *)sc_presentedViewController {
    [self btd_attachObject:sc_presentedViewController forKey:NSStringFromSelector(@selector(sc_presentedViewController)) isWeak:YES];
}

- (UIViewController *)sc_presentingViewController {
    return [self btd_getAttachedObjectForKey:NSStringFromSelector(@selector(sc_presentingViewController)) isWeak:YES];
}

- (void)setSc_presentingViewController:(UIViewController *)sc_presentingViewController {
    [self btd_attachObject:sc_presentingViewController forKey:NSStringFromSelector(@selector(sc_presentingViewController)) isWeak:YES];
}

@end
