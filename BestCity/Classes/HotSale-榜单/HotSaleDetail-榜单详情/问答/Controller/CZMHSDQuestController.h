//
//  CZMHSDQuestController.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDQuestController : UIViewController
/** 标题 */
@property (nonatomic, strong) NSString *titleText;
/** 数据 */
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *ID;
@end

NS_ASSUME_NONNULL_END
