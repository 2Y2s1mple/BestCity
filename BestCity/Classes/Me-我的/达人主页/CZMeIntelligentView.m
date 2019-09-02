//
//  CZMeIntelligentView.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMeIntelligentView.h"
#import "UIImageView+WebCache.h"
#import "CZMyProfileController.h"
extern BOOL isUserInfo;
@interface CZMeIntelligentView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *genderImageView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
/** 关注 : follow */
@property (nonatomic, weak) IBOutlet UILabel *attentionLabel;
/** 粉丝 */
@property (nonatomic, weak) IBOutlet UILabel *fansLabel;
/** 点赞: vote */
@property (nonatomic, weak) IBOutlet UILabel *voteLabel;
// 点赞按钮的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthAttentionLabel;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *verticalLine;

/** <#注释#> */
@property (nonatomic, strong) UIButton *attentionBtn;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *shadowView;
@end

@implementation CZMeIntelligentView

+ (instancetype)meIntelligentView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.iconImageView.layer.borderWidth = 2;
    self.iconImageView.layer.borderColor = CZGlobalWhiteBg.CGColor;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:JPOTHERUSERINFO[@"avatar"]]];


    self.shadowView.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.5].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0,3);
    self.shadowView.layer.shadowOpacity = 1;
    self.shadowView.layer.shadowRadius = 6;
    self.shadowView.layer.cornerRadius = 60;



    self.nameLabel.text = JPOTHERUSERINFO[@"nickname"];
    if ([JPOTHERUSERINFO[@"gender"] isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"nan 2"];
    } else {
        self.genderImageView.image = [UIImage imageNamed:@"nv 2"];
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@", JPOTHERUSERINFO[@"age"]];

    NSString *status = [@"个签: " stringByAppendingFormat:@"%@", JPOTHERUSERINFO[@"detail"]];
    self.detailLabel.attributedText = [status addAttributeColor:UIColorFromRGB(0x9D9D9D) Range:[status rangeOfString:@"个签: "]];

    // 关注
    self.attentionLabel.text = [NSString stringWithFormat:@"%@",  JPOTHERUSERINFO[@"followCount"]];
    // 粉丝
    self.fansLabel.text = [NSString stringWithFormat:@"%@", JPOTHERUSERINFO[@"fansCount"]];
    // 点赞
    self.voteLabel.text = [NSString stringWithFormat:@"%@", JPOTHERUSERINFO[@"voteCount"]];
    

    [self layoutIfNeeded];

    if (isUserInfo) {
        UIButton *btn = [[UIButton alloc] init];
        btn.width = 100;
        btn.height = 34;
        btn.x = SCR_WIDTH - 115;
        btn.y = CZGetY(self.detailLabel) + 16 + 25 - 17;

        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:@"编辑个人资料" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColorFromRGB(0xE25838).CGColor;
        btn.layer.cornerRadius = btn.height / 2.0;
        [btn addTarget:self action:@selector(pushEditorUserController) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        self.widthAttentionLabel.constant = (SCR_WIDTH - btn.width - 45) / 3;
    } else {
        UIButton *btn = [[UIButton alloc] init];
        self.attentionBtn = btn;
        btn.width = 90;
        btn.height = 38;
        btn.x = SCR_WIDTH -15 - 90;
        btn.y = CZGetY(self.detailLabel) + 16 + 25 - 17;

        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height / 2.0;
        [btn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        if ([JPOTHERUSERINFO[@"follow"] integerValue] == 1) {
            btn.selected = YES;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            btn.backgroundColor = UIColorFromRGB(0x9D9D9D);
        } else {
            btn.selected = NO;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            btn.backgroundColor = UIColorFromRGB(0xE25838);
        }
    }
    self.height = CZGetY(self.verticalLine);
}

- (void)attentionAction:(UIButton *)sender
{
    if (!sender.isSelected) {
        [CZJIPINSynthesisTool addAttentionWithID:JPOTHERUSERINFO[@"userId"] action:^{
            [self attentionBtnStyle:self.attentionBtn];
        }];
    } else {
        [CZJIPINSynthesisTool deleteAttentionWithID:JPOTHERUSERINFO[@"userId"] action:^{
            [self notAttentionBtnStyle:self.attentionBtn];
        }];
    }
    sender.selected = !sender.isSelected;
}

// 未关注样式
- (void)notAttentionBtnStyle:(UIButton *)sender
{
    [sender setTitle:@"+关注" forState:UIControlStateNormal];
    sender.backgroundColor = UIColorFromRGB(0xE25838);
}

// 已关注样式
- (void)attentionBtnStyle:(UIButton *)sender
{
    [sender setTitle:@"已关注" forState:UIControlStateNormal];
    sender.backgroundColor = UIColorFromRGB(0x9D9D9D);
}


// 跳转个人信息
- (void)pushEditorUserController
{
    CZMyProfileController *vc = [[CZMyProfileController alloc] init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

/** pop */
- (IBAction)pop
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperty];
    }
    return self;
}

- (void)setupProperty
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if ([JPOTHERUSERINFO[@"bgImg"] length] > 10) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:JPOTHERUSERINFO[@"bgImg"]]];
    } else {
        imageView.image = [UIImage imageNamed:@"矩形备份 + 矩形蒙版"];
    }
    imageView.x = 0;
    imageView.y = 0;
    imageView.width = self.width;
    imageView.height = 188 + (IsiPhoneX ? 24 : 0);
    [self addSubview:imageView];

    CZMeIntelligentView *intelligentView = [CZMeIntelligentView meIntelligentView];
    intelligentView.backgroundColor = [UIColor clearColor];
    intelligentView.x = 0;
    intelligentView.y = (IsiPhoneX ? 24 : 0);
    intelligentView.width = self.width;
    [self addSubview:intelligentView];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = CZGlobalLightGray;
    line.width = SCR_WIDTH;
    line.height = 10;
    line.y = CZGetY(intelligentView) + 3;
    [self addSubview:line];
    
    self.height = CZGetY(line);
}

@end
