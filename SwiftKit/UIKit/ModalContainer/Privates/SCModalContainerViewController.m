//
//  SCModalContainerViewController.m
//  SCBusinessFoundation
//
//  Created by CookiesChen on 2021/6/23.
//

#import "SCModalContainerViewController.h"
#import "SCModalNavigationController.h"
#import "UIViewController+ModalContainer.h"
#import "Masonry.h"
#import "UIView+BTDAdditions.h"
#import "ModalContainerDefines.h"

#define SCModalContainerIndicatorBottomMargin 8.f

@interface SCModalContainerViewController() <UIGestureRecognizerDelegate,SCModalNavigationProtocol>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIView *indicatorContainerView;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL indicatorEnable;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) BOOL isDismissing;
 
@end

@implementation SCModalContainerViewController

static CGFloat const kSCModalContainerPanThreshold = 50.f;

- (instancetype)initWithRootViewController:(UIViewController *)rootVc
                               modalHeight:(CGFloat)modalHeight
                           indicatorEnable:(BOOL)indicatorEnable
                           indicatorHeight:(CGFloat)indicatorHeight
                            indicatorColor:(UIColor *)indicatorColor
{
    self = [super init];
    if (self) {
        self.nav = [[SCModalNavigationController alloc] initWithRootViewController:rootVc];
        ((SCModalNavigationController *)self.nav).navigationDelegate = self;
        self.indicatorEnable = indicatorEnable;
        self.indicatorColor = indicatorColor;
        self.indicatorHeight = indicatorHeight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    ///indicator
    [self.view addSubview:self.indicatorContainerView];
    [self.indicatorContainerView btd_roundCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                          radius:12.f
                                     roundedRect:CGRectMake(0, 0, SCREEN_WIDTH, 28.f)];
    
    self.indicator.hidden = !self.indicatorEnable;
    
    self.nav.navigationBar.tintColor = UIColor.whiteColor;
    [self.view addSubview:self.nav.view];
    [self addChildViewController:self.nav];
    [self.nav didMoveToParentViewController:self];
    
    [self.view addSubview:self.indicator];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentPan:)];
    self.panRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panRecognizer];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContainerViewController:)];
//    tapGestureRecognizer.delegate = self;
//    [self.view addGestureRecognizer:tapGestureRecognizer];
//    self.tapGestureRecognizer = tapGestureRecognizer;
    
    [self.indicatorContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(self.indicatorHeight);
    }];
    
    [self.indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.indicatorContainerView);
    }];
    
    [self.nav.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.indicatorContainerView.mas_bottom).offset(-1); // 减少1，避免闪现一条线
    }];
}

- (void)presentAnimation:(BOOL)animated completion:(nullable void (^)(void))completion {
    UIViewController *presentingVC = self.sc_presentingViewController;
    SCModalContainerViewController *presentedVC = self;
    presentedVC.pi_position = PIModalPositionMiddle;
    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
    if (animated) {
        
        [presentedVC presentTransition:0];
        [presentingVC.view setNeedsLayout];
        [presentingVC.view layoutIfNeeded];
        
        [presentedVC presentTransition:1];
        [UIView animateWithDuration:0.5f
                              delay:0
             usingSpringWithDamping:0.85
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{
            [presentingVC.view setNeedsLayout];
            [presentingVC.view layoutIfNeeded];
            [presentedVC.pi_backgroundView setAlpha:1];
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        [presentedVC presentTransition:1];
        if (completion) {
            completion();
        }
    }
}

- (void)dismissAnimation:(BOOL)animated completion:(nullable void (^)(void))completion {
    self.isDismissing = YES;
    UIViewController *presentingVC = self.sc_presentingViewController;
    SCModalContainerViewController *presentedVC = self;
    self.pi_position = PIModalPositionBottom;
    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
    if (animated) {
        [presentedVC presentTransition:0];
        [UIView animateWithDuration:0.25 animations:^{
            [presentingVC.view layoutIfNeeded];
            [presentedVC.pi_backgroundView setAlpha:0];
        } completion:^(BOOL finished) {
            [presentedVC.view removeFromSuperview];
            [presentedVC removeFromParentViewController];
            presentingVC.sc_presentedViewController = nil;
            [presentedVC.pi_backgroundView removeFromSuperview];
            if (completion) {
                completion();
            }
            
            PI_SAFE_BLOCK(presentingVC.sc_dismissCompletion);
        }];
    } else {
        [presentedVC.view removeFromSuperview];
        [presentedVC removeFromParentViewController];
        presentingVC.sc_presentedViewController = nil;
        if (completion) {
            completion();
        }
        [presentedVC.pi_backgroundView removeFromSuperview];
        PI_SAFE_BLOCK(presentingVC.sc_dismissCompletion);
    }
}

// 高度不变，只改变 bottom
- (void)presentTransition:(CGFloat)persent {
    UIViewController *presentingVC = self.sc_presentingViewController;
    SCModalContainerViewController *presentedVC = self;
    
    [presentedVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(presentingVC.view.mas_bottom).offset(presentedVC.view.btd_height * (1-persent));
    }];
}

// 高度会改变
- (void)stretchTransition:(CGFloat)distance {
    SCModalContainerViewController *presentedVC = self;
    
    CGFloat presentedVCHeight = MIN(presentedVC.sc_defaultHeight - distance, presentedVC.sc_maxHeight);
    [presentedVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(presentedVCHeight);
    }];
}

// 返回原高度
- (void)backToDefaultHeight {
    UIViewController *presentingVC = self.sc_presentingViewController;
    SCModalContainerViewController *presentedVC = self;
    
    [presentedVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(presentingVC.view.mas_bottom);
    }];
}

- (void)moveDown:(CGFloat)offset {
    UIViewController *presentingVC = self.sc_presentingViewController;
    SCModalContainerViewController *presentedVC = self;
    
    [presentedVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(presentingVC.view.mas_bottom).offset(offset);
    }];
}

- (void)presentPan:(UIPanGestureRecognizer *)pan {
    UIViewController *presentingVC = self.sc_presentingViewController;
    SCModalContainerViewController *presentedVC = self;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat panDistanceY = [pan translationInView:presentedVC.view].y;
            if (presentedVC.pi_heightChangeable) {
                BOOL scrolledDown = panDistanceY > 0;
                if (presentedVC.view.btd_height > presentedVC.sc_defaultHeight) {
                    if (scrolledDown && presentedVC.pi_position == PIModalPositionTop) {
                        [self stretchTransition:presentedVC.sc_defaultHeight - presentedVC.sc_maxHeight + panDistanceY];
                    } else {
                        [self stretchTransition:panDistanceY];
                    }
                } else {
                    if (presentedVC.pi_position == PIModalPositionTop) {
                        panDistanceY -= (presentedVC.sc_maxHeight - presentedVC.sc_defaultHeight);
                    }
                    [self stretchTransition:panDistanceY];
                }
            } else {
                CGFloat progress = panDistanceY / presentedVC.view.btd_height;
                progress = MIN(progress, 1.f);
                progress = MAX(progress, 0.f);
                [self presentTransition:(1 - progress)];
                
                CGFloat totalProgress = panDistanceY / presentedVC.sc_defaultHeight;
                totalProgress = MIN(totalProgress, 1.f);
                totalProgress = MAX(totalProgress, 0.f);
                [presentedVC.pi_backgroundView setAlpha:1 - totalProgress];
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            CGFloat panDistanceY = [pan translationInView:presentedVC.view].y;
            CGFloat panVelocityY = [pan velocityInView:presentedVC.view].y;
            if (presentedVC.pi_heightChangeable) {
                BOOL scrolledDown = panDistanceY > 0;
                if (fabs(presentedVC.view.btd_height - presentedVC.sc_maxHeight) < kSCModalContainerPanThreshold ||
                    (presentedVC.view.btd_height > presentedVC.sc_defaultHeight && !scrolledDown) ) {
                    
                    // 停止在顶部
                    // 1. 位于顶部附近，且移动距离小于 50
                    // 2. 位于中间，且向上移动
                    
                    presentedVC.pi_position = PIModalPositionTop;
                    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
                    [self stretchTransition:presentedVC.sc_defaultHeight - presentedVC.sc_maxHeight];
                    [UIView animateWithDuration:0.25 animations:^{
                        [presentingVC.view setNeedsLayout];
                        [presentingVC.view layoutIfNeeded];
                    }];
                } else if (presentedVC.view.btd_height > presentedVC.sc_defaultHeight && scrolledDown) {
                    
                    // 停止在中间
                    // 1. 从顶部向下拖动
                    
                    presentedVC.pi_position = PIModalPositionMiddle;
                    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
                    [self stretchTransition:0];
                    [UIView animateWithDuration:0.25 animations:^{
                        [presentingVC.view setNeedsLayout];
                        [presentingVC.view layoutIfNeeded];
                    }];
                } else if (presentedVC.view.btd_height < presentedVC.sc_defaultHeight && scrolledDown) {
                    
                    // 收起
                    // 1. 位于中间，且向下移动
                    self.pi_position = PIModalPositionBottom;
                    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
                    [self presentTransition:0];
                    [UIView animateWithDuration:0.25f animations:^{
                        [presentingVC.view setNeedsLayout];
                        [presentingVC.view layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        [presentedVC.view removeFromSuperview];
                        [presentedVC removeFromParentViewController];
                        presentingVC.sc_presentedViewController = nil;
                        [presentedVC.pi_backgroundView removeFromSuperview];
                        PI_SAFE_BLOCK(presentingVC.sc_dismissCompletion);
                    }];
                }
            } else {
                if (panVelocityY < 0) {
                    [self backToDefaultHeight];
                    [UIView animateWithDuration:0.25f animations:^{
                        [presentedVC.pi_backgroundView setAlpha:1];
                        [presentingVC.view setNeedsLayout];
                        [presentingVC.view layoutIfNeeded];
                    }];
                } else {
                    self.pi_position = PIModalPositionBottom;
                    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
                    [self updateChildViewControllerPostion:self.pi_position forPresenedVC:presentedVC];
                    [self presentTransition:0];
                    [UIView animateWithDuration:0.25f animations:^{
                        [presentingVC.view setNeedsLayout];
                        [presentingVC.view layoutIfNeeded];
                        [presentedVC.pi_backgroundView setAlpha:0];
                    } completion:^(BOOL finished) {
                        [presentedVC.view removeFromSuperview];
                        [presentedVC removeFromParentViewController];
                        presentingVC.sc_presentedViewController = nil;
                        [presentedVC.pi_backgroundView removeFromSuperview];
                        PI_SAFE_BLOCK(presentingVC.sc_dismissCompletion);
                    }];
                }

            }
        } break;;
        default:
            break;
    }
}

- (void)updateChildViewControllerPostion:(PIModalPosition)position forPresenedVC:(SCModalContainerViewController *)presentedVC {
    for (UIViewController *vc in presentedVC.nav.viewControllers) {
        vc.pi_position = position;
    }
}

- (void)didTapContainerViewController:(UITapGestureRecognizer *)tapGestureRecognizer {
    for (UIViewController *vc in self.nav.viewControllers) {
        [vc pi_didTapModalContainerViewController];
    }
}

#pragma mark -- SCModalNavigationProtocol

- (void)willPushToViewController:(UIViewController *)vc {
    [self willMoveToViewController:vc];
}

- (void)willPopToViewController:(UIViewController *)vc {
    [self willMoveToViewController:vc];
}

- (void)willSetViewControllersWithTopController:(UIViewController *)vc {
    [self willMoveToViewController:vc];
}

- (void)willMoveToViewController:(UIViewController *)vc {
    BOOL indicatorEnable = YES;
    if ([vc conformsToProtocol:@protocol(SCModalIndicator)]) {
        indicatorEnable = ((UIViewController<SCModalIndicator> *)vc).indicatorEnable;
    }
    self.panRecognizer.enabled = indicatorEnable;
    self.indicator.hidden = !indicatorEnable;
}

- (void)updateHeight:(CGFloat)height animation:(BOOL)animation completion:(nullable dispatch_block_t)completion {
    if (self.isDismissing) {
        return;
    }
    self.sc_defaultHeight = height;
    if (animation) {
        if (height < self.view.btd_height) {
            [self moveDown:self.view.btd_height - height];
            [UIView animateWithDuration:0.25 animations:^{
               [self.view.superview layoutIfNeeded];
           } completion:^(BOOL finished) {
               [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.height.mas_equalTo(height);
                   make.bottom.equalTo(self.sc_presentingViewController.view.mas_bottom);
               }];
               [self.view.superview layoutIfNeeded];
               PI_SAFE_BLOCK(completion);
           }];
        } else {
            [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
                make.bottom.equalTo(self.sc_presentingViewController.view.mas_bottom);
            }];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view.superview layoutIfNeeded];
            } completion:^(BOOL finished) {
                PI_SAFE_BLOCK(completion);
            }];
        }
    } else {
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        PI_SAFE_BLOCK(completion);
    }
}

#pragma mark -- 响应拦截

- (void)panIntercept:(UIPanGestureRecognizer *)pan {
    return ;
}

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panRecognizer) {
        if ([self.panRecognizer translationInView:self.nav.view].x > 0.5) return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        UIView *view = touch.view;
        NSArray <UIView *> *ignoreViews = [self ignoreTapGestureView];
        while (view && ignoreViews.count > 0) {
            if ([ignoreViews containsObject:view]) {
                return NO;
            } else {
                view = view.superview;
            }
        }
    } else if (gestureRecognizer == self.panRecognizer) {
        UIView *view = touch.view;
        NSArray <UIView *> *ignoreViews = [self ignorePanGestureView];
        while (view && ignoreViews.count > 0) {
            if ([ignoreViews containsObject:view]) {
                return NO;
            } else {
                view = view.superview;
            }
        }
    }
    
    return YES;
}

- (nullable NSArray <UIView *> *)ignoreTapGestureView {
    UIViewController *topVC = self.nav.topViewController;
    NSArray <UIView *>  *ignoreViews = [topVC pi_ignoreViewWhenTapModalContainerViewController];
    if (ignoreViews.count > 0) {
        return ignoreViews;
    }
    return nil;
}

- (nullable NSArray <UIView *> *)ignorePanGestureView {
    UIViewController *topVC = self.nav.topViewController;
    NSArray <UIView *>  *ignoreViews = [topVC pi_ignoreViewWhenPanModalContainerViewController];
    if (ignoreViews.count > 0) {
        return ignoreViews;
    }
    return nil;
}

#pragma mark -- Accessor

- (UIView *)indicatorContainerView {
    if (!_indicatorContainerView) {
        _indicatorContainerView = [[UIView alloc] init];
        _indicatorContainerView.backgroundColor = self.indicatorColor;
    }
    return _indicatorContainerView;
}

- (UIView *)indicator {
    if (!_indicator) {
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor = UIColor.clearColor;
    
        UIView *indicatorBar = [[UIView alloc] init];
        indicatorBar.layer.cornerRadius = 2.f;
        indicatorBar.backgroundColor = UIColor.lightGrayColor;
        [_indicator addSubview:indicatorBar];
        [indicatorBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_indicator);
            make.size.mas_equalTo(CGSizeMake(48.f, 4.f));
        }];
    }
    return _indicator;
}
@end
