//
//  UIScrollView+BTDAdditions.m
//  ByteDanceKit
//
//  Created by wangdi on 2018/3/2.
//

#import "UIScrollView+BTDAdditions.h"

@implementation UIScrollView (BTDAdditions)

- (CGFloat)btd_contentOffsetX {
    return self.contentOffset.x;
}
- (void)setBtd_contentOffsetX:(CGFloat)btd_contentOffsetX {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = btd_contentOffsetX;
    self.contentOffset = contentOffset;
}

- (CGFloat)btd_contentOffsetY {
    return self.contentOffset.y;
}
- (void)setBtd_contentOffsetY:(CGFloat)btd_contentOffsetY {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = btd_contentOffsetY;
    self.contentOffset = contentOffset;
}

- (CGFloat)btd_contentWidth {
    return self.contentSize.width;
}
- (void)setBtd_contentWidth:(CGFloat)btd_contentWidth {
    CGSize contentSize = self.contentSize;
    contentSize.width = btd_contentWidth;
    self.contentSize = contentSize;
}

- (CGFloat)btd_contentHeight {
    return self.contentSize.height;
}
- (void)setBtd_contentHeight:(CGFloat)btd_contentHeight {
    CGSize contentSize = self.contentSize;
    contentSize.height = btd_contentHeight;
    self.contentSize = contentSize;
}

- (CGFloat)btd_contentInsetTop {
    return self.contentInset.top;
}
- (void)setBtd_contentInsetTop:(CGFloat)btd_contentInsetTop {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.top = btd_contentInsetTop;
    self.contentInset = contentInset;
}

- (CGFloat)btd_contentInsetBottom {
    return self.contentInset.bottom;
}
- (void)setBtd_contentInsetBottom:(CGFloat)btd_contentInsetBottom {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom = btd_contentInsetBottom;
    self.contentInset = contentInset;
}

- (CGFloat)btd_contentInsetLeft {
    return self.contentInset.left;
}
- (void)setBtd_contentInsetLeft:(CGFloat)btd_contentInsetLeft {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.left = btd_contentInsetLeft;
    self.contentInset = contentInset;
}

- (CGFloat)btd_contentInsetRight {
    return self.contentInset.right;
}
- (void)setBtd_contentInsetRight:(CGFloat)btd_contentInsetRight {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.right = btd_contentInsetRight;
    self.contentInset = contentInset;
}

- (void)btd_scrollToTop
{
    [self btd_scrollToTopAnimated:YES];
}

- (void)btd_scrollToBottom
{
    [self btd_scrollToBottomAnimated:YES];
}

- (void)btd_scrollToLeft
{
    [self btd_scrollToLeftAnimated:YES];
}

- (void)btd_scrollToRight
{
    [self btd_scrollToRightAnimated:YES];
}

- (void)btd_scrollToTopAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)btd_scrollToBottomAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)btd_scrollToLeftAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)btd_scrollToRightAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
