//
//  CZConst.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/9.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
NSString * const OpenBoxInspectWebHeightKey = @"OpenBoxInspectViewWebViewWidthNotifiKey";
/** 登录成功时候发送的通知KEY */
NSString * const loginChangeUserInfo = @"loginChangeUserInfo";
/** 系统消息通知 */
NSString * const systemMessageDetailControllerMessageRead = @"systemMessageDetailControllerMessageRead";
/** 关注时候发测评通知 */
NSString * const attentionCellNotifKey = @"CZAttentionCellNotifKey";
/** 记录是否更新 */
NSString * const requiredVersionCode = @"requiredVersionCode";

/** 收藏通知的KEY */
NSString * const collectNotification = @"collectNotification";

/** 记录搜索的字段 */
NSMutableArray *recordSearchTextArray;

/** 根路径 */
NSString *JPSERVER_URL;

/** 存弹框的数组 */
NSMutableArray *alertList_;

/** 广告数据 */
NSArray *aDImage;

/** 推动数据 */
NSDictionary *PushData_;

/** 全局版本号KEY */
NSString * const CZVERSION_ = @"CZVersion";




