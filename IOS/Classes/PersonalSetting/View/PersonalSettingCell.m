//
//  PersonalSettingCell.m
//  SFLIS
//
//  Created by kit on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "PersonalSettingCell.h"

@implementation PersonalSettingCell {
    UILabel *_tipsLabel;
    UIView *_lineView;
    
    UIImageView *_arrowImage;
    UIImageView *_headerView;
    UILabel *_detailLabel;
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
    
    _tipsLabel = [UILabel new];
    _tipsLabel.textColor = BLACKCOLOR;
    _tipsLabel.font = FONT_COMMON_16;
    [self addSubview:_tipsLabel];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
    
    _headerView = [UIImageView new];
    _headerView.hidden = YES;
    _headerView.clipsToBounds = YES;
    _headerView.layer.cornerRadius = 19;
    _headerView.backgroundColor = RandomColor;
    [self addSubview:_headerView];
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:SF_USER.small_head_src] placeholderImage:[UIImage imageNamed:@"Default_Head"]];
    
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalCenter_arrow"]];
    [self addSubview:_arrowImage];
    
    _detailLabel = [UILabel new];
    _detailLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _detailLabel.font = FONT_COMMON_16;
    _detailLabel.text = @"22113";
    [self addSubview:_detailLabel];
}

- (void)setTitleStr:(NSString *)titleStr {
    _tipsLabel.text = titleStr;
    [self setNeedsLayout];
}

- (void)setDetailStr:(NSString *)detailStr {
    _detailLabel.text = detailStr;
    [self setNeedsLayout];
}

- (void)setShowArrowImage:(BOOL)showArrowImage {
    _showArrowImage = showArrowImage;
    _arrowImage.hidden = !showArrowImage;
}

- (void)setShowHeaderView:(BOOL)showHeaderView {
    _showHeaderView = showHeaderView;
    _headerView.hidden = !showHeaderView;
    _detailLabel.hidden = showHeaderView;
}

- (void)layoutSubviews {
    _tipsLabel.frame = CGRectMake(20, 0, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame));
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 40, 1);
    _arrowImage.frame = CGRectMake(CGRectGetWidth(self.frame) - 20 - 8, (CGRectGetHeight(self.frame) - 16) * 0.5, 8, 16);
    
    CGSize detailSize = [_detailLabel.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _detailLabel.frame = CGRectMake(CGRectGetMinX(_arrowImage.frame) - 10 - detailSize.width, (CGRectGetHeight(self.frame) - detailSize.height) * 0.5, detailSize.width, detailSize.height);
    
    
    _headerView.frame = CGRectMake(CGRectGetMinX(_arrowImage.frame) - 10 - 38, (CGRectGetHeight(self.frame) - 38) * 0.5, 38, 38);
    
}

@end
