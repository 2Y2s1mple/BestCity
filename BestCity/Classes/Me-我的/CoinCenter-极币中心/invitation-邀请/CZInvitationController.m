//
//  CZInvitationController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZInvitationController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZUMConfigure.h"
#import "GXLineLayout.h"
#import "GXPhotoCell.h"

@interface CZInvitationController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigImageConstraint;
/** 文字 */
@property (nonatomic, weak) IBOutlet UILabel *contentText;
/** 后台返回的图片 */
@property (nonatomic, strong) NSDictionary *shareImageDic;
/** 承载图片View */
@property (nonatomic, weak) IBOutlet UIView *contentView;
/** 选中的图片 */
@property (nonatomic, assign) NSUInteger index;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UICollectionView *collectView;

@end

@implementation CZInvitationController

static NSString *ID = @"PhotoCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShareImage];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"邀请好友" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    self.bigImageConstraint.constant = CZGetY(navigationView);
    self.bottomViewConstraint.constant = (IsiPhoneX ? 34 : 0);

    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    [self.view addSubview:navigationView];

}

- (void)setupUI
{
    
    GXLineLayout *flowLayout = [[GXLineLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(210, self.collectView.height - 40); // 小格子的大小
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectView.collectionViewLayout = flowLayout;

    self.collectView.backgroundColor = CZGlobalLightGray;
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    
    // 必须注册
    [self.collectView registerNib:[UINib nibWithNibName:NSStringFromClass([GXPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - <UICollectionViewDataSource>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.index = scrollView.contentOffset.x / 200;
    NSLog(@"----%zd-----", self.index);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.shareImageDic[@"posterImgs"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GXPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.shareImageDic[@"posterImgs"][indexPath.row]]];

    return cell;
}


- (void)getShareImage
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/user/getQRcodeImgs"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.shareImageDic = result[@"data"];
            self.contentText.text = self.shareImageDic[@"shareContent"];
            
            [self.view layoutIfNeeded];
            [self setupUI];
            [self.collectView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:nil];
}

- (void)setShareImageDic:(NSDictionary *)shareImageDic
{
    _shareImageDic = shareImageDic;
//    [self.QRCodeImage sd_setImageWithURL:[NSURL URLWithString:shareImageDic[@"qrcodeImg"]]];
}

- (IBAction)action:(UIButton *)sender
{
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (sender.tag - 100) {
        case 0:
            type = UMSocialPlatformType_WechatSession;//微信好友
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
            break;
        case 2:
            type = UMSocialPlatformType_Sina;//新浪微博
            break;
        case 3:
            type = UMSocialPlatformType_QQ;//QQ好友
            break;
        case 4:
            type = UMSocialPlatformType_Qzone;//QQ空间
            break;
        default:
            
            break;
    }
    
    if (![[UMSocialManager defaultManager] isInstall:type]) {
        [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
        [CZProgressHUD hideAfterDelay:2];
        return;
    }
    //设置图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    shareObject.thumbImage = [UIImage imageNamed:@"icon.png"];
    //如果有缩略图，则设置缩略图
    [shareObject setShareImage:self.shareImageDic[@"posterImgs"][self.index]];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            UMSocialShareResponse *dataResponse = data;
            NSLog(@"response data is %@", dataResponse.message);
            [CZGetJIBITool getJiBiWitType:@(5)];
        }
    }];
}



@end
