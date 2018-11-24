//
//  CZAttentionDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/20.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZAttentionDetailModel : NSObject
/** ID */
@property (nonatomic, strong) NSString *articleId;
/** 图片 */
@property (nonatomic, strong) NSString *img;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 附标题 */
@property (nonatomic, strong) NSString *smallTitle;
/** 创建时间 */
@property (nonatomic, strong) NSString *publishTime;
/** 访问量 */
@property (nonatomic, strong) NSString *visitCount;
/** 评论量 */
@property (nonatomic, strong) NSString *commentNum;

/** 辅助 */
/** 记录高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
