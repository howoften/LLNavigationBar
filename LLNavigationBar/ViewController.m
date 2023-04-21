//
//  ViewController.m
//  LLNavigationBar
//
//  Created by liujiang on 2022/9/22.
//

#import "ViewController.h"
#import "LLNavigationBar.h"
#import <WebKit/WebKit.h>
#import "LLNavigationBackButton.h"
#import "LLModalTransition.h"
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webview;
@property (nonatomic, strong)LLModalTransition *transit;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://sh.meituan.com/"]]];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationBar.title = @"巨无霸汉堡";
    self.navigationBar.subTitle = @"abcdef炸鸡憨袄🍗";
//    self.navigationBar.lightStyle = NO;
//    self.navigationBar.translucent = NO;
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"巨无霸汉堡巨无霸汉堡巨无霸汉堡巨无霸汉堡" forState:UIControlStateNormal];
//    [button setBackgroundColor:UIColor.blueColor];
//    self.navigationBar.titleView = button;
    self.navigationBar.leftItems = @[[UIButton buttonWithType:UIButtonTypeDetailDisclosure], [UIButton buttonWithType:UIButtonTypeContactAdd]];
    self.navigationBar.leftItemSpacing = 5;
    self.navigationBar.contentInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    self.navigationBar.rightItems = @[[UIButton buttonWithType:UIButtonTypeDetailDisclosure], [UIButton buttonWithType:UIButtonTypeContactAdd]];
    self.navigationBar.rightItemSpacing = 5;
    
    [(UIControl *)self.navigationBar.leftItems.firstObject addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.backgroundImageView.image = [UIImage imageNamed:@"picMadeByMatools"];
    self.webview.scrollView.delegate = self;

}
- (IBAction)nextAction:(id)sender {
//    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"] animated:YES];
    
    UINavigationController *next = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]];
    next.navigationBar.hidden = YES;
    _transit = [LLModalTransition transitionFromModalStyle:ViewControllerModalStyleLikeSystemNavigation presentedViewController:next presentingViewController:self.navigationController];
    [self.navigationController presentViewController:next animated:YES completion:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percent = (scrollView.contentOffset.y+self.navigationBar.statusBarHeight) / 200;
    [self.navigationBar hiddenPercent:percent];
//    [self.navigationBar showPercent:1-percent];
    
}
- (void)onTap {
    [self.navigationBar hiddenAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationBar showAnimated:YES];
    });
}
@end
