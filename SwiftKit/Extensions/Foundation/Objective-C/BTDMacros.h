//
//  BTDMacros.h
//  Pods
//
//  Created by willorfang on 16/8/5.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <pthread.h>

#ifndef __BTDMacros_H__
#define __BTDMacros_H__

FOUNDATION_EXPORT CGFloat BTD_CLAMP(CGFloat x, CGFloat low, CGFloat high);

#ifndef BTD_SWAP
#define BTD_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

#ifndef BTDAssertMainThread
#define BTDAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#endif

#ifndef btd_keywordify
#if DEBUG
    #define btd_keywordify autoreleasepool {}
#else
    #define btd_keywordify try {} @catch (...) {}
#endif
#endif

#define btd_metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        btd_metamacro_concat(btd_metamacro_foreach_cxt, btd_metamacro_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)

#define btd_metamacro_foreach(MACRO, SEP, ...) \
        btd_metamacro_foreach_cxt(btd_metamacro_foreach_iter, SEP, MACRO, __VA_ARGS__)

#define btd_metamacro_foreach_iter(INDEX, MACRO, ARG) MACRO(INDEX, ARG)

#define btd_metamacro_foreach_cxt0(MACRO, SEP, CONTEXT)
#define btd_metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)

#define btd_metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    btd_metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)

#define btd_metamacro_foreach_cxt3(MACRO, SEP, CONTEXT, _0, _1, _2) \
    btd_metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    SEP \
    MACRO(2, CONTEXT, _2)

#define btd_metamacro_foreach_cxt4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
    btd_metamacro_foreach_cxt3(MACRO, SEP, CONTEXT, _0, _1, _2) \
    SEP \
    MACRO(3, CONTEXT, _3)

#define btd_metamacro_foreach_cxt5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
    btd_metamacro_foreach_cxt4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
    SEP \
    MACRO(4, CONTEXT, _4)

#define btd_metamacro_foreach_cxt6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
    btd_metamacro_foreach_cxt5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
    SEP \
    MACRO(5, CONTEXT, _5)

#define btd_metamacro_foreach_cxt7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
    btd_metamacro_foreach_cxt6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
    SEP \
    MACRO(6, CONTEXT, _6)

#define btd_metamacro_foreach_cxt8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
    btd_metamacro_foreach_cxt7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
    SEP \
    MACRO(7, CONTEXT, _7)

#define btd_metamacro_foreach_cxt9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
    btd_metamacro_foreach_cxt8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
    SEP \
    MACRO(8, CONTEXT, _8)

#define btd_metamacro_foreach_cxt10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
    btd_metamacro_foreach_cxt9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
    SEP \
    MACRO(9, CONTEXT, _9)

#define btd_metamacro_foreach_cxt11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
    btd_metamacro_foreach_cxt10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
    SEP \
    MACRO(10, CONTEXT, _10)

#define btd_metamacro_foreach_cxt12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
    btd_metamacro_foreach_cxt11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
    SEP \
    MACRO(11, CONTEXT, _11)

#define btd_metamacro_foreach_cxt13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
    btd_metamacro_foreach_cxt12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
    SEP \
    MACRO(12, CONTEXT, _12)

#define btd_metamacro_foreach_cxt14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
    btd_metamacro_foreach_cxt13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
    SEP \
    MACRO(13, CONTEXT, _13)

#define btd_metamacro_foreach_cxt15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
    btd_metamacro_foreach_cxt14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
    SEP \
    MACRO(14, CONTEXT, _14)

#define btd_metamacro_foreach_cxt16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
    btd_metamacro_foreach_cxt15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
    SEP \
    MACRO(15, CONTEXT, _15)

#define btd_metamacro_foreach_cxt17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
    btd_metamacro_foreach_cxt16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
    SEP \
    MACRO(16, CONTEXT, _16)

#define btd_metamacro_foreach_cxt18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
    btd_metamacro_foreach_cxt17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
    SEP \
    MACRO(17, CONTEXT, _17)

#define btd_metamacro_foreach_cxt19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
    btd_metamacro_foreach_cxt18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
    SEP \
    MACRO(18, CONTEXT, _18)

#define btd_metamacro_foreach_cxt20(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
    btd_metamacro_foreach_cxt19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
    SEP \
    MACRO(19, CONTEXT, _19)

#define btd_metamacro_concat(A, B) \
        btd_metamacro_concat_(A, B)

#define btd_metamacro_concat_(A, B) A ## B

#define btd_metamacro_argcount(...) \
        btd_metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

#define btd_metamacro_at(N, ...) \
        btd_metamacro_concat(btd_metamacro_at, N)(__VA_ARGS__)

#define btd_metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) btd_metamacro_head(__VA_ARGS__)

#define btd_metamacro_head(...) \
        btd_metamacro_head_(__VA_ARGS__, 0)

#define btd_metamacro_head_(FIRST, ...) FIRST

#define btd_weakify_(INDEX, CONTEXT, VAR) \
    CONTEXT __typeof__(VAR) btd_metamacro_concat(VAR, _weak_) = (VAR);

#define btd_strongify_(INDEX, VAR) \
    __strong __typeof__(VAR) VAR = btd_metamacro_concat(VAR, _weak_);

#define btd_block_(INDEX, CONTEXT, VAR) \
    __block __typeof__(VAR) btd_metamacro_concat(VAR, _block_) = (VAR);

#define btd_typeof_(INDEX, VAR) \
    __typeof__(VAR) VAR = btd_metamacro_concat(VAR, _block_);

#ifndef weakify
    #if __has_feature(objc_arc)
        #define weakify(...) btd_keywordify btd_metamacro_foreach_cxt(btd_weakify_,, __weak, __VA_ARGS__)
    #else
        #define weakify(...) btd_keywordify btd_metamacro_foreach_cxt(btd_block_,, __block, __VA_ARGS__)
    #endif
#endif

#ifndef strongify
    #if __has_feature(objc_arc)
        #define strongify(...) btd_keywordify btd_metamacro_foreach(btd_strongify_,, __VA_ARGS__)
    #else
        #define strongify(...) btd_keywordify btd_metamacro_foreach(btd_typeof_,, __VA_ARGS__)
    #endif
#endif


static inline bool btd_dispatch_is_main_queue(void) {
    return dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue());
}

static inline bool btd_dispatch_is_main_thread(void) {
    return [NSThread isMainThread];
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
FOUNDATION_EXPORT void btd_dispatch_async_on_main_queue(void (^block)(void));
FOUNDATION_EXPORT void btd_dispatch_sync_on_main_queue(void (^block)(void));

#ifndef onExit
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
static void blockCleanUp(__strong void(^*block)(void))
{
    (*block)();
}
#pragma clang diagnostic pop

#define onExit \
        btd_keywordify __strong void(^__on_exit_block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^

#endif

#ifndef BTD_MUTEX_LOCK
#define BTD_MUTEX_LOCK(lock) \
    pthread_mutex_lock(&(lock)); \
    @onExit{ \
        pthread_mutex_unlock(&(lock)); \
    };
#endif

#ifndef BTD_SEMAPHORE_LOCK
#define BTD_SEMAPHORE_LOCK(lock) \
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER); \
    @onExit{ \
        dispatch_semaphore_signal(lock); \
    };
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
static NSString *currentTimeString()
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
#pragma clang diagnostic pop

#ifndef BTDLog
#if DEBUG
    #define BTDLog(s, ...) \
    fprintf(stderr, "%s <%s:%d> %s\n", [currentTimeString() UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String])
#else
    #define BTDLog(s, ...)
#endif
#endif

#ifndef BTD_isEmptyString
FOUNDATION_EXPORT BOOL BTD_isEmptyString(id param);
#endif

#ifndef BTD_isEmptyArray
FOUNDATION_EXPORT BOOL BTD_isEmptyArray(id param);
#endif

#ifndef BTD_isEmptyDictionary
FOUNDATION_EXPORT BOOL BTD_isEmptyDictionary(id param);
#endif

/**
 XXClass *xxObj = [object isKindOfClass: [XXClass class]] ? (XXClass *)object : nil;
 [xxObj doSomething];
 =>
 [BTD_DYNAMIC_CAST(XXClass, object) doSomething];
 */
#ifndef BTD_DYNAMIC_CAST
#define BTD_DYNAMIC_CAST(TYPE, OBJECT)  ({ id __obj__ = OBJECT;[__obj__ isKindOfClass:[TYPE class]] ? (TYPE *) __obj__: nil; })
#endif

#ifndef BTD_BLOCK_INVOKE
#define BTD_BLOCK_INVOKE(block, ...) ({block ? block(__VA_ARGS__) : 0;})
#endif

#endif
