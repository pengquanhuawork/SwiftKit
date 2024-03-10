//
//  UIButton+BTDAdditions.h
//  Pods
//
//  Created by yanglinfeng on 2019/7/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BTDButtonEdgeInsetsStyle) {
    BTDButtonEdgeInsetsStyleImageLeft,
    BTDButtonEdgeInsetsStyleImageRight,
    BTDButtonEdgeInsetsStyleImageTop,
    BTDButtonEdgeInsetsStyleImageBottom
};


@interface UIButton (BTDAdditions)

- (void)btd_addActionBlockForTouchUpInside:(void(^)(__kindof UIButton *sender))block;

/**
 *  设置Button中图片与文字的距离
 *
 *  @param style style
 *  @param space space
 */
- (void)btd_layoutButtonWithEdgeInsetsStyle:(BTDButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
