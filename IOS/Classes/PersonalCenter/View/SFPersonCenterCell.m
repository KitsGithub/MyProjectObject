//
//  SFPersonCenterCell.m
//  SFLIS
//
//  Created by kit on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFPersonCenterCell.h"

@implementation SFPersonCenterCell {
    UIView *_lineView;
    UILabel *_title;
    UIImageView *_arrow;
    UILabel *_subTitle;
    BOOL hasSubView;
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
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
    _title = [UILabel new];
    _title.font = [UIFont systemFontOfSize:16];
    _title.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_title];
    
    _arrow = [UIImageView new];
    _arrow.image = [UIImage imageNamed:@"PersonalCenter_arrow"];
    [self addSubview:_arrow];
    
    
    _subTitle = [UILabel new];
    _subTitle.textColor = [UIColor colorWithHexString:@"666666"];
    _subTitle.font = [UIFont systemFontOfSize:16];
    [self addSubview:_subTitle];
    
    hasSubView = YES;
}

- (void)setTitleStr:(NSString *)titleStr andSubTitleStr:(NSString *)subTitleStr {
    
    _title.text = titleStr;
    if (subTitleStr.length) {
        _subTitle.hidden = NO;
        _arrow.hidden = YES;
        _subTitle.text = subTitleStr;
    } else {
        _arrow.hidden = NO;
        _subTitle.hidden = YES;
    }
    hasSubView = YES;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    if (hasSubView) {
        _lineView.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, 1);
        
        CGFloat buttonH = 77;
        _title.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, buttonH);
        
        _arrow.frame = CGRectMake(SCREEN_WIDTH - 20 - 8, (buttonH - 16) * 0.5, 8, 16);
        
        CGSize subTitleSize = [_subTitle.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _subTitle.frame = CGRectMake(SCREEN_WIDTH - 20 - subTitleSize.width, (buttonH - subTitleSize.height) * 0.5, subTitleSize.width, subTitleSize.height);
        hasSubView = NO;
    }
}

@end
