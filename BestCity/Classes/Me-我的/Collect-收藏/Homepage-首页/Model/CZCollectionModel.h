//
//  CZCollectionModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CZCollectionModel : NSObject
/** 图片 */
@property (nonatomic, strong) NSString *product_img;
/** 标题 */
@property (nonatomic, strong) NSString *collect_message;
/** 标签 */
@property (nonatomic, strong) NSArray *product_tabs;
/** 现价 */
@property (nonatomic, strong) NSString *collect_price;
/** 原价 */
@property (nonatomic, strong) NSString *product_price;
/** 访问量 */
@property (nonatomic, strong) NSString *collect_nubmer;
@end

NS_ASSUME_NONNULL_END
