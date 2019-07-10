//
//  CZGiveLikeView.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZGiveLikeView : UIView
/** 文章的ID */
@property (nonatomic, strong) NSString *currentID;
/** 文章的类型: 1商品，2评测, 3发现，4试用 */
@property (nonatomic, strong) NSString *type;



// 后期要去掉
/** 发现的ID */
@property (nonatomic, strong) NSString *findGoodsId;
/** 评测的ID */
@property (nonatomic, strong) NSString *evalId;


@end
