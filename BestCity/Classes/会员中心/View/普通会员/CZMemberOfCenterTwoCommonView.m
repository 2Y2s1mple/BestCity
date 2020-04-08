//
//  CZMemberOfCenterTwoCommonView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/1.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterTwoCommonView.h"
#import "UIImageView+WebCache.h"
#import "CZMemberOfCenterTool.h"

@interface CZMemberOfCenterTwoCommonView ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UILabel *nickname;
@property (nonatomic, weak) IBOutlet UIImageView *levelImage;
@end

@implementation CZMemberOfCenterTwoCommonView

+ (instancetype)mMemberOfCenterTwoCommonView
{
    // 父视图的高度, 如果想跟图片自适应的话, 暂时的在外面设置
    CZMemberOfCenterTwoCommonView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
//    [view layoutIfNeeded];
    view.height = CZGetY(view.imageView);
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    return view;
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:param[@"avatar"]]];
    self.nickname.text = param[@"nickname"];
    self.imageView.image = [CZMemberOfCenterTool toolUserStatus:param][1];
    self.levelImage.image = [CZMemberOfCenterTool toolUserStatus:param][0];
}

@end
