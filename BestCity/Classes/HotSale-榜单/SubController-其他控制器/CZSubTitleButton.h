//
//  CZSubTitleButton.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZHotSubTilteModel;
NS_ASSUME_NONNULL_BEGIN

@interface CZSubTitleButton : UIButton
/** 标题模型 */
@property (nonatomic, strong) CZHotSubTilteModel *model;
@end

NS_ASSUME_NONNULL_END
