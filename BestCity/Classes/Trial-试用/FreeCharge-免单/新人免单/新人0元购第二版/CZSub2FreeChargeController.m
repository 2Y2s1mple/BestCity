//
//  CZSub2FreeChargeController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/25.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeController.h"
#import "CZNavigationView.h"
#import "CZSub2FreeChargeHeaderView.h"
#import "CZSub2FreeChargeFooterView.h"
#import "CZSub2FreeChargeCell.h"
#import "GXNetTool.h"
#import "CZSub2FreeChargeDetailController.h"

@interface CZSub2FreeChargeController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 表 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 导航 */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *list;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *resultDic;

@end

@implementation CZSub2FreeChargeController
#pragma mark - 创建UI

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGRect frame = CGRectMake(0, CZGetY(self.navigationView), SCR_WIDTH, SCR_HEIGHT - CZGetY(self.navigationView) - (IsiPhoneX ? 34 + 55 : 55));
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromRGB(0xFA6D4E);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // 注册cell
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZSub2FreeChargeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZSub2FreeChargeCell"];
        // 注册sectionHeader
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        // 注册sectionFooter
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFA6D4E);
    self.navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"新人免单专区" rightBtnTitle:nil rightBtnAction:nil];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navigationView];
    // 表
    [self.view addSubview:self.collectionView];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share setBackgroundImage:[UIImage imageNamed:@"peopleNew-5"] forState:UIControlStateNormal];
    share.width = SCR_WIDTH;
    share.height = 55;
    share.x = 0;
    share.y = SCR_HEIGHT - (IsiPhoneX ? 34 + 55 : 55);
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadNewTrailDataSorce];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
        header.backgroundColor = UIColorFromRGB(0xF5F5F5);
        if (self.resultDic[@"officialWechat"]) {
            CZSub2FreeChargeHeaderView *headerView = [CZSub2FreeChargeHeaderView sub2FreeChargeHeaderView];
            headerView.param = self.resultDic;
            [header addSubview:headerView];
        }
         return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"forIndexPath:indexPath];
        header.backgroundColor = UIColorFromRGB(0xF5F5F5);
        if (self.resultDic[@"officialWechat"]) {
            CZSub2FreeChargeFooterView *headerView = [CZSub2FreeChargeFooterView sub2FreeChargeFooterView];
            headerView.param = self.resultDic;
            [header addSubview:headerView];
        }
        return header;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCR_WIDTH, 385); // 头视图高度
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCR_WIDTH, 410); // 尾视图高度
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZSub2FreeChargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZSub2FreeChargeCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *param = self.list[indexPath.item];
    cell.dataDic = param;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param =  self.list[indexPath.item];
    CZSub2FreeChargeDetailController *vc = [[CZSub2FreeChargeDetailController alloc] init];
    vc.allowanceGoodsId = param[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCR_WIDTH - 40) / 2, 300); // 每个块尺寸
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15); // 上左下右的间距
}



#pragma mark - 数据
- (void)reloadNewTrailDataSorce
{
    //
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    NSString *urlStr = [JPSERVER_URL stringByAppendingPathComponent:@"api/v3/free/list"];
    //获取数据
    [GXNetTool GetNetWithUrl:urlStr body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.list = result[@"data"];
            self.resultDic = result;
            
            

            [self.collectionView reloadData];
            // 结束刷新
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 事件
- (void)share
{
    // 统一分享UI
    [CZJIPINSynthesisView JIPIN_UMShareUIWithAction:^(CZJIPINSynthesisView * _Nonnull view, NSInteger index) {
        UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
        switch (index) {
            case 0:
            {
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_WechatSession;//微信好友
                [self UMShareWebWithType:type];
                break;
            }
            case 1: // 朋友圈
            {
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
                [self getPosterImage:type];
                break;
            }
            case 2:
            {
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_QQ;//QQ好友
                [self UMShareWebWithType:type];
                break;
            }
            case 3:
            {
                [CZProgressHUD showProgressHUDWithText:nil];
                [CZProgressHUD hideAfterDelay:2];
                type = UMSocialPlatformType_Sina;//新浪微博
                [self UMShareWebWithType:type];
                break;
            }
            case 4:
            {
                type = 4;
                [self getPosterImage:type];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)UMShareWebWithType:(UMSocialPlatformType)type
{
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    shareDic[@"shareTitle"] = @"新人免单，仅剩3天！";
    shareDic[@"shareContent"] = @"价值30元免单礼品任意选";
    
//    NSString *url = @"9345a5dc869e40cd90dc827a203f607b";
    
    shareDic[@"shareUrl"] = [NSString stringWithFormat:@"https://www.jipincheng.cn/new-free?query=\"%@\"", JPUSERINFO[@"userId"]];
    

    shareDic[@"shareImg"] = @"https://jipincheng.cn/share_newFree.png";
    [CZJIPINSynthesisTool JINPIN_UMShareWeb:shareDic[@"shareUrl"] Title:shareDic[@"shareTitle"] subTitle:shareDic[@"shareContent"] thumImage:shareDic[@"shareImg"] Type:type];
}

- (void)getPosterImage:(UMSocialPlatformType)type
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/allowance/getIndexPosterImg"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
         if ([result[@"msg"] isEqualToString:@"success"]) {
             if (type == 4) {
                 [CZJIPINSynthesisTool jipin_saveImage:result[@"data"]];
             } else {
                 [self shareImageWithType:type thumImage:result[@"data"]];
             }
         } else {
             [CZProgressHUD hideAfterDelay:0];
         }

    } failure:nil];
}

// 分享图片
- (void)shareImageWithType:(UMSocialPlatformType)type thumImage:(NSString *)thumImage
{
    [CZJIPINSynthesisTool JINPIN_UMShareImage:thumImage Type:type];
}

@end
