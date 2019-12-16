//
//  CZGuessWhatYouLikeSubVC.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGuessWhatYouLikeSubVC.h"
#import "GXNetTool.h"
#import <AdSupport/AdSupport.h>
#import "CZguessWhatYouLikeCell.h"
#import "CZTaobaoDetailController.h"
#import "KCUtilMd5.h"

@interface CZGuessWhatYouLikeSubVC () <UICollectionViewDelegate, UICollectionViewDataSource>
/** <#注释#> */
@property (nonatomic, weak) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CZGuessWhatYouLikeSubVC

#pragma mark - 系统生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessWhatYouLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessWhatYouLikeCell"];

    [self getSourceData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.height = self.view.height;
}


#pragma mark - 代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    CZguessWhatYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessWhatYouLikeCell" forIndexPath:indexPath];
    cell.dataDic = dic;
    //
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param = self.dataSource[indexPath.row];
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = param[@"otherGoodsId"];
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];

}



#pragma mark - 数据
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        //
    }
    return _dataSource;
}

- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    param[@"deviceType"] = @"IDFA";
    param[@"deviceValue"] = [KCUtilMd5 stringToMD5:idfa];
    param[@"deviceEncrypt"] = @"MD5";
    param[@"otherGoodsId"] = @"";

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/listSimilerGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {}];
}

@end
