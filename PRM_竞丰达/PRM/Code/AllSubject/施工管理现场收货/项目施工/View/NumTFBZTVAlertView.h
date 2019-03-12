//
//  XMBGAlertContentView.h
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NumTFHeight   35
#define NumTFPading   5
#define NumTFMargin   15
#define MentionHeight   20
@interface NumTFBZTVAlertView : UIView
@property(nonatomic, strong) QMUILabel *numMentionLab;
@property(nonatomic, strong) QMUITextField *numTF;
@property(nonatomic, strong) QMUILabel *sepLine;
@property(nonatomic, strong) QMUILabel *bzMentionLab;
@property(nonatomic, strong) QMUITextView *BZTV; 
 
@end


