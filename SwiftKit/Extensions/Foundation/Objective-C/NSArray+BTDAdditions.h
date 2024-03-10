//
//  NSArray+BTDAdditions.h
//  ByteDanceKit
//
//  Created by wangdi on 2018/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray <__covariant ObjectType> (BTDAdditions)
/**
Convert a NSArray to a NSString. If an error happened, it would return nil.

 @return A NSString instance.
 */
- (nullable NSString *)btd_jsonStringEncoded;
- (nullable NSString *)btd_jsonStringEncoded:(NSError * _Nullable __autoreleasing * _Nullable)error;

/**
 Use NSJSONWritingPrettyPrinted to convert.

 @return A NSString instance.
 */
- (nullable NSString *)btd_jsonStringPrettyEncoded;

/**
 Convert a NSArray to a NSString. It is safer but lower in efficiency.

 @return A NSString instance.
 */
- (nullable NSString *)btd_safeJsonStringEncoded;
- (nullable NSString *)btd_safeJsonStringEncoded:(NSError * _Nullable __autoreleasing * _Nullable)error;

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

- (NSArray<ObjectType> *)btd_filterWithIndex:(BOOL (^)(ObjectType obj, NSUInteger))block;

- (NSArray<id> *)btd_map:(id _Nullable (^)(ObjectType obj))block;

- (NSArray<id> *)btd_compactMap:(id _Nullable (^)(ObjectType obj))block;

- (nullable id)btd_reduce:(nullable id)initialValue reducer:(_Nullable id(^)(_Nullable id preValue, ObjectType obj))block;

/**
 @param anObject If anObject is nil, this method will returns a copy of the receiving array.
 @return Returns a new array that is a copy of the receiving array with a given object added to the end.
 */
- (NSArray<ObjectType> *)btd_arrayByAddingObject:(nullable ObjectType)anObject;

/**
 @param otherArray If otherArray is nil, this method will returns a copy of the receiving array.
 @return Returns a new array that is a copy of the receiving array with the objects contained in another array added to the end
 */
- (NSArray<ObjectType> *)btd_arrayByAddingObjectsFromArray:(nullable NSArray<ObjectType> *)otherArray;

/**
 Returns a new array containing the receiving array’s elements that fall within the limits specified by a given range. If range's location isn’t within the array’s range of elements, it will return nil. In addition, If the range is greater than the array’s range of elements, it will return the subarray of the array after range's location.
 */

- (nullable NSArray<ObjectType> *)btd_subarrayWithRange:(NSRange)range;

@end

@interface NSMutableArray <ObjectType> (BTDAdditions)

#pragma mark - Safe Operation

- (void)btd_addObject:(ObjectType)anObject;

- (void)btd_insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

- (void)btd_insertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexes;

- (void)btd_replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

- (void)btd_removeObject:(ObjectType)anObject;

- (void)btd_removeObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
