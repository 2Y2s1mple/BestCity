//
//  CZFreeChargeController.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
// 工具
#import "GXNetTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 试用数据 */
@property (nonatomic, strong) NSMutableArray *freeChargeDatas;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, assign) BOOL isNewUser;
@end

NS_ASSUME_NONNULL_END
