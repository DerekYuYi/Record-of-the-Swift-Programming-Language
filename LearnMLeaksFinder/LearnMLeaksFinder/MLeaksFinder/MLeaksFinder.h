//
//  MLeaksFinder.h
//  LearnMLeaksFinder
//
//  Created by yuyi on 2017/10/31.
//  Copyright © 2017年 Summer. All rights reserved.
//

#ifndef MLeaksFinder_h
#define MLeaksFinder_h

//#define MEMORY_LEAKS_FINDER_ENABLED

#ifdef MEMORY_LEAKS_FINDER_ENABLED
    #define _INYERNAL_MLF_ENABLED MEMORY_LEAKS_FINDER_ENABLED
#else
    #define _INYERNAL_MLF_ENABLED DEBUG
#endif

#define MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED 0

#ifdef MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED
#define _INTERNAL_MLF_RC_ENABLED MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED
#elif COCOAPODS
#define _INTERNAL_MLF_RC_ENABLED COCOAPODS
#endif

#endif /* MLeaksFinder_h */
