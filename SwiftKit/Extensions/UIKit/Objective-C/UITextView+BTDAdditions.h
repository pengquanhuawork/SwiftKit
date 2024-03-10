//
//  UITextView+BTDAdditions.h
//  Pods
//
//  Created by yanglinfeng on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//https://github.com/devxoul/UITextView-Placeholder

@interface UITextView (BTDAdditions)

@property (nonatomic, strong, nullable) IBInspectable NSString *btd_placeholder;
@property (nonatomic, strong, nullable) NSAttributedString *btd_attributedPlaceholder;
@property (nonatomic, strong, nullable) IBInspectable UIColor *btd_placeholderColor;
@property (nonatomic, strong, nullable) IBInspectable UIColor *btd_placeholderBackgroundColor;

/// Determine whether or not align the textContainer related properties of placeholderTextView with the origin textView
/// TextContainer related properties include textContainerInset | textContainer.exclusionPaths | textContainer.lineFragmentPadding
/// Default value is NO, if you set the value YES, you need to control the above properties yourself.
@property (nonatomic, assign, readwrite) IBInspectable BOOL btd_disableAligningTextContainerProps;
@property (nonatomic, strong, readonly) UITextView *btd_placeholderTextView;


@end

NS_ASSUME_NONNULL_END
