//
//  CZRecommendListModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/22.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZRecommendListModel : NSObject
//"goodTag": [
//            "成人",
//            "小资"
//            ],
//"goodsFromBrand": "天猫",
//"goodsGrade": 7.875,
//"goodsImgPath": "http://192.168.5.2:8080/ea_cs_tmall_app/images/1.png",
//"goodsLinkText": "双十一大促特卖飞利浦电动牙刷HX3216",
//"goodsPrice": 199,
//"gradeWays": [],
//"linkRef": "http://www.baidu.com",
//"othersPrice": 290,
//"recommendReason": "飞利浦电动牙刷HX3216是飞利浦退出入门级产品,采用声波震动技术原理,每分钟23000次/分,1种模式,是初次使用电动牙刷的首选。",
//"savePrice": 20,
//"visitCount": "93.70万"
//

/** 标题 */
@property (nonatomic, strong) NSString *goodsLinkText;

/** 标签 */
@property (nonatomic, strong) NSString *goodTag;

/** 标题 */
@property (nonatomic, strong) NSString *goodsFromBrand;



@end
