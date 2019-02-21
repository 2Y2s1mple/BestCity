//
//  CZHotListController.h
//  BestCity
//
//  Created by JasonBourne on 2019/2/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "WMPageController.h"
#import "CZHotTitleModel.h"

@interface CZHotListController : WMPageController
- (void)setUpPorperty;
/** 标题 */
@property (nonatomic, strong) NSString *mainTitle;
/** 子标题 */
@property (nonatomic, strong) NSArray <CZHotTitleModel *> *subTitles;
/** 是否是二级列表 */
@property (nonatomic, assign) BOOL isList2;
/** 类型: 1热卖榜，2轻奢榜，3新品榜，4性价比榜 */
@property (nonatomic, assign) NSInteger type;
@end


