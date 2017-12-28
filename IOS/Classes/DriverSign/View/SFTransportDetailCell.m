//
//  SFTransportDetailCell.m
//  SFLIS
//
//  Created by kit on 2017/11/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFTransportDetailCell.h"
#import "SFTransportLineView.h"
@implementation SFTransportDetailCell {
    UIButton *_tipsView;
    
    UILabel *_time;
    UILabel *_location;
    SFTransportLineView *_lineView;
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
    
    _lineView = [[SFTransportLineView alloc] init];
    _lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_lineView];
    
    
    _tipsView = [UIButton new];
    [_tipsView setImage:[UIImage imageNamed:@"Transprot_Location_Selected"] forState:(UIControlStateSelected)];
    [_tipsView setImage:[UIImage imageNamed:@"Transprot_Location_Normal"] forState:(UIControlStateNormal)];
    _tipsView.userInteractionEnabled = NO;
    [self addSubview:_tipsView];
    
    
    _time = [UILabel new];
    _time.textColor = COLOR_TEXT_DARK;
    _time.font = [UIFont systemFontOfSize:14];
    [self addSubview:_time];
    
    
    _location = [UILabel new];
    _location.textColor = COLOR_TEXT_COMMON;
    _location.font = FONT_COMMON_16;
    _location.numberOfLines = 0;
    [self addSubview:_location];
    
    
    
    
}

- (void)setModel:(SFSignInfoModel *)model {
    _model = model;
    _time.text = model.sign_date;
    _location.text = model.sign_location;
    
}

- (void)setCurrentLoacted:(BOOL)currentLoacted {
    _currentLoacted = currentLoacted;
    _tipsView.selected = currentLoacted;
}

- (void)setShowLineView:(BOOL)showLineView {
    _showLineView = showLineView;
    _lineView.hidden = !showLineView;
}

- (void)layoutSubviews {
    
    _tipsView.frame = CGRectMake(20, 0, 12, 15);
    
    CGFloat timeX = CGRectGetMaxX(_tipsView.frame) + 20;
    CGSize timeSize = [_time.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT - timeX - 24, MAXFLOAT)];
    _time.frame = CGRectMake(timeX , 0, timeSize.width, timeSize.height);
    
    
    CGSize loactionSize = [_location.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(SCREEN_WIDTH - timeX - 24, MAXFLOAT)];
    _location.frame = CGRectMake(timeX, CGRectGetMaxY(_time.frame) + 4, loactionSize.width, loactionSize.height);
    
    _lineView.frame = CGRectMake(_tipsView.center.x, CGRectGetMaxY(_tipsView.frame), 1, CGRectGetHeight(self.frame) - CGRectGetHeight(_tipsView.frame));
}

@end
