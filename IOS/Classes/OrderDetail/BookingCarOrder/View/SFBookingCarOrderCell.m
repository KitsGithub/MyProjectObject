//
//  SFBookingCarOrderCell.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingCarOrderCell.h"

@implementation SFBookingCarOrderCell {
    UILabel *_message1;
    UILabel *_message2;
    
    UIButton *_delButton;
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
    
    _message1 = [UILabel new];
    _message1.font = FONT_COMMON_16;
    _message1.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:_message1];
    
    _message2 = [UILabel new];
    _message2.font = FONT_COMMON_16;
    _message2.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:_message2];
    
    _delButton = [UIButton new];
    [_delButton setTitle:@"删除" forState:(UIControlStateNormal)];
    [_delButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:(UIControlStateNormal)];
    [_delButton setImage:[UIImage imageNamed:@"CarrierDel"] forState:(UIControlStateNormal)];
    [_delButton addTarget:self action:@selector(delButtonDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    _delButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _delButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [self addSubview:_delButton];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)delButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(SFBookingCarOrderCellDidClickDelButton:)]) {
        [self.delegate SFBookingCarOrderCellDidClickDelButton:self];
    }
}

- (void)setModel:(SFBookingCarModel *)model {
    _model = model;
    
    NSString *carType;
    if (model.car_type.length) {
        carType = model.car_type;
    } else {
        carType = @"任意车类型";
    }
    
    NSString *carLong;
    if (model.car_long.length) {
        carLong = model.car_long;
    } else {
        carLong = @"任意车长";
    }
    
    NSString *carWeight;
    if (model.car_weight.length) {
        carWeight = model.car_weight;
    } else {
        carWeight = @"0";
    }
    
    NSString *carSize;
    if (model.car_size.length) {
        carSize = model.car_size;
    } else {
        carSize = @"0";
    }
    
    _message1.text = [NSString stringWithFormat:@"%@ %@ %@辆",carType,carLong,model.car_count];
    _message2.text = [NSString stringWithFormat:@"%@吨 %@方  %@元/车",carWeight,carSize,model.car_fee];
    
}

- (void)layoutSubviews {
    CGSize firstSize = [_message1.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _message1.frame = CGRectMake(20, 30, firstSize.width, firstSize.height);
    
    CGSize secondSize = [_message2.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _message2.frame = CGRectMake(20, CGRectGetMaxY(_message1.frame) + 18, secondSize.width, secondSize.height);
    
    _delButton.frame = CGRectMake(SCREEN_WIDTH - 73, (CGRectGetHeight(self.frame) - 16) * 0.5, 58, 16);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
}

@end
