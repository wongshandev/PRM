//
//  ViewController.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/6.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,assign)JumpDirection jumpDeriction;

//显示loading
-(void)showProgressHUD;
//带有文字的loading
-(void)showProgressHUDWithStr:(NSString *)str;
//隐藏loading
-(void)hideProgressHUD;

-(void)showMessageLabel:(NSString *)message withBackColor:(UIColor *)color;


//字典、Model 转 字符 串
-(NSString *)bodyStringWithModel:(id)model;//model 转 字典
-(NSMutableDictionary *)returnToDictionaryWithModel:(id)model;
-(NSString *)paraStrReturnedByDic:(NSDictionary *)dic;
- (NSMutableDictionary *)changeNullWithDic:(NSMutableDictionary *)dic;



//封装 model 打印属性
- (void)FengZhuangWithDic:(NSDictionary *)dic;

-(void)frontPageAction:(UIBarButtonItem *)sender;


- (NSArray *)getAllFileNames:(NSString *)dirName;

@end

