//
//  CZRedPackets2Controller.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPackets2Controller.h"
#import <WebKit/WebKit.h>
#import "UIButton+CZExtension.h" // 按钮扩展
#import "CZRedPackets3Controller.h"

@interface CZRedPackets2Controller () <WKNavigationDelegate>
/** <#注释#> */
@property (nonatomic, strong) WKWebView *webView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *popButton;

@end

@implementation CZRedPackets2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect rect = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0));
    _webView = [[WKWebView alloc] initWithFrame:rect configuration:[self wkWebViewConfiguration]];
    
    NSString *url = @"https://www.jipincheng.cn/new-free/submitRedPacket?token=5be54e9e5115495fb7576f3a0352390d";
//    NSString *url = @"http://40.0.0.60:8080/new-free/submitRedPacket?token=5be54e9e5115495fb7576f3a0352390d";
    
    _webView.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
    [self.view addSubview:self.popButton];
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 配置信息
- (WKWebViewConfiguration *)wkWebViewConfiguration
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    return config;
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *htmlHeadString = @"https://gethb";
    
    if([urlStr hasPrefix:htmlHeadString]){
        CURRENTVC(currentVc);
        CZRedPackets3Controller *vc = [[CZRedPackets3Controller alloc] init];
        [currentVc.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}



@end
