//
//  MLeakedObjectProxy.h
//  LearnMLeaksFinder
//
//  Created by yuyi on 2017/10/31.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLeakedObjectProxy : NSObject

+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs;
+ (void)addLeakedObject:(id)object;

@end
