//
//  UIResponder+BTDAdditions.h
//
//
//  Created by ByteDance on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *BTDResponderEventName NS_TYPED_EXTENSIBLE_ENUM;
typedef void(^BTDResponderEventBlock)(NSDictionary * _Nullable userInfo, BOOL *proceed);

@interface UIResponder (BTDAdditions)

/**
 Post an event to subsequent responder in responder chain.
 
 Reference:
    https://bytedance.feishu.cn/docx/doxcnZUXh02BIw7K6xLqgLUcuCc
 */
- (void)btd_postResponderEvent:(BTDResponderEventName)eventName userInfo:(NSDictionary * _Nullable)userInfo;

/**
 Adds an object to receive previous responder event, and execute the provided block.
 @param eventName The name of the previous responder event.
 @param block The block to response to previous responder event.
    userInfo
     A user info dictionary with optional information about the source UIResponder.
    proceed
     A reference to a Boolean value. Setting the value to YES within the block continue deliver the event to subsequent responder.
 */
- (void)btd_observeResponderEvent:(_Nonnull BTDResponderEventName)eventName usingBlock:(BTDResponderEventBlock)block;

- (void)btd_unobserveResponderEvent:(_Nonnull BTDResponderEventName)eventName;


@end

NS_ASSUME_NONNULL_END
