//
//  CZFreeSubThreeController.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZFreeSubThreeController : UIViewController
@property (nonatomic, strong, readonly) UIWebView *webView;
/** html */
@property (nonatomic, strong) NSString *stringHtml;
/** 滚动视图 */
@property (nonatomic, strong) CZScrollView *scrollerView;
@end

NS_ASSUME_NONNULL_END
