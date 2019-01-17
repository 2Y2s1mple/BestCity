//
//  CZVoteShowView.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZVoteShowView : UIView
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 赞个数 */
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

+ (instancetype)voteShowView;
@end

NS_ASSUME_NONNULL_END
