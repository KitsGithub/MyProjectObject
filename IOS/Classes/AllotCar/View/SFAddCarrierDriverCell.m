//
//  SFAddCarrierDriverCell.m
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAddCarrierDriverCell.h"

@implementation SFAddCarrierDriverCell {
    UIButton *_chooseButton;
    UILabel *_driverName;
    
    UIView *_lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    _chooseButton.selected = selected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _chooseButton = [UIButton new];
    [_chooseButton setImage:[UIImage imageNamed:@"Confirm_Normal"] forState:(UIControlStateNormal)];
    [_chooseButton setImage:[UIImage imageNamed:@"Confirm_Selected"] forState:(UIControlStateSelected)];
    [_chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_chooseButton];
    
    _driverName = [UILabel new];
    _driverName.textColor = COLOR_TEXT_COMMON;
    _driverName.font = FONT_COMMON_16;
    [self addSubview:_driverName];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)setDriverModel:(SFDriverModel *)driverModel {
    _driverModel = driverModel;
    _driverName.text = driverModel.driver_by;
    
}

- (void)chooseButtonClick:(UIButton *)sender {
    _selectedDriver = sender.selected = !sender.selected;
}

- (void)layoutSubviews {
    _chooseButton.frame = CGRectMake(20, 18, 20, 20);
    
    CGSize nameSize = [_driverName.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _driverName.frame = CGRectMake(CGRectGetMaxX(_chooseButton.frame) + 10, (CGRectGetHeight(self.frame) - nameSize.height) * 0.5, nameSize.width, nameSize.height);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
    
}

@end
