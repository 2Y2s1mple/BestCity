//
//  CZAllCriticalModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZAllCriticalModel : NSObject
/** 图片 */
@property (nonatomic, strong) NSString *icon;
/** 名字 */
@property (nonatomic, strong) NSString *name;
/** 内容 */
@property (nonatomic, strong) NSString *contentText;
/** 点赞数 */
@property (nonatomic, strong) NSString *likeNumber;
/** 时间 */
@property (nonatomic, strong) NSString *time;
/** 返回的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


+ (instancetype)allCriticalModelWithDic:(NSDictionary *)dic;

@end
