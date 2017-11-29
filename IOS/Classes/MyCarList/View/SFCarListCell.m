//
//  SFCarListCell.m
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarListCell.h"

#define NormalFont [UIFont systemFontOfSize:16]

@implementation SFCarListCell {
    UIImageView *_carTips;
    UIView *_lineView;
    UILabel *_carNum;
    UILabel *_carType;
    UILabel *_carLong;
    
    UIButton *_option1;
    UIButton *_option2;
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
    
    _carTips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFCarList_CarTips"]];
    [self addSubview:_carTips];
    
    _carNum = [UILabel new];
    _carNum.textColor = BLACKCOLOR;
    _carNum.font = NormalFont;
    [self addSubview:_carNum];
    
    _carType = [UILabel new];
    _carType.textColor = BLACKCOLOR;
    _carType.font = NormalFont;
    [self addSubview:_carType];
    
    _carLong = [UILabel new];
    _carLong.textColor = BLACKCOLOR;
    _carLong.font = NormalFont;
    [self addSubview:_carLong];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
    
    _option1 = [UIButton new];
    [_option1 setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [_option1 setTitle:@"删除" forState:(UIControlStateNormal)];
    [_option1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [_option1 addTarget:self action:@selector(optionsDidSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    _option1.titleLabel.font = [UIFont systemFontOfSize:14];
    _option1.layer.cornerRadius = 2;
//    _option1.hidden = YES;
    _option1.tag = 0;
    
    [self addSubview:_option1];
    
    _option2 = [UIButton new];
    [_option2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [_option2 setBackgroundColor:THEMECOLOR];
    _option2.titleLabel.font = [UIFont systemFontOfSize:14];
    [_option2 addTarget:self action:@selector(optionsDidSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    _option2.layer.cornerRadius = 2;
    _option2.tag = 1;
    
    [self addSubview:_option2];
}


- (void)optionsDidSelected:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFCarListCell:didSelectedOptionsWithIndex:)]) {
        [self.delegate SFCarListCell:self didSelectedOptionsWithIndex:sender.tag];
    }
}

- (void)setModel:(SFCarListModel *)model {
    _model = model;
    
    _carNum.text = model.car_no;
    _carType.text = model.car_type;
    _carLong.text = model.car_long;
    
    if ([model.verify_status isEqualToString:@"D"]) {
        _option1.hidden = NO;
        _option2.hidden = NO;
        
        [_option1 setTitle:@"认证成功" forState:(UIControlStateNormal)];
        [_option2 setTitle:@"查看认证信息" forState:(UIControlStateNormal)];
    }  else if ([model.verify_status isEqualToString:@"B"]) {
        _option1.hidden = YES;
        _option2.hidden = NO;
        
        [_option2 setTitle:@"审核中" forState:(UIControlStateNormal)];
    } else if ([model.verify_status isEqualToString:@"F"]) {
        _option1.hidden = YES;
        _option2.hidden = NO;
        
        [_option2 setTitle:@"审核失败" forState:(UIControlStateNormal)];
    } else {
        _option1.hidden = NO;
        _option2.hidden = NO;
        
        [_option1 setTitle:@"删除" forState:(UIControlStateNormal)];
        [_option2 setTitle:@"待认证" forState:(UIControlStateNormal)];
    }
    
}


- (void)layoutSubviews {
    _carTips.frame = CGRectMake(20, 20, 20, 16);
    
    CGSize numSize = [_carNum.text sizeWithFont:NormalFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carNum.frame = CGRectMake(CGRectGetMaxX(_carTips.frame) + 10, _carTips.center.y - numSize.height * 0.5, numSize.width, numSize.height);
    
    CGSize typeSize = [_carType.text sizeWithFont:NormalFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carType.frame = CGRectMake(CGRectGetMinX(_carTips.frame), CGRectGetMaxY(_carTips.frame) + 18, typeSize.width, typeSize.height);
    
    CGSize carLongSize = [_carLong.text sizeWithFont:NormalFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carLong.frame = CGRectMake(CGRectGetMaxX(_carType.frame) + 10, CGRectGetMinY(_carType.frame), carLongSize.width, carLongSize.height);
    
    
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 40, 1);
    
    
    CGSize optionSize = [_option2.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat buttonW = optionSize.width + 20 < 76 ? 76 : optionSize.width + 20;
    CGFloat buttonH = 24;
    _option2.frame = CGRectMake(SCREEN_WIDTH - 20 - buttonW, CGRectGetHeight(self.frame) - 20 - buttonH, buttonW, buttonH);
    
    
    CGFloat width = 76;
    CGFloat optino1X = SCREEN_WIDTH - buttonW - width - 30;
    
    _option1.frame = CGRectMake(optino1X, CGRectGetMinY(_option2.frame), width, buttonH);
    
}

@end
