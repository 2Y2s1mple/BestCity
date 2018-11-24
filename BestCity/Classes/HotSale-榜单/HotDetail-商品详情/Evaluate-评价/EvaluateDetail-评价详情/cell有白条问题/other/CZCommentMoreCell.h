//
//  CZCommentMoreCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZCommentMoreCellDelegate <NSObject>
@optional
- (void)loadMoreBtnWithIndexPath:(NSIndexPath *)IndexPath;
@end

@interface CZCommentMoreCell : UITableViewCell
/** 剩余几个 */
@property (nonatomic, strong) NSString *count;
/** 当前的section */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 代理 */
@property (nonatomic, weak) id<CZCommentMoreCellDelegate> delegate;
@end


