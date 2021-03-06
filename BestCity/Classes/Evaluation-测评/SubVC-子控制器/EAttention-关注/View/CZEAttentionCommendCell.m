//
//  CZEAttentionCommendCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEAttentionCommendCell.h"
#import "CZEACCollectionCell.h"
//数据模型
#import "CZEAttentionItemViewModel.h"
#import "CZMeIntelligentController.h"

@interface CZEAttentionCommendCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** 标示图 */
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *mainTitle;

/** 视图模型 */
@property (nonatomic, strong) CZEAttentionItemViewModel *viewModel;
@end

@implementation CZEAttentionCommendCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZEAttentionCommendCell";
    CZEAttentionCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZEACCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZEACCollectionCell"];
}

- (void)bindViewModel:(CZEAttentionItemViewModel *)viewModel
{
    self.viewModel = viewModel;
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.model.userList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZEACCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZEACCollectionCell" forIndexPath:indexPath];
    cell.model = self.viewModel.model.userList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZEAttentionUserModel *model = self.viewModel.model.userList[indexPath.row];
    NSLog(@"-------------%@", model.userId);
    CZMeIntelligentController *vc = [[CZMeIntelligentController alloc] init];
    vc.freeID = model.userId;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
