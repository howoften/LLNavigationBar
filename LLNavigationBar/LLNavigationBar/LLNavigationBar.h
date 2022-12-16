//
//  LLNavigationBar.h
//  LLNavigationBar
//
//  Created by liujiang on 2022/9/22.
//

#import <UIKit/UIKit.h>
#import "LLNavigationBackButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLNavigationBar : UIView
@property (nonatomic, strong, readonly)UIImageView *backgroundImageView;
@property (nonatomic, assign)UIEdgeInsets contentInset;

@property (nonatomic, strong)NSArray<UIView *> *leftItems;
@property (nonatomic, strong)NSArray<UIView *> *rightItems;

@property (nonatomic, strong)UIView *titleView;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)NSAttributedString *attributeTitle;
@property (nonatomic, strong)NSString *subTitle;
@property (nonatomic, strong)UIColor *subTitleColor;
@property (nonatomic, strong)NSAttributedString *subAttributeTitle;

@property (nonatomic)CGFloat titleSpacing;
@property (nonatomic)CGFloat leftItemSpacing;
@property (nonatomic)CGFloat rightItemSpacing;

@property (nonatomic) BOOL lightStyle;
@property (nonatomic) BOOL translucent;
@property (nonatomic, strong)UIColor *shadowColor;
@property (nonatomic, readonly)CGFloat statusBarHeight;
@property (nonatomic) BOOL hiddenBackButton;
@property (nonatomic, strong) UIView *backButton;

- (void)showAnimated:(BOOL)animated;
- (void)hiddenAnimated:(BOOL)animated;
- (void)showPercent:(CGFloat)percent;
- (void)hiddenPercent:(CGFloat)percent;

@end


@interface UIViewController (LLNavigationBar)
@property (nonatomic, strong, readonly)LLNavigationBar *navigationBar;

@end
NS_ASSUME_NONNULL_END
