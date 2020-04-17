//
//  CZMeArrowCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeArrowCell.h"
#import "CZMeController.h"
#import "CZSubFreeChargeController.h"
#import "CZFreeAlertView4.h"
#import "CZMeArrowCell2.h"

#import "CZWelfareChangeController.h"

@interface CZMeArrowCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *collectionArr;

@end

@implementation CZMeArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((SCR_WIDTH - 30) / 4.0, 82);

    CGRect frame = CGRectMake(0, 35, SCR_WIDTH - 30, 205 - 35);
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_collectionView];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZMeArrowCell2 class]) bundle:nil] forCellWithReuseIdentifier:@"CZMeArrowCell2"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CZMeArrowCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZMeArrowCell2" forIndexPath:indexPath];
    cell.dataDic = self.collectionArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param = self.collectionArr[indexPath.item];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *navVc = nav.topViewController;
    if ([param[@"destinationVC"] isEqualToString:@"custom1"]) {
        // 福利兑换
        CZWelfareChangeController *vc = [[CZWelfareChangeController alloc] init];
        [navVc.navigationController pushViewController:vc animated:YES];

    } else if ([param[@"destinationVC"] isEqualToString:@"custom2"]) {
        [self action5];
    }  else {
        UIViewController *vc = [[NSClassFromString(param[@"destinationVC"]) alloc] init];
        [navVc.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"meArrowCell";
    CZMeArrowCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZMeArrowCell class]) owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 0) {
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer  alloc]  init];
//        maskLayer.frame = cell.bounds;
//        maskLayer.path = maskPath.CGPath;
//        cell.layer.mask = maskLayer;
    } else if (indexPath.row == 6) {
//        UIBezierPath *bezierPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
//        mask.frame = cell.bounds;
//        mask.path = bezierPath.CGPath;
//        cell.layer.mask = mask;
    }
    return cell;
}

- (void)setList:(NSArray *)list
{
    _list = list;
    self.collectionArr = list;

//   if ([JPUSERINFO[@"isNewUser"] integerValue] != 0) { // 0 新用户
//       for (NSDictionary *dic in dataSource[@"titles"]) {
//           if ([dic[@"title"] isEqualToString:@"新人专区"]) {
//               [self.collectionArr removeObject:dic];
//           }
//       }
//    }

    [self.collectionView reloadData];
}

//邀请码
- (void)action5
{
    CZFreeAlertView4 *alertView = [CZFreeAlertView4 freeAlertView:^(NSString * _Nonnull text) {
        if (text.length == 0) {
            [CZProgressHUD showProgressHUDWithText:@"邀请码为空"];
            // 取消菊花
            [CZProgressHUD hideAfterDelay:1.5];
            return;
        }

        NSLog(@"%@", text);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        // 要关注对象ID
        param[@"invitationCode"] = text;
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/addInvitationCode"];
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"code"] isEqualToNumber:@(630)]) {
                [alertView hide];
            }
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            // 取消菊花
            [CZProgressHUD hideAfterDelay:1.5];

        } failure:^(NSError *error) {
            // 取消菊花
            [CZProgressHUD hideAfterDelay:0];
        }];
    }];
    [alertView show];
}


@end
