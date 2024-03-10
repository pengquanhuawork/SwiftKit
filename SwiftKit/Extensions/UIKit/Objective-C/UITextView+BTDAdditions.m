//
//  UITextView+BTDAdditions.m
//  Pods
//
//  Created by yanglinfeng on 2019/7/3.
//

#import "UITextView+BTDAdditions.h"
#import <objc/runtime.h>
#import "NSObject+BTDAdditions.h"

@interface UITextView ()

@property (nonatomic, readonly) UITextView *placeholderTextView;

@end

@implementation UITextView (BTDAdditions)


#pragma mark - Swizzle Dealloc

+ (void)load {
    // is this the best solution?
//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
//                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self btd_swizzleInstanceMethod:NSSelectorFromString(@"dealloc") with:@selector(_btd_swizzledDealloc)];
    });
}

- (void)_btd_swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (textView) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self _btd_swizzledDealloc];
}


#pragma mark - Class Methods

#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.exclusionPaths"];
}


#pragma mark - Properties
#pragma mark `placeholderTextView`

- (UITextView *)placeholderTextView {
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (!textView) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;
        
        textView = [[UITextView alloc] init];
        textView.textColor = [UIColor colorWithRed:0 green:0 blue:0.098 alpha:0.22];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderTextView), textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.needsUpdateFont = YES;
        [self updatePlaceholderTextView];
        self.needsUpdateFont = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderTextView)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return textView;
}

- (UITextView *)btd_placeholderTextView {
    return self.placeholderTextView;;
}

#pragma mark `placeholder`

- (NSString *)btd_placeholder {
    return self.placeholderTextView.text;
}

- (void)setBtd_placeholder:(NSString *)btd_placeholder {
    self.placeholderTextView.text = btd_placeholder;
    [self updatePlaceholderTextView];
}

- (NSAttributedString *)btd_attributedPlaceholder {
    return self.placeholderTextView.attributedText;
}

- (void)setBtd_attributedPlaceholder:(NSAttributedString *)btd_attributedPlaceholder {
    self.placeholderTextView.attributedText = btd_attributedPlaceholder;
    [self updatePlaceholderTextView];
}

#pragma mark `placeholderColor`

- (UIColor *)btd_placeholderColor {
    return self.placeholderTextView.textColor;
}

- (void)setBtd_placeholderColor:(UIColor *)btd_placeholderColor {
    self.placeholderTextView.textColor = btd_placeholderColor;

}

- (UIColor *)btd_placeholderBackgroundColor{
    return self.placeholderTextView.backgroundColor;
}
- (void)setBtd_placeholderBackgroundColor:(UIColor *)btd_placeholderBackgroundColor{
    self.placeholderTextView.backgroundColor = btd_placeholderBackgroundColor;
}

#pragma mark `needsUpdateFont`

- (BOOL)needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - btd_shouldAlignTextViewProperty

- (BOOL)btd_disableAligningTextContainerProps {
    return [objc_getAssociatedObject(self, @selector(btd_disableAligningTextContainerProps)) boolValue];
}

- (void)setBtd_disableAligningTextContainerProps:(BOOL)btd_disableAligningTextContainerProps {
    objc_setAssociatedObject(self,
                             @selector(btd_disableAligningTextContainerProps),
                             @(btd_disableAligningTextContainerProps),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderTextView];
}


#pragma mark - Update

- (void)updatePlaceholderTextView {
    if (self.text.length) {
        [self.placeholderTextView removeFromSuperview];
    } else {
        [self insertSubview:self.placeholderTextView atIndex:0];
    }
    
    if (self.needsUpdateFont) {
        self.placeholderTextView.font = self.font;
        self.needsUpdateFont = NO;
    }
    self.placeholderTextView.textAlignment = self.textAlignment;
    
    if (!self.btd_disableAligningTextContainerProps) {
        self.placeholderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
        self.placeholderTextView.textContainerInset = self.textContainerInset;
        self.placeholderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    }
    self.placeholderTextView.frame = self.bounds;
}

@end
