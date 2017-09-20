//
//  XXJSObject.m
//  Ant
//
//  Created by yuyi on 2017/9/19.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "XXJSObject.h"

@implementation XXJSObject

- (void)testWithoutParameter {
    NSLog(@"JS has called iOS native method without parameter.");
}

- (NSString *)testWithOneParameter:(NSString *)message {
    NSLog(@"JS has called iOS native method with one parameter: %@", message);
    return NSStringFromSelector(_cmd);
}

- (NSString *)testWithOneParameter:(NSString *)messageOne secondParameter:(NSString *)messageTwo {
    NSLog(@"JS has called iOS native method with two parameters: %@, %@", messageOne, messageTwo);
    return NSStringFromSelector(_cmd);
}

- (void)postMessage:(NSString *)message {
    NSLog(@"JS has called iOS native method: %@", NSStringFromSelector(_cmd));
}

@end
