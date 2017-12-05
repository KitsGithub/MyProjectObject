//
//  SFCarDetailCell.m
//  SFLIS
//
//  Created by kit on 2017/11/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarDetailCell.h"



@implementation SFCarDetailCell {
    UILabel *_name;
    UILabel *_carType;
    UILabel *_price;
    
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
    _name.text = @"车辆1详情";
    _name.font = FONT_COMMON_16;
    _name.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_name];
    
    _carType = [UILabel new];
    _carType.text = @"平板车 5.8米 3辆";
    _carType.font = FONT_COMMON_16;
    _carType.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_carType];
    
    _price = [UILabel new];
    _price.text = @"1400元/车";
    _price.font = FONT_COMMON_16;
    _price.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_price];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)layoutSubviews {
    
    CGSize nameSize = [_name.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _name.frame = CGRectMake(20, 20, nameSize.width, nameSize.height);
    
    CGSize typeSize = [_carType.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carType.frame = CGRectMake(CGRectGetMinX(_name.frame), CGRectGetMaxY(_name.frame) + 18, typeSize.width, typeSize.height);
    
    CGSize priceSize = [_price.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _price.frame = CGRectMake(CGRectGetMinX(_name.frame), CGRectGetMaxY(_carType.frame) + 18, priceSize.width, priceSize.height);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 49, 1);
}

@end
