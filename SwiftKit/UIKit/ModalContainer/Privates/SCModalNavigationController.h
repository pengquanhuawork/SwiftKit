//
//  SCModalNavigationController.h
//  SCBusinessFoundation
//
//  Created by CookiesChen on 2021/6/23.
//

#import <UIKit/UIKit.h>

extern CGFloat modalNavigationAdditionalTop(void);

@protocol SCModalNavigationProtocol <NSObject>

@required

- (void)willPushToViewController:(UIViewController *)vc;
- (void)willPopToViewController:(UIViewController *)vc;
- (void)willSetViewControllersWithTopController:(UIViewController *)vc;

@optional

- (void)updateHeight:(CGFloat)height animation:(BOOL)animation completion:(nullable dispatch_block_t)completion;

@end

@interface SCModalNavigationController : UINavigationController

@property (nonatomic, weak) id<SCModalNavigationProtocol> navigationDelegate;

- (void)updateHeight:(CGFloat)height animation:(BOOL)animation completion:(nullable dispatch_block_t)completion;

@end
