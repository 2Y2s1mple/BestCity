//
//  CZFestivalCollectThreeCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectThreeCell.h"
#import "CZTitlesViewTypeLayout.h"

@interface CZFestivalCollectThreeCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *tabaoLabel1;
@property (nonatomic, weak) IBOutlet UILabel *tabaoLabel2;
@property (nonatomic, weak) IBOutlet UILabel *jingdongLabel1;
@property (nonatomic, weak) IBOutlet UILabel *jingdongLabel2;
@property (nonatomic, weak) IBOutlet UILabel *pinduoduoLabel1;
@property (nonatomic, weak) IBOutlet UILabel *pinduoduoLabel2;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *taobaoBtn;
@property (nonatomic, weak) IBOutlet UIButton *jingdongBtn;
@property (nonatomic, weak) IBOutlet UIButton *pinduoduoBtn;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleName;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, strong) NSString *orderByType;  //  1:京东 2:淘宝 4拼多多
/** <#注释#> */
@property (nonatomic, strong) UIButton *recordBtn;
/** <#注释#> */
@property (nonatomic, assign) NSInteger recoredBtnClick;
@end

@implementation CZFestivalCollectThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.recordBtn = self.taobaoBtn;
    [self changeRedTitleLabel:self.tabaoLabel1 andSubLabel:self.tabaoLabel2];
    
    self.titleName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
    
}

- (IBAction)didClickedBtn:(UIButton *)btn
{
    // 1:京东 2:淘宝 4拼多多
    NSInteger index = 1;
    if (btn == self.taobaoBtn) {
        index = 2;
        [self changeRedTitleLabel:self.tabaoLabel1 andSubLabel:self.tabaoLabel2];
        
        [self changeOriginalLabel:self.pinduoduoLabel1 andSubLabel:self.pinduoduoLabel2];
        [self changeOriginalLabel:self.jingdongLabel1 andSubLabel:self.jingdongLabel2];
    } else if (btn == self.jingdongBtn) {
        index = 1;
        [self changeRedTitleLabel:self.jingdongLabel1 andSubLabel:self.jingdongLabel2];
        
        
        [self changeOriginalLabel:self.pinduoduoLabel1 andSubLabel:self.pinduoduoLabel2];
        [self changeOriginalLabel:self.tabaoLabel1 andSubLabel:self.tabaoLabel2];

    } else if (btn == self.pinduoduoBtn) {
        index = 4;
        [self changeRedTitleLabel:self.pinduoduoLabel1 andSubLabel:self.pinduoduoLabel2];
        
        [self changeOriginalLabel:self.tabaoLabel1 andSubLabel:self.tabaoLabel2];
        [self changeOriginalLabel:self.jingdongLabel1 andSubLabel:self.jingdongLabel2];

    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainSameTitleAction" object:nil userInfo:@{@"orderByType" : @(index)}];
    
    self.recordBtn = btn;
}



- (void)changeRedTitleLabel:(UILabel *)label1 andSubLabel:(UILabel *)label2
{
    label1.textColor = UIColorFromRGB(0xE25838);
    label2.textColor = UIColorFromRGB(0xE25838);
}

- (void)changeOriginalLabel:(UILabel *)label1 andSubLabel:(UILabel *)label2
{
    label1.textColor = UIColorFromRGB(0x565252);
    label2.textColor = UIColorFromRGB(0x9D9D9D);
}


- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    attributes.size = CGSizeMake(SCR_WIDTH, 100);
    
    return attributes;
}
@end
