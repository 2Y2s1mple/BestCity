//
//  CZTwoController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZBaseRecommendController.h"
@class CZHotSubTilteModel;
@interface CZTwoController : CZBaseRecommendController
/** 大图片URL */
@property (nonatomic, strong) NSString *imageUrl;
/** 附标题 */
@property (nonatomic, strong) NSArray<CZHotSubTilteModel *> *subTitles;
@end
