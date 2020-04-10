//
//  CZCategoryLineLayoutView.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CZCategoryLineLayoutViewType) {
    CZCategoryLineLayoutViewTypeDefault,
    CZCategoryLineLayoutViewTypeLine,
    CZCategoryLineLayoutViewTypeVertical,
};

@interface CZCategoryItem : NSObject
/** 设置选中的第几个 */
@property (nonatomic, assign) NSInteger selecedIndex;
@property (nonatomic, strong) NSString * categoryId;
@property (nonatomic, strong) NSString *categoryImage;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) NSInteger index;
/** 存储的各种数据 */
@property (nonatomic, strong) id objectInfo;
@end

@interface CZCategoryButton : UIButton
@end

@interface CZCategoryLineLayoutView : UIView
/** 处理数据 */
+ (NSArray *)categoryItems:(NSArray *)items setupNameKey:(NSString *)NameKey imageKey:(NSString *)imageKey IdKey:(NSString *)IdKey objectKey:(NSString *)objectKey;
/** 初始化, type : 0多行创建, 其他是一行创建 */
+ (instancetype)categoryLineLayoutViewWithFrame:(CGRect)frame Items:(NSArray <CZCategoryItem *> *)items type:(CZCategoryLineLayoutViewType)type didClickedIndex:(void (^)(CZCategoryItem *item))block;

#pragma mark - 刷新

/** 根据数组创建 */
@property (nonatomic, strong) NSArray <CZCategoryItem *> *categoryItems;
/** 每个item的数据 */
@property (nonatomic, strong) CZCategoryItem *categoryItem;

@end

NS_ASSUME_NONNULL_END
