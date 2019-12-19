//
//  CZFestivalCollectTwoCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectTwoCell.h"
#import "CZFestivalGoodsColLayoutView.h"
#import "CZTaobaoDetailController.h"

@interface CZFestivalCollectTwoCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *containView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation CZFestivalCollectTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];

    self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 172)];
    self.scrollerView.showsVerticalScrollIndicator = NO;;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    [self.containView addSubview:self.scrollerView];

}

- (void)setHotGoodsList:(NSArray *)hotGoodsList
{
    _hotGoodsList = hotGoodsList;


    for (int i = 0; i < hotGoodsList.count; i++) {
        CGFloat y = 0;
        CGFloat w = 100;
        CGFloat h = 172;
        CGFloat x = 15 + (w + 10) * i;
        CZFestivalGoodsColLayoutView *view = (CZFestivalGoodsColLayoutView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZFestivalGoodsColLayoutView class]) owner:nil options:nil] firstObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchView:)];
        [view addGestureRecognizer:tap];
        view.frame = CGRectMake(x, y, w, h);
        view.dataDic = hotGoodsList[i];
        [self.scrollerView addSubview:view];
        self.scrollerView.contentSize = CGSizeMake(CZGetX(view) + 15, 0);
    }
    
}

- (void)pushSearchView:(UIGestureRecognizer *)sender
{
    CZFestivalGoodsColLayoutView *view = sender.view;
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = view.dataDic[@"otherGoodsId"];
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}
@end
