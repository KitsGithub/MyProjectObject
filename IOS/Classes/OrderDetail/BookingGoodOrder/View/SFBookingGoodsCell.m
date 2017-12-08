//
//  SFBookingGoodsCell.m
//  SFLIS
//
//  Created by kit on 2017/12/4.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingGoodsCell.h"
#import "SFMessageInputView.h"

@interface SFBookingGoodsCell () <SFMessageInputViewDelegate>

@end

@implementation SFBookingGoodsCell {
    UIView *_contentView;
    
    UIButton *_closeButton;
    UIImageView *_carNumImg;
    UILabel *_carNum;
    UILabel *_carType;
    SFMessageInputView *_price;
    
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
    
    _contentView = [UIView new];
    _contentView.layer.borderWidth = 1;
    _contentView.layer.borderColor = COLOR_LINE_DARK.CGColor;
    [self addSubview:_contentView];
    
    
    _carNumImg = [UIImageView new];
    _carNumImg.image = [UIImage imageNamed:@"SFCarList_CarTips"];
    [_contentView addSubview:_carNumImg];
    
    _carNum = [UILabel new];
    _carNum.font = FONT_COMMON_16;
    _carNum.textColor = COLOR_TEXT_COMMON;
    [_contentView addSubview:_carNum];
    
    _carType = [UILabel new];
    _carType.font = FONT_COMMON_16;
    _carType.textColor = COLOR_TEXT_COMMON;
    [_contentView addSubview:_carType];
    
    _price = [SFMessageInputView new];
    _price.keyBoardType = MessageKeyBoardType_FloatOnly;
    _price.delegate = self;
    _price.placeHolder = @"填写报价";
    _price.tipsStr = @"￥";
    [_contentView addSubview:_price];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = THEMECOLOR;
    [_contentView addSubview:_lineView];
    
    _closeButton = [UIButton new];
    [_closeButton setImage:[UIImage imageNamed:@"Nav_Close_Dark"] forState:(UIControlStateNormal)];
    [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_closeButton];
}


- (void)closeButtonClick {
    if ([self.delegate respondsToSelector:@selector(SFBookingGoodsCellDidSelectedDel:)]) {
        [self.delegate SFBookingGoodsCellDidSelectedDel:self];
    }
}

- (void)sfMessageInputViewDidFinishedEditting:(NSString *)str {
    _model.order_fee = str;
}

- (void)setModel:(SFCarListModel *)model {
    _model = model;
    _carNum.text = model.car_no;
    NSString *carType = [NSString stringWithFormat:@"%@ %@ %@ %@",model.car_type,model.car_long,model.dead_weight,model.car_size];
    _carType.text = carType;
    [_price setTitleStr:[NSString stringWithFormat:@"%@",model.order_fee]];
    
}

- (void)layoutSubviews {
    _contentView.frame = CGRectMake(20, (CGRectGetHeight(self.frame) - 161) * 0.5, SCREEN_WIDTH - 40, 161);
    
    _lineView.frame = CGRectMake(0, 0, 2, CGRectGetHeight(_contentView.frame));
    
    _carNumImg.frame = CGRectMake(CGRectGetMaxX(_lineView.frame) + 20, 21, 20, 16);
    
    CGSize carNumSize = [_carNum.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carNum.frame = CGRectMake(CGRectGetMaxX(_carNumImg.frame) + 10, CGRectGetMinY(_carNumImg.frame), carNumSize.width, carNumSize.height);
    
    CGSize carTypeSize = [_carType.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carType.frame = CGRectMake(CGRectGetMinX(_carNumImg.frame), CGRectGetMaxY(_carNumImg.frame) + 18, carTypeSize.width, carTypeSize.height);
    
    
    _price.frame = CGRectMake(20, CGRectGetMaxY(_carType.frame) + 20, CGRectGetWidth(_contentView.frame) - 40, 50);
    
    _closeButton.frame = CGRectMake(CGRectGetWidth(_contentView.frame) - 20 - 24, CGRectGetMinY(_carNumImg.frame), 24, 24);
    
}

@end
