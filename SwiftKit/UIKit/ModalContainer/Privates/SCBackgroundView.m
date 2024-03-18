//
//  SCBackgroundView.m
//  MarkCamera
//
//  Created by quanhua peng on 2024/3/10.
//

#import "SCBackgroundView.h"
#import "UIViewController+ModalContainer.h"

@implementation SCBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBgViewClick:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}

- (void)onBgViewClick:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.presentedViewController.view endEditing:YES];
    [self.presentedViewController sc_dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
