//
//  DXBaseTableHeaderFooterView.m
//  JiYouGe
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 河南咏赞软件有限公司. All rights reserved.
//

#import "DXBaseTableHeaderFooterView.h"

@implementation DXBaseTableHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupHeaderFooterView];
        [self buildSubview];
    }
    
    return self;
}

- (void)setHeaderFooterViewBackgroundColor:(UIColor *)color {
    self.contentView.backgroundColor = color;
}

- (void)setupHeaderFooterView {
    
}

- (void)buildSubview {
    
}

- (void)loadContent {
    
}

+ (void)registerToTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    NSString *identifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
}

+ (void)registerToTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:NSStringFromClass([self class])];
}




@end
