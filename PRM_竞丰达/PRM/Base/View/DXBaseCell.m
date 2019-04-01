//
//  DXBaseCell.m
//  JiYouGe
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 Sonjery. All rights reserved.
//

#import "DXBaseCell.h"

@implementation DXBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static   NSString *identifier = @"DXBaseCell";
    DXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[self className]];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[self className]];
    }
    cell.tableView = tableView;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupCell];
        
        [self buildSubview];
    }
    return self;
}

- (void)setupCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)buildSubview {
    
}

- (void)loadContent {
    
}

- (void)selectedEvent {
    
}

+ (CGFloat)cellHeightWithData:(id)data {
    return 0.f;
}

- (void)setWeakReferenceWithDXCellDataAdapter:(DXCellDataAdapter *)dataAdapter data:(id)data indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    _dataAdapter = dataAdapter;
    _data = data;
    _indexPath = indexPath;
    _tableView = tableView;
}

+ (DXCellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data cellHeight:(CGFloat)height type:(NSInteger)type {
    
    NSString *temReuseIdentifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    return [DXCellDataAdapter DXCellDataAdapterWithCellReuseIdentifier:temReuseIdentifier data:data cellHeight:height cellType:type];
}

+ (DXCellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data cellHeight:(CGFloat)height cellWidth:(CGFloat)cellWidth type:(NSInteger)type {
    
    NSString *temReuseIdentifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    return [DXCellDataAdapter DXCellDataAdapterWithCellReuseIdentifier:temReuseIdentifier data:data cellHeight:height cellWidth:cellWidth cellType:type];
}

+ (DXCellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height type:(NSInteger)type {
    return [[self class] dataAdapterWithCellReuseIdentifier:nil data:data cellHeight:height type:type];
}

+ (DXCellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height {
    return [[self class] dataAdapterWithCellReuseIdentifier:nil data:data cellHeight:height type:0];
}

+ (DXCellDataAdapter *)dataAdapterWithData:(id)data {
    return [[self class] dataAdapterWithCellReuseIdentifier:nil data:data cellHeight:0 type:0];
}

- (void)updateWithNewCellHeight:(CGFloat)height animated:(BOOL)animated {
    if (_tableView && _dataAdapter) {
        if (animated) {
            _dataAdapter.cellHeight = height;
            [_tableView beginUpdates];
            [_tableView endUpdates];
        } else {
            _dataAdapter.cellHeight = height;
            [_tableView reloadData];
        }
    }
}

+ (void)registerToTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
}

+ (void)registerToTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:NSStringFromClass([self class])];
}



-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.lineBreakMode = NSLineBreakByCharWrapping; 
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}


@end
