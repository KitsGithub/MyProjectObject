//
//  HomeViewCell.m
//  SFLIS
//
//  Created by kit on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "HomeViewCell.h"
#import "SFUserView.h"
#import "SFDetailView.h"

#define textFont [UIFont systemFontOfSize:16]

@implementation HomeViewCell {
    UILabel *_from;
    UILabel *_to;
    
    UIView *_from_tips;
    UIView *_lineView;
    UIView *_to_tips;
    
    SFUserView *_userView;
    
    UIButton *_optionButton;
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
    
    _from = [UILabel new];
    _from.numberOfLines = 2;
    _from.font = textFont;
    [self addSubview:_from];
    
    
    _to = [UILabel new];
    _to.numberOfLines = 2;
    _to.font = textFont;
    [self addSubview:_to];
    
    
    
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
    
    
    _userView = [[SFUserView alloc] init];
    [self addSubview:_userView];
    
    
    _optionButton = [UIButton new];
    _optionButton.layer.cornerRadius = 2;
    _optionButton.clipsToBounds = YES;
    _optionButton.backgroundColor = THEMECOLOR;
    [_optionButton setTitleColor:[UIColor colorWithHexString:@"3D3D3D"] forState:UIControlStateNormal];
    [_optionButton addTarget:self action:@selector(optionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    _optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_optionButton];
    
}


- (void)setModel:(GoodsSupply *)model withResourceType:(ResourceType)resourceType {
    [_userView setModel:model withResourceType:resourceType];
    self.model = model;
    self.resourceType = resourceType;
}



- (void)setModel:(GoodsSupply *)model {
    _model = model;
    
    NSString *from_Str = [NSString stringWithFormat:@"%@-%@-%@",model.from_province,model.from_city,model.from_district];
    
    NSString *to_Str = [NSString stringWithFormat:@"%@-%@-%@",model.to_province,model.to_city,model.to_district];
    
    _from.text = from_Str;
    _to.text = to_Str;
    
    
    [self setNeedsLayout];
}


- (void)setResourceType:(ResourceType)resourceType {
    _resourceType = resourceType;
    
    if (resourceType == Resource_Order) {
        [_optionButton setTitle:@"接单" forState:UIControlStateNormal];
    } else {
        [_optionButton setTitle:@"预定" forState:UIControlStateNormal];
    }
}


- (void)optionButtonDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HomeViewCell:didClickOptionButton:)]) {
        [self.delegate HomeViewCell:self didClickOptionButton:sender];
    }
}


- (void)layoutSubviews {
    
    CGSize fromSize = [_from.text sizeWithFont:textFont maxSize:CGSizeMake(SCREEN_WIDTH - 37, MAXFLOAT)];
    _from.frame = CGRectMake(27, 20, fromSize.width, fromSize.height);
    
    CGSize toSize = [_to.text sizeWithFont:textFont maxSize:CGSizeMake(SCREEN_WIDTH - 37, MAXFLOAT)];
    _to.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_from.frame) + 8, toSize.width, toSize.height);
    
    
    _from_tips.frame = CGRectMake(10, _from.center.y - 3.5, 7, 7);
    _to_tips.frame = CGRectMake(CGRectGetMinX(_from_tips.frame), _to.center.y - 3.5, 7, 7);
    _lineView.frame = CGRectMake(_from_tips.center.x - 0.5, CGRectGetMaxY(_from_tips.frame) + 2, 1,  CGRectGetMinY(_to_tips.frame) - CGRectGetMaxY(_from_tips.frame) - 4);
    
    _optionButton.frame = CGRectMake(SCREEN_WIDTH - 10 - 56, CGRectGetHeight(self.frame) - 24 - 10, 56, 24);
    
    CGFloat userY = CGRectGetMaxY(_to.frame) + 20;
    _userView.frame = CGRectMake(0, userY, SCREEN_WIDTH, CGRectGetHeight(self.frame) - userY);
}



@end
