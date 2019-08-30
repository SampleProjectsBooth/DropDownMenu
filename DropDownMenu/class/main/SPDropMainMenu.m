//
//  SPDropMenu.m
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import "SPDropMainMenu.h"
#import "SPBaseCollectionViewCell.h"

@interface SPDropMainMenu () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<id <SPDropItemProtocol>> *m_items;

@property (nonatomic, weak) UIView *containView;

@property (nonatomic, weak) UICollectionView *MyCollectView;

@property (nonatomic, assign) CGFloat margin;

@end

@implementation SPDropMainMenu

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    _m_items = [[NSMutableArray alloc] init];
    _margin = 10.f;
}

/**
 添加数据源
 */
- (void)addItem:(id <SPDropItemProtocol>)item
{
    if (item) {
        [self.m_items addObject:item];
    }
}

- (NSArray<id<SPDropItemProtocol>> *)items
{
    return [self.m_items mutableCopy];
}

#pragma mark - show

/**
 从坐标展示
 */
- (void)showFromPoint:(CGPoint)point
{
    [self showFromPoint:point animated:YES];
}
/**
 从坐标展示，动画
 */
- (void)showFromPoint:(CGPoint)point animated:(BOOL)animated
{
    
}

/**
 从视图边缘展示
 */
- (void)showInView:(UIView *)view
{
    [self showInView:view animated:YES];
}
/**
 从视图边缘展示，动画
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    
}

#pragma mark - hidden

/**
 隐藏菜单
 */
- (void)dismiss
{
    [self dismissWithAnimated:YES];
}
/**
 隐藏菜单，动画
 */
- (void)dismissWithAnimated:(BOOL)animated
{
    
}

#pragma mark - Private Methods
#pragma mark 创建视图
- (void)_createContainView
{
    UIView *aView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:aView];
    self.containView = aView;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.containView addSubview:collectionView];
    self.MyCollectView = collectionView;
    
    [self.MyCollectView registerClass:[SPBaseCollectionViewCell class] forCellWithReuseIdentifier:[SPBaseCollectionViewCell identifier]];
    
}

#pragma mark 计算高度
- (void)_calculateTotalHeight
{
    CGFloat height = 0.f;
    for (id<SPDropItemProtocol>obj in self.items) {
        CGFloat subViewHeight = CGRectGetHeight(obj.displayView.frame);
        height += subViewHeight;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<SPDropItemProtocol>obj = [self.items objectAtIndex:indexPath.row];
    return obj.displayView.frame.size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<SPDropItemProtocol>obj = [self.items objectAtIndex:indexPath.row];
    obj.handler(obj);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [SPBaseCollectionViewCell identifier];
    SPBaseCollectionViewCell *cell = (SPBaseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    id<SPDropItemProtocol>obj = [self.items objectAtIndex:indexPath.row];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:obj.displayView];
    
    return cell;
}

@end
