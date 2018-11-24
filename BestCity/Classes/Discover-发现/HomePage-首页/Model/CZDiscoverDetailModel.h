//
//  CZDiscoverDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/17.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CZDiscoverDetailModel : NSObject
/** ID */
@property (nonatomic, strong) NSString *findgoodsId;
/** 大图片 */
@property (nonatomic, strong) NSString *imgId;
/** 主标题 */
@property (nonatomic, strong) NSString *title;
/** 附标题 */
@property (nonatomic, strong) NSString *smallTitle;
/** 时间 */
@property (nonatomic, strong) NSString *publishTime;
/** 访问量 */
@property (nonatomic, strong) NSString *visitCount;
@end

