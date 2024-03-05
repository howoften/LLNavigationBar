//
//  SDCycleScrollView+CellPaging.h
//  TinySweet
//
//  Created by liujiang on 2021/4/22.
//  Copyright © 2021 xinmeng. All rights reserved.
//

/**
 @brief 只有当你的轮播图需要一屏展示多个cell， 且一次滚动一个cell的宽度， 且是横向滚动轮播图时，你会需要用到以下扩展。否则请不要使用
 */
#import "SDCycleScrollView.h"

@interface SDCycleScrollView (CellPaging)
@property (nonatomic, assign)BOOL enableCellPaging;
@property (nonatomic, assign)CGFloat cellSpacing;
@property (nonatomic, assign)CGFloat cellWidth;
@property (nonatomic, assign)CGFloat autoPagingInterval;
@end
