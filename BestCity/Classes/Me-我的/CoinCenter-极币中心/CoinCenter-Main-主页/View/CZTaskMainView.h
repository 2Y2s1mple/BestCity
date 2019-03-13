//
//  CZTaskMainView.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZTaskMainViewDelegate <NSObject>
@optional
- (void)reloadContentView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CZTaskMainView : UIView
@property (nonatomic, weak) id <CZTaskMainViewDelegate> delegate;
/** 数据 */
@property (nonatomic, strong) NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
