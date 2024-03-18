//
//  SCModalContainerViewController.h
//  SCBusinessFoundation
//
//  Created by CookiesChen on 2021/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCModalIndicator <NSObject>

-(BOOL)indicatorEnable;

@end

@interface SCModalContainerViewController : UIViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootVc
                               modalHeight:(CGFloat)modalHeight
                           indicatorEnable:(BOOL)indicatorEnable
                           indicatorHeight:(CGFloat)indicatorHeight
                            indicatorColor:(UIColor *)indicatorColor;

- (void)presentAnimation:(BOOL)animated completion:(nullable void (^)(void))completion;
- (void)dismissAnimation:(BOOL)animated completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
