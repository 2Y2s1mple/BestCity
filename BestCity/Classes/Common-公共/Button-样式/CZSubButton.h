//
//  CZSubTitleButton.h
//  BestCity
//
//  Created by JasonBourne on 2019/2/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZHotSubTilteModel.h"
#import "CZArrowButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZSubButton : UIButton
@property (nonatomic, strong) CZHotSubTilteModel *model;

@property (nonatomic, strong) NSString *categoryId;

@property (nonatomic, strong) NSString *categoryName;

@property (nonatomic, strong) NSString *categoryType;
@end

NS_ASSUME_NONNULL_END
