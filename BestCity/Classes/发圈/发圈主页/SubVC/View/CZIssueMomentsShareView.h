//
//  CZIssueMomentsShareView.h
//  BestCity
//
//  Created by JasonBourne on 2020/3/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZIssueMomentsShareView : UIView
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) IBOutlet UILabel *shareNumber;
/** <#注释#> */
@property (nonatomic, strong) NSString *momentId;
/** <#注释#> */
@end

NS_ASSUME_NONNULL_END
