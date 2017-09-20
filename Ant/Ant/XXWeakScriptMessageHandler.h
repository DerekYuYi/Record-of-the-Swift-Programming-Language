//
//  XXWeakScriptMessageHandler.h
//  Ant
//
//  Created by YuYi on 2017/9/20.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>


@interface XXWeakScriptMessageHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
