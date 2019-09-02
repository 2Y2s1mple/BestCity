//
//  CZTestDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTestDetailModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 用户信息 */
@property (nonatomic, strong) NSDictionary *user;
/** 创建时间 */
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *createTimeStr;
/** 判断内容是否HTML 1: html 3: json */ 
@property (nonatomic, assign) NSInteger contentType;
/** 内容HTML */
@property (nonatomic, strong) NSString *content;
/** 当前的ID */
@property (nonatomic, strong) NSString *articleId;
/** 分享标题 */
@property (nonatomic, strong) NSString *shareTitle;
/** 分享内容 */
@property (nonatomic, strong) NSString *shareContent;
/** 分享的URL */
@property (nonatomic, strong) NSString *shareUrl;
/** 分享的图片 */
@property (nonatomic, strong) NSString *shareImg;
/** 购买数据 */
@property (nonatomic, strong) NSArray *relatedGoodsList;
/** 相关商品 */
@property (nonatomic, strong) NSArray *relatedArticleList;
/** <#注释#> */
@property (nonatomic, strong) NSString *remark;

@end

NS_ASSUME_NONNULL_END
