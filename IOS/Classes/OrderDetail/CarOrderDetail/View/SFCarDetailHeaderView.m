//
//  SFCarDetailHeaderView.m
//  SFLIS
//
//  Created by kit on 2017/11/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarDetailHeaderView.h"
#import "SFAddressMessageView.h"
@implementation SFCarDetailHeaderView {
    SFAddressMessageView *_address;
    
    UIImageView *_userV;
    UILabel *_name;
    UILabel *_phone;
    
    UIView *_lineView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _address = [SFAddressMessageView new];
    [self addSubview:_address];
    
    _userV = [UIImageView new];
    _userV.layer.cornerRadius = 19;
    _userV.clipsToBounds = YES;
    _userV.image = [UIImage imageNamed:@"Default_Head"];
    [self addSubview:_userV];
    
    _name = [UILabel new];
    _name.font = FONT_COMMON_16;
    _name.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_name];
    
    _phone = [UILabel new];
    _phone.font = FONT_COMMON_16;
    _phone.textColor = [UIColor colorWithHexString:@"#4c90ff"];
    [self addSubview:_phone];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)setModel:(SFCarOrderDetailModel *)model {
    
    [_userV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Resource_URL,model.head_src]] placeholderImage:[UIImage imageNamed:@"Default_Head"]];
    
    _address.fromAddress = [NSString stringWithFormat:@"%@-%@-%@",model.from_province,model.from_city,model.from_district];
    _address.fromDistrict = model.from_address;
    
    _address.toAddress = [NSString stringWithFormat:@"%@-%@-%@",model.to_province,model.to_city,model.to_district];
    _address.toDistrict = model.to_address;
    
    _name.text = model.name;
    _phone.text = model.mobile;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    _address.frame = CGRectMake(0, 30, SCREEN_WIDTH, 102);
    
    _userV.frame = CGRectMake(20, CGRectGetMaxY(_address.frame) + 20, 38, 38);
    
    CGFloat nameX = CGRectGetMaxX(_userV.frame) + 10;
    CGSize nameSize = [_name.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _name.frame = CGRectMake(nameX, CGRectGetMinY(_userV.frame), nameSize.width, nameSize.height);
    
    
    CGSize phoneSize = [_phone.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _phone.frame = CGRectMake(nameX, CGRectGetMaxY(_userV.frame) - phoneSize.height, phoneSize.width, phoneSize.height);
    
    _lineView.frame = CGRectMake(20, CGRectGetMaxY(self.frame) - 1, SCREEN_WIDTH - 40, 1);
}

@end
