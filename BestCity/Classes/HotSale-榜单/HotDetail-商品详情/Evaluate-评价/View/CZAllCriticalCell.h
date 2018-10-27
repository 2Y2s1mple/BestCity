//
//  CZAllCriticalCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZAllCriticalModel.h"

@interface CZAllCriticalCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, assign) CGFloat height;
/** <#注释#> */
@property (nonatomic, strong) CZAllCriticalModel *model;
/** <#注释#> */
@property (nonatomic, assign) CGFloat textHeight;
@end
