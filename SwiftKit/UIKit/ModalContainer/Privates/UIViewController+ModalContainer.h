//
//  UIViewController+ModalContainer.h
//  SCBusinessFoundation
//
//  Created by CookiesChen on 2021/7/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PIModalPosition) {
    PIModalPositionBottom = 0,
    PIModalPositionMiddle = 1,
    PIModalPositionTop = 2
};

typedef NSString * SCModalConfigurationKey;
extern SCModalConfigurationKey const _Nullable SCModalMaxHeightConfiguration;    // NSNumber
extern SCModalConfigurationKey const _Nullable SCModalDefaultHeightConfiguration;    // NSNumber
extern SCModalConfigurationKey const _Nullable SCModalHeightConfiguration;    // NSNumber
extern SCModalConfigurationKey const _Nullable SCModalIndicatorConfiguration; // @(YES/NO)
extern SCModalConfigurationKey const _Nullable SCModalIndicatorHeightConfiguration; // NSNumber
extern SCModalConfigurationKey const _Nullable SCModalIndicatorColorConfiguration; // UIColor
extern SCModalConfigurationKey const _Nullable SCModalHeightChangeableConfiguration; // @(YES/NO)
extern SCModalConfigurationKey const _Nullable SCModalBackgroudCoverConfiguration; // @(YES/NO)
extern SCModalConfigurationKey const _Nullable SCModalBackgroundCoverTouchConfiguration;
extern SCModalConfigurationKey const _Nullable SCModalBackgroundCoverColorConfiguration; // UIColor

typedef void(^SCModelContainerDismissCompletion)(void);

@interface UIViewController(ModalContainer) <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat sc_maxHeight;
@property (nonatomic, assign) CGFloat sc_defaultHeight;
@property (nonatomic, assign) BOOL pi_heightChangeable;
@property (nonatomic, assign) PIModalPosition pi_position;
@property (nonatomic, strong, nullable) UIView *pi_backgroundView;
@property (nonatomic, weak, nullable) UIViewController *sc_presentedViewController;
@property (nonatomic, weak, nullable) UIViewController *sc_presentingViewController;
@property (nonatomic, strong, nullable) SCModelContainerDismissCompletion sc_dismissCompletion;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
               dismissCompletion:(nullable SCModelContainerDismissCompletion)dismissCompletion;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
                      completion:(nullable void (^)(void))completion;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
                        animated:(BOOL)flag
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
                      completion:(nullable void (^)(void))completion;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
               dismissCompletion:(nullable SCModelContainerDismissCompletion)dismissCompletion;

- (void)sc_presentViewController:(nonnull UIViewController *)rootVC
                        animated:(BOOL)flag
                   configuration:(nullable NSDictionary<SCModalConfigurationKey, id> *)configuration
                      completion:(nullable void (^)(void))completion
                dismissCompletion:(nullable SCModelContainerDismissCompletion)dismissCompletion;

- (void)sc_dismissViewControllerAnimated:(BOOL)flag completion:(nullable void (^)(void))completion;

- (nullable UIViewController *)sc_topPresentingViewController;


/// 面板上有个点击手势，如果面板上的subview的点击事件与该手势冲突，在返回值添加该subview处理冲突
- (nullable NSArray <UIView *> *)pi_ignoreViewWhenTapModalContainerViewController;
/// 面板上的点击手势响应
- (void)pi_didTapModalContainerViewController;

/// 面板上有个点击手势，如果面板上的subview的点击事件与该手势冲突，在返回值添加该subview处理冲突
- (nullable NSArray <UIView *> *)pi_ignoreViewWhenPanModalContainerViewController;

- (void)begin;

@end
