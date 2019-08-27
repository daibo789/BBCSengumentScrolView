//
//  BBCPageViewController.h
//  BBCPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBCPageViewControllerDelegate <NSObject>
- (void)pageViewControllerLeaveTop;
@end

@interface BBCPageViewController : UIViewController
@property (nonatomic, weak) id<BBCPageViewControllerDelegate> delegate;
@property (nonatomic) NSInteger pageIndex;

- (void)makePageViewControllerScroll:(BOOL)canScroll;
- (void)makePageViewControllerScrollToTop;
@end
