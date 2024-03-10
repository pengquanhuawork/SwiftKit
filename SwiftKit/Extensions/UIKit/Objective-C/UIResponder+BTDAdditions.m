//
//  UIResponder+BTDAdditions.m
//
//
//  Created by ByteDance on 2022/6/6.
//

#import "UIResponder+BTDAdditions.h"
#import "NSObject+BTDAdditions.h"
#import "NSDictionary+BTDAdditions.h"


@interface BTDResponderChainEvent : NSObject

@property (nonatomic, readonly, copy) BTDResponderEventName eventName;
@property (nonatomic, readonly, copy) BTDResponderEventBlock block;

- (instancetype)initWithEventName:(BTDResponderEventName)eventName block:(BTDResponderEventBlock)block;

@end

static NSString * const BTDResponderChainEventKey = @"BTDResponderChainEventKey";

@implementation BTDResponderChainEvent

- (instancetype)initWithEventName:(BTDResponderEventName)eventName block:(BTDResponderEventBlock)block {
    self = [super init];
    if (self) {
        _eventName = [eventName copy];
        _block = [block copy];
    }
    return self;
}

@end


@implementation UIResponder (BTDAdditions)


- (void)btd_postResponderEvent:(BTDResponderEventName)eventName userInfo:(NSDictionary *)userInfo {
    [self btd_postResponderEvent:eventName sourceResponder:self userInfo:userInfo];
}

- (void)btd_postResponderEvent:(BTDResponderEventName)eventName sourceResponder:(UIResponder *)sourceResponder userInfo:(NSDictionary *)userInfo {
    if (eventName.length == 0) {
        return;
    }
    
    if ([self isEqual:sourceResponder]) {
        [[self nextResponder] btd_postResponderEvent:eventName sourceResponder:sourceResponder userInfo:userInfo];
        return;
    }
    NSMutableDictionary *dict = [self btd_getAttachedObjectForKey:BTDResponderChainEventKey];
    BTDResponderChainEvent *event = [dict btd_objectForKey:eventName default:nil];
    if (!event || !event.block) {
        [[self nextResponder] btd_postResponderEvent:eventName sourceResponder:sourceResponder userInfo:userInfo];
    } else {
        BOOL proceed = NO;
        event.block(userInfo, &proceed);
        if (proceed) {
            [[self nextResponder] btd_postResponderEvent:eventName sourceResponder:sourceResponder userInfo:userInfo];
        }
    }
}

- (void)btd_observeResponderEvent:(BTDResponderEventName)eventName usingBlock:(BTDResponderEventBlock)block {
    if (eventName.length == 0 || !block) {
        return;
    }
    
    BTDResponderChainEvent *event = [[BTDResponderChainEvent alloc] initWithEventName:eventName block:block];
    NSMutableDictionary *eventDict = [self btd_getAttachedObjectForKey:BTDResponderChainEventKey];
    if (eventDict == nil) {
        eventDict = [NSMutableDictionary dictionary];
        [self btd_attachObject:eventDict forKey:BTDResponderChainEventKey];
    }
    eventDict[eventName] = event;
}

- (void)btd_unobserveResponderEvent:(BTDResponderEventName)eventName {
    NSMutableDictionary *eventDict = [self btd_getAttachedObjectForKey:BTDResponderChainEventKey];
    if (eventDict.count > 0) {
        [eventDict removeObjectForKey:eventName];
    }
}

@end
