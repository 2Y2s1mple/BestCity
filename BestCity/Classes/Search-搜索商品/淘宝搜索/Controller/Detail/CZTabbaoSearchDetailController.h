//
//  CZTabbaoSearchDetailController.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CZTabbaoSearchDetailControllerDelegate <NSObject>
@optional
- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear;

@end

@interface CZTabbaoSearchDetailController : UIViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *type; // 商品来源(1京东,2淘宝，4拼多多)
/** 代理 */
@property (nonatomic, assign) id<CZTabbaoSearchDetailControllerDelegate> currentDelegate;
@end

NS_ASSUME_NONNULL_END
