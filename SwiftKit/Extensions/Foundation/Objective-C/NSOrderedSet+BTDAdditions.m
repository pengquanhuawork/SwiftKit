//
//  NSOrderedSet+BTDAdditions.m
//  ByteDanceKit
//
//  Created by bytedance on 2021/4/11.
//

#import "NSOrderedSet+BTDAdditions.h"

@implementation NSOrderedSet (BTDAdditions)

#pragma mark - Safe Access

- (id)btd_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (id)btd_objectAtIndex:(NSUInteger)index class:(Class)cls {
    id obj = [self btd_objectAtIndex:index];
    if ([obj isKindOfClass:cls]) {
        return obj;
    }
    return nil;
}

#pragma mark - Functional

- (void)btd_forEach:(void (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (BOOL)btd_contains:(BOOL (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    __block BOOL result = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL)btd_all:(BOOL (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    __block BOOL result = YES;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (NSUInteger)btd_firstIndex:(BOOL (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    __block NSUInteger result = NSNotFound;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            result = idx;
            *stop = YES;
        }
    }];
    return result;
}

- (id)btd_find:(BOOL (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    __block id result = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}

- (NSOrderedSet *)btd_filter:(BOOL (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSetWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }];
    return [result copy];
}

- (NSOrderedSet<id> *)btd_map:(id  _Nonnull (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSetWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id mapped = block(obj) ? : [NSNull null];
        [result addObject:mapped];
    }];
    return [result copy];
}

- (NSOrderedSet<id> *)btd_compactMap:(id  _Nullable (^)(id _Nonnull))block {
    NSParameterAssert(block != nil);
    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSetWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id mapped = block(obj);
        if (mapped) {
            [result addObject:mapped];
        }
    }];
    return [result copy];
}

- (id)btd_reduce:(id)initialValue reducer:(id  _Nullable (^)(id _Nullable, id _Nonnull))block {
    NSParameterAssert(block != nil);
    __block id result = initialValue;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result = block(result, obj);
    }];
    return result;
}


@end

#pragma mark - Safe Operation

@implementation NSMutableOrderedSet (BTDAdditions)

- (void)btd_addObject:(id)anObject {
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)btd_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject != nil && index <= self.count) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)btd_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (objects != nil && indexes != nil &&
        objects.count == indexes.count &&
        [indexes indexGreaterThanOrEqualToIndex:(self.count + objects.count)] == NSNotFound) {
        [self insertObjects:objects atIndexes:indexes];
    }
}

- (void)btd_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject != nil && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)btd_removeObject:(id)anObject {
    if (anObject != nil) {
        [self removeObject:anObject];
    }
}

- (void)btd_removeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

@end
