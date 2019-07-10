//
//  CZHotTagLabel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/5.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZHotTagLabel;
typedef enum : NSUInteger {
    CZHotTagLabelTypeTapGesture,
    CZHotTagLabelTypeLongPressGesture,
    CZHotTagLabelTypeDefault,
} CZHotTagLabelType;

@protocol CZHotTagLabelDelegate <NSObject>
@optional
/** 长按手势 */
- (void)hotTagLabel:(CZHotTagLabel *)label longPressAccessoryEvent:(UIButton *)sender;
/** 点击事件 */
- (void)hotTagLabelWithTapEvent:(CZHotTagLabel *)label;
@end

@interface CZHotTagLabel : UILabel
/** 类型 */
@property (nonatomic, assign) CZHotTagLabelType type;
/** 代理 */
@property (nonatomic, assign) id<CZHotTagLabelDelegate> delegate;
@end


