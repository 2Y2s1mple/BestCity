//
//  CZDiscoverDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/17.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZDiscoverDetailModel : NSObject
/** 主标题 */
@property (nonatomic, strong) NSString *title;
/** ID */
@property (nonatomic, strong) NSString *articleId;
/** 大图片 */
@property (nonatomic, strong) NSString *img;
/** 文章用户信息 */
@property (nonatomic, strong) NSDictionary *user;
/** 访问量 */
@property (nonatomic, strong) NSString *pv;
/** 跳转类型 1商品，2评测, 3发现，4试用 */
@property (nonatomic, strong) NSString *type;

/** 辅助 */
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

