//
//  SFOrderCell.m
//  SFLIS
//
//  Created by kit on 2017/12/18.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderCell.h"
#import "SFOrder.h"
@implementation SFOrderCell {
    UILabel *_sender;
    UILabel *_carrier;
    
    UILabel *_orderNum;
    UILabel *_orderCreated;
    UILabel *_orderStatus;
    
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
    
    _sender = [UILabel new];
    _sender.font = [UIFont boldSystemFontOfSize:16];
    _sender.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_sender];
    
    _carrier = [UILabel new];
    _carrier.font = [UIFont boldSystemFontOfSize:16];
    _carrier.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_carrier];
    
    
    _orderNum = [UILabel new];
    _orderNum.font = [UIFont systemFontOfSize:12];
    _orderNum.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_orderNum];
    
    _orderCreated = [UILabel new];
    _orderCreated.font = [UIFont systemFontOfSize:12];
    _orderCreated.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_orderCreated];
    
    _orderStatus = [UILabel new];
    _orderStatus.backgroundColor = THEMECOLOR;
    _orderStatus.text = @"运输中";
    _orderStatus.textColor = COLOR_TEXT_COMMON;
    _orderStatus.font = [UIFont systemFontOfSize:12];
    _orderStatus.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderStatus];
    
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
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_bottomLine];
    
    
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


- (void)setCommonds:(NSArray<SFCommond *> *)commonds {
    _commonds = commonds;
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

- (void)setModel:(id<SfOrderProtocol>)model {
    _model = model;
    _sender.text = [NSString stringWithFormat:@"发货人：%@",model.goodownnerName];
    _carrier.text = [NSString stringWithFormat:@"承运人：%@",model.carownnerName];
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",model.order_no];
    _orderCreated.text = [NSString stringWithFormat:@"订单创建时间：%@",model.order_date];
    
    _orderStatus.text = model.stateStr;
}


- (void)layoutSubviews {
    CGSize senderSize = [_sender.text sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _sender.frame = CGRectMake(20, 20, senderSize.width, senderSize.height);
    
    CGSize carrierSize = [_carrier.text sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _carrier.frame = CGRectMake(CGRectGetMinX(_sender.frame), CGRectGetMaxY(_sender.frame) + 8, carrierSize.width, carrierSize.height);
    
    _orderStatus.frame = CGRectMake(SCREEN_WIDTH - 10 - 51, 31, 41, 18);
    
    CGSize orderNumSize = [_orderNum.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _orderNum.frame = CGRectMake(CGRectGetMinX(_sender.frame), CGRectGetMaxY(_carrier.frame) + 20, orderNumSize.width, orderNumSize.height);
    
    CGSize orderCreatedSize = [_orderCreated.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _orderCreated.frame = CGRectMake(CGRectGetMinX(_sender.frame), CGRectGetMaxY(_orderNum.frame) + 11, orderCreatedSize.width, orderCreatedSize.height);
    
    CGFloat buttonW = 76;
    CGFloat butthonH = 24;
    _oprationBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - buttonW, CGRectGetHeight(self.frame) - 20 - butthonH, buttonW, butthonH);
    
    _comfirBtn.frame = CGRectMake(CGRectGetMinX(_oprationBtn.frame) - 10 - buttonW, CGRectGetMinY(_oprationBtn.frame), buttonW, butthonH);
    
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH, 1);
}

@end
