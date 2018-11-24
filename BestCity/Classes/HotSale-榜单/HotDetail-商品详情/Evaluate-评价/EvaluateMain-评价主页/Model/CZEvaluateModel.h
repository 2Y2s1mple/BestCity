//
//  CZEvaluateModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluateModel : NSObject
/** 当前回复的ID */
@property (nonatomic, strong) NSString *commentId;
/** 文章ID */
@property (nonatomic, strong) NSString *articId;
/** 头像 */
@property (nonatomic, strong) NSString *fromImg;
/** 名字 */
@property (nonatomic, strong) NSDictionary *userShopmember;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 时间 */
@property (nonatomic, strong) NSString *createTime;
/** 当前点赞的数 */
@property (nonatomic, strong) NSString *snapNum;
/** 子评论的个数 */
@property (nonatomic, assign) NSString *secondNum;
/** 子评论 */
@property (nonatomic, strong) NSArray *userCommentList;


//辅助
/** 行数 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/** 返回的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 实际表单个数 */
@property (nonatomic, assign) NSInteger realCommentArrCount;
/** 控制的表单个数 */
@property (nonatomic, assign) NSInteger contrlCommentArrCount;
/** 判断时候有更多按钮 */
@property (nonatomic, assign) BOOL isMoreBtn;
/** 按钮显示的类型 */
@property (nonatomic, assign) NSInteger moreBtnType;

@end

NS_ASSUME_NONNULL_END
