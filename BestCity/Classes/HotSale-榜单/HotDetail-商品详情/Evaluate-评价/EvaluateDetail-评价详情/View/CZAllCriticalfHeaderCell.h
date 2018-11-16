//
//  CZAllCriticalfHeaderCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZEvaluateModel.h"

@protocol CZAllCriticalfHeaderCellDelegate <NSObject>
@optional
- (void)showMoreCommentCell:(NSIndexPath *)indexPath;
@end

@interface CZAllCriticalfHeaderCell : UITableViewCell
@property (nonatomic, strong) CZEvaluateModel *model;
/** 代理 */
@property (nonatomic, weak) id<CZAllCriticalfHeaderCellDelegate> delegate;
@end

