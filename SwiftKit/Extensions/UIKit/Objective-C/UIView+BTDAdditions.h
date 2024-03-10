//
//  UIView+BTDAdditions.h
//  ByteDanceKit
//
//  Created by wangdi on 2018/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BTDAdditions)

/*
 Properties about the coordinate.
 */
@property (nonatomic, assign) CGFloat btd_x;
@property (nonatomic, assign) CGFloat btd_y;
@property (nonatomic, assign) CGFloat btd_centerX;
@property (nonatomic, assign) CGFloat btd_centerY;
@property (nonatomic, assign) CGFloat btd_width;
@property (nonatomic, assign) CGFloat btd_height;
@property (nonatomic, assign) CGSize btd_size;
/**
 Capture a snapshot, some layer doesn't support(EX CAEAGLLayer).

 @return The snapshot image of the current view.
 */
- (nullable UIImage *)btd_snapshotImage;

/**
 Set the layer's shadow.

 @param color The shadow's color.
 @param offset The shadow's offset.
 @param radius The shadow's radius.
 */
- (void)btd_setLayerShadow:(nonnull UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

- (void)btd_addShadowAndCornerWithShadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius cornerRadius:(CGFloat)cornerRadius;


/**
 Remove all subviews.
 */
- (void)btd_removeAllSubviews;

/**
 Return the UIViewController of the view.

 @return A UIViewController.
 */
- (nullable UIViewController *)btd_viewController;

@property (nonatomic, assign) CGFloat btd_left;

@property (nonatomic, assign) CGFloat btd_right;

@property (nonatomic, assign) CGFloat btd_top;

@property (nonatomic, assign) CGFloat btd_bottom;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, assign, readonly) CGFloat btd_screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, assign, readonly) CGFloat btd_screenY;

/**
 *  safeAreaInsets osVersion safe
 */
@property (nonatomic, assign, readonly) UIEdgeInsets btd_safeAreaInsets NS_EXTENSION_UNAVAILABLE_IOS("Not available in Extension Target");

@property(nonatomic, assign) UIEdgeInsets btd_hitTestEdgeInsets;

- (void)btd_eachSubview:(void (^)(UIView *subview))block;

@end

NS_ASSUME_NONNULL_END
