

#import "BBCCategoryView.h"
#import <Masonry/Masonry.h>
#import "BBCSegumenCommen.h"

@interface BBCCategoryViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end;

@implementation BBCCategoryViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface BBCCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *vernier;
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL selectedCellExist;
@property (nonatomic) CGFloat fontPointSizeScale;
@property (nonatomic, strong) MASConstraint *underlineCenterXConstraint;
@property (nonatomic, strong) MASConstraint *underlineWidthConstraint;
@end

static NSString * const SegmentHeaderViewCollectionViewCellIdentifier = @"SegmentHeaderViewCollectionViewCell";

@implementation BBCCategoryView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = 0;
        _height = BBCCategoryViewDefaultHeight;
        _vernierHeight = 1.8;
        _itemSpacing = 15;
        _leftAndRightMargin = 10;
        self.titleNomalFont = [UIFont systemFontOfSize:16];
        self.titleSelectedFont = [UIFont systemFontOfSize:17];
        self.titleNormalColor = [UIColor grayColor];
        self.titleSelectedColor = [UIColor redColor];
        self.vernier.backgroundColor = self.titleSelectedColor;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.originalIndex > 0) {
        self.selectedIndex = self.originalIndex;
    } else {
        _selectedIndex = 0;
        [self setupUnderlineDefaultLocation];
    }
}

#pragma mark - Public Method
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex {
    if (self.selectedIndex == targetIndex) {
        return;
    }
    BBCCategoryViewCollectionViewCell *selectedCell = [self getCell:self.selectedIndex];
    BBCCategoryViewCollectionViewCell *targetCell = [self getCell:targetIndex];
    if (selectedCell) selectedCell.titleLabel.textColor = self.titleNormalColor;
    if (targetCell) targetCell.titleLabel.textColor = self.titleSelectedColor;
    CGFloat scale = self.titleSelectedFont.pointSize / self.titleNomalFont.pointSize;
    [UIView animateWithDuration:0.15 animations:^{
        if (selectedCell) selectedCell.titleLabel.transform = CGAffineTransformIdentity;
        if (targetCell) targetCell.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        if (selectedCell) selectedCell.titleLabel.font = self.titleNomalFont;
        if (targetCell) targetCell.titleLabel.font = self.titleSelectedFont;
    }];
    self.selectedIndex = targetIndex;
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.topBorder];
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.vernier];
    [self addSubview:self.bottomBorder];
    
    [self.topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(BBC_ONE_PIXEL);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBorder.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.height - BBC_ONE_PIXEL);
    }];
    [self.vernier mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat collectionViewHeight = self.height - BBC_ONE_PIXEL * 2;
        make.top.mas_equalTo(collectionViewHeight - self.vernierHeight);
        make.height.mas_equalTo(self.vernierHeight);
    }];
    [self.bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(BBC_ONE_PIXEL);
    }];
}

- (BBCCategoryViewCollectionViewCell *)getCell:(NSUInteger)index {
    return (BBCCategoryViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.selectedItemHelper) {
        self.selectedItemHelper(self.selectedIndex);
    }
    
    BBCCategoryViewCollectionViewCell *selectedCell = [self getCell:self.selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateUnderlineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateUnderlineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupUnderlineDefaultLocation {
    [self.collectionView layoutIfNeeded];
    BBCCategoryViewCollectionViewCell *cell = [self getCell:self.selectedIndex];
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        self.underlineCenterXConstraint = make.centerX.mas_equalTo(cell);
        self.underlineWidthConstraint = make.width.mas_equalTo(cell.titleLabel);
    }];
}

- (void)updateUnderlineLocation {
    [self.collectionView layoutIfNeeded];
    BBCCategoryViewCollectionViewCell *cell = [self getCell:self.selectedIndex];
    [self.underlineCenterXConstraint uninstall];
    [self.underlineWidthConstraint uninstall];
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        self.underlineCenterXConstraint = make.centerX.mas_equalTo(cell);
        self.underlineWidthConstraint = make.width.mas_equalTo(cell.titleLabel);
    }];
    [UIView animateWithDuration:0.15 animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}

- (void)updateCollectionViewContentInset {
    [self.collectionView layoutIfNeeded];
    CGFloat width = self.collectionView.contentSize.width;
    CGFloat margin;
    if (width > BBC_SCREEN_WIDTH) {
        width = BBC_SCREEN_WIDTH;
        margin = 0;
    } else {
        margin = (BBC_SCREEN_WIDTH - width) / 2.0;
    }
    
    switch (self.alignment) {
        case BBCCategoryViewAlignmentLeft:
            self.collectionView.contentInset = UIEdgeInsetsZero;
            break;
        case BBCCategoryViewAlignmentCenter:
            self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
            break;
        case BBCCategoryViewAlignmentRight:
            self.collectionView.contentInset = UIEdgeInsetsMake(0, margin * 2, 0, 0);
            break;
    }
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height - BBC_ONE_PIXEL)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:self.titleSelectedFont}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self getWidthWithContent:self.titles[indexPath.row]];
    CGFloat height = self.height - BBC_ONE_PIXEL * 2;
    return CGSizeMake(self.itemWidth > 0 ? self.itemWidth : width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.leftAndRightMargin, 0, self.leftAndRightMargin);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBCCategoryViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.titleLabel.textColor = self.selectedIndex == indexPath.row ? self.titleSelectedColor : self.titleNormalColor;
    if (self.selectedIndex == indexPath.row) {
        cell.titleLabel.transform = CGAffineTransformMakeScale(self.fontPointSizeScale, self.fontPointSizeScale);
        cell.titleLabel.font = self.titleSelectedFont;
    } else {
        cell.titleLabel.transform = CGAffineTransformIdentity;
        cell.titleLabel.font = self.titleNomalFont;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemToTargetIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateUnderlineLocation];
    }
}

#pragma mark - Setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (self.titles.count == 0) {
        return;
    }
    if (selectedIndex >= self.titles.count) {
        _selectedIndex = self.titles.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    [self layoutAndScrollToSelectedItem];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles.copy;
    [self updateCollectionViewContentInset];
}

- (void)setAlignment:(BBCCategoryViewAlignment)alignment {
    _alignment = alignment;
}

- (void)setHeight:(CGFloat)categoryViewHeight {
    _height = categoryViewHeight;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.height - BBC_ONE_PIXEL);
    }];
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height - self.vernierHeight - BBC_ONE_PIXEL);
    }];
}

- (void)setUnderlineHeight:(CGFloat)underlineHeight {
    _vernierHeight = underlineHeight;
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height - self.vernierHeight - BBC_ONE_PIXEL);
    }];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self updateCollectionViewContentInset];
}

- (void)setItemSpacing:(CGFloat)cellSpacing {
    _itemSpacing = cellSpacing;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self updateCollectionViewContentInset];
}

- (void)setLeftAndRightMargin:(CGFloat)leftAndRightMargin {
    _leftAndRightMargin = leftAndRightMargin;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self updateCollectionViewContentInset];
}

- (void)setIsEqualParts:(CGFloat)isEqualParts {
    _isEqualParts = isEqualParts;
    if (self.isEqualParts && self.titles.count > 0) {
        self.itemWidth = (BBC_SCREEN_WIDTH - self.leftAndRightMargin * 2 - self.itemSpacing * (self.titles.count - 1)) / self.titles.count;
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[BBCCategoryViewCollectionViewCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)vernier {
    if (!_vernier) {
        _vernier = [[UIView alloc] init];
    }
    return _vernier;
}

- (UIView *)topBorder {
    if (!_topBorder) {
        _topBorder = [[UIView alloc] init];
        _topBorder.backgroundColor = [UIColor lightGrayColor];
    }
    return _topBorder;
}

- (UIView *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = [[UIView alloc] init];
        _bottomBorder.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomBorder;
}

- (CGFloat)fontPointSizeScale {
    return self.titleSelectedFont.pointSize / self.titleNomalFont.pointSize;
}

@end
