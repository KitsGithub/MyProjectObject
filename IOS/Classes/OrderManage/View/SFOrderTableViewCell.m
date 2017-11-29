//
//  SFOrderTableViewCell.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderTableViewCell.h"

@interface SFOrderTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *costLineView;

@property (weak, nonatomic) IBOutlet UILabel *costTagLable;

@end

@implementation SFOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.oprationBtn.hidden  = YES;
    self.comfirBtn.hidden  = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.oprationBtn addTarget:self action:@selector(firstAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.comfirBtn addTarget:self action:@selector(secondAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d8d8d8"];
}



- (void)setModel:(id<SfOrderProtocol>)model
{
    _model  = model;
    self.fromlable.text  = model.from;
    self.toLable.text    = model.to;
    self.goodsTypeLable.text  = model.goodsNameOrType ? model.goodsNameOrType : model.carType;
    self.goodsCountLable.text = model.goodsWeight ? model.goodsWeight : model.carLone;
    if (model.cost) {
        self.costLineView.hidden  = NO;
        self.costLable.hidden  = NO;
        self.costLable.text  = model.cost;
        self.costTagLable.hidden  = NO;
    }else{
        self.costLineView.hidden  = YES;
        self.costLable.hidden  = YES;
        self.costTagLable.hidden  = YES;
    }
    self.transportStateLable.text  = model.stateStr;
    self.nameLable.text            = model.goodownnerName;
    self.carNumberLable.text       = model.licensePlateNumber;
    
    
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

- (void)setCommonds:(NSArray<SFCommond *> *)commonds
{
    _commonds  = commonds;
    if (!commonds.count) {
        self.oprationBtn.hidden  =  YES;
        self.comfirBtn.hidden   = YES;
    }else if(commonds.count  == 1){
        self.oprationBtn.hidden  =  NO;
        [self.oprationBtn setTitle:commonds.firstObject.name forState:(UIControlStateNormal)];
        self.comfirBtn.hidden   = YES;
    }else if (commonds.count  == 2){
        self.oprationBtn.hidden  =  NO;
        [self.oprationBtn setTitle:commonds.firstObject.name forState:(UIControlStateNormal)];
        self.comfirBtn.hidden   = NO;
        [self.comfirBtn setTitle:commonds.lastObject.name forState:(UIControlStateNormal)];
    }
}

- (void)setStatusStr:(NSString *)statusStr
{
    self.transportStateLable.text = statusStr;
}


@end

