

#import <UIKit/UIKit.h>
#import "BBCCategoryView.h"
#import "BBCPageViewController.h"

@protocol BBCSegmentedPageViewControllerDelegate <NSObject>
@optional
- (void)segmentedPageViewControllerWillBeginDragging;
- (void)segmentedPageViewControllerDidEndDragging;
- (void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index;
@end

@interface BBCSegmentedPageViewController : UIViewController
@property (nonatomic, strong, readonly) BBCCategoryView *categoryView;
@property (nonatomic, copy) NSArray<BBCPageViewController *> *pageViewControllers;
@property (nonatomic, strong, readonly) BBCPageViewController *currentPageViewController;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, weak) id<BBCSegmentedPageViewControllerDelegate> delegate;
@end

