//
//  CZCommentModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZCommentModel : NSObject
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 用户信息 */
@property (nonatomic, strong) NSDictionary *userShopmember;


// 辅助
/** 真实显示的内容 */
@property (nonatomic, strong) NSString *realContent;
/** 姓名 */
@property (nonatomic, strong) NSString *nickName;
/** 真实显示的富文本内容 */
@property (nonatomic, strong) NSMutableAttributedString *attriString;
/** cell的高度 */
@property (nonatomic, assign) CGFloat labelHeight;
/** 缓存高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

