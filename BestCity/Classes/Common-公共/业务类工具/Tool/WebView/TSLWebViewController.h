//
//  TSLWebViewController.h
//  TeslaUI
//
//  Created by 曹文辉 on 2017/3/8.
//  Copyright © 2017年 卓健科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WebViewBlock)(void);

@interface TSLWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong, readonly) UIWebView *webView;

@property (nonatomic, strong, readonly) NSURL *url;

/** 标题 */
@property (nonatomic, strong) NSString *titleName;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url rightBtnTitle:(id)rightBtnTitle actionblock:(WebViewBlock)block;
/** html */
@property (nonatomic, strong) NSString *stringHtml;
@end
