//
//  UIApplication+BTDAdditions.h
//  ByteDanceKit
//
//  Created by wangdi on 2018/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (BTDAdditions)

/**
 @return Return the total diskspace of the device.
 */
+ (nonnull NSNumber *)btd_totalDiskSpace;

/**
 @return Return the free diskspace of the device.
 */
+ (nonnull NSNumber *)btd_freeDiskSpace;

/**
 @return Return the size of the memory used by the current thread.返回当前线程内存的使用大小
 */
+ (int64_t)btd_memoryUsage;

/**

 @return Return the rate of the CPU used by the current thread. Return -1 if an error happened.
 */
+ (float)btd_cpuUsage;
/**
 Return the App's Informations.
 */
+ (nonnull NSString *)btd_appDisplayName;

/**
 Return ipad or iphone .
 */
+ (nonnull NSString *)btd_platformName __attribute((deprecated("A non-standard method. Use +[UIDevice btd_platformName] instead!")));
+ (nonnull NSString *)btd_versionName;
+ (nonnull NSString*)btd_bundleVersion;

// Return the value of the key "AppName" in NSBundle.
+ (nonnull NSString *)btd_appName __attribute((deprecated("A non-standard method. Use +btd_appDisplayName instead!")));

+ (nonnull NSString *)btd_appID;
+ (nonnull NSString *)btd_bundleIdentifier;
+ (nonnull NSString *)btd_currentChannel;


/**
 获取当前应用的广义mainWindow

 @return uiwindow
 */
+ (nullable UIWindow *)btd_mainWindow NS_EXTENSION_UNAVAILABLE("Not available in Extension Target");

@end

NS_ASSUME_NONNULL_END
