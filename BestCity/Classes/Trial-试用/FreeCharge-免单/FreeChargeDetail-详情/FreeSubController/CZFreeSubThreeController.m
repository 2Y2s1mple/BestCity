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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49) - 60)];
//    _webView.scrollView.scrollEnabled = NO;
    _webView.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:_webView];
    _webView.scrollView.delegate = self;

    [_webView loadHTMLString:self.stringHtml baseURL:nil];

    self.view.width = SCR_WIDTH;
    self.view.height = CZGetY(_webView);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentViewIsScroll:) name:@"CZFreeDetailsubViewNoti" object:nil];

}

- (void)currentViewIsScroll:(NSNotification *)noti
{
    NSLog(@"%@", noti.userInfo[@"isScroller"]);
    if ([noti.userInfo[@"isScroller"]  isEqual: @(1)]) {
        _webView.scrollView.scrollEnabled = YES;
    } else {
        _webView.scrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s %lf", __func__, scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeSubOneControllerNoti" object:nil userInfo:@{@"isScroller" : @(YES)}];
        scrollView.scrollEnabled = NO;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeSubOneControllerNoti" object:nil userInfo:@{@"isScroller" : @(NO)}];
        scrollView.scrollEnabled = YES;
    }
}

- (void)scrollTop
{
    [_webView.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
@end
