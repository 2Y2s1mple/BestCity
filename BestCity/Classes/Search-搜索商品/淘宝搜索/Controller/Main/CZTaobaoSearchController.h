//
//  CZHotsaleSearchController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZTaobaoSearchControllerDelegate <NSObject>
@optional
- (void)pushSearchDetailWithText:(NSString *)str;
@end

@interface CZTaobaoSearchController : UIViewController
@property (nonatomic, strong) NSString *type; // 1:京东 2:淘宝 4拼多多
/** <#注释#> */
@property (nonatomic, strong) NSString *searchText;

/** <#注释#> */
@property (nonatomic, assign) id<CZTaobaoSearchControllerDelegate>delegate;
@end
