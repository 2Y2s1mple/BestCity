//
//  CZAlertView3Controller.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/8.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertView3Controller.h"
#import "UIImageView+WebCache.h"

@interface CZAlertView3Controller ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel1;

@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel2;

@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel3;
@end

@implementation CZAlertView3Controller

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *list = self.param[@"allowanceGoodsList"];

    for (int i = 0; i < list.count; i++) {

        switch (i) {
            case 0:
            {
                NSDictionary *dic = list[i];
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                self.titleLabel1.text = [NSString stringWithFormat:@"减 ¥%@", dic[@"actualPrice"]];
                break;
            }
            case 1:
            {
                NSDictionary *dic = list[i];
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                self.titleLabel2.text = [NSString stringWithFormat:@"减 ¥%@", dic[@"actualPrice"]];
                break;
            }
            case 2:
            {
                NSDictionary *dic = list[i];
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                self.titleLabel3.text = [NSString stringWithFormat:@"减 ¥%@", dic[@"actualPrice"]];
                break;
            }
            default:
                break;
        }
    }


}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
