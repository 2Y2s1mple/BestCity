//
//  CZGiveLikeView.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZGiveLikeView : UIView
/** 判断是否点击了小手 */
@property (nonatomic, assign) BOOL isClicked;
/** 改文章的ID */
@property (nonatomic, strong) NSString *currentID;
/** 发现的ID */
@property (nonatomic, strong) NSString *findGoodsId;
/** 评测的ID */
@property (nonatomic, strong) NSString *evalId;
@end
