//
//  UIScrollView+BTDAdditions.h
//  ByteDanceKit
//
//  Created by wangdi on 2018/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (BTDAdditions)

@property (nonatomic, assign) CGFloat btd_contentOffsetX;
@property (nonatomic, assign) CGFloat btd_contentOffsetY;

@property (nonatomic, assign) CGFloat btd_contentWidth;
@property (nonatomic, assign) CGFloat btd_contentHeight;

@property (nonatomic, assign) CGFloat btd_contentInsetTop;
@property (nonatomic, assign) CGFloat btd_contentInsetBottom;
@property (nonatomic, assign) CGFloat btd_contentInsetLeft;
@property (nonatomic, assign) CGFloat btd_contentInsetRight;

/**
 Some ways to scroll the UIScrollView.
 */
- (void)btd_scrollToTop;
- (void)btd_scrollToBottom;
- (void)btd_scrollToLeft;
- (void)btd_scrollToRight;
- (void)btd_scrollToTopAnimated:(BOOL)animated;
- (void)btd_scrollToBottomAnimated:(BOOL)animated;
- (void)btd_scrollToLeftAnimated:(BOOL)animated;
- (void)btd_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
