//
//  XXWeakScriptMessageHandler.m
//  Ant
//
//  Created by YuYi on 2017/9/20.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "XXWeakScriptMessageHandler.h"

@implementation XXWeakScriptMessageHandler


- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

/*
 @abstract Invoked when a script message is received from a webpage.
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
