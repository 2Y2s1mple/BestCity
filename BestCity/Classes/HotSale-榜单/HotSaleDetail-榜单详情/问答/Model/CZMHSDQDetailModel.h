//
//  CZMHSDQDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDQDetailModel : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userNickname;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) NSNumber *vote;
@property (nonatomic, strong) NSString *ID;
// 高度
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
