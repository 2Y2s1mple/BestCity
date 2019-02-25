//
//  CZTwoController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZBaseRecommendController.h"
#import "CZHotSubTilteModel.h"
@class CZHotTitleModel;
@interface CZTwoController : CZBaseRecommendController
/** 大图片URL */
@property (nonatomic, strong) NSString *imageUrl;
/** 附标题 */
@property (nonatomic, strong) CZHotTitleModel *subTitles;

@end
