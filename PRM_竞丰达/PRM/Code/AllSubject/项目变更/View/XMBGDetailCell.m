//
//  XMBGDetailCell.m
//  PRM
//
//  Created by apple on 2019/1/19.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMBGDetailCell.h"

@interface XMBGDetailCell ()

@property (nonatomic, strong) UIImageView *leftImgeView;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *subTitle;
@property(nonatomic,strong) QMUILabel *fujianLab;

@end
@implementation XMBGDetailCell

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
     UIImageView *leftImgeView = [[UIImageView alloc] init];;
     [self addSubview:leftImgeView];
    self.leftImgeView = leftImgeView;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *subTitle = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:subTitle];
    self.subTitle = subTitle;

    QMUILabel *fujianLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    fujianLab.text= @"附件:";
    [self addSubview:fujianLab];
    self.fujianLab = fujianLab;

    QMUIButton *fujianBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [fujianBtn setTitleColor:Color_NavigationLightBlue forState:UIControlStateNormal];
    fujianBtn.titleLabel.font = Font_ListOtherTxt;
    [self addSubview:fujianBtn];
    fujianBtn.hidden = YES;
    self.fujianBtn = fujianBtn;
}
-(void)buildSubview{
    [self.leftImgeView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(10);
        make.height.equalTo(50);
        make.width.equalTo(50);
    }];

    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.leftImgeView.mas_right).offset(10);
        make.height.mas_greaterThanOrEqualTo(20);
        make.right.equalTo(self).offset(-10);
    }];
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.leftImgeView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
     }];
 
    [self.fujianLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitle.mas_bottom).offset(5);
        make.left.equalTo(self.leftImgeView.mas_right).offset(10);
        make.height.lessThanOrEqualTo(35);
         make.bottom.equalTo(self).offset(-5);
    }];
    [self.fujianBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fujianLab.mas_centerY);
        make.left.equalTo(self.fujianLab.mas_right).offset(10);
         make.height.mas_equalTo(self.fujianLab.mas_height);
     }];
}
-(void)loadContent{
    XMBGDetailModel *model = self.data;
    if (self.cellType == CellType_XMBGDetial) {
        self.subTitle.text = model.Remark;
        self.titleLab.text = model.titleStr;
        self.fujianBtn.hidden =  !(model.Url.lastPathComponent.length && [model.Url.lastPathComponent containsString:@"."]);
        [self.fujianBtn setTitle:model.Url.lastPathComponent forState:UIControlStateNormal];

        self.leftImgeView.image = SJYCommonImage([NSString matchType:model.Url.lastPathComponent]);

    }
    if (self.cellType == CellType_WJQDList) {
         self.titleLab.text = model.Name;
        self.fujianBtn.hidden =  !(model.Url.lastPathComponent.length && [model.Url.lastPathComponent containsString:@"."]);
        [self.fujianBtn setTitle:model.Url.lastPathComponent forState:UIControlStateNormal];
        self.leftImgeView.image = SJYCommonImage([NSString matchType:model.Url.lastPathComponent]);
    }
}


//
//// 根据文件名后缀区分 文件类型
///*
// * @param: fileName - 文件名称
// * @param: 数据返回 1) 无后缀匹配 - false
// * @param: 数据返回 2) 匹配图片 - image
// * @param: 数据返回 3) 匹配 txt - txt
// * @param: 数据返回 4) 匹配 excel - excel
// * @param: 数据返回 5) 匹配 word - word
// * @param: 数据返回 6) 匹配 pdf - pdf
// * @param: 数据返回 7) 匹配 ppt - ppt
// * @param: 数据返回 8) 匹配 视频 - video
// * @param: 数据返回 9) 匹配 音频 - radio
// * @param: 数据返回 10) 其他匹配项 - other
// */
//
//-(NSString *)matchType:(NSString *)fileName{
//     // 后缀获取
//    NSString *suffix = @"";
//    // 获取类型结果
//    NSString * result = @"";
//    if (fileName.length !=0 && [fileName containsString:@"."] ) {
//         suffix =  [fileName componentsSeparatedByString:@"."].lastObject;
//    }else{
//        suffix = nil;
//        result = @"nofile";
//        return result;
//    }
//    // 图片格式
//    NSArray * imglist = @[@"png", @"jpg", @"jpeg", @"bmp", @"gif"];
//    if ([imglist containsObject:suffix]) {
//        result = @"image";
//        return result;
//     }
//
//    // 匹配txt
//  NSArray * txtlist = @[@"txt"];
//    if ([txtlist containsObject: suffix]) {
//        result = @"txt";
//        return result;
//    };
//
//    // 匹配 excel
//  NSArray * excelist = @[@"xls",@"xlsx"];
//
//    if  ([excelist containsObject: suffix]){
//        result = @"excel";
//        return result;
//    };
//    // 匹配 word
//    NSArray * wordlist = @[@"doc", @"docx"];
//
//    if ([wordlist containsObject: suffix]) {
//        result = @"word";
//        return result;
//    };
//    // 匹配 pdf
//    NSArray * pdflist = @[@"pdf"];
//
//    if ([pdflist containsObject: suffix]) {
//        result = @"pdf";
//        return result;
//    };
//    // 匹配 ppt
//    NSArray * pptlist = @[@"ppt"];
//
//    if ([pptlist containsObject: suffix]) {
//        result = @"ppt";
//        return result;
//    };
//    // 匹配 视频
//    NSArray * videolist = @[@"mp4", @"m2v", @"mkv"];
//
//    if ([videolist containsObject: suffix]) {
//        result = @"video";
//        return result;
//    };
//    // 匹配 音频
//    NSArray * radiolist = @[@"mp3", @"wav", @"wmv"];
//
//    if ([radiolist containsObject: suffix]) {
//        result = @"radio";
//        return result;
//    }
//
//    NSArray * ziplist = @[@"zip"];
//
//    if ([ziplist containsObject: suffix]) {
//        result = @"zip";
//        return result;
//    }
//    NSArray * rarlist = @[ @"rar"];
//    if ([rarlist containsObject: suffix]) {
//        result = @"rar";
//        return result;
//    }
//    // 其他 文件类型
//    result = @"otherfile";
//    return result;
//}
//

@end
