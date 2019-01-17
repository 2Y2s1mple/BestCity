//
//  CZCommodityDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCommodityDetailModel : NSObject
/** 商品介绍 */
@property (nonatomic, strong) NSArray *parametersList;
/** 商品ID */
@property (nonatomic, strong) NSString *goodsId;
/** 购买链接 */
@property (nonatomic, strong) NSString *goodsBuyLink;
/** 分享标题 */
@property (nonatomic, strong) NSString *shareTitle;
/** 分享内容 */
@property (nonatomic, strong) NSString *shareContent;
/** 分享的URL */
@property (nonatomic, strong) NSString *shareUrl;
/** 分享的图片 */
@property (nonatomic, strong) NSString *shareImg;
@end

NS_ASSUME_NONNULL_END
