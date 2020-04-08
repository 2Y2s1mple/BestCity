//
//  CZGoodsScoreView.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZGoodsScoreView : UIView
+ (instancetype)goodsScoreView;
@property (nonatomic, strong) NSDictionary *detailModel;
@property (nonatomic, strong) NSString *titleName;
/** 评分view */
@property (weak, nonatomic) IBOutlet UIView *pointView;
/** 综合评分 */
@property (nonatomic, weak) IBOutlet UILabel *comprehensiveScoreLabel;
/** 评分中第1个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreFirstImageConstraint;
/** 评分中第1个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreFirstName;
/** 评分中第1个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score1;
/** 评分中第2个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreSecondImageConstraint;
/** 评分中第2个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreSecondName;
/** 评分中第2个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score2;
/** 评分中第3个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreThreeImageConstraint;
/** 评分中第3个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreThreeName;
/** 评分中第3个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score3;
/** 评分中第4个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreThirdImageConstraint;
/** 评分中第4个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreThirdName;
/** 评分中第4个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score4;
/** 评分中第5个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreFiveImageConstraint;
/** 评分中第5个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreFiveName;
/** 评分中第5个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score5;
/** 评分中第5个的View */
@property (nonatomic, weak) IBOutlet UIView *scoreFiveView;
@end

NS_ASSUME_NONNULL_END
