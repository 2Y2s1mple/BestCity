//
//  CZIssueMomentsCell.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueMomentsCell.h"
#import "CZIssueMomentsShareView.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "GXZoomImageView.h"
#import "CZUserInfoTool.h"

@interface CZIssueMomentsCell ()
/** 图片视图 */
@property (nonatomic, weak) IBOutlet UIView *imagesBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackViewTop;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *userAvatar;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *userNickname;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *content;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *shareNumber;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *shareNumberView;
@property (nonatomic, weak) IBOutlet UIView *shareNumberViewBtn;
/** 参看详情 */
@property (nonatomic, weak) IBOutlet UIButton *watchBtn;
// 商品信息
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *img;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *otherName;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *couponPrice;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *actualPrice;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *fee;

/** 商品视图 */
@property (nonatomic, weak) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;
/** 评论视图 */
@property (nonatomic, weak) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeight;

/** <#注释#> */
@property (nonatomic, strong) UIImage *shareImg;

/** <#注释#> */
@property (nonatomic, assign) NSInteger flag;

@end

@implementation CZIssueMomentsCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZIssueMomentsCell";
    CZIssueMomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setParam:(CZIssueMomentsModel *)param
{
    _param = param;

    NSDictionary *dic = param.param;

    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:dic[@"userAvatar"]]];
    self.userNickname.text = dic[@"userNickname"];
    self.content.text = dic[@"content"];
    self.shareNumber.text = [NSString stringWithFormat:@"%@", dic[@"shareNumber"]];

    CGFloat backViewWidth = SCR_WIDTH - 69 - 15;
    NSArray *images = dic[@"imgList"];
    NSInteger count = [images count];
    NSUInteger cols = 3;
    CGFloat space = 5;
    CGFloat width = (backViewWidth - 10) / cols;
    self.imageBackViewHeight.constant = 0;
    NSLog(@"--setParam----%lf", self.imagesBackView.width);
    for (int i = 0; i < count; i++) {
        NSInteger colIndex = i % cols;
        NSInteger rowIndex = i / cols;
        NSString *url = images[i];
        // 创建按钮
        UIImageView *btn = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
        btn.userInteractionEnabled = YES;
        [btn addGestureRecognizer:tap];
        btn.image = [UIImage imageNamed:@"testImage1"];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn sd_setImageWithURL:[NSURL URLWithString:url]];
        btn.tag = i;
        btn.width = width;
        btn.height = width;
        btn.x = colIndex * (width + space);
        btn.y = rowIndex * (width + space);
        [self.imagesBackView addSubview:btn];
        [self layoutIfNeeded];
        self.imageBackViewHeight.constant = CZGetY(btn);
    }

    // 商品详情
    [self layoutIfNeeded];
    if (![dic[@"goodsInfo"] isKindOfClass:[NSNull class]]) {
        // 显示参看更多
        self.imageBackViewTop.constant = 30;
        self.watchBtn.hidden = NO;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString: dic[@"goodsInfo"][@"img"]]] ;
        self.otherName.text = dic[@"goodsInfo"][@"otherName"];
        [self.couponPrice setTitle:[NSString stringWithFormat:@"券 ¥%@", dic[@"goodsInfo"][@"couponPrice"]] forState:UIControlStateNormal];
        self.actualPrice.text = [NSString stringWithFormat:@"券后价¥%.2f", [dic[@"goodsInfo"][@"actualPrice"] floatValue]];
        self.fee.text = [NSString stringWithFormat:@"¥%@", dic[@"goodsInfo"][@"fee"]];
        self.goodsView.hidden = NO;
        self.goodsViewHeight.constant = 90;
        self.param.cellHeight = CZGetY(self.goodsView) + 20;
    } else {
        // 隐藏更多
        self.watchBtn.hidden = YES;
        self.imageBackViewTop.constant = 10;
        self.goodsViewHeight.constant = 0;
        self.goodsView.hidden = YES;
        self.param.cellHeight = CZGetY(self.imagesBackView) + 20;
    }

    // 评论
    NSArray *commentList = dic[@"commentList"];
    if (commentList.count > 0) {
        for (int i = 0; i < commentList.count; i++) {
            CGFloat y = i * (83 + 10);
            [self createCommentView:commentList[i] index:i y:y];
        }
    } else {

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareView)];
    [self.shareNumberView addGestureRecognizer:tap];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareView)];
    [self.shareNumberViewBtn addGestureRecognizer:tap1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/**     */
- (void)shareView
{
    if (self.flag != 0) return;

    self.flag++;
    ISPUSHLOGIN;
    // 为了同步关联的淘宝账号
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
            // 获取和合成图
            if (![self.param.param[@"goodsInfo"] isKindOfClass:[NSNull class]]) {
                [self getShareImage:self.param.param[@"goodsInfo"][@"otherGoodsId"]];
            } else {
                [self jumpShareViewWithImage:nil];
                self.flag = 0;
            }
        } else {
            self.flag = 0;
        }
    }];
}


- (void)createCommentView:(NSDictionary *)param index:(NSInteger)index y:(CGFloat)y
{
    UIView *comment = [[UIView alloc] init];
    comment.y = y;
    comment.tag = index + 100;
    comment.width = SCR_WIDTH - 69 - 15;
    comment.height = 83;
    comment.backgroundColor = UIColorFromRGB(0xEDF3F6);
    [self.commentView addSubview:comment];

    self.commentViewHeight.constant = CZGetY(comment);
    [self layoutIfNeeded];
    self.param.cellHeight = CZGetY(self.commentView) + 20;

    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label.textColor = [UIColor colorWithRed:86/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    label.text = param[@"content"];
    label.x = 10;
    label.y = 5;
    label.width = comment.width - 20;
    label.height = 40;
    [comment addSubview:label];

    UIView *copyView = [[UIView alloc] init];
    copyView.layer.cornerRadius = 5;
    copyView.backgroundColor = UIColorFromRGB(0x84B5D3);
    copyView.x = comment.width - 92;
    copyView.y = comment.height - 7 - 23;
    copyView.width = 83;
    copyView.height = 23;
    [comment addSubview:copyView];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"moments-5"];
    imageView.x = 13;
    imageView.y = 5;
    imageView.width = 13;
    imageView.height = 13;
    [copyView addSubview:imageView];

    UILabel *copyLabel = [[UILabel alloc] init];
    copyLabel.text = @"复制评论";
    copyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    copyLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    copyLabel.x = 28;
    copyLabel.y = 5;
    copyLabel.width = 44;
    copyLabel.height = 15;
    [copyView addSubview:copyLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(generalPaste:)];
    [comment addGestureRecognizer:tap];
}

- (void)generalPaste:(UIGestureRecognizer *)sender
{
    ISPUSHLOGIN;
    // 为了同步关联的淘宝账号
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
            UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
            posteboard.string = self.param.param[@"commentList"][(sender.view.tag - 100)][@"copyContent"];
            [recordSearchTextArray addObject:posteboard.string];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评论内容复制成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"暂不粘贴" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去微信粘贴" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen) {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                } else {
                    [CZProgressHUD showProgressHUDWithText:@"您的设备未安装微信APP"];
                    [CZProgressHUD hideAfterDelay:1.5];
                }
            }]];
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
        }
    }];
}


- (void)showImage:(UIGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    [CZJIPINSynthesisTool jipin_showZoomImage:imageView];
}

// 获取合成图片
- (void)getShareImage:(NSString *)otherGoodsId
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = otherGoodsId;
    param[@"shareImgLocation"] = @"1";
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsShareInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            // 保存图片
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:result[@"data"][@"shareImg"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                [self jumpShareViewWithImage:image];
                self.flag = 0;
            }];
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 弹出分享
- (void)jumpShareViewWithImage:(UIImage *)image
{
    CZIssueMomentsShareView *view = [[CZIssueMomentsShareView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];

    NSMutableArray *images = [NSMutableArray array];
    for (UIImageView *imageView in self.imagesBackView.subviews) {
        if (imageView.image) {
            [images addObject:imageView.image];
        }
    }
    if (image) {
        [images replaceObjectAtIndex:0 withObject:image];
    }

    view.images = images;
    view.shareNumber = self.shareNumber;
    view.momentId = self.param.param[@"id"];
    [[UIApplication sharedApplication].keyWindow addSubview:view];

    // 文案
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.param.param[@"content"];
    [recordSearchTextArray addObject:posteboard.string];
    [CZProgressHUD hideAfterDelay:0];

}

@end
