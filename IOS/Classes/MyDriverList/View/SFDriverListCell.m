//
//  SFCarListCell.m
//  SFLIS
//
//  Created by kit on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDriverListCell.h"

#define NormalFont [UIFont systemFontOfSize:16]

@implementation SFDriverListCell {
    UILabel *_name;
    UIImageView *_phoneTips;
    UILabel *_phone;
    
    UIButton *_option1;
    UIButton *_option2;
    UIView *_lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _name = [UILabel new];
    _name.textColor = BLACKCOLOR;
    _name.font = NormalFont;
    [self addSubview:_name];
    
    _phone = [UILabel new];
    _phone.textColor = BLACKCOLOR;
    _phone.font = NormalFont;
    [self addSubview:_phone];
    
    _phoneTips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dirvier_Phone"]];
    [self addSubview:_phoneTips];
    
    
    _option1 = [UIButton new];
    [self addSubview:_option1];
    [_option1 setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [_option1 setTitle:@"去认证" forState:(UIControlStateNormal)];
    [_option1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [_option1 addTarget:self action:@selector(optionsDidSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    _option1.titleLabel.font = [UIFont systemFontOfSize:14];
    _option1.layer.cornerRadius = 2;
    _option1.hidden = YES;
    _option1.tag = 0;
    
    
    
    _option2 = [UIButton new];
    [self addSubview:_option2];
    [_option2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [_option2 addTarget:self action:@selector(optionsDidSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    _option2.titleLabel.font = [UIFont systemFontOfSize:14];
    _option2.layer.cornerRadius = 2;
    _option2.tag = 1;
    
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
}

- (void)optionsDidSelected:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFDriverListCell:didSelectedOptionsAtIndex:)]) {
        [self.delegate SFDriverListCell:self didSelectedOptionsAtIndex:sender.tag];
    }
}

- (void)setModel:(SFDriverModel *)model {
    _model = model;
    
    _name.text = model.driver_by;
    _phone.text = model.driver_mobile;
    
    _option1.hidden = YES;
    
    
    if ([model.verify_status isEqualToString:@"D"]) {
        //认证成功
        [_option2 setTitle:@"查看认证状态" forState:(UIControlStateNormal)];
        [_option2 setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    } else if ([model.verify_status isEqualToString:@"C"] || [model.verify_status isEqualToString:@""]) {
        //等待认证
        [_option2 setTitle:@"发起认证" forState:(UIControlStateNormal)];
        [_option2 setBackgroundColor:THEMECOLOR];
        _option1.hidden = NO;
        [_option1 setTitle:@"删除" forState:(UIControlStateNormal)];
        
    } else if ([model.verify_status isEqualToString:@"B"]) {
        //审核中
        [_option2 setTitle:@"查看认证状态" forState:(UIControlStateNormal)];
        [_option2 setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    } else {
        //认证失败
        [_option2 setTitle:@"重新发起认证" forState:(UIControlStateNormal)];
        [_option2 setBackgroundColor:THEMECOLOR];
        _option1.hidden = NO;
        [_option1 setTitle:@"删除" forState:(UIControlStateNormal)];
    }
}




- (void)layoutSubviews {
    CGSize nameSize = [_name.text sizeWithFont:NormalFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _name.frame = CGRectMake(20, 20, nameSize.width, nameSize.height);
    
    _phoneTips.frame = CGRectMake(CGRectGetMaxX(_name.frame) + 20, _name.center.y - 9, 14, 18);
    
    CGSize phoneSize = [_phone.text sizeWithFont:NormalFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _phone.frame = CGRectMake(CGRectGetMaxX(_phoneTips.frame) + 5, CGRectGetMinY(_name.frame), phoneSize.width, phoneSize.height);
    
    CGSize optionSize = [_option2.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat buttonW = optionSize.width + 20;
    CGFloat buttonH = 24;
    _option2.frame = CGRectMake(SCREEN_WIDTH - 20 - buttonW, CGRectGetHeight(self.frame) - 20 - buttonH, buttonW, buttonH);
    
    
    CGFloat width = 76;
    CGFloat optino1X = SCREEN_WIDTH - buttonW - width - 30;
    
    _option1.frame = CGRectMake(optino1X, CGRectGetMinY(_option2.frame), width, buttonH);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
    
}
@end
