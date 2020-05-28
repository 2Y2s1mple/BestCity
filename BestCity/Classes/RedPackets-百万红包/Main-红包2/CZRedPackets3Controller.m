//
//  CZRedPackets3Controller.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPackets3Controller.h"
#import "CZNavigationView.h"
#import <WebKit/WebKit.h>
#import "GXNetTool.h"
#import "CZRedPacketsWithdrawalController.h"
#import "CZRedPackets2Controller.h"


@interface CZRedPackets3Controller () <WKNavigationDelegate>
/** <#注释#> */
@property (nonatomic, strong) WKWebView *webView;
/** <#注释#> */
@property (nonatomic, strong) NSString *hongbao2Id;
/** <#注释#> */
@property (nonatomic, strong) NSString *shareType;

@end

@implementation CZRedPackets3Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"天天领现金" rightBtnTitle:nil rightBtnAction:nil];
    [self.view addSubview:navigationView];
    
    CGRect rect = CGRectMake(0, CZGetY(navigationView), SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0) - CZGetY(navigationView));
    _webView = [[WKWebView alloc] initWithFrame:rect configuration:[self wkWebViewConfiguration]];
    NSString *url = @"https://www.jipincheng.cn/new-free/getRedPacket?token=5be54e9e5115495fb7576f3a0352390d";
//    [NSString stringWithFormat:@"https://www.jipincheng.cn/new-free/getRedPacket?token=%@", JPTOKEN]
    _webView.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
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
    NSString *htmlHeadString = @"https://sharehb";
    NSString *htmlHeadString1 = @"https://txhb";
    NSString *htmlHeadString2 = @"https://openhb";
    if([urlStr hasPrefix:htmlHeadString]){
        NSRange range = [urlStr rangeOfString:@"shareType"];
        self.shareType = [urlStr substringWithRange:NSMakeRange((range.location + range.length + 1), 1)];
        self.hongbao2Id = [[urlStr componentsSeparatedByString:@"="] lastObject];
        
        if ([self.shareType isEqualToString:@"6"]) {
            NSLog(@"提现页面");
            [self ImmediateWithdrawal];
        } else {
            NSLog(@"分享弹框");
            [self share];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlStr hasPrefix:htmlHeadString1]) {
        NSLog(@"提现页面");
        [self ImmediateWithdrawal];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlStr hasPrefix:htmlHeadString2]) {
        NSLog(@"开红包页面");
        CZRedPackets2Controller *vc = [[CZRedPackets2Controller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
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

/** 立即提现 */
- (void)ImmediateWithdrawal
{
    NSLog(@"立即提现");
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    CZRedPacketsWithdrawalController *toVc = [[CZRedPacketsWithdrawalController alloc] init];
//    toVc.model = _model;
    [vc.navigationController pushViewController:toVc animated:YES];
}

#pragma mark - 事件
- (void)share
{
    // 统一分享UI
    [CZJIPINSynthesisView JIPIN_UMShareUIWithAction:^(CZJIPINSynthesisView * _Nonnull view, NSInteger index) {
        UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
        switch (index) {
            case 0:
            {
                [self statistics:index + 1];
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_WechatSession;//微信好友
                [self UMShareWebWithType:type];
                break;
            }
            case 1: // 朋友圈
            {
                [self statistics:index + 1];
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
                [self getPosterImage:type];
                break;
            }
            case 2:
            {
                [self statistics:index + 1];
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_QQ;//QQ好友
                [self UMShareWebWithType:type];
                break;
            }
            case 3:
            {
                [self statistics:index + 1];
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_Sina;//新浪微博
                [self UMShareWebWithType:type];
                break;
            }
            case 4:
            {
                [self statistics:index + 1];
                type = 4;
                [self getPosterImage:type];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)UMShareWebWithType:(UMSocialPlatformType)type
{
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    shareDic[@"shareTitle"] = @"新人免单，仅剩3天！";
    shareDic[@"shareContent"] = @"价值30元免单礼品任意选";
    
//    NSString *url = @"9345a5dc869e40cd90dc827a203f607b";
    
    shareDic[@"shareUrl"] = [NSString stringWithFormat:@"https://www.jipincheng.cn/new-free?query=\"%@\"", JPUSERINFO[@"userId"]];
    

    shareDic[@"shareImg"] = @"https://jipincheng.cn/share_newFree.png";
    [CZJIPINSynthesisTool JINPIN_UMShareWeb:shareDic[@"shareUrl"] Title:shareDic[@"shareTitle"] subTitle:shareDic[@"shareContent"] thumImage:shareDic[@"shareImg"] Type:type];
}

- (void)getPosterImage:(UMSocialPlatformType)type
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/v2/hongbao/createPosterImg"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"hongbao2Id"] = self.hongbao2Id;
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
         if ([result[@"msg"] isEqualToString:@"success"]) {
             if (type == 4) {
                 [CZJIPINSynthesisTool jipin_saveImage:result[@"data"]];
             } else {
                 [self shareImageWithType:type thumImage:result[@"data"]];
             }
         } else {
             [CZProgressHUD hideAfterDelay:0];
         }

    } failure:nil];
}

// 分享图片
- (void)shareImageWithType:(UMSocialPlatformType)type thumImage:(NSString *)thumImage
{
    [CZJIPINSynthesisTool JINPIN_UMShareImage:thumImage Type:type];
}

- (void)dealloc
{
       if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
           NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]];
           NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
           [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
               // Done
           }];
       } else {
           NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
           NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
           NSError *errors;
           [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
       }
}

- (void)statistics:(NSInteger)type
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/v2/hongbao/share"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"hongbao2Id"] = self.hongbao2Id;
    param[@"shareType"] = self.shareType;
    param[@"type"] = @(type);
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:nil];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
