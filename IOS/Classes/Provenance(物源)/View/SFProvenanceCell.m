//
//  SFProvenanceCell.m
//  SFLIS
//
//  Created by kit on 2017/12/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFProvenanceCell.h"
#import "SFCarProvenance.h"

@implementation SFProvenanceCell {
    UIView *_fromTips;
    UIView *_lineTips;
    UIView *_toTips;
    
    UILabel *_from;
    UILabel *_to;
    
    UILabel *_orderTime;
    UILabel *_orderStatus;
    UILabel *_otherMessage;
    
    UIView *_bottomLine;
    
    UIButton *_oprationBtn;
    UIButton *_comfirBtn;
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
    
    _fromTips = [UIView new];
    _fromTips.layer.cornerRadius = 3.5;
    _fromTips.clipsToBounds = YES;
    _fromTips.backgroundColor = [UIColor colorWithHexString:@"#7bcf66"];
    [self addSubview:_fromTips];
    
    _toTips = [UIView new];
    _toTips.layer.cornerRadius = 3.5;
    _toTips.clipsToBounds = YES;
    _toTips.backgroundColor = [UIColor colorWithHexString:@"#f75d5d"];
    [self addSubview:_toTips];
    
    _lineTips = [UIView new];
    _lineTips.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
    [self addSubview:_lineTips];
    
    _from = [UILabel new];
    _from.font = [UIFont boldSystemFontOfSize:16];
    _from.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_from];
    
    _to = [UILabel new];
    _to.font = [UIFont boldSystemFontOfSize:16];
    _to.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_to];
    
    _orderTime = [UILabel new];
    _orderTime.textColor = COLOR_TEXT_COMMON;
    _orderTime.font = [UIFont systemFontOfSize:12];
    [self addSubview:_orderTime];
    
    _orderStatus = [UILabel new];
    _orderStatus.backgroundColor = THEMECOLOR;
    _orderStatus.font = [UIFont systemFontOfSize:12];
    _orderStatus.textColor = COLOR_TEXT_COMMON;
    _orderStatus.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderStatus];
    
    _otherMessage = [UILabel new];
    _otherMessage.font = [UIFont systemFontOfSize:12];
    _otherMessage.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_otherMessage];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_bottomLine];
    
    _oprationBtn = [UIButton new];
    _oprationBtn.layer.cornerRadius = 2;
    _oprationBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [_oprationBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    _oprationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_oprationBtn];
    
    _comfirBtn = [UIButton new];
    _comfirBtn.layer.cornerRadius = 2;
    _comfirBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [_comfirBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    _comfirBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_comfirBtn];
    
    
    [_oprationBtn addTarget:self action:@selector(firstAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_comfirBtn addTarget:self action:@selector(secondAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)firstAction:(id)sender
{
    if (self.commonds.count && self.commonds.firstObject.commond) {
        self.commonds.firstObject.commond(self.model);
    }
}

- (void)secondAction:(id)sender
{
    if (self.commonds.count  > 1) {
        self.commonds.lastObject.commond(self.model);
    }
}

- (void)setModel:(id<SFProvenanceProtocol>)model {
    _model = model;
    
    _from.text = model.from;
    _to.text = model.to;
    
    _orderTime.text = model.timeMessage;
    
    _orderStatus.text = model.stateStr;
    
    if (self.currentDirection == SFProvenanceDirectionPublish) {
        ;
        _otherMessage.text = [NSString stringWithFormat:@"待确认订单数:%@",model.usercount];
    } else {
        _otherMessage.text = [NSString stringWithFormat:@"发布人:%@",model.name];
    }
}


- (void)setCommonds:(NSArray<SFCommond *> *)commonds
{
    _commonds  = commonds;
    if (!commonds.count) {
        _oprationBtn.hidden  =  YES;
        _comfirBtn.hidden   = YES;
    }else if(commonds.count  == 1){
        _oprationBtn.hidden  =  NO;
        [_oprationBtn setTitle:commonds.firstObject.name forState:(UIControlStateNormal)];
        _comfirBtn.hidden   = YES;
    }else if (commonds.count  == 2){
        _oprationBtn.hidden  =  NO;
        [_oprationBtn setTitle:commonds.firstObject.name forState:(UIControlStateNormal)];
        _comfirBtn.hidden   = NO;
        [_comfirBtn setTitle:commonds.lastObject.name forState:(UIControlStateNormal)];
    }
}

- (void)layoutSubviews {
    CGSize fromSize = [_from.text sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(SCREEN_WIDTH - 37, MAXFLOAT)];
    _from.frame = CGRectMake(27, 20, fromSize.width, fromSize.height);
    
    CGSize toSize = [_to.text sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(SCREEN_WIDTH - 37, MAXFLOAT)];
    _to.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_from.frame) + 8, toSize.width, toSize.height);
    
    
    _fromTips.frame = CGRectMake(10, _from.center.y - 3.5, 7, 7);
    _toTips.frame = CGRectMake(CGRectGetMinX(_fromTips.frame), _to.center.y - 3.5, 7, 7);
    _lineTips.frame = CGRectMake(_fromTips.center.x - 0.5, CGRectGetMaxY(_fromTips.frame) + 2, 1,  CGRectGetMinY(_toTips.frame) - CGRectGetMaxY(_fromTips.frame) - 4);
    
    
    CGSize orderTimeSize = [_orderTime.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH - 27, MAXFLOAT)];
    _orderTime.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_to.frame) + 20, orderTimeSize.width, orderTimeSize.height);
    
    _orderStatus.frame = CGRectMake(CGRectGetMinX(_from.frame), CGRectGetMaxY(_orderTime.frame) + 10, 41, 18);
    
    CGSize otherSize = [_otherMessage.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _otherMessage.frame = CGRectMake(CGRectGetMaxX(_orderStatus.frame) + 10, _orderStatus.center.y - otherSize.height * 0.5, otherSize.width, otherSize.height);
    
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH, 1);
    
    
    CGFloat buttonW = 76;
    CGFloat butthonH = 24;
    _oprationBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - buttonW, CGRectGetHeight(self.frame) - 20 - butthonH, buttonW, butthonH);
    
    _comfirBtn.frame = CGRectMake(CGRectGetMinX(_oprationBtn.frame) - 10 - buttonW, CGRectGetMinY(_oprationBtn.frame), buttonW, butthonH);
}

@end
