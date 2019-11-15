//
//  CZShareView.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZTestDetailModel.h"

@interface CZShareView : UIView
/** 分享的数据 */
@property (nonatomic, strong) NSDictionary *param;
/** <#注释#> */
@property (nonatomic, strong) NSString *cententText;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *shareTypeParam;
// 分享小程序
- (void)shareMiniProgram;
@end
