//
//  BBCPopGestureCompatibleScrollView.m
//  BBCPersonalCenterExtend
//
//  Created by Arch on 2019/5/16.
//

#import "BBCPopGestureCompatibleScrollView.h"

@implementation BBCPopGestureCompatibleScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWitBBCestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
