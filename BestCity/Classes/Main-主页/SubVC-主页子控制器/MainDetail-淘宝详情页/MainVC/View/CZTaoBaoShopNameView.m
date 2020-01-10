//
//  CZTaoBaoShopNameView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaoBaoShopNameView.h"
#import "UIImageView+WebCache.h"

@interface CZTaoBaoShopNameView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *title;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *subTitle1;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *subScoreTitle1;

@property (nonatomic, weak) IBOutlet UILabel *subTitle2;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *subScoreTitle2;

@property (nonatomic, weak) IBOutlet UILabel *subTitle3;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *subScoreTitle3;
@end

@implementation CZTaoBaoShopNameView

+ (instancetype)taoBaoShopNameView
{
    CZTaoBaoShopNameView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
    view.height = 83;
    return view;
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:paramDic[@"shopIcon"]]];
    self.title.text = paramDic[@"shopName"];
    NSArray *list;// = paramDic[@"evaluateList"];

    for (int i = 0; i < list.count; i++) {
        switch (i) {
            case 0:
            {
                NSDictionary *dic = list[i];
                self.subTitle1.text = dic[@"title"];
                self.subScoreTitle1.text = dic[@"score"];
                break;
            }
            case 1:
            {
                NSDictionary *dic = list[i];
                self.subTitle2.text = dic[@"title"];
                self.subScoreTitle2.text = dic[@"score"];
                break;
            }
            case 2:
            {
                NSDictionary *dic = list[i];
                self.subTitle3.text = dic[@"title"];
                self.subScoreTitle3.text = dic[@"score"];
                break;
            }
            default:
                break;
        }
    }
}

@end
