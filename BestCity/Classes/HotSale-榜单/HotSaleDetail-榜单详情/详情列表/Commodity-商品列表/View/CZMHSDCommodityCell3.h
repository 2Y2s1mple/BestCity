//
//  CZMHSDCommodityCell3.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDCommodityCell3 : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableVie;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** 是否是第一个 */
@property (nonatomic, assign) BOOL isFirstOne;
/** <#注释#> */
@property (nonatomic, strong) NSString *ID;
/** <#注释#> */
@property (nonatomic, strong) NSString *titleText;
@end

NS_ASSUME_NONNULL_END
