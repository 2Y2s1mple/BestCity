//
//  CZDChoicenessController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CZDChoicenessControllerType) {
    CZDChoicenessControllerTypeDiscover,
    CZDChoicenessControllerTypeEvaluation,
};

@interface CZDChoicenessController : UIViewController
/**  标题的ID */
@property (nonatomic, strong) NSString *titleID;
/** 大图片URL */
@property (nonatomic, strong) NSArray *imageUrlList;
/** 类型 */
@property (nonatomic, assign) CZDChoicenessControllerType type;
@end
