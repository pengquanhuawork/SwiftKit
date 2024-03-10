//
//  NSURLComponents+BTDAdditions.m
//  Pods
//
//  Created by LiJiannian on 2022/8/10.
//

#import "NSURLComponents+BTDAdditions.h"

static BOOL isValidScheme(NSString *scheme) {
    if (scheme.length == 0) {
        return YES;
    }
    const char *schemeChars = [scheme UTF8String];
    BOOL firstChar = YES;
    while (schemeChars && *schemeChars != '\0') {
        char c = *schemeChars;
        if (isalnum(c) || c == '+' || c == '-' || c =='.') {
            if (firstChar) {
                if (!isalpha(c)) {
                    return NO;
                }
                firstChar = NO;
            }
            schemeChars++;
        } else {
            return NO;
        }
    }
    return YES;
}

static NSRange getSchemeRangeInURL(NSString *URLString) {
    if (URLString.length == 0) {
        return NSMakeRange(NSNotFound, 0);
    }
    const char *url = [URLString UTF8String];
    NSUInteger length = 0;
    while (url && *url != '\0') {
        char c = *url;
        if (c == '/' || c == '?' || c == '#') {
            return NSMakeRange(NSNotFound, 0);
        }
        if (c == ':') {
            break;
        }
        length +=1;
        url++;
    }
    
    if (length == 0) {
        return NSMakeRange(NSNotFound, 0);
    }
    return NSMakeRange(0, length);
}

@implementation NSURLComponents (BTDAdditions)

+ (instancetype)btd_componentsWithString:(NSString *)URLString {
    if (URLString.length == 0) {
        return nil;
    }
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:URLString];
    if (urlComponents) {
        return urlComponents;
    }
    
    NSRange schemeRange = getSchemeRangeInURL(URLString);
    
    /// If URLString don't have scheme or scheme is valid.
    if (schemeRange.location == NSNotFound ||
        isValidScheme([URLString substringWithRange:NSMakeRange(0, schemeRange.length)])) {
        return nil;
    }
    NSString *fixedURLString = [NSString stringWithFormat:@"/%@", URLString];
    urlComponents = [NSURLComponents componentsWithString:fixedURLString];
    if (!urlComponents) {
        return nil;
    }
    NSString *encodedPath = urlComponents.percentEncodedPath;
    urlComponents.percentEncodedPath = encodedPath.length > 1 ? [encodedPath substringFromIndex:1] : @"";
    return urlComponents;
}

+ (instancetype)btd_componentsWithURL:(NSURL *)URL {
    if (!URL) {
        return nil;
    }
    return [self btd_componentsWithString:URL.absoluteString];
}

@end
