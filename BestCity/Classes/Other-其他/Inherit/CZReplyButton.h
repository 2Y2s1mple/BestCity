//
//  CZReplyButton.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CZReplyButton : UIButton
/** ID */
@property (nonatomic, strong) NSString *commentId;
/** 姓名 */
@property (nonatomic, strong) NSString *name;
@end

