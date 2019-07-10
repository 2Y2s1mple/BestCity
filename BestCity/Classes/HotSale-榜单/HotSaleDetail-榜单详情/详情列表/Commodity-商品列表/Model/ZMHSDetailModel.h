//
//  ZMHSDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMHSDetailModel : NSObject
/** 列表 */
@property (nonatomic, strong) NSArray *relatedGoodsList;
/** 百科 */
@property (nonatomic, strong) NSDictionary *relatedPedia;
/** 话题问答 */
@property (nonatomic, strong) NSArray *relatedQuestionList;
/** 性价比排行 */
@property (nonatomic, strong) NSArray *relatedItemCategotyList;
/** 测评推荐 */
@property (nonatomic, strong) NSArray *relatedArticleList;

/** 名称 */
@property (nonatomic, strong) NSString *categoryName;
@end

NS_ASSUME_NONNULL_END
