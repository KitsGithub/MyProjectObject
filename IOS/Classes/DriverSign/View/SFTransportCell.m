//
//  SFTransportCell.m
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFTransportCell.h"
#import "SFAddressMessageView.h"
@implementation SFTransportCell {
    SFAddressMessageView *_address;
    
    UIImageView *_carNumTips;
    UILabel *_carNum;
    
    UIImageView *_driverTips;
    UILabel *_drivers;
    
    UIView *_buttonView;
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
    
    _address = [[SFAddressMessageView alloc] init];
    [self addSubview:_address];
    
    _carNumTips = [UIImageView new];
    _carNumTips.image = [UIImage imageNamed:@"SFCarList_CarTips"];
    [self addSubview:_carNumTips];
    
    _carNum = [UILabel new];
    _carNum.text = @"粤B 123123";
    _carNum.textColor = COLOR_TEXT_COMMON;
    _carNum.font = [UIFont systemFontOfSize:16];
    [self addSubview:_carNum];
    
    
    _driverTips = [UIImageView new];
    _driverTips.image = [UIImage imageNamed:@"Driver_image"];
    [self addSubview:_driverTips];
    
    _drivers = [UILabel new];
    _drivers.font = [UIFont systemFontOfSize:16];
    _drivers.textColor = COLOR_TEXT_COMMON;
    _drivers.text = @"陈小鸣／李天强／李强／余威";
    [self addSubview:_drivers];
    
    
    _buttonView = [UIView new];
    [self addSubview:_buttonView];
    for (NSInteger index = 0; index < 3; index ++) {
        UIButton *button = [[UIButton alloc] init];
        [_buttonView addSubview:button];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
        button.layer.cornerRadius = 4;
        button.clipsToBounds = YES;
        button.tag = index;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        switch (index) {
            case 0:
                [button setTitle:@"详情" forState:(UIControlStateNormal)];
                [button setBackgroundColor:[UIColor colorWithHexString:@"#f0f0f0"]];
                break;
            case 1:
                [button setTitle:@"送达" forState:(UIControlStateNormal)];
                [button setBackgroundColor:[UIColor colorWithHexString:@"#f0f0f0"]];
                break;
            case 2:
                [button setTitle:@"签到" forState:(UIControlStateNormal)];
                [button setBackgroundColor:THEMECOLOR];
                break;
        }
    }
    
}

- (void)buttonDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFTransportCell:didSelectedButtonAtIndex:)]) {
        [self.delegate SFTransportCell:self didSelectedButtonAtIndex:sender.tag];
    }
}


- (void)setDataType:(DataType)dataType {
    _dataType = dataType;
    switch (dataType) {
        case DataType_Transprot:
            _buttonView.hidden = NO;
            break;
        case DataType_Finished:
            _buttonView.hidden = YES;
            break;
        default:
            break;
    }
}




- (void)layoutSubviews {
    _address.frame = CGRectMake(0, 30, SCREEN_WIDTH, 102);
    
    _carNumTips.frame = CGRectMake(20, CGRectGetMaxY(_address.frame) + 20, 20, 16);
    CGSize carNumSize = [_carNum.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carNum.frame = CGRectMake(CGRectGetMaxX(_carNumTips.frame) + 10, _carNumTips.center.y - carNumSize.height * 0.5, carNumSize.width, carNumSize.height);
    
    _driverTips.frame = CGRectMake(CGRectGetMinX(_carNumTips.frame), CGRectGetMaxY(_carNumTips.frame) + 20, 20, 16);
    CGSize driverSize = [_drivers.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _drivers.frame = CGRectMake(CGRectGetMaxX(_driverTips.frame) + 10, _driverTips.center.y - driverSize.height * 0.5, driverSize.width, driverSize.height);
    
    _buttonView.frame = CGRectMake(20, CGRectGetMaxY(_driverTips.frame) + 30, SCREEN_WIDTH - 40, 44);
    
    CGFloat buttonW = (CGRectGetWidth(_buttonView.frame) - 20) / 3;
    CGFloat buttonH = 44;
    for (NSInteger index = 0; index < _buttonView.subviews.count; index++) {
        UIButton *button = _buttonView.subviews[index];
        button.frame = CGRectMake((buttonW + 10) * index, 0, buttonW, buttonH);
    }
    
}

@end
