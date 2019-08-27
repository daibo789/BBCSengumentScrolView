

#ifndef BBCSegumenCommen_h
#define BBCSegumenCommen_h


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// device
#define BBC_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define BBC_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define BBC_ONE_PIXEL (1 / [UIScreen mainScreen].scale)

// static
static const CGFloat BBCCategoryViewDefaultHeight = 41;




#import "BBCCenterBaseTableView.h"
#import "BBCCategoryView.h"
#import "BBCPageViewController.h"
#import "BBCSegmentedPageViewController.h"

#endif /* BBCSegumenCommen_h */
