//
//  CZRecommendNav.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CZRecommendNavType){
    CZRecommendNavDefault,
    CZRecommendNavDiscover,
};

@protocol CZRecommendNavDelegate <NSObject>
@optional
- (void)recommendNavWithPop:(UIView *)view;
- (void)didClickedTitleWithIndex:(NSInteger)index;
@end


@interface CZRecommendNav : UIView
@property (nonatomic, strong) NSArray *mainTitles;
- (instancetype)initWithFrame:(CGRect)frame type:(CZRecommendNavType)type;
/** 代理 */
@property (nonatomic, weak) id <CZRecommendNavDelegate> delegate;
/** 监听vc中scroller的滚动 */
@property (nonatomic, assign) NSInteger monitorIndex;

/** 商品的ID */
@property (nonatomic, strong) NSString *projectId;
/** 收藏的类型 */
@property (nonatomic, strong) NSString *type;
@end
