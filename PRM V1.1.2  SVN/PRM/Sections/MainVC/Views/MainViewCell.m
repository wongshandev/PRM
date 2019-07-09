//
//  MainViewCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell
-(void)showMainCellDataWithModel:(MainModel *)model{
    NSString *imageStr = [model.iconURL stringByReplacingOccurrencesOfString:@"../.." withString:kImageUrl];
    NSURL *icomUrl = [NSURL URLWithString:imageStr];
    [self.mainImageView sd_setImageWithURL:icomUrl placeholderImage:[UIImage imageNamed:@"faliureImg"] options:SDWebImageRefreshCached];
    self.mainTitleLabe.text = [NSString stringWithFormat:@"%@",model.text];
}
@end
