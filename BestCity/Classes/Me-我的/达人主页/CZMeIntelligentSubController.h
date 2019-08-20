//
//  CZMeIntelligentSubController.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
// 视图
#import "CZTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZMeIntelligentSubController : UIViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *freeID;
@property (nonatomic, strong) CZTableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSString *type;
@end

NS_ASSUME_NONNULL_END
