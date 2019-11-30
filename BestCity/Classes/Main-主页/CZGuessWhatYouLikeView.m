//
//  CZGuessWhatYouLikeView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGuessWhatYouLikeView.h"
#import "GXNetTool.h"
#import <AdSupport/AdSupport.h>
#import "CZguessWhatYouLikeCell.h"

@interface CZGuessWhatYouLikeView () <UICollectionViewDelegate, UICollectionViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation CZGuessWhatYouLikeView

+(instancetype)guessWhatYouLikeView
{
    CZGuessWhatYouLikeView *view = [[CZGuessWhatYouLikeView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xF5F5F5);

    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:@"taobaoDetai_guess"];
        [image sizeToFit];
        image.centerX = SCR_WIDTH / 2.0;
        image.y = 14;
        [self addSubview:image];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CZGetY(image) + 14, SCR_WIDTH, 0) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self addSubview:collectionView];
        self.collectionView = collectionView;

        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessWhatYouLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessWhatYouLikeCell"];

        self.height = CZGetY(image) + 14;
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    CZguessWhatYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessWhatYouLikeCell" forIndexPath:indexPath];
    cell.dataDic = dic;

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)setOtherGoodsId:(NSString *)otherGoodsId
{
    _otherGoodsId = otherGoodsId;
    [self getSourceData];
}


- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    param[@"deviceType"] = idfa;
    param[@"otherGoodsId"] = self.otherGoodsId;

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/listSimilerGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];


            CGFloat height = ((self.dataSource.count + 1) / 2) * 312 + ((self.dataSource.count  + 1) / 2 + 1) * 10;
            self.collectionView.height = height;

            self.height = CZGetY(self.collectionView);
            
            [self.collectionView reloadData];
            !self.delegate ? : [self.delegate reloadGuessWhatYouLikeView];
        }
    } failure:^(NSError *error) {}];
}

@end
