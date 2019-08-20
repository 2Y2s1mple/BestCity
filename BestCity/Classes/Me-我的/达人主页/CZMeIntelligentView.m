//
//  CZMeIntelligentView.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMeIntelligentView.h"
#import "UIImageView+WebCache.h"

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
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"avatar"]]];
    self.nameLabel.text = JPUSERINFO[@"nickname"];
    if ([JPUSERINFO[@"gender"] isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"nan 2"];
    } else {
        self.genderImageView.image = [UIImage imageNamed:@"nv 2"];
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"age"]];

    NSString *status = [@"个签: " stringByAppendingFormat:@"%@", JPUSERINFO[@"detail"]];
    self.detailLabel.attributedText = [status addAttributeColor:UIColorFromRGB(0x9D9D9D) Range:[status rangeOfString:@"个签: "]];

    // 关注
    self.attentionLabel.text = [NSString stringWithFormat:@"%@",  JPUSERINFO[@"followCount"]];
    // 粉丝
    self.fansLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"fansCount"]];
    // 点赞
    self.voteLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"voteCount"]];
    

    [self layoutIfNeeded];

    if (YES) {

    }


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

    self.height = CZGetY(self.verticalLine);
}

// 跳转个人信息
- (void)pushEditorUserController
{
    
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形备份 + 矩形蒙版"]];
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
