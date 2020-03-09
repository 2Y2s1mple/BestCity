//
//  CZTaobaoGoodsView.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTaobaoGoodsView : UIView
+ (instancetype)taobaoGoodsView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *model;
/** 总数据 */
@property (nonatomic, strong) NSDictionary *allDetailModel;

/** 记录xib的尺寸 */
@property (nonatomic, assign) CGFloat commodityH;
@property (nonatomic, weak) IBOutlet UIImageView *BottomImageView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *couponBtn;

/** 优惠券 */
@property (nonatomic, weak) IBOutlet UILabel *couponPrice;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label3;
@end

NS_ASSUME_NONNULL_END
