//
//  CZHotTagsView.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/6.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZHotTagLabel.h"
@class CZHotTagsView;
@protocol CZHotTagsViewDelegate <NSObject>
@optional
- (void)hotTagsView:(CZHotTagsView *)tagsView didSelectedTag:(CZHotTagLabel *)tagLabel;
- (void)hotTagsViewLongPressAccessoryEvent;

- (void)deleteTags;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CZHotTagsView : UIView
/** 代理 */
@property (nonatomic, assign) id<CZHotTagsViewDelegate> delegate;
/** 最大存储量 */
@property (nonatomic, assign) NSInteger maxNumber;
/** 历史搜索 */
@property (nonatomic, strong) NSMutableArray *hisArray;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 类型 */
@property (nonatomic, assign) CZHotTagLabelType type;

/** <#注释#> */
@property (nonatomic, assign) BOOL isShow;

/** 创建标签方法 */
- (void)createTagLabelWithTitle:(NSString *)title withEventType:(CZHotTagLabelType)type;
- (void)reloadSubViews;


- (void)showAll;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
