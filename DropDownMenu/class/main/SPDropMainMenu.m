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

@property (nonatomic, assign) CGFloat arrowHeight;

@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, assign) BOOL isShowInView;

@property (nonatomic, assign) CGFloat maxItemWidth;

@end

@implementation SPDropMainMenu

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _customInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _customInit];
    }
    return self;
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
    self.isShowInView = NO;
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
    self.isShowInView = YES;
    
    /** 计算点 */
    CGRect converRect = [[UIApplication sharedApplication].keyWindow convertRect:view.frame fromView:view.superview];
    
    [self _showFromFrame:converRect animated:YES];

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
        CGRect tempRect = self.frame;
        switch (self.menuDirection) {
            case SPDropMainMenuDirectionTop:
            {
                tempRect.origin.y += CGRectGetHeight(tempRect);
            }
                break;
                
            default:
                break;
        }
        tempRect.size.height = 0.f;
        [UIView animateWithDuration:.25f animations:^{
            self.frame = tempRect;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark - Private Methods
- (void)_customInit
{
    _autoDismiss = YES;
    
    _displayMaxNum = 4;
    
    _m_items = [[NSMutableArray alloc] init];
    
    _margin = 10.f;
    
    _arrowHeight = 10.f;
    
    _maxItemWidth = 0.f;
    
    _menuDirection = SPDropMainMenuDirectionBottom;

    _containerViewbackgroundColor = [UIColor blackColor];
    
    self.backgroundColor = [UIColor clearColor];
    
}

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

#pragma mark 计算出菜单视图大小
- (CGRect)_calculateMenuViewFrameWithConverFrame:(CGRect)converFrame
{
    CGRect resultRect = CGRectZero;
    
    resultRect.origin = converFrame.origin;
    
    resultRect.size.width = [self maxItemWidth];
    
    resultRect.origin.x -= CGRectGetWidth(resultRect)/2;

    if (self.displayMaxNum == 0) {
        self.displayMaxNum = self.items.count;
    }
    
    for (NSUInteger i = 0; i < self.displayMaxNum; i ++) {
        id<SPDropItemProtocol>obj = [self.items objectAtIndex:i];
        resultRect.size.height += (CGRectGetHeight(obj.displayView.frame)+self.margin);
    }
    
    resultRect.size.height += (self.arrowHeight + self.margin*2);

    if (CGSizeEqualToSize(converFrame.size, CGSizeZero)) {
        
        if (self.menuDirection == SPDropMainMenuDirectionTop) {
            resultRect.origin.y -= CGRectGetHeight(resultRect);
        }
        
    } else {
        
        resultRect.origin.y = CGRectGetMaxY(converFrame);
        resultRect.origin.x = converFrame.origin.x;
        
        if (self.menuDirection == SPDropMainMenuDirectionTop) {
            resultRect.origin.y = (CGRectGetMinY(converFrame) - CGRectGetHeight(resultRect));
        }

    }
    
    
    if (CGRectGetMinX(resultRect) < self.margin) {
        resultRect.origin.x = self.margin;
    }
     
    if (CGRectGetMaxX(resultRect) > (CGRectGetWidth([UIScreen mainScreen].bounds) - self.margin)) {
        resultRect.origin.x = (CGRectGetWidth([UIScreen mainScreen].bounds) - self.margin - CGRectGetWidth(resultRect));
    }
    
    
    return resultRect;
}

#pragma mark 计算视图
- (void)_calculateItemViews
{
    CGFloat totalHeight = 0.f;
    CGFloat maxHeight = 0.f;
    _maxItemWidth = 0.f;
    BOOL isOnlySelect = NO;
    for (id<SPDropItemProtocol>obj in self.m_items) {
        maxHeight = MAX(maxHeight, CGRectGetHeight(obj.displayView.frame));
        _maxItemWidth = MAX(_maxItemWidth, CGRectGetWidth(obj.displayView.frame));
        totalHeight += CGRectGetHeight(obj.displayView.frame);
        if (isOnlySelect) {
            obj.selected  = NO;
        }
        if (obj.selected) {
            isOnlySelect = YES;
        }
    }
}
#pragma mark 展示视图
- (void)_showFromFrame:(CGRect)frame animated:(BOOL)animated
{
    
    [self _createContainView];

    [self _calculateItemViews];

    self.clipsToBounds = YES;
        
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect rect = [self _calculateMenuViewFrameWithConverFrame:frame];
    
    self.frame = rect;

    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        self.arrowPoint = CGPointMake(CGRectGetWidth(rect)/2, 0.f);
        if (self.menuDirection == SPDropMainMenuDirectionTop) {
            self.arrowPoint = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(self.frame));
        }
    } else {
        CGPoint point = [self convertPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)) fromView:[UIApplication sharedApplication].keyWindow];
        if (self.menuDirection == SPDropMainMenuDirectionTop) {
            point = [self convertPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)) fromView:[UIApplication sharedApplication].keyWindow];
        }
        self.arrowPoint = point;
    }
    
    if (self.menuDirection == SPDropMainMenuDirectionTop) {
        self.containView.frame = CGRectMake(0.f, self.margin, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-self.margin);
        self.MyCollectView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame)-self.margin*2);
    } else if (self.menuDirection == SPDropMainMenuDirectionBottom) {
        self.containView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-self.margin);
        self.MyCollectView.frame = CGRectMake(0.f, self.margin, CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame)-self.margin*2);
    }
        
    [self _drawCircleView];

    self.containView.backgroundColor = self.containerViewbackgroundColor;

    CGRect tempRect = self.frame;
    
    if (animated) {
        CGRect zeroRect = tempRect;

        switch (self.menuDirection) {
            case SPDropMainMenuDirectionTop:
            {
                zeroRect.size.height = 0.f;
                zeroRect.origin.y += CGRectGetHeight(tempRect);
            }
                break;
            case SPDropMainMenuDirectionBottom:
            {
                zeroRect.size.height = 0.f;
            }
                break;
            default:
                break;
        }
        self.frame = zeroRect;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.25f animations:^{
            weakSelf.frame = tempRect;
        }];
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
    
    if (obj.selected) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
    }
    return cell;
}

@end
