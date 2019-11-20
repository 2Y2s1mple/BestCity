//
//  CZFreeSubThreeController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeSubThreeController.h"

@interface CZFreeSubThreeController () <UIWebViewDelegate, UIScrollViewDelegate>

@end

@implementation CZFreeSubThreeController
- (CZScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[CZScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 50 - (IsiPhoneX ? 83 : 49) - (IsiPhoneX ? 44 : 20))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = [UIColor whiteColor];
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.scrollerView];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, self.scrollerView.height)];
    _webView.backgroundColor = CZGlobalWhiteBg;
    [self.scrollerView addSubview:_webView];
    _webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/free-rule.html"]];
    [_webView loadRequest:request];
    _webView.scrollView.scrollEnabled = NO;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    self.scrollerView.contentSize = size;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeChargeDetailControllerNoti" object:nil userInfo:@{@"isScroller" : scrollView}];
}

@end
