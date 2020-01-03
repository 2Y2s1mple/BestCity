//
//  CZCollectButton.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/21.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCollectButton : UIButton
+ (instancetype)collectButton;
/** 商品 */
@property (nonatomic, strong) NSString *projectId;
/** 发现 */
@property (nonatomic, strong) NSString *findGoodsId;
/** 测评 */
@property (nonatomic, strong) NSString *evalId;

/** 商品ID */
@property (nonatomic, strong) NSString *commodityID;
/** 类型: 1商品，2评测, 3发现，4试用 */
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
