//
//  TSLWebViewController.m
//  TeslaUI
//
//  Created by 曹文辉 on 2017/3/8.
//  Copyright © 2017年 卓健科技. All rights reserved.
//

#import "TSLWebViewController.h"
#import "CZNavigationView.h"

@interface TSLWebViewController ()
{
    UIWebView *_webview;
    NSURL *_url;
}

@end

@implementation TSLWebViewController


- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleName rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 67 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 67 - (IsiPhoneX ? 24 : 0))];
    _webview.delegate = self;
    _webview.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:_webview];
    

    if (self.stringHtml) {
        [_webview loadHTMLString:self.stringHtml baseURL:nil];
    } else if(self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [_webview loadRequest:request];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webview.frame = CGRectMake(0, 67 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 67 - (IsiPhoneX ? 24 : 0));
}

- (UIWebView *)webView {
    return _webview;
}

- (NSURL *)url {
    return _url;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 转菊花
    [CZProgressHUD showProgressHUDWithText:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 隐藏
    [CZProgressHUD hideAfterDelay:0];
    if (self.title) {
        return;
    }
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // 隐藏
    [CZProgressHUD hideAfterDelay:0];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"出错啦" message:@"网页加载失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"%@", request.URL);
    return YES;
}

- (void)dealloc
{
    [CZProgressHUD hideAfterDelay:0];
}

@end
