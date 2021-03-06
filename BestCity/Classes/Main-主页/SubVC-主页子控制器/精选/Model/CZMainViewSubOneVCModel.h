//
//  CZMainViewSubOneVCModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/17.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMainViewSubOneVCModel : NSObject
/** 轮播图 */
@property (nonatomic, strong) NSArray *ad1List;
/** 宫格图 */
@property (nonatomic, strong) NSArray *boxList;
/** 新人专区 */
@property (nonatomic, strong) NSArray *allowanceGoodsList;
/** 右边单独圆角专区 */
@property (nonatomic, strong) NSArray *activityList;
/** 今日爆款 */
@property (nonatomic, strong) NSDictionary *hotActivity;
/** 广告位 */
@property (nonatomic, strong) NSDictionary *ad2;
/** 热销榜单 */
@property (nonatomic, strong) NSArray *hotGoodsList;
/** 跑马灯 */
@property (nonatomic, strong) NSArray *messageList;
/** 是否是新人 */
@property (nonatomic, assign) BOOL newUser;
/** 新手必看高度 */
@property (nonatomic, assign) CGFloat peopleNewZeroViewHeight;
/** 新人0元购高度 */
@property (nonatomic, assign) CGFloat peopleNewCellHeight;
@end

NS_ASSUME_NONNULL_END
