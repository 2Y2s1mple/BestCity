//
//  CZERecommendCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZEvaluationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZERecommendCell : UITableViewCell <CZEvaluationProtocol>
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 刷新列表 */
@property (nonatomic, strong) void (^cellWithBlcok)(NSString *ID, BOOL isFollow);
@end

NS_ASSUME_NONNULL_END
