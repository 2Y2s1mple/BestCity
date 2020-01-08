//
//  CZFestivalCollectOneCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFestivalCollectOneCell : UICollectionViewCell
/** 新人专区 */
@property (nonatomic, strong) NSArray *allowanceGoodsList;
/** 是否是新人 */
@property (nonatomic, assign) BOOL newUser;
/** 高反专区 */
@property (nonatomic, strong) NSArray *activityList;
/** 今日爆款 */
@property (nonatomic, strong) NSDictionary *hotActivity;
/** 广告位 */
@property (nonatomic, strong) NSDictionary *ad2;
/** 跑马灯 */
@property (nonatomic, strong) NSArray *messageList;
@end

NS_ASSUME_NONNULL_END
