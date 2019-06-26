//
//  CZFreeSubOneController.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeSubOneController : UIViewController
/** 商品详情 */
@property (nonatomic, strong) NSArray *goodsContentList;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

NS_ASSUME_NONNULL_END
