//
//  CZAllHotListController.h
//  BestCity
//
//  Created by JasonBourne on 2019/2/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "WMPageController.h"
#import "CZHotTitleModel.h"

@interface CZAllHotListController : WMPageController
/** 子标题 */
@property (nonatomic, strong) CZHotTitleModel *subTitlesModel;
- (void)setUpPorperty;
@end

