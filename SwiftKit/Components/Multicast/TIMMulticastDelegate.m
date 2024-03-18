//
//  TIMMulticastDelegate.m
//  TTIMSDK
//
//  Created by bob on 2018/4/13.
//  Copyright © 2018年 musical.ly. All rights reserved.
//

#import "TIMMulticastDelegate.h"


@interface TIMMulticastDelegateNode : NSObject
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) int priority;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) BOOL sync;
@end


@implementation TIMMulticastDelegateNode
@end


@interface TIMMulticastDelegateTarget : NSObject
@property (nonatomic, weak) TIMMulticastDelegate *target;
@end


@interface TIMMulticastDelegate ()
@property (nonatomic, strong) NSMutableDictionary *allNodes;
@property (nonatomic, strong) NSLock *allNodesLock;
@property (nonatomic, strong) TIMMulticastDelegateTarget *target;

@end


@implementation TIMMulticastDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allNodes = [@{} mutableCopy];
        self.allNodesLock = [[NSLock alloc] init];
        self.target = [TIMMulticastDelegateTarget new];
        self.target.target = self;
    }
    return self;
}


- (NSString *)addWeakDelegate:(id)delegate onQueue:(dispatch_queue_t)queue
{
    return [self addWeakDelegate:delegate onQueue:queue priority:100];
}

- (NSString *)addWeakDelegate:(id)delegate onQueue:(dispatch_queue_t)queue priority:(int)priority
{
    TIMMulticastDelegateNode *node = [TIMMulticastDelegateNode new];
    node.delegate = delegate;
    node.priority = priority;
    node.queue = queue ?: dispatch_get_main_queue();
    NSString *uuid = [NSUUID UUID].UUIDString;
    node.key = uuid;
    [self.allNodesLock lock];
    self.allNodes[uuid] = node;
    [self.allNodesLock unlock];
    return uuid;
}

- (NSString *)addSyncCallbackWeakDelegate:(id)delegate priority:(int)priority
{
    TIMMulticastDelegateNode *node = [TIMMulticastDelegateNode new];
    node.delegate = delegate;
    node.priority = priority;
    node.queue = dispatch_get_main_queue();
    NSString *uuid = [NSUUID UUID].UUIDString;
    node.key = uuid;
    node.sync = YES;
    [self.allNodesLock lock];
    self.allNodes[uuid] = node;
    [self.allNodesLock unlock];
    return uuid;
}

- (void)removeDelegateWithIdentifier:(NSString *)identifier
{
    if (!identifier) {
        return;
    }
    [self.allNodesLock lock];
    self.allNodes[identifier] = nil;
    [self.allNodesLock unlock];
}


- (id)mediator
{
    return self.target;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return YES;
}

@end


@implementation TIMMulticastDelegateTarget

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    // Prevent NSInvalidArgumentException
}

- (void)forwardInvocation:(NSInvocation *)origInvocation
{
    SEL selector = [origInvocation selector];
    NSDictionary *all;
    [self.target.allNodesLock lock];
    all = [self.target.allNodes copy];
    NSArray *allValue = [[all allValues] sortedArrayUsingComparator:^NSComparisonResult(TIMMulticastDelegateNode *obj1, TIMMulticastDelegateNode *obj2) {
        return [@(obj1.priority) compare:@(obj2.priority)];
    }];
    [self.target.allNodesLock unlock];

    NSMutableArray *toDiscard = [@[] mutableCopy];

    for (TIMMulticastDelegateNode *node in allValue) {
        __strong id delegate = node.delegate;
        if (delegate == nil) {
            [toDiscard addObject:node.key];
            continue;
        } else {
            if ([delegate respondsToSelector:selector]) {
                NSInvocation *dupInvocation = [self duplicateInvocation:origInvocation];
                if (node.sync) {
                    [dupInvocation invokeWithTarget:delegate];
                } else {
                    dispatch_async(node.queue, ^{
                        @autoreleasepool {
                            [dupInvocation invokeWithTarget:delegate];
                        }
                    });
                }
            }
        }
    }
    if (toDiscard.count > 0) {
        [self.target.allNodesLock lock];
        [self.target.allNodes removeObjectsForKeys:toDiscard];
        [self.target.allNodesLock unlock];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSDictionary *all;
    [self.target.allNodesLock lock];
    all = [self.target.allNodes copy];
    [self.target.allNodesLock unlock];

    NSArray *allKey = [all allKeys];
    NSMethodSignature *result;
    for (NSString *key in allKey) {
        TIMMulticastDelegateNode *node = all[key];
        __strong id delegate = node.delegate;
        if (delegate == nil) {
            continue;
        } else {
            result = [delegate methodSignatureForSelector:aSelector];
            if (result) {
                break;
            }
        }
    }
    if (result) {
        return result;
    }
    return [[self class] instanceMethodSignatureForSelector:@selector(doNothing)];
}

- (void)doNothing
{
}
- (NSInvocation *)duplicateInvocation:(NSInvocation *)origInvocation
{
    NSMethodSignature *methodSignature = [origInvocation methodSignature];

    NSInvocation *dupInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [dupInvocation setSelector:[origInvocation selector]];

    NSUInteger i, count = [methodSignature numberOfArguments];
    for (i = 2; i < count; i++) {
        const char *type = [methodSignature getArgumentTypeAtIndex:i];

        if (*type == *@encode(BOOL)) {
            BOOL value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(char) || *type == *@encode(unsigned char)) {
            char value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(short) || *type == *@encode(unsigned short)) {
            short value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(int) || *type == *@encode(unsigned int)) {
            int value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(long) || *type == *@encode(unsigned long)) {
            long value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(long long) || *type == *@encode(unsigned long long)) {
            long long value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(double)) {
            double value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(float)) {
            float value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == '@') {
            void *value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == '^') {
            void *block;
            [origInvocation getArgument:&block atIndex:i];
            [dupInvocation setArgument:&block atIndex:i];
        } else {
            NSString *selectorStr = NSStringFromSelector([origInvocation selector]);

            NSString *format = @"Argument %lu to method %@ - Type(%c) not supported";
            NSString *reason = [NSString stringWithFormat:format, (unsigned long)(i - 2), selectorStr, *type];

            [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        }
    }

    [dupInvocation retainArguments];

    return dupInvocation;
}

@end
