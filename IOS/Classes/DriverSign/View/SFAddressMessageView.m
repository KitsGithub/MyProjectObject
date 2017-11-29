//
//  SFAddressMessageView.m
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAddressMessageView.h"

#define textFont [UIFont boldSystemFontOfSize:16]
#define smallFont [UIFont systemFontOfSize:14]
@implementation SFAddressMessageView {
    UILabel *_from;
    UILabel *_fromDetail;
    UILabel *_to;
    UILabel *_toDetail;
    
    UIView *_from_tips;
    UIView *_lineView;
    UIView *_to_tips;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    _from = [UILabel new];
    _from.numberOfLines = 2;
    _from.textColor = COLOR_TEXT_COMMON;
    _from.text = @"河北省-石家庄市-长安区";
    _from.font = textFont;
    [self addSubview:_from];
    
    _fromDetail = [UILabel new];
    _fromDetail.numberOfLines = 2;
    _fromDetail.textColor = [UIColor colorWithHexString:@"#999999"];
    _fromDetail.text = @"东山门街道李记水果店";
    _fromDetail.font = smallFont;
    [self addSubview:_fromDetail];
    
    _to = [UILabel new];
    _to.numberOfLines = 2;
    _to.textColor = COLOR_TEXT_COMMON;
    _to.font = textFont;
    _to.text = @"天津市-市辖区-河东区";
    [self addSubview:_to];
    
    _toDetail = [UILabel new];
    _toDetail.numberOfLines = 2;
    _toDetail.textColor = [UIColor colorWithHexString:@"#999999"];
    _toDetail.text = @"中山门街道张记包子铺";
    _toDetail.font = smallFont;
    [self addSubview:_toDetail];
    
    _from_tips = [UIView new];
    _from_tips.layer.cornerRadius = 3.5;
    _from_tips.clipsToBounds = YES;
    _from_tips.backgroundColor = [UIColor colorWithHexString:@"7BCF66"];
    [self addSubview:_from_tips];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    [self addSubview:_lineView];
    
    _to_tips = [UIView new];
    _to_tips.layer.cornerRadius = 3.5;
    _to_tips.clipsToBounds = YES;
    _to_tips.backgroundColor = [UIColor colorWithHexString:@"F75D5D"];
    [self addSubview:_to_tips];
}

- (void)layoutSubviews {
    CGSize fromSize = [_from.text sizeWithFont:textFont maxSize:CGSizeMake(SCREEN_WIDTH - 37, MAXFLOAT)];
    _from.frame = CGRectMake(37, 0, fromSize.width, fromSize.height);
    
    CGSize fromDetailSize = [_fromDetail.text sizeWithFont:smallFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _fromDetail.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_from.frame) + 5, fromDetailSize.width, fromDetailSize.height);
    
    
    CGSize toSize = [_to.text sizeWithFont:textFont maxSize:CGSizeMake(SCREEN_WIDTH - 37, MAXFLOAT)];
    _to.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_fromDetail.frame) + 20, toSize.width, toSize.height);
    
    CGSize toDetailSize = [_toDetail.text sizeWithFont:smallFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _toDetail.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_to.frame) + 5, toDetailSize.width, toDetailSize.height);
    
    
    _from_tips.frame = CGRectMake(20, _from.center.y - 3.5, 7, 7);
    _to_tips.frame = CGRectMake(CGRectGetMinX(_from_tips.frame), _to.center.y - 3.5, 7, 7);
    _lineView.frame = CGRectMake(_from_tips.center.x - 0.5, CGRectGetMaxY(_from_tips.frame) + 8, 1,  CGRectGetMinY(_to_tips.frame) - CGRectGetMaxY(_from_tips.frame) - 16);
}

@end
