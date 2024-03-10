//
//  TIMMulticastDelegate.h
//  TTIMSDK
//
//  Created by bob on 2018/4/13.
//  Copyright © 2018年 musical.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TIMMulticastDelegate : NSObject
- (NSString *)addWeakDelegate:(id)delegate onQueue:(dispatch_queue_t)queue;
- (NSString *)addWeakDelegate:(id)delegate onQueue:(dispatch_queue_t)queue priority:(int)priority;
- (NSString *)addSyncCallbackWeakDelegate:(id)delegate priority:(int)priority;
- (void)removeDelegateWithIdentifier:(NSString *)identifier;
- (id)mediator;

@end


NS_ASSUME_NONNULL_END;
