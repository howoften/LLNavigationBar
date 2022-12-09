//
//  LLNavigationBar.m
//  LLNavigationBar
//
//  Created by liujiang on 2022/9/22.
//

#import <objc/runtime.h>
#import "LLNavigationBar.h"

@interface LLNavigationBar ()
@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)UIVisualEffectView *blurView;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, assign)CGFloat statusBarHeight;

@property (nonatomic, strong)UIStackView *titleStack;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subTitleLabel;

@property (nonatomic, strong)UIStackView *leftStack;
@property (nonatomic, strong)UIStackView *rightStack;

@property (nonatomic, strong)NSLayoutConstraint *topInset;
@property (nonatomic, strong)NSLayoutConstraint *leftInset;
@property (nonatomic, strong)NSLayoutConstraint *bottomInset;
@property (nonatomic, strong)NSLayoutConstraint *rightInset;
@property (nonatomic, strong)NSLayoutConstraint *contentHeight;


@property (nonatomic, strong)NSLayoutConstraint *barBottomAnchor;

@property (nonatomic) BOOL titleColorModified;
@end
const NSInteger llNavigationBarTag = 3145;
@implementation LLNavigationBar

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.tag = llNavigationBarTag;
        _translucent= YES;
        _lightStyle = YES;
//        self.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
        __weak LLNavigationBar *bar_weak_ref = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillChangeStatusBarFrameNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            bar_weak_ref.barBottomAnchor.constant = [bar_weak_ref barStandarMarginBottom];
            [bar_weak_ref setNeedsUpdateConstraints];
        }];
    }
    return self;
}
- (void)setup {
    self.backgroundImageView = [UIImageView new];
    [self addSubview:self.backgroundImageView];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView.leftAnchor constraintEqualToAnchor:self.backgroundImageView.superview.leftAnchor constant:0].active = YES;
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.backgroundImageView.superview.topAnchor constant:0].active = YES;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.backgroundImageView.superview.bottomAnchor constant:0].active = YES;
    [self.backgroundImageView.rightAnchor constraintEqualToAnchor:self.backgroundImageView.superview.rightAnchor constant:0].active = YES;
    
    
    UIBlurEffect *style = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:style];
    [self addSubview:self.blurView];
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.blurView.leftAnchor constraintEqualToAnchor:self.blurView.superview.leftAnchor constant:0].active = YES;
    [self.blurView.topAnchor constraintEqualToAnchor:self.blurView.superview.topAnchor constant:0].active = YES;
    [self.blurView.bottomAnchor constraintEqualToAnchor:self.blurView.superview.bottomAnchor constant:0].active = YES;
    [self.blurView.rightAnchor constraintEqualToAnchor:self.blurView.superview.rightAnchor constant:0].active = YES;
    
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _topInset = [self.contentView.topAnchor constraintEqualToAnchor:self.contentView.superview.topAnchor constant:self.contentInset.top + self.statusBarHeight];
    _leftInset = [self.contentView.leftAnchor constraintEqualToAnchor:self.contentView.superview.leftAnchor constant:self.contentInset.left];
    _bottomInset = [self.contentView.bottomAnchor constraintEqualToAnchor:self.contentView.superview.bottomAnchor constant:self.contentInset.bottom];
    _rightInset = [self.contentView.rightAnchor constraintEqualToAnchor:self.contentView.superview.rightAnchor constant:self.contentInset.right];
    _contentHeight = [self.contentView.heightAnchor constraintEqualToConstant:44];
    _topInset.priority = UILayoutPriorityDefaultLow;
    _topInset.active = YES;
    _leftInset.active = YES;
    _bottomInset.active = YES;
    _rightInset.active = YES;
    _contentHeight.active = YES;
    
    
    self.titleStack = [UIStackView new];
    self.titleStack.axis = UILayoutConstraintAxisVertical;
    self.titleStack.spacing = 2;
    self.titleStack.distribution = UIStackViewDistributionFillProportionally;
    self.titleStack.alignment = UIStackViewAlignmentCenter;
    self.titleStack.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.titleStack];
    [self.titleStack.centerXAnchor constraintEqualToAnchor:self.titleStack.superview.centerXAnchor].active = YES;
    [self.titleStack.centerYAnchor constraintEqualToAnchor:self.titleStack.superview.centerYAnchor].active = YES;
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleStack addArrangedSubview:self.titleLabel];
    self.subTitleLabel = [UILabel new];
    [self.subTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    [self.titleStack addArrangedSubview:self.subTitleLabel];
    
    
    self.leftStack = [UIStackView new];
    self.leftStack.axis = UILayoutConstraintAxisHorizontal;
    self.leftStack.distribution = UIStackViewDistributionFillProportionally;
    self.leftStack.alignment = UIStackViewAlignmentCenter;
    self.leftStack.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.leftStack];
    [self.leftStack.leftAnchor constraintEqualToAnchor:self.leftStack.superview.leftAnchor].active = YES;
    [self.leftStack.centerYAnchor constraintEqualToAnchor:self.leftStack.superview.centerYAnchor].active = YES;
    [self.leftStack.rightAnchor constraintLessThanOrEqualToAnchor:self.titleStack.leftAnchor constant:-3].active = YES;
    
    self.rightStack = [UIStackView new];
    self.rightStack.axis = UILayoutConstraintAxisHorizontal;
    self.rightStack.distribution = UIStackViewDistributionFillProportionally;
    self.rightStack.alignment = UIStackViewAlignmentCenter;
    self.rightStack.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.rightStack];
    [self.rightStack.rightAnchor constraintEqualToAnchor:self.rightStack.superview.rightAnchor].active = YES;
    [self.rightStack.centerYAnchor constraintEqualToAnchor:self.rightStack.superview.centerYAnchor].active = YES;
    [self.rightStack.leftAnchor constraintGreaterThanOrEqualToAnchor:self.titleStack.rightAnchor constant:3].active = YES;
    
    
}
- (void)applyConstraintInView:(UIView *)view {
    UIView *superView = view ?: self.superview;
    [superView addSubview: self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor].active = YES;
    [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor].active = YES;
    [self.heightAnchor constraintEqualToConstant:self.statusBarHeight+44].active = YES;
    
    
    self.barBottomAnchor = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-[self barStandarMarginBottom]];
    self.barBottomAnchor.active = YES;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.superview bringSubviewToFront:self];
    self.barBottomAnchor.constant = -[self barStandarMarginBottom];
    [self setNeedsUpdateConstraints];
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    self.barBottomAnchor.constant = -[self barStandarMarginBottom];
    [self setNeedsUpdateConstraints];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    if (UIEdgeInsetsEqualToEdgeInsets(contentInset, _contentInset)) return;
    _contentInset = contentInset;
    
    _topInset.constant = contentInset.top + self.statusBarHeight;
    _leftInset.constant = contentInset.left;
    _bottomInset.constant = contentInset.bottom;
    _rightInset.constant = contentInset.right;
    [self setNeedsLayout];
}
- (void)setLeftItems:(NSArray<UIView *> *)leftItems {
    _leftItems = leftItems;
    [self.leftStack.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [leftItems enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.leftStack addArrangedSubview:obj];
    }];
    
}
- (void)setRightItems:(NSArray<UIView *> *)rightItems {
    _rightItems = rightItems;
    
    [self.rightStack.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [rightItems enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rightStack addArrangedSubview:obj];
    }];
}
- (void)setTitleView:(UIView *)titleView {
    if (titleView == nil && _titleView) {
        [self.titleStack removeArrangedSubview:_titleView];
    }
    _titleView = titleView;
    [_titleView removeFromSuperview];
    _titleLabel.hidden = titleView != nil;
    _subTitleLabel.hidden = titleView != nil;
    if (!titleView) return;
    [self.titleStack insertArrangedSubview:titleView atIndex:0];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
    _titleColorModified = YES;
}
- (void)setAttributeTitle:(NSAttributedString *)attributeTitle {
    _attributeTitle = attributeTitle;
    _titleLabel.attributedText = attributeTitle;
}
- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
}
- (void)setSubTitleColor:(UIColor *)subTitleColor {
    _subTitleColor = subTitleColor;
    _subTitleLabel.textColor = subTitleColor;
    _titleColorModified = YES;
}
- (void)setSubAttributeTitle:(NSAttributedString *)subAttributeTitle {
    _subAttributeTitle = subAttributeTitle;
    _subTitleLabel.attributedText = subAttributeTitle;
}
- (void)setTitleSpacing:(CGFloat)titleSpacing {
    _titleSpacing = titleSpacing;
    _titleStack.spacing = titleSpacing;
}
- (void)setLeftItemSpacing:(CGFloat)leftItemSpacing {
    _leftItemSpacing = leftItemSpacing;
    _leftStack.spacing = leftItemSpacing;
}
- (void)setRightItemSpacing:(CGFloat)rightItemSpacing {
    _rightItemSpacing = rightItemSpacing;
    _rightStack.spacing = rightItemSpacing;
}
- (void)setLightStyle:(BOOL)lightStyle {
    _lightStyle = lightStyle;
    UIBlurEffect *style = [UIBlurEffect effectWithStyle:lightStyle ? UIBlurEffectStyleLight : UIBlurEffectStyleDark];
    self.blurView.effect = style;
    
    if (!self.titleColorModified ) {
        self.titleLabel.textColor = lightStyle ? UIColor.blackColor : UIColor.whiteColor;
        self.subTitleLabel.textColor = lightStyle ? UIColor.blackColor : UIColor.whiteColor;
    }
    
}

- (void)showAnimated:(BOOL)animated {
    if (!animated) {
        self.transform = CGAffineTransformIdentity;
        return;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenAnimated:(BOOL)animated {
    if (!animated) {
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(self.frame));
        return;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(self.frame));
    } completion:^(BOOL finished) {
        
    }];
}
- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    self.blurView.hidden = !translucent;
    
    if (self.backgroundColor == nil && !translucent) {
        self.backgroundColor = _lightStyle ? [UIColor colorWithWhite:250 / 255.0 alpha:1] : [UIColor colorWithWhite:100 / 255.0 alpha:1];
    }else if ((CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor colorWithWhite:250 / 255.0 alpha:1].CGColor) ||
               CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor colorWithWhite:100 / 255.0 alpha:1].CGColor)) && translucent) {
        self.backgroundColor = nil;
    }
}

- (CGFloat)statusBarHeight {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (CGRectGetHeight(window.frame) < 737) { // plus: 414 * 736
        return 20;
    }
    if (@available(iOS 11.0, *)) {
        if (window.safeAreaInsets.bottom > 0 && _statusBarHeight < 40) {
            _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }else if (window.safeAreaInsets.bottom < 1 && _statusBarHeight < 1) {
            _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    if (_statusBarHeight < 1) {
        if (@available(iOS 11.0, *)) {
            if (window.safeAreaInsets.top > 0) {
                _statusBarHeight = 44;
            }else if (window.safeAreaInsets.top < 1) {
                _statusBarHeight = 20;
            }
        } else {
            _statusBarHeight = 20;
        }
    }
    return _statusBarHeight;
}
- (CGFloat)barStandarMarginBottom {
    UIViewController *barController = [self viewController];
    CGFloat height = CGRectGetHeight(barController.view.frame);
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (height < CGRectGetHeight(window.frame) - self.statusBarHeight - 44 ) {
        height = CGRectGetHeight(window.rootViewController.view.frame);
    }
    return height - self.statusBarHeight - 44;
}

- (UIViewController *)viewController {
    UIResponder *viewController = self;
    while (viewController.nextResponder != nil && ![viewController isKindOfClass:UIViewController.class]) {
        viewController = viewController.nextResponder;
    }
    return [viewController isKindOfClass:UIViewController.class] ? viewController : nil;
}

@end


@implementation UIViewController (LLNavigationBar)

- (LLNavigationBar *)navigationBar {
    LLNavigationBar *bar = [self.view viewWithTag:llNavigationBarTag];
    if (![bar isKindOfClass:LLNavigationBar.class]) {
        bar = [[LLNavigationBar alloc] initWithFrame:CGRectZero];
        [self.view addSubview:bar];
        [bar applyConstraintInView:nil];
    }
    return bar;
}

@end
