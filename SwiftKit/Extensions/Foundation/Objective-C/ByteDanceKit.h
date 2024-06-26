//
//  ByteDanceKit.h
//  Pods
//
//  Created by willorfang on 16/9/1.
//
//

#ifndef ByteDanceKit_h
#define ByteDanceKit_h

#import <TargetConditionals.h>
#import "BTDMacros.h"
#import "BTDWeakProxy.h"
#import "BTDDispatch.h"
#import "NSArray+BTDAdditions.h"
#import "NSAttributedString+BTDAdditions.h"
#import "NSBundle+BTDAdditions.h"
#import "NSData+BTDAdditions.h"
#import "NSDate+BTDAdditions.h"
#import "NSDictionary+BTDAdditions.h"
#import "NSFileManager+BTDAdditions.h"
#import "NSNumber+BTDAdditions.h"
#import "NSObject+BTDAdditions.h"
#import "NSObject+BTDBlockObservation.h"
#import "NSOrderedSet+BTDAdditions.h"
#import "NSSet+BTDAdditions.h"
#import "NSString+BTDAdditions.h"
#import "NSTimer+BTDAdditions.h"
#import "NSURL+BTDAdditions.h"
#import "NSURLComponents+BTDAdditions.h"


#if TARGET_OS_IPHONE

#if __has_include("BTDResponder.h")
#import "BTDResponder.h"
#import "UIApplication+BTDAdditions.h"
#import "UIButton+BTDAdditions.h"
#import "UIColor+BTDAdditions.h"
#import "UIControl+BTDAdditions.h"
#import "UIDevice+BTDAdditions.h"
#import "UIGestureRecognizer+BTDAdditions.h"
#import "UIImage+BTDAdditions.h"
#import "UILabel+BTDAdditions.h"
#import "UIScrollView+BTDAdditions.h"
#import "UIView+BTDAdditions.h"
#import "UIWindow+BTDAdditions.h"
#import "UIResponder+BTDAdditions.h"
#endif

#if __has_include("UITextView+BTDAdditions.h")
#import "UITextView+BTDAdditions.h"
#endif

#if __has_include("UIDevice+BTDLegacy.h")
#import "UIDevice+BTDLegacy.h"
#import "UIView+BTDLegacy.h"
#endif

#endif

#endif /* ByteDanceKit_h */
