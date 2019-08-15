//
//  CZEInventoryAddGoodsCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZEInventoryAddGoodsCellViewMdoel.h"

NS_ASSUME_NONNULL_BEGIN

extern int addGoodsNumber;

@interface CZEInventoryAddGoodsCell : UITableViewCell

+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) CZEInventoryAddGoodsCellViewMdoel *viewModel;
/** <#注释#> */
@property (nonatomic, strong) void (^block) (void);

@end

NS_ASSUME_NONNULL_END
