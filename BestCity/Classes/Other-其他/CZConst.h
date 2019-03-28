//
//  CZConst.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/9.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString * const OpenBoxInspectWebHeightKey;
UIKIT_EXTERN NSString * const loginChangeUserInfo;
UIKIT_EXTERN NSString * const systemMessageDetailControllerMessageRead;
UIKIT_EXTERN NSString * const attentionCellNotifKey;
UIKIT_EXTERN NSString * const requiredVersionCode;
UIKIT_EXTERN BOOL appVersion;
/** 收藏通知的KEY */
UIKIT_EXTERN NSString * const collectNotification;

typedef NS_ENUM(NSInteger, CZJIPINModuleType){
    CZJIPINModuleHotSale,
    CZJIPINModuleDiscover,
    CZJIPINModuleEvaluation,
    CZJIPINModuleTrail,
    CZJIPINModuleTrailReport,
    CZJIPINModuleMe,
};
