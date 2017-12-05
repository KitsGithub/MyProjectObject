//
//  SFChooseCarCell.m
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChooseCarCell.h"

@implementation SFChooseCarCell {
    UIImageView *_tipsView;
    UILabel *_carNum;
    UILabel *_detail;
    
    UIButton *_tickImage;
    UIView *_lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    _tickImage.hidden = !selected;
    
}

- (void)showTickImage:(BOOL)show {
    _tickImage.hidden = !show;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _tipsView = [UIImageView new];
    _tipsView.image = [UIImage imageNamed:@"SFCarList_CarTips"];
    [self addSubview:_tipsView];
    
    _carNum = [UILabel new];
    _carNum.textColor = COLOR_TEXT_COMMON;
    _carNum.font = FONT_COMMON_16;
    [self addSubview:_carNum];
    
    _detail = [UILabel new];
    _detail.textColor = COLOR_TEXT_COMMON;
    _detail.font = FONT_COMMON_16;
    [self addSubview:_detail];
    
    
    _tickImage = [UIButton new];
    _tickImage.userInteractionEnabled = NO;
    [_tickImage setImage:[UIImage imageNamed:@"Confirm_Normal"] forState:(UIControlStateNormal)];
    [_tickImage setImage:[UIImage imageNamed:@"Confirm_Selected"] forState:(UIControlStateSelected)];
    _tickImage.hidden = YES;
    [self addSubview:_tickImage];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
}

- (void)setModel:(SFCarListModel *)model {
    _model = model;
    
    _carNum.text = model.car_no;
    NSString *carDetail = [NSString string];
    if (model.car_type.length) {
        carDetail = [carDetail stringByAppendingString:model.car_type];
    }
    _detail.text = [model.car_type stringByAppendingString:[NSString stringWithFormat:@" %@%@%@",model.car_long,model.dead_weight,model.car_size]];
    
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type) {
        _tickImage.hidden = NO;
    } else {
        _tickImage.hidden = YES;
    }
}

- (void)setTickChoose {
    _tickImage.selected = !_tickImage.selected;
    _SFSelected = _tickImage.selected;
}

- (void)layoutSubviews {
    _tipsView.frame = CGRectMake(20, 20, 20, 16);
    
    CGSize carNumSize = [_carNum.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carNum.frame = CGRectMake(CGRectGetMaxX(_tipsView.frame) + 10, 20, carNumSize.width, carNumSize.height);
    
    CGSize detailSize = [_detail.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _detail.frame = CGRectMake(20, CGRectGetMaxY(_tipsView.frame) + 18, detailSize.width, detailSize.height);
    
    _tickImage.frame = CGRectMake(SCREEN_WIDTH - 20 - 20, (CGRectGetHeight(self.frame) - 20) * 0.5, 20, 20);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
    
}

@end
