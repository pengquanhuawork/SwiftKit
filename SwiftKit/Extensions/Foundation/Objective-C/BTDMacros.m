//
//  BTD_isEmptyFunctions.m
//  ByteDanceKit
//
//  Created by bytedance on 2020/6/22.
//

#import <Foundation/Foundation.h>
#import "BTDMacros.h"

BOOL BTD_isEmptyString(id param){
    if(!param){
        return YES;
    }
    if ([param isKindOfClass:[NSString class]]){
        NSString *str = param;
        return (str.length == 0);
    }
    NSCAssert(NO, @"BTD_isEmptyString: param %@ is not NSString", param);
    return YES;
}

BOOL BTD_isEmptyArray(id param){
    if(!param){
        return YES;
    }
    if ([param isKindOfClass:[NSArray class]]){
        NSArray *array = param;
        return (array.count == 0);
    }
    NSCAssert(NO, @"BTD_isEmptyArray: param %@ is not NSArray", param);
    return YES;
}

BOOL BTD_isEmptyDictionary(id param){
    if(!param){
        return YES;
    }
    if ([param isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = param;
        return (dict.count == 0);
    }
    NSCAssert(NO, @"BTD_isEmptyDictionary: param %@ is not NSDictionary", param);
    return YES;
}

CGFloat BTD_CLAMP(CGFloat x, CGFloat low, CGFloat high) {
    return (x > high) ? high : ((x < low) ? low : x);
}

void btd_dispatch_async_on_main_queue(void (^block)(void))
{
    if (btd_dispatch_is_main_queue()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void btd_dispatch_sync_on_main_queue(void (^block)(void))
{
    if (btd_dispatch_is_main_queue()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
