//
//  CZGuessWhatYouLikeView.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CZGuessWhatYouLikeViewDelegate <NSObject>
@optional
- (void)reloadGuessWhatYouLikeView;
@end

@interface CZGuessWhatYouLikeView : UIView
+(instancetype)guessWhatYouLikeView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *list;
/** <#注释#> */
@property (nonatomic, strong) NSString *otherGoodsId;
/** <#注释#> */
@property (nonatomic, weak) id <CZGuessWhatYouLikeViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
