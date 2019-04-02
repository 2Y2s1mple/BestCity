//
//  CZTrialApplyForCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialApplyForCell.h"
#import "UIImageView+WebCache.h"
#import "CZShareView.h"

@interface CZTrialApplyForCell ()
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 第一行文字 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 第二行文字 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
/** 第三行文字 */
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
/** 获赞 */
@property (nonatomic, weak) IBOutlet UILabel *praiseLabel;
/** 集赞按钮 */
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
@end

@implementation CZTrialApplyForCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZTrialApplyForCell";
    CZTrialApplyForCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

/** 分享集赞 */
- (IBAction)shareBtnAction
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = (UINavigationController *)tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    
    CZShareView *share = [[CZShareView alloc] initWithFrame:vc.view.frame];
//    share.param = @{
//                    @"shareUrl" : self.dataSource[@"shareUrl"], 
//                    @"shareTitle" : self.dataSource[@"shareTitle"],
//                    @"shareContent" : self.dataSource[@"shareContent"],
//                    @"shareImg" : self.dataSource[@"shareImg"],
//                    };
    [vc.view addSubview:share];
}

- (void)setDicData:(NSDictionary *)dicData
{
    _dicData = dicData;
//    [self.bigImage sd_setImageWithURL:dicData[@""]];
//    self.titleLabel.text = dicData[@""];
//    self.subTitleLabel.text = dicData[@""];
//    self.statusLabel.text = dicData[@""];
//    self.praiseLabel.text = dicData[@""];
    
    self.bigImage.image = [UIImage imageNamed:@"testImage1"];
    self.titleLabel.text = @"便携式果蔬榨汁料理机gx";
    self.subTitleLabel.text = @"预计2018-08-22 公布名单gx";
    self.statusLabel.text = @"审核中gx";
    self.praiseLabel.text = @"已获397个赞gx";
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
