//
//  CZFestivalCollectOneSubCell.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/23.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectOneSubCell.h"
#import "UIButton+WebCache.h"

@interface CZFestivalCollectOneSubCell ()
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@end

@implementation CZFestivalCollectOneSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CZMainViewSubOneVCModel *)model
{
    _model = model;
    CGFloat Y = 10;
    CGFloat width = (SCR_WIDTH - 30 - 30) / 2;
    CGFloat height = 80;
    CGFloat space = 10; //(SCR_WIDTH - 30 - 20 - width * 2)
    
    self.bottomView.backgroundColor = [UIColor gx_colorWithHexString:self.model.ad2[@"color"]];
    
    // 根据返回的图片加载
    for (int i = 0; i < model.activityList.count; i++) {
        NSDictionary *dic = model.activityList[i];
        int col = i % 2;
        int row = i / 2;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jumpVC:) forControlEvents:UIControlEventTouchUpInside];
        btn.y = Y + 10 + row * (height + 10);
        btn.x = 10 + col * (space + width);
        btn.width = width;
        btn.height = height;
        
        [self.bottomView addSubview:btn];
        CGFloat cellHeight = CZGetY(btn);
        self.model.peopleNewZeroViewHeight = cellHeight;
    }
}

// 如果要从cell里面得出计算的高度, 1, 设置estimatedItemSize, 2, 重写这个方法. 具体原因不详
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    NSLog(@"--如果要从cell里面得出计算的高度---%f", self.model.peopleNewZeroViewHeight);
    attributes.size = CGSizeMake(SCR_WIDTH,  self.model.peopleNewZeroViewHeight + 10);;
    
    return attributes;
}

- (void)jumpVC:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    NSDictionary *dic =  self.model.activityList[tag];
    NSDictionary *param = @{
        @"targetType" : dic[@"type"],
        @"targetId" : dic[@"objectId"],
        @"targetTitle" : dic[@"name"],
    };
    [CZFreePushTool bannerPushToVC:param];
}
@end
