//
//  SDCycleScrollView+CellPaging.m
//  TinySweet
//
//  Created by liujiang on 2021/4/22.
//  Copyright © 2021 xinmeng. All rights reserved.
//

#import "SDCycleScrollView+CellPaging.h"
#import <objc/runtime.h>
#import "UIView+SDExtension.h"
#import "SDWeakProxy.h"

@interface SDCellPagingEnableLayout : UICollectionViewFlowLayout
@property (nonatomic, assign)NSInteger pageCapacity;
@property (nonatomic, assign)CGFloat itemSpacing;
@end
@implementation SDCellPagingEnableLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.itemSize.width, CGRectGetHeight(self.collectionView.frame));
    // 每页可以完整显示的items个数

    _pageCapacity = (NSInteger)(CGRectGetWidth(self.collectionView.frame) + self.minimumInteritemSpacing) / (NSInteger)(self.itemSize.width + self.minimumInteritemSpacing);
    
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
//    NSInteger index = (NSInteger)proposedContentOffset.x / (NSInteger)(_pageCapacity * (self.itemSize.width + self.minimumInteritemSpacing));
//
//    NSInteger remainder = (NSInteger)proposedContentOffset.x % (NSInteger)(_pageCapacity * (self.itemSize.width + self.minimumInteritemSpacing));
//
//    if (remainder > 10 && velocity.x > 0.3) {
//        index ++;
//    }
//
//    if (velocity.x < -0.3 && index > 0) {
//        index --;
//    }
    CGFloat interSpacing = 9999999;
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(-99999999, 0, 0, 0)];
    UICollectionViewCell *lastCell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(-99999999, 0, 0, 0)];
    for (UICollectionViewCell *visibleCell in self.collectionView.visibleCells) {
        if (fabs(CGRectGetMinX(lastCell.frame) - CGRectGetMinX(visibleCell.frame))- CGRectGetWidth(lastCell.frame) < interSpacing) {
            interSpacing = fabs(CGRectGetMinX(lastCell.frame) - CGRectGetMinX(visibleCell.frame))- CGRectGetWidth(lastCell.frame);
        }
        if (fabs(CGRectGetMinX(cell.frame) - proposedContentOffset.x) >= fabs(CGRectGetMinX(visibleCell.frame) - proposedContentOffset.x)) {
            cell = visibleCell;
        }
        lastCell = visibleCell;
    }
    CGFloat speedDistance = 0;
    speedDistance -= self.collectionView.contentInset.left;
    if (velocity.x > 0.2 && CGRectGetMaxX(cell.frame) + (interSpacing + CGRectGetWidth(cell.frame)) < self.collectionView.contentSize.width && fabs(self.collectionView.contentOffset.x -CGRectGetMinX(cell.frame)) < CGRectGetWidth(cell.frame)/2) {
        speedDistance += (interSpacing + CGRectGetWidth(cell.frame));
    }
    self.itemSpacing = MAX(interSpacing, self.minimumInteritemSpacing);
    return CGPointMake(CGRectGetMinX(cell.frame)+speedDistance, 0);
}

@end



@interface SDCycleScrollView ()
@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)NSTimer *pagingTimer;

- (void)scrollToIndex:(int)targetIndex;
@end

@implementation SDCycleScrollView (CellPaging)
- (void)setEnableCellPaging:(BOOL)enableCellPaging {
    objc_setAssociatedObject(self, @selector(enableCellPaging), @(enableCellPaging), OBJC_ASSOCIATION_RETAIN);
    if (enableCellPaging) {
        SDCellPagingEnableLayout *flowLayout = [[SDCellPagingEnableLayout alloc] init];
        flowLayout.minimumInteritemSpacing = self.cellSpacing;
        if (self.cellWidth > 0) {
            flowLayout.itemSize = CGSizeMake(self.cellWidth, 76);
        }
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.mainView.collectionViewLayout = flowLayout;
        self.mainView.pagingEnabled = NO;
        self.mainView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.backgroundImageView.image = nil;
        self.autoScroll = NO;
        self.showPageControl = NO;
    }
}
- (BOOL)enableCellPaging {
    return [objc_getAssociatedObject(self, @selector(enableCellPaging)) boolValue];
}
- (void)setCellSpacing:(CGFloat)cellSpacing {
    objc_setAssociatedObject(self, @selector(cellSpacing), @(cellSpacing), OBJC_ASSOCIATION_RETAIN);
    [(SDCellPagingEnableLayout *)self.mainView.collectionViewLayout setMinimumInteritemSpacing:cellSpacing];
}
- (CGFloat)cellSpacing {
    return [objc_getAssociatedObject(self, @selector(cellSpacing)) floatValue];
}
- (void)setCellWidth:(CGFloat)cellWidth {
    objc_setAssociatedObject(self, @selector(cellWidth), @(cellWidth), OBJC_ASSOCIATION_RETAIN);
    [(SDCellPagingEnableLayout *)self.mainView.collectionViewLayout setItemSize:CGSizeMake(cellWidth, 76)];
}
- (CGFloat)cellWidth {
    
    return [objc_getAssociatedObject(self, @selector(cellWidth)) floatValue];
}
- (void)setAutoPagingInterval:(CGFloat)autoPagingInterval {
    objc_setAssociatedObject(self, @selector(autoPagingInterval), @(autoPagingInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (autoPagingInterval <= 0) {
        [self.pagingTimer invalidate];
        self.pagingTimer = nil;
        return;
    }

    if (!self.pagingTimer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoPagingInterval target:[[SDWeakProxy alloc] initWithTarget:self] selector:@selector(autoScrollPagingContent) userInfo:nil repeats:YES];
        self.pagingTimer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }else {
        [self.pagingTimer fire];
    }
}

- (CGFloat)autoPagingInterval {
    return [objc_getAssociatedObject(self, @selector(autoPagingInterval)) floatValue];
}

- (void)setPagingTimer:(NSTimer *)pagingTimer {
    objc_setAssociatedObject(self, @selector(pagingTimer), pagingTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimer *)pagingTimer {
    return objc_getAssociatedObject(self, @selector(pagingTimer));
}

- (void)autoScrollPagingContent {
    if (self.mainView.decelerating || self.mainView.dragging || self.mainView.tracking || !self.mainView.window) {
        return;
    }
    NSLog(@"auto page ########");
    [self scrollToIndex:[self pageScrollViewCurrentIndex]];
}
- (int)pageScrollViewCurrentIndex
{
    if (self.mainView.sd_width == 0 || self.mainView.sd_height == 0) {
        return 0;
    }
    
    int index = 0;
    if (((UICollectionViewFlowLayout *)self.mainView.collectionViewLayout).scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.mainView.contentOffset.x + (((SDCellPagingEnableLayout *)self.mainView.collectionViewLayout).itemSize.width + [self itemSpacing]) * 0.5) / (((SDCellPagingEnableLayout *)self.mainView.collectionViewLayout).itemSize.width + [self itemSpacing])+1;
    } else {
        NSAssert(NO, @"SDCycleScrollView+CellPaging only support horizen direction");
    }
    
    return MAX(0, index);
}
- (CGFloat)itemSpacing {
    CGFloat interSpacing = 9999999;
    UICollectionViewCell *lastCell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(-99999999, 0, 0, 0)];
    for (UICollectionViewCell *visibleCell in self.mainView.visibleCells) {
        if (fabs(CGRectGetMinX(lastCell.frame) - CGRectGetMinX(visibleCell.frame))- CGRectGetWidth(lastCell.frame) < interSpacing) {
            interSpacing = fabs(CGRectGetMinX(lastCell.frame) - CGRectGetMinX(visibleCell.frame))- CGRectGetWidth(lastCell.frame);
        }
        
        lastCell = visibleCell;
    }
    return MAX(interSpacing, ((SDCellPagingEnableLayout *)self.mainView.collectionViewLayout).minimumInteritemSpacing);
}
@end

