
#import <UIKit/UIKit.h>

//⚠️：如果使用Swift改写BBCCenterBaseTableView这个类, 则需要主动去服从UIGestureRecognizerDelegate这个代理协议

@interface BBCCenterBaseTableView : UITableView<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat categoryViewHeight;

@end
