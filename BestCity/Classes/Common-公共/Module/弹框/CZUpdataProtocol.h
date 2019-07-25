//
//  CZUpdataProtocol.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#ifndef CZUpdataProtocol_h
#define CZUpdataProtocol_h

@protocol CZUpdataProtocol <NSObject>
@optional
/** 更新数据 */
@property (nonatomic, strong) NSDictionary *versionMessage;
+ (instancetype)updataViewWithFrame:(CGRect)frame;
- (UIView *)getView;
@end
#endif /* CZUpdataProtocol_h */
