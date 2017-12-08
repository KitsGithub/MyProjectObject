//
//  SFCarDetailFooterView.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarDetailFooterView.h"

@implementation SFCarDetailFooterView {
    UILabel *_title;
    UILabel *_message;
    
    UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _title = [UILabel new];
    _title.font = FONT_COMMON_16;
    _title.text = @"备注";
    _title.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_title];
    
    _message = [UILabel new];
    _message.font = FONT_COMMON_16;
    _message.textColor = [UIColor colorWithHexString:@"#666666"];
    _message.numberOfLines = 0;
    _message.text = @"未填写备注";
    [self addSubview:_message];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)setRemark:(NSString *)remark {
    if (remark.length) {
        _message.text = remark;
    }
}

- (void)layoutSubviews {
    CGSize titleSize = [_title.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _title.frame = CGRectMake(20, 20, titleSize.width, titleSize.height);
    
    CGSize messageSize = [_message.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    _message.frame = CGRectMake(20, CGRectGetMaxY(_title.frame) + 15, messageSize.width, messageSize.height);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
}

@end
