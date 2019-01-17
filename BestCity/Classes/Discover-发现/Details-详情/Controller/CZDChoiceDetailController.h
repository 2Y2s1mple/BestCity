//
//  CZDChoiceDetailController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CZDChoiceDetailControllerType) {
    CZDChoiceDetailControllerDiscover,
    CZDChoiceDetailControllerEvaluation,
};
@interface CZDChoiceDetailController : UIViewController
/** Id */
@property (nonatomic, strong) NSString *findgoodsId;
/** 详情的类型 */
@property (nonatomic, assign)  CZDChoiceDetailControllerType detailType;

@end
