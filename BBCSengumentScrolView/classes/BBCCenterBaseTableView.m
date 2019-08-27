
#import "BBCCenterBaseTableView.h"
#import "BBCSegumenCommen.h"

@implementation BBCCenterBaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    CGFloat segmentViewContentScrollViewHeight = self.tableFooterView.frame.size.height - self.categoryViewHeight ?: 41;
    BOOL isContainsPoint = CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, [[UIScreen mainScreen] bounds].size.width, segmentViewContentScrollViewHeight), currentPoint);
    return isContainsPoint ? YES : NO;
}
@end
