//
//  CZTrialApplySuccessModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/4/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialApplySuccessModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *reportStatus;
@property (nonatomic, strong) NSString *reportEndTime;
@property (nonatomic, strong) NSString *confirmTime;
@property (nonatomic, strong) NSString *activitiesEndTime;
@property (nonatomic, strong) NSString *voteShareTitle;
@property (nonatomic, strong) NSString *voteShareContent;
@property (nonatomic, strong) NSString *voteShareUrl;
@property (nonatomic, strong) NSString *voteShareImg;

/** <#注释#> */
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
