//
//  CZDiscountCouponCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CZDiscountCouponCellType) {
    CZDiscountCouponCellTypeUnused,
    CZDiscountCouponCellTypeUsed,
    CZDiscountCouponCellTypePastDue,
};

@interface CZDiscountCouponCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** cell的类型 */
@property (nonatomic, assign) CZDiscountCouponCellType type;
@end
