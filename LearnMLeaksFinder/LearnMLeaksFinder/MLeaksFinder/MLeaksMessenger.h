//
//  MLeaksMessenger.h
//  LearnMLeaksFinder
//
//  Created by yuyi on 2017/10/31.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLeaksMessenger : NSObject

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
              delegate:(id<UIAlertViewDelegate>)delegate
 additionalButtonTitle:(NSString *)additionalButtonTitle;

@end
