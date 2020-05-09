//
//  CZFestivalCollectOneCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectOneCell.h"
#import "UIImageView+WebCache.h"

// 跳转
#import "CZSubFreeChargeController.h"
#import "CZSubFreePreferentialController.h" // 特惠购

#import "CZFreePushTool.h"

// 滚动广告位
#import "CZScrollAD.h"

// 不是新人的时候显示
#import "CZFestivalCollectMillionsView.h"

@interface CZFestivalCollectOneCell ()

/** 跑马灯 */
@property (weak, nonatomic) IBOutlet CZScrollAD *messageListView;
/** 新人 */
@property (nonatomic, weak) IBOutlet UIView *peopleNewView;
@property (nonatomic, weak) IBOutlet UILabel *peopleNewViewLabel; // 新人大标题
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleNewViewHeight;

@property (nonatomic, weak) IBOutlet UIImageView *image1; // 图片
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;
@property (nonatomic, weak) IBOutlet UILabel *title1; // 文字
@property (nonatomic, weak) IBOutlet UILabel *title2;
@property (nonatomic, weak) IBOutlet UILabel *title3;
@property (nonatomic, weak) IBOutlet UILabel *title4;
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;
@property (nonatomic, weak) IBOutlet UILabel *label4;

/** 老人才百万返现 */
@property (nonatomic, strong) CZFestivalCollectMillionsView *millionsView;


/** go图片 */
@property (nonatomic, weak) IBOutlet UIImageView *goImageVeiw;


@end

@implementation CZFestivalCollectOneCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 跑马灯
    UITapGestureRecognizer *messageListViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMessageListView)];
    [self.messageListView addGestureRecognizer:messageListViewTap];
    self.messageListView.type = 0;
    self.messageListView.layer.cornerRadius = 4;
    self.messageListView.layer.masksToBounds = YES;

    self.peopleNewViewLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.title4.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.title1.font = self.title4.font;
    self.title2.font = self.title4.font;
    self.title3.font = self.title4.font;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPeopleNew)];
    self.peopleNewView.userInteractionEnabled = YES;
    [self.peopleNewView addGestureRecognizer:tap];

    // 百万返现
    self.millionsView = [CZFestivalCollectMillionsView festivalCollectMillionsView];
    self.millionsView.width = SCR_WIDTH - 30;
    self.millionsView.height = 118;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPreferential)];
    self.millionsView.userInteractionEnabled = YES;
    [self.millionsView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainHighBackViewAction)];
    self.goImageVeiw.userInteractionEnabled = YES;
    [self.goImageVeiw addGestureRecognizer:tap2];
}

- (void)setAllowanceGoodsList:(NSArray *)allowanceGoodsList
{
    _allowanceGoodsList = allowanceGoodsList;

    // 跑马灯
    self.messageListView.dataSource = self.messageList;

    // 如果是未登陆状态
    if ([JPTOKEN length] <= 0) {
        // 新人0元和百万补贴互换
        [self changeNewPeopleAndMillion:_allowanceGoodsList isNewUser:YES];
    } else {
        // 新人0元和百万补贴互换
        [self changeNewPeopleAndMillion:_allowanceGoodsList isNewUser:self.newUser];
    }
    
    // go大图片
    [self.goImageVeiw sd_setImageWithURL:[NSURL URLWithString:self.model.ad2[@"img"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.model.peopleNewZeroViewHeight = CZGetY(self.goImageVeiw);
    }];
    
    [self layoutIfNeeded];
    
    self.model.peopleNewCellHeight = CZGetY(self.goImageVeiw);
}

// 新人0元和百万补贴互换
- (void)changeNewPeopleAndMillion:(NSArray *)allowanceGoodsList isNewUser:(BOOL)isNewUser
{
    // 老人
    if (isNewUser == NO) {
        self.peopleNewViewHeight.constant = 118;
        self.millionsView.allowanceGoodsList = allowanceGoodsList;
        [self.peopleNewView addSubview:self.millionsView];

    } else { // 新人0元购
        [self.millionsView removeFromSuperview];
        self.peopleNewView.hidden = NO;
        self.peopleNewViewHeight.constant = 142;
        
        for (int i = 0; i < allowanceGoodsList.count; i++) {
            NSDictionary *imageDic = [allowanceGoodsList[i] changeAllValueWithString];
            NSString *image = imageDic[@"img"];
            NSString *text = [NSString stringWithFormat:@"¥%@", imageDic[@"buyPrice"]];
            NSAttributedString *attrText = [text addStrikethroughWithRange:NSMakeRange(0, text.length)];

            switch (i) {
                case 0:
                    [self.image1 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label1.attributedText = attrText;
                    break;
                case 1:
                    [self.image2 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label2.attributedText = attrText;
                    break;
                case 2:
                    [self.image3 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label3.attributedText = attrText;
                    break;
                case 3:
                    [self.image4 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label4.attributedText = attrText;
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - 事件
// 跳转到新人专区
- (void)pushPeopleNew
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_xinren"];
    CURRENTVC(currentVc);
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 跳特惠购
- (void)pushPreferential
{
    ISPUSHLOGIN
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_tehui"];
    CURRENTVC(currentVc);
    CZSubFreePreferentialController *vc = [[CZSubFreePreferentialController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 跳到极品城购物返现说明
- (void)pushMessageListView
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_pmd"];
    // push省钱攻略
    [CZFreePushTool push_freeMoney];
}

// 大图跳转
- (void)mainHighBackViewAction
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_zhuanti"];
    NSDictionary *dic =  self.model.ad2;
    NSDictionary *param = @{
        @"targetType" : dic[@"type"],
        @"targetId" : dic[@"objectId"],
        @"targetTitle" : dic[@"name"],
    };
    [CZFreePushTool bannerPushToVC:param];
}

//// 如果要从cell里面得出计算的高度, 1, 设置estimatedItemSize, 2, 重写这个方法. 具体原因不详
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    // 老人
    if (self.newUser == NO) {
        attributes.size = CGSizeMake(SCR_WIDTH,  327 - 24);
    } else {
        attributes.size = CGSizeMake(SCR_WIDTH,  327);
    }
    return attributes;
}



@end
