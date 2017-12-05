//
//  SFAllotCarrierCell.m
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAllotCarrierCell.h"
#import "SFDriversView.h"

@implementation SFAllotCarrierCell {
    UIButton *_firstButton;
    UIButton *_secondButton;
    
    UILabel *_carNum;
    UIView *_lineView1;
    UIView *_lineView2;
    UILabel *_driverTips;
    
    UIImageView *_arrowDown;
    UIImageView *_arrowRight;
    
    UIView *_eddittingView;
    UIButton *_firstCar;
    UIButton *_delButton;
    
    SFDriversView *_dvriverView;
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
    
    
    _firstButton = [UIButton new];
    _firstButton.tag = 1;
    [_firstButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_firstButton];
    
    _carNum = [UILabel new];
    _carNum.font = FONT_COMMON_16;
    _carNum.textColor = COLOR_TEXT_COMMON;
    _carNum.text = @"请选择车牌";
    [_firstButton addSubview:_carNum];
    
    _secondButton = [UIButton new];
    _secondButton.tag = 2;
    [_secondButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_secondButton];
    
    _driverTips = [UILabel new];
    _driverTips.font = FONT_COMMON_16;
    _driverTips.text = @"添加司机";
    _driverTips.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_driverTips];
    
    _lineView1 = [UIView new];
    _lineView1.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView1];
    
    _lineView2 = [UIView new];
    _lineView2.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView2];
    
    _arrowDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalCenter_arrow"]];
    [self addSubview:_arrowDown];
    
    _arrowRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalCenter_arrow"]];
    [self addSubview:_arrowRight];
    
    _eddittingView = [UIView new];
    [self addSubview:_eddittingView];
    
    _firstCar = [UIButton new];
    [_firstCar setTitle:@"首发车辆" forState:(UIControlStateNormal)];
    [_firstCar setTitle:@"首发车辆" forState:(UIControlStateSelected)];
    [_firstCar setImage:[UIImage imageNamed:@"Confirm_Normal"] forState:(UIControlStateNormal)];
    [_firstCar setImage:[UIImage imageNamed:@"Confirm_Selected"] forState:(UIControlStateSelected)];
    [_firstCar setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [_firstCar addTarget:self action:@selector(setFirstCar:) forControlEvents:(UIControlEventTouchUpInside)];
    _firstCar.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _firstCar.titleLabel.font = FONT_COMMON_16;
    
    [_eddittingView addSubview:_firstCar];
    
    
    _delButton = [UIButton new];
    [_delButton setTitle:@"删除" forState:(UIControlStateNormal)];
    [_delButton setImage:[UIImage imageNamed:@"CarrierDel"] forState:(UIControlStateNormal)];
    [_delButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    _delButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _delButton.tag = 1;
    _delButton.titleLabel.font = FONT_COMMON_16;
    [_delButton addTarget:self action:@selector(optionsClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_eddittingView addSubview:_delButton];
    
    _dvriverView = [[SFDriversView alloc] init];
    [self addSubview:_dvriverView];
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFAllotCarrierCell:didSelectedButtonWithIndex:)]) {
        [self.delegate SFAllotCarrierCell:self didSelectedButtonWithIndex:sender.tag];
    }
}

- (void)optionsClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFAllotCarrierCell:didSelectedOptionsWithIndex:)]) {
        [self.delegate SFAllotCarrierCell:self didSelectedOptionsWithIndex:sender.tag];
    }
}


- (void)setFirstCar:(UIButton *)sender {
    _firstCar.selected = !sender.selected;
    [self optionsClick:sender];
}


- (void)setModel:(id<SFCarrierProtocol>)model {
    _model = model;
    _driverTips.text = @"司机管理";
    _carNum.text = model.carNum;
    
    _dvriverView.driverList = [model.driverNameArray copy];
    
    [self setNeedsLayout];
}

- (void)setEnableEdditting:(BOOL)enableEdditting {
    _enableEdditting = enableEdditting;
    _eddittingView.hidden = _lineView2.hidden =  !enableEdditting;
}





- (void)layoutSubviews {
    
    _firstButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 76);
    
    CGSize numSize = [_carNum.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carNum.frame = CGRectMake(20, (CGRectGetHeight(_firstButton.frame) - numSize.height) * 0.5, numSize.width, numSize.height);
    
    _lineView1.frame = CGRectMake(20, CGRectGetMaxY(_carNum.frame) + 30, SCREEN_WIDTH - 40, 1);
    _driverTips.frame = CGRectMake(20, CGRectGetMaxY(_lineView1.frame) + 30, 70, 16);
    
    _arrowDown.frame = CGRectMake(SCREEN_WIDTH - 20 - 8, _carNum.center.y - 8, 8, 16);
    _arrowRight.frame = CGRectMake(SCREEN_WIDTH - 20 - 8, _driverTips.center.y - 8, 8, 16);
    
    _lineView2.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 56, SCREEN_WIDTH - 40, 1);
    
    
    
    _eddittingView.frame = CGRectMake(0, CGRectGetMaxY(_lineView2.frame), SCREEN_WIDTH, 56);
    _firstCar.frame = CGRectMake(20, (CGRectGetHeight(_eddittingView.frame) - 30) * 0.5 , 25+67, 30);
    _delButton.frame = CGRectMake(SCREEN_WIDTH - 20 - 53,(CGRectGetHeight(_eddittingView.frame) - 30) * 0.5, 60, 30);
    
    
    _dvriverView.frame = CGRectMake(20, CGRectGetMaxY(_driverTips.frame) + 20, SCREEN_WIDTH - 40, CGRectGetMinY(_lineView2.frame) - CGRectGetMaxY(_driverTips.frame) - 20);
    
    if (self.enableEdditting) {
        _secondButton.frame = CGRectMake(0, CGRectGetMaxY(_firstButton.frame), SCREEN_WIDTH, CGRectGetMinY(_lineView2.frame) - CGRectGetMaxY(_firstButton.frame));
    } else {
        _secondButton.frame = CGRectMake(0, CGRectGetMaxY(_firstButton.frame), SCREEN_WIDTH, CGRectGetHeight(self.frame) - CGRectGetMaxY(_firstButton.frame));
    }
    
}



@end
