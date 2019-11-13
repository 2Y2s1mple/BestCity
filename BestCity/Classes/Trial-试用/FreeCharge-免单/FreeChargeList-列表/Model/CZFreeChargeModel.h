//
//  CZFreeChargeModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *userCount;
@property (nonatomic, strong) NSString *actualPrice;
@property (nonatomic, strong) NSString *otherPrice;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *inviteUserCount;
@property (nonatomic, strong) NSString *myInviteUserCount;





/** 开始时间 */
@property (nonatomic, strong) NSString *activitiesStartTime;
// 辅助
@property (nonatomic, assign) CGFloat cellHeight;


// 详情
@property (nonatomic, strong) NSArray *imgList;
/** -1未申请，0申请成功未付款，1已付款 */
@property (nonatomic, strong) NSString *applyStatus;
/** 免单金额 */
@property (nonatomic, strong) NSString *freePrice;
/** 付款剩余时间 */
@property (nonatomic, strong) NSString *dendlineTime;
/** 淘宝需要 */
@property (nonatomic, strong) NSString *goodsId;
/** 详情界面 */
@property (nonatomic, strong) NSArray *goodsContentList;
/** 规则 */
@property (nonatomic, strong) NSString *freeGuide;
/** 免单粉色提示 */
@property (nonatomic, strong) NSString *freeNote;
@end

NS_ASSUME_NONNULL_END
