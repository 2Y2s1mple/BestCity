//
//  CZShareAndlikeView.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZShareView.h" // 分享详情


typedef void(^btnClickedBlock)(void);
@interface CZShareAndlikeView : UIView
- (instancetype)initWithFrame:(CGRect)frame leftBtnAction:(btnClickedBlock)leftBlock rightBtnAction:(btnClickedBlock)rightBlock;
/** 数据 */
@property (nonatomic, strong) NSDictionary *titleData;
@end
