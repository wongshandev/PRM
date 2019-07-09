//
//  ViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/6.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseViewController.h"
#import "UILabel+LabelHeightAndWidthAutoFit.h"
@interface BaseViewController ()
///loading对象
@property(nonatomic,strong) MBProgressHUD *progressHUD;

@end

@implementation BaseViewController
//懒加载
-(MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHUD];
    }
    return _progressHUD;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor]; 
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
     }
    
}


//显示loading
-(void)showProgressHUD {
    [self showProgressHUDWithStr:nil];
}
//带有文字的loading
-(void)showProgressHUDWithStr:(NSString *)str {
    if (str.length == 0) {
        self.progressHUD.labelText = nil;
    }else{
        self.progressHUD.labelText = str;
    }
    [self.progressHUD show:YES];
}
//隐藏loading
-(void)hideProgressHUD{
    if (self.progressHUD != nil ) {
        [self.progressHUD hide:YES];
        [self.progressHUD removeFromSuperViewOnHide];
        self.progressHUD = nil; 
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearDisk];//清理磁盘
    [[SDImageCache sharedImageCache] clearMemory];//清理内存
}

-(void)showMessageLabel:(NSString *)message withBackColor:(UIColor *)color{
    UILabel * label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.layer.cornerRadius = 15;
    label.layer.masksToBounds = YES;
    label.backgroundColor = color;;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = message;
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo([UILabel getWidthWithTitle:message font:label.font] + 30);
        make.bottom.equalTo(self.view.bottom).offset(-40);
        make.height.greaterThanOrEqualTo(30);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//字典、Model 转 字符 串
-(NSString *)bodyStringWithModel:(id)model{
    NSDictionary *paraDic = [self returnToDictionaryWithModel:model];
    NSString *valueNullStr = @"";
    NSString *valueNoneNullStr = @"";
    for (NSString *key in paraDic) {
        if ([[paraDic objectForKey:key] length] == 0) {
            valueNullStr =    [valueNullStr stringByAppendingFormat:@"%@=",key];
        }else{
            valueNoneNullStr = [valueNoneNullStr stringByAppendingFormat:@"&%@=%@",key,[paraDic objectForKey:key]];
        }
    }
    NSString *para = [NSString stringWithFormat:@"%@%@",valueNullStr,valueNoneNullStr];
    return para;
}
//model 转 字典
-(NSMutableDictionary *)returnToDictionaryWithModel:(id)model{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return userDic;
}

-(NSString *)paraStrReturnedByDic:(NSDictionary *)dic{
    NSString *valueNullStr = @"";
    NSString *valueNoneNullStr = @"";
    for (NSString *key in dic) {
        if ([[dic objectForKey:key] length] == 0) {
            valueNullStr =    [valueNullStr stringByAppendingFormat:@"%@=",key];
        }else{
            valueNoneNullStr = [valueNoneNullStr stringByAppendingFormat:@"&%@=%@",key,[dic objectForKey:key]];
        }
    }
    NSString *para = [NSString stringWithFormat:@"%@%@",valueNullStr,valueNoneNullStr];
    return para;
}

- (NSMutableDictionary *)changeNullWithDic:(NSMutableDictionary *)dic{
    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (NSString *key in dic) {
        if ([dic[key] isEqual:[NSNull null]] || dic[key] == nil) {
            temDic[key] = @"";
        }
    }
    return temDic;
}


//封装 model 打印属性
- (void)FengZhuangWithDic:(NSDictionary *)dic {
    NSString *string = @"";
    
    for (NSString *key in dic) {
        if ([dic[key] isKindOfClass:[NSDictionary class]]) {
            string = [NSString stringWithFormat:@"%@@property (nonatomic, strong) NSMutableDictionary *%@;\n",string,key];
        }else if ([dic[key] isKindOfClass:[NSArray class]]) {
            string = [NSString stringWithFormat:@"%@@property (nonatomic, strong) NSMutableArray *%@;\n",string,key];
        }else {
            string = [NSString stringWithFormat:@"%@@property (nonatomic, copy) NSString *%@;\n",string,key];
        }
    }
    NSLog(@"****************\n%@",string);
}


-(void)frontPageAction:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSArray *)getAllFileNames:(NSString *)dirName
{
    // 获得此程序的沙盒路径
    NSString *patchs = NSHomeDirectory();// NSSearchPathForDirectoriesInDomains(NSHomeDirectory(), NSUserDomainMask, YES);
    NSString *fileDirectory = [patchs stringByAppendingPathComponent:dirName];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
    return files;
}
@end
