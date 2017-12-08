//
//  SFOrderDetailCell.m
//  SFLIS
//
//  Created by kit on 2017/12/4.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderDetailCell.h"

@implementation SFOrderDetailCell {
    UILabel *_titleLabel;
    UILabel *_message;
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
    
    _titleLabel = [UILabel new];
    _titleLabel.font = FONT_COMMON_16;
    _titleLabel.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_titleLabel];
    
    _message = [UILabel new];
    _message.font = FONT_COMMON_16;
    _message.textColor = [UIColor colorWithHexString:@"#666666"];
    _message.text = @"水果 10吨 50方";
    _message.numberOfLines = 0;
    [self addSubview:_message];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)layoutSubviews {
    CGSize titleSize = [_titleLabel.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGSize messageSize = [_message.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    
    _titleLabel.frame = CGRectMake(20, (CGRectGetHeight(self.frame) - titleSize.height - messageSize.height - 18) * 0.5, titleSize.width, titleSize.height);
    
    
    _message.frame = CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 18, messageSize.width, messageSize.height);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
}

@end
