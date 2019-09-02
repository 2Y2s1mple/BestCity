//
//  CZETestModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZETestModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *pv;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 发布时间 */
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *createTime;
/** 拒绝原因 */
@property (nonatomic, strong) NSString *remark;
/** 辅助 */
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
