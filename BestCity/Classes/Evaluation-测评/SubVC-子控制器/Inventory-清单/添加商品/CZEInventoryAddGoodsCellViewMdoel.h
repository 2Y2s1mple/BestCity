//
//  CZEInventoryAddGoodsCellViewMdoel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEInventoryAddGoodsCellViewMdoel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataDic;
/** <#注释#> */
@property (nonatomic, assign) BOOL isSelected;
/** 关联的ID */
@property (nonatomic, strong) NSString *articleId;

- (instancetype)initWithviewModel:(NSDictionary *)dataDic;
@end

NS_ASSUME_NONNULL_END
