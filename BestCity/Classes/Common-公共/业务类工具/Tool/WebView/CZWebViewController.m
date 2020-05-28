//
//  CZWebViewController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZWebViewController.h"
#import <WebKit/WebKit.h>

@interface CZWebViewController () <WKNavigationDelegate>
/** <#注释#> */
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation CZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - IsiPhoneX);
    _webView = [[WKWebView alloc] initWithFrame:rect configuration:[self wkWebViewConfiguration]];
    _webView.scrollView.scrollEnabled = NO;
    _webView.backgroundColor = [UIColor grayColor];
    _webView.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/5cf0d241ae12"]];
    [_webView loadRequest:request];
    
}

// 配置信息
- (WKWebViewConfiguration *)wkWebViewConfiguration
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    return config;
}

@end
