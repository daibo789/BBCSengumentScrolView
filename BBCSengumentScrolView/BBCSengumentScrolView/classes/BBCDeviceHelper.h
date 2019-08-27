//
//  BBCDeviceHelper.h

//
//  Created by Arch on 2018/9/17.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BBCDeviceHelper : NSObject

+ (BOOL)isExistFringe;
+ (BOOL)isExistJaw;
+ (CGFloat)safeAreaInsetsTop;
+ (CGFloat)safeAreaInsetsBottom;

@end

NS_ASSUME_NONNULL_END
