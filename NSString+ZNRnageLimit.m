//
//  NSString+ZNRnageLimit.m
//  zn_flu_utl_common
//
//  Created by Villain on 2019/9/26.
//

#import "NSString+ZNRnageLimit.h"
#import <objc/runtime.h>

@implementation NSString (ZNRnageLimit)
+ (void)load {
    Method originalMethod = class_getInstanceMethod(objc_getClass("__NSCFString"), @selector(substringWithRange:));
    Method userMethod = class_getInstanceMethod(objc_getClass("__NSCFString"), @selector(ms_substringWithRange:));
    method_exchangeImplementations(originalMethod, userMethod);
    // NSString
//    exchangeMethod(@"__NSCFString", @selector(substringToIndex:), @selector(ms_substringToIndex:));
//    exchangeMethod(@"__NSCFString", @selector(substringFromIndex:), @selector(ms_substringFromIndex:));
   // exchangeMethod(@"__NSCFString", @selector(substringWithRange:), @selector(ms_substringWithRange:));
    // NSMutableString
//    exchangeMethod(@"__NSCFString", @selector(replaceCharactersInRange:withString:), @selector(ms_replaceCharactersInRange:withString:));
//    exchangeMethod(@"__NSCFString", @selector(insertString:atIndex:), @selector(ms_insertString:atIndex:));
//    exchangeMethod(@"__NSCFString", @selector(deleteCharactersInRange:), @selector(ms_deleteCharactersInRange:));
}

#pragma mark - hook NSString 方法
- (NSString *)ms_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
#if DEBUG
        NSAssert(NO, @"字符串长度越界了");
#endif
        return nil;
    }
    return [self ms_substringToIndex:to];
}

- (NSString *)ms_substringFromIndex:(NSUInteger)from {
    if (from > self.length) {
#if DEBUG
        NSAssert(NO, @"字符串长度越界了");
#endif
        return nil;
    }
    return [self ms_substringFromIndex:from];
}

- (NSString *)ms_substringWithRange:(NSRange)range {
    NSInteger location = [NSString stringWithFormat:@"%ld", range.location].integerValue;
    
    NSInteger nowLength = [[NSString stringWithFormat:@"%ld",range.length] integerValue];

    //如果开始位置为负数，则截取全部
    if (location < 0) {
        range = NSMakeRange(0, range.length);
    }
  
    //如果长度为负数的时候，在则截取全部
    if (nowLength < 0) {
        range = NSMakeRange(0, self.length);
    }
    
    return [self ms_substringWithRange:range];
}

#pragma mark - hook NSMutableString 方法
- (void)ms_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    NSInteger location = [NSString stringWithFormat:@"%ld", range.location].integerValue;
    if (location < 0 || (range.location + range.length) > self.length) {
#if DEBUG
        NSAssert(NO, @"字符串长度越界了");
#endif
        return;
    }
    [self ms_replaceCharactersInRange:range withString:aString];
}

- (void)ms_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (loc > self.length) {
#if DEBUG
        NSAssert(NO, @"字符串长度越界了");
#endif
        return;
    }
    [self ms_insertString:aString atIndex:loc];
}

- (void)ms_deleteCharactersInRange:(NSRange)range {
    NSInteger location = [NSString stringWithFormat:@"%ld", range.location].integerValue;
    if (location < 0 || (range.location + range.length) > self.length) {
#if DEBUG
        NSAssert(NO, @"字符串长度越界了");
#endif
        return;
    }
    [self ms_deleteCharactersInRange:range];
}
@end
