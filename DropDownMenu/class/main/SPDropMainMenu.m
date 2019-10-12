//
//  SPDropMenu.m
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import "SPDropMainMenu.h"
#import "SPBaseCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, SPDropMainMenuDirection)
{
    SPDropMainMenuDirectionTop = 0,
    SPDropMainMenuDirectionLeft,
    SPDropMainMenuDirectionBottom,
    SPDropMainMenuDirectionRight,
};

@interface SPDropMainMenu () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<id <SPDropItemProtocol>> *m_items;

@property (nonatomic, weak) UIView *containView;

@property (nonatomic, weak) UICollectionView *MyCollectView;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CGFloat arrowHeight;

@property (nonatomic, assign) SPDropMainMenuDirection menuDirection;

@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, assign) NSUInteger itemNumber;

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
    _autoDismiss = YES;
    
    _m_items = [[NSMutableArray alloc] init];
    
    _margin = 10.f;
    
    _arrowHeight = 10.f;
    
    _menuDirection = SPDropMainMenuDirectionBottom;

    self.backgroundColor = [UIColor clearColor];
    [self _createContainView];
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
    [self _showFromFrame:(CGRect){point, CGSizeZero} animated:animated];
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
    
    if ([view isKindOfClass:[UIView class]]) {
        
        /** 计算点 */
        CGRect converRect = [[UIApplication sharedApplication].keyWindow convertRect:view.frame fromView:view.superview];
        
        [self _showFromFrame:converRect animated:YES];
        
    }
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
    if (animated) {
        CGRect containViewF = self.containView.frame;
        CGRect collectionViewF = self.MyCollectView.frame;
        if (self.menuDirection == SPDropMainMenuDirectionTop) {
            collectionViewF.origin.y = 0.f;
            containViewF.origin.y = CGRectGetHeight(self.bounds);
        }
        containViewF.size.height = 0.f;
        collectionViewF.size.height = 0.f;
        [UIView animateWithDuration:.25f animations:^{
            self.MyCollectView.frame = collectionViewF;
            self.containView.frame = containViewF;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark - Private Methods
#pragma mark 创建视图
- (void)_createContainView
{
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:aView];
    self.containView = aView;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.containView addSubview:collectionView];
    self.MyCollectView = collectionView;
    
    [self.MyCollectView registerClass:[SPBaseCollectionViewCell class] forCellWithReuseIdentifier:[SPBaseCollectionViewCell identifier]];
    
}

#pragma mark 圆角边
- (void)_drawCircleView
{
    CGSize cornerRadii = CGSizeMake(5.f, 5.f);
    
    CGFloat startY = 0.f;
    if (self.menuDirection == SPDropMainMenuDirectionBottom) {
        startY = self.arrowHeight;
    }
        
    CGPoint arrowP = [self convertPoint:self.arrowPoint toView:self.containView];

    UIBezierPath * maskPath = [UIBezierPath bezierPath];
    
    /** 起始点 */
    [maskPath moveToPoint:CGPointMake(cornerRadii.width, startY)];
    /** 第一个圆角 */
    [maskPath addQuadCurveToPoint:CGPointMake(0.f, cornerRadii.height + startY) controlPoint:CGPointMake(0.f, startY)];
    /** 左边竖线 */
    [maskPath addLineToPoint:CGPointMake(0.f, CGRectGetHeight(self.containView.frame) - self.margin - cornerRadii.height)];
    /** 第二个圆角 */
    [maskPath addQuadCurveToPoint:CGPointMake(cornerRadii.width, CGRectGetHeight(self.containView.frame) - self.margin) controlPoint:CGPointMake(0.f, CGRectGetHeight(self.containView.frame) - self.margin)];
    if (self.menuDirection == SPDropMainMenuDirectionTop) {
        /** 画三角形 */
        [maskPath addLineToPoint:CGPointMake(arrowP.x - self.arrowHeight, CGRectGetHeight(self.containView.frame) - self.margin)];
        /** 尖点 */
        [maskPath addLineToPoint:CGPointMake(arrowP.x, arrowP.y)];
        /** 画三角形 */
        [maskPath addLineToPoint:CGPointMake(arrowP.x + self.arrowHeight, CGRectGetHeight(self.containView.frame) - self.margin)];
    }
    /** 底部横线 */
    [maskPath addLineToPoint:CGPointMake(CGRectGetWidth(self.containView.frame) - cornerRadii.width, CGRectGetHeight(self.containView.frame) - self.margin)];
    /** 第三个圆角 */
    [maskPath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame) - self.margin - cornerRadii.height) controlPoint:CGPointMake(CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame) - self.margin)];
    /** 右边竖线 */
    [maskPath addLineToPoint:CGPointMake(CGRectGetWidth(self.containView.frame), cornerRadii.height + startY)];
    /** 第四个圆角 */
    [maskPath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.containView.frame) - cornerRadii.width, startY) controlPoint:CGPointMake(CGRectGetWidth(self.containView.frame), startY)];
    if (self.menuDirection == SPDropMainMenuDirectionBottom) {
        /** 画三角形 */
        [maskPath addLineToPoint:CGPointMake(arrowP.x + self.arrowHeight, startY)];
        /** 尖点 */
        [maskPath addLineToPoint:CGPointMake(arrowP.x, arrowP.y)];
        /** 画三角形 */
        [maskPath addLineToPoint:CGPointMake(arrowP.x - self.arrowHeight, startY)];
    }
    /** 闭合 */
    [maskPath closePath];
    
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.containView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.containView.layer.mask = maskLayer;

}

#pragma mark 计算高度
- (CGFloat)_calculateTotalHeight
{
    CGFloat height = 0.f;
    for (id<SPDropItemProtocol>obj in self.items) {
        CGFloat subViewHeight = CGRectGetHeight(obj.displayView.frame);
        height += subViewHeight;
    }
    return height;
}

- (CGFloat)_calculateMaxHeight
{
    CGFloat height = 0.f;
    for (id<SPDropItemProtocol>obj in self.items) {
        CGFloat subViewHeight = CGRectGetHeight(obj.displayView.frame);
        height = MAX(height, subViewHeight);
    }
    return height;
}

- (CGFloat)_calculateMaxWidth
{
    CGFloat width = 0.f;
    for (id<SPDropItemProtocol>obj in self.items) {
        CGFloat subViewWidth = CGRectGetWidth(obj.displayView.frame);
        width = MAX(width, subViewWidth);
    }
    return width;
}

#pragma mark 计算出菜单视图大小
- (CGRect)_calculateMenuViewFrameWithConverFrame:(CGRect)converFrame
{
    CGRect resultRect = CGRectZero;
    
    resultRect.origin = converFrame.origin;
    
    resultRect.size.width = [self _calculateMaxWidth];
    
    resultRect.origin.x -= CGRectGetWidth(resultRect)/2;

    if (self.itemNumber == 0) {
        self.itemNumber = self.items.count;
    }
    
    for (NSUInteger i = 0; i < self.itemNumber; i ++) {
        id<SPDropItemProtocol>obj = [self.items objectAtIndex:i];
        resultRect.size.height += (CGRectGetHeight(obj.displayView.frame)+self.margin);
    }
    
    resultRect.size.height += (self.arrowHeight + self.margin*2);

    if (CGSizeEqualToSize(converFrame.size, CGSizeZero)) {
        
    } else {
        resultRect.origin.y += CGRectGetHeight(converFrame);
        resultRect.origin.x = converFrame.origin.x;
    }
    
    
    if (CGRectGetMinX(resultRect) < self.margin) {
        resultRect.origin.x = self.margin;
    }
     
    if (CGRectGetMaxX(resultRect) > (CGRectGetWidth([UIScreen mainScreen].bounds) - self.margin)) {
        resultRect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - self.margin - CGRectGetWidth(resultRect));
    }
    
    return resultRect;
}

#pragma mark 展示视图
- (void)_showFromFrame:(CGRect)frame animated:(BOOL)animated
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect rect = [self _calculateMenuViewFrameWithConverFrame:frame];
    
    self.frame = rect;

    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        self.arrowPoint = CGPointMake(CGRectGetWidth(rect)/2, 0.f);
    } else {
        CGPoint point = [self convertPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)) fromView:[UIApplication sharedApplication].keyWindow];
        self.arrowPoint = point;
    }
        
    if (self.menuDirection == SPDropMainMenuDirectionTop) {
        self.containView.frame = CGRectMake(0.f, self.margin, CGRectGetWidth(self.frame), CGRectGetHeight(rect)-self.margin);
        self.MyCollectView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(rect), CGRectGetHeight(rect)-self.margin*2);
    } else if (self.menuDirection == SPDropMainMenuDirectionBottom) {
        self.containView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(rect)-self.margin);
        self.MyCollectView.frame = CGRectMake(0.f, self.margin, CGRectGetWidth(rect), CGRectGetHeight(rect)-self.margin*2);
    }
    
    [self _drawCircleView];

    CGRect a = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), 0.f);
    CGRect b = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), 0.f);
    if (self.menuDirection == SPDropMainMenuDirectionTop) {
        a.origin.y = CGRectGetHeight(self.frame);
    } else if (self.menuDirection == SPDropMainMenuDirectionBottom) {
        b.origin.y = self.margin;
    }
    
    self.containView.backgroundColor = [UIColor blackColor];
    self.containView.frame = a;
    self.MyCollectView.frame = b;
    
    
    [UIView animateWithDuration:.25f animations:^{
        if (self.menuDirection == SPDropMainMenuDirectionTop) {
            self.containView.frame = CGRectMake(0.f, self.margin, CGRectGetWidth(self.frame), CGRectGetHeight(rect)-self.margin);
            self.MyCollectView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(rect), CGRectGetHeight(rect)-self.margin*2);
        } else if (self.menuDirection == SPDropMainMenuDirectionBottom) {
            self.containView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(rect)-self.margin);
            self.MyCollectView.frame = CGRectMake(0.f, self.margin, CGRectGetWidth(rect), CGRectGetHeight(rect)-self.margin*2);
        }
    } completion:^(BOOL finished) {

    }];

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
    for (id<SPDropItemProtocol>obj in self.items) {
        obj.selected = NO;
    }
    {
        id<SPDropItemProtocol>obj = [self.items objectAtIndex:indexPath.row];
        obj.tapHandler(obj);
        obj.selected = YES;
        [self dismiss];
    }
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
