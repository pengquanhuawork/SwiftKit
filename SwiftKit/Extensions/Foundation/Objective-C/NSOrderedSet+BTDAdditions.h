//
//  NSOrderedSet+BTDAdditions.h
//  ByteDanceKit
//
//  Created by bytedance on 2021/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOrderedSet <ObjectType> (BTDAdditions)

#pragma mark - Safe Access

- (nullable ObjectType)btd_objectAtIndex:(NSUInteger)index;

- (nullable ObjectType)btd_objectAtIndex:(NSUInteger)index class:(Class)cls;

#pragma mark - Functional

- (void)btd_forEach:(void(^)(ObjectType obj))block;

- (BOOL)btd_contains:(BOOL(^)(ObjectType obj))block;

- (BOOL)btd_all:(BOOL(^)(ObjectType obj))block;

- (NSUInteger)btd_firstIndex:(BOOL(^)(ObjectType obj))block;

- (nullable ObjectType)btd_find:(BOOL(^)(ObjectType obj))block;

- (NSArray<ObjectType> *)btd_filter:(BOOL(^)(ObjectType obj))block;

- (NSArray<id> *)btd_map:(id _Nullable (^)(ObjectType obj))block;

- (NSArray<id> *)btd_compactMap:(id _Nullable (^)(ObjectType obj))block;

- (nullable id)btd_reduce:(nullable id)initialValue reducer:(_Nullable id(^)(_Nullable id preValue, ObjectType obj))block;

@end

@interface NSMutableOrderedSet <ObjectType> (BTDAdditions)

#pragma mark - Safe Operation

- (void)btd_addObject:(ObjectType _Nullable )anObject;

- (void)btd_insertObject:(ObjectType _Nullable )anObject atIndex:(NSUInteger)index;

- (void)btd_insertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexes;

- (void)btd_replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType _Nullable )anObject;

- (void)btd_removeObject:(ObjectType _Nullable )anObject;

- (void)btd_removeObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
