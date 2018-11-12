//
//  CZBaseRecommendController.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZBaseRecommendController : UIViewController
/** 当前数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
