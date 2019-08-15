//
//  CZEAttentionCommendCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZEvaluationProtocol.h"


NS_ASSUME_NONNULL_BEGIN
@interface CZEAttentionCommendCell : UITableViewCell <CZEvaluationProtocol>

+ (instancetype)cellwithTableView:(UITableView *)tableView;

@end
NS_ASSUME_NONNULL_END
