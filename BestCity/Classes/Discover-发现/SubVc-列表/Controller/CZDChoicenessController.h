//
//  CZDChoicenessController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZDChoicenessController : UIViewController
/**  标题的ID */
@property (nonatomic, strong) NSString *titleID;
/** 大图片URL */
@property (nonatomic, strong) NSArray *imageUrlList;
/** 类型 */
@property (nonatomic, assign) CZJIPINModuleType type;
@end
