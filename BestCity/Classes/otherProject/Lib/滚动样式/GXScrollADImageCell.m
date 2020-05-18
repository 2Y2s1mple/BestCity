//
//  CZScrollADImageCell.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2019/12/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "GXScrollADImageCell.h"
#import "UIImageView+WebCache.h"

@interface GXScrollADImageCell ()
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation GXScrollADImageCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setImageUrlString:(NSString *)imageUrlString
{
    _imageUrlString = imageUrlString;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
}


@end
