//
//  CZMHSDetailCommodity.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZBaseViewController.h"
#import "ZMHSDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDetailCommodity : CZBaseViewController
/** 当前数据 */
@property (nonatomic, strong) ZMHSDetailModel *model;
/** <#注释#> */
@property (nonatomic, strong) NSString *ID;
/** <#注释#> */
@property (nonatomic, strong) NSArray *topDataList;
@end

NS_ASSUME_NONNULL_END
