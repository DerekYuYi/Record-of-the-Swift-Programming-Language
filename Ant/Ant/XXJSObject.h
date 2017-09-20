//
//  XXJSObject.h
//  Ant
//
//  Created by yuyi on 2017/9/19.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

// Note: Offering four methods which must inherit JSExport protocol for JS to calls. 
@protocol JSObjectDelegate <JSExport>

- (void)testWithoutParameter;
- (NSString *)testWithOneParameter:(NSString *)message;
- (NSString *)testWithOneParameter:(NSString *)messageOne secondParameter:(NSString *)messageTwo;
- (void)postMessage:(NSString *)message;
@end



@interface XXJSObject : NSObject<JSObjectDelegate>

@end
