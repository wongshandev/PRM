//
//  MainViewCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"
@interface MainViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabe;
-(void)showMainCellDataWithModel:(MainModel *)model;
@end
