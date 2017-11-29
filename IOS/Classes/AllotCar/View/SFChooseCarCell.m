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
    
    UIImageView *_tickImage;
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

- (void)showTickImage:(BOOL)hidden {
    _tickImage.hidden = hidden;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _tipsView = [UIImageView new];
    _tipsView.image = [UIImage imageNamed:@"SFCarList_CarTips"];
    [self addSubview:_tipsView];
    
    _carNum = [UILabel new];
    _carNum.textColor = COLOR_TEXT_COMMON;
    _carNum.font = [UIFont systemFontOfSize:16];
    [self addSubview:_carNum];
    
    _detail = [UILabel new];
    _detail.textColor = COLOR_TEXT_COMMON;
    _detail.font = [UIFont systemFontOfSize:16];
    [self addSubview:_detail];
    
    
    _tickImage = [UIImageView new];
    _tickImage.image = [UIImage imageNamed:@"Tick_Image"];
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

- (void)layoutSubviews {
    _tipsView.frame = CGRectMake(20, 20, 20, 16);
    
    CGSize carNumSize = [_carNum.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carNum.frame = CGRectMake(CGRectGetMaxX(_tipsView.frame) + 10, 20, carNumSize.width, carNumSize.height);
    
    CGSize detailSize = [_detail.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _detail.frame = CGRectMake(20, CGRectGetMaxY(_tipsView.frame) + 18, detailSize.width, detailSize.height);
    
    _tickImage.frame = CGRectMake(SCREEN_WIDTH - 20 - 16, (CGRectGetHeight(self.frame) - 12) * 0.5, 16, 12);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
    
}

@end
