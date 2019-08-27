//
//  ViewController.m
//  BBCSengumentScrolView
//
//  Created by botu on 2019/8/27.
//  Copyright © 2019 dbb. All rights reserved.
//

// device
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATION_BAR_HEIGHT (IS_IPAD ? 50 : 44)
#define IS_EXIST_FRINGE [BBCDeviceHelper isExistFringe]
#define IS_EXIST_JAW [BBCDeviceHelper isExistJaw]
#define SAFE_AREA_INSERTS_BOTTOM [BBCDeviceHelper safeAreaInsetsBottom]
#define SAFE_AREA_INSERTS_TOP [BBCDeviceHelper safeAreaInsetsTop]
#define TOP_BAR_HEIGHT (SAFE_AREA_INSERTS_TOP + NAVIGATION_BAR_HEIGHT)
#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
// color
#define kRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#import "ViewController.h"
#import "BBCCenterBaseTableView.h"
#import "BBCSengumentScrolView-Swift.h"
#import "BBCSegmentedPageViewController.h"
#import "BBCPageViewController.h"
#import <Masonry/Masonry.h>
#import "BBCChildViewController.h"
#import "BBCDeviceHelper.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, BBCSegmentedPageViewControllerDelegate, BBCPageViewControllerDelegate>
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) BBCCenterBaseTableView *tableView;
@property (nonatomic, strong) BPMenuCollectionView *headerImageView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) BBCSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic) BOOL cannotScroll;
@property (nonatomic, assign) BOOL isEnlarge;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end


CGFloat const HeaderImageViewHeight = 240+200;
@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self setupSubViews];
}

#pragma mark - Private Methods
- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerImageView];
    [self addChildViewController:self.segmentedPageViewController];
    [self.footerView addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
}




#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.segmentedPageViewController.currentPageViewController makePageViewControllerScrollToTop];
    return YES;
}

/**
 * 处理联动
 * 因为要实现下拉头部放大的问题，tableView设置了contentInset，所以试图刚加载的时候会调用一遍这个方法，所以要做一些特殊处理，
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //第一部分：处理导航栏
   
    
    //第二部分：处理手势冲突
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    CGFloat criticalPointOffsetY = [self.tableView rectForSection:0].origin.y - TOP_BAR_HEIGHT;
    criticalPointOffsetY = criticalPointOffsetY+200;
    
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (contentOffsetY >= criticalPointOffsetY) {
        /*
         * 到达临界点：
         * 1.未吸顶状态 -> 吸顶状态
         * 2.维持吸顶状态(pageViewController.scrollView.contentOffsetY > 0)
         */
        //“进入吸顶状态”以及“维持吸顶状态”
        self.cannotScroll = YES;
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [self.segmentedPageViewController.currentPageViewController makePageViewControllerScroll:YES];
    } else {
        /*
         * 未达到临界点：
         * 1.吸顶状态 -> 不吸顶状态
         * 2.维持吸顶状态(pageViewController.scrollView.contentOffsetY > 0)
         */
        if (self.cannotScroll) {
            //“维持吸顶状态”
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        } else {
            /* 吸顶状态 -> 不吸顶状态
             * pageViewController.scrollView.contentOffsetY <= 0时，会通过代理BBCPageViewControllerDelegate来改变当前控制器self.cannotScroll的值；
             */
        }
    }
    
    //第三部分：
    /**
     * 处理头部自定义背景视图 (如: 下拉放大)
     * 图片会被拉伸多出状态栏的高度
     */
    if (contentOffsetY <= -HeaderImageViewHeight) {
        scrollView.bounces = NO;
    } else {
        scrollView.bounces = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = UIColor.redColor;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

//解决tableView在group类型下tableView头部和底部多余空白的问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - BBCSegmentedPageViewControllerDelegate
- (void)segmentedPageViewControllerWillBeginDragging {
    self.tableView.scrollEnabled = NO;
}

- (void)segmentedPageViewControllerDidEndDragging {
    self.tableView.scrollEnabled = YES;
}

#pragma mark - BBCPageViewControllerDelegate
- (void)pageViewControllerLeaveTop {
    self.cannotScroll = NO;
}

#pragma mark - Lazy
- (UIButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _messageButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_messageButton addTarget:self action:@selector(viewMessage) forControlEvents:UIControlEventTouchUpInside];
        [_messageButton sizeToFit];
    }
    return _messageButton;
}

- (BPMenuCollectionView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[BPMenuCollectionView alloc] initWithFrame:CGRectMake(0, -HeaderImageViewHeight, SCREEN_WIDTH, HeaderImageViewHeight)];
    }
    return _headerImageView;
}

- (UIView *)footerView {
    if (!_footerView) {
        //如果当前控制器存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight和SAFE_AREA_INSERTS_BOTTOM
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT)];
    }
    return _footerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[BBCCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
        _tableView.contentInset = UIEdgeInsetsMake(HeaderImageViewHeight, 0, 0, 0);
        [_tableView setContentOffset:CGPointMake(0, -HeaderImageViewHeight)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (BBCSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        NSMutableArray *controllers = [NSMutableArray array];
        NSArray *titles = @[@"ios", @"json", @"xml", @"java",@"主2", @"1", @"1", @"1"];
        for (int i = 0; i < titles.count; i++) {
            BBCPageViewController *controller;
            if (i % 3 == 0) {
                controller = [[BBCChildViewController alloc] init];
            } else if (i % 2 == 0) {
                controller = [[BBCChildViewController alloc] init];
            } else {
                controller = [[BBCChildViewController alloc] init];
            }
            controller.delegate = self;
            [controllers addObject:controller];
        }
        _segmentedPageViewController = [[BBCSegmentedPageViewController alloc] init];
        _segmentedPageViewController.pageViewControllers = controllers;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.alignment = BBCCategoryViewAlignmentLeft;
        _segmentedPageViewController.categoryView.originalIndex = self.selectedIndex;
        _segmentedPageViewController.categoryView.itemSpacing = 25;
        _segmentedPageViewController.categoryView.backgroundColor = [UIColor yellowColor];
        _segmentedPageViewController.categoryView.isEqualParts = NO;
        _segmentedPageViewController.delegate = self;
    }
    return _segmentedPageViewController;
}


@end
