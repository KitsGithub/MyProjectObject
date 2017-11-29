//
//  SFOrderTableViewCell.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SfOrderProtocol.h"
#import "SFCommond.h"

//@class SFOrderTableViewCell;
//@protocol  SFOrderTableViewCellDelegate
//
//- (void)SFOrderTableViewCell:(SFOrderTableViewCell *)cell toSentWithModel:(id<SfOrderProtocol>)model;
//
//- (void)SFOrderTableViewCell:(SFOrderTableViewCell *)cell toCancleWithModel:(id<SfOrderProtocol>)model;
//
//- (void)SFOrderTableViewCell:(SFOrderTableViewCell *)cell toDelivaryWithModel:(id<SfOrderProtocol>)model;
//
//- (void)SFOrderTableViewCell:(SFOrderTableViewCell *)cell toDeleteeWithModel:(id<SfOrderProtocol>)model;
//
//- (void)SFOrderTableViewCell:(SFOrderTableViewCell *)cell toEvalWithModel:(id<SfOrderProtocol>)model;
//
//@end

@interface SFOrderTableViewCell : UITableViewCell

//@property (nonatomic,weak)id<SFOrderTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *fromlable;

@property (weak, nonatomic) IBOutlet UILabel *toLable;

@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLable;

@property (weak, nonatomic) IBOutlet UILabel *goodsCountLable;

@property (weak, nonatomic) IBOutlet UILabel *costLable;

@property (weak, nonatomic) IBOutlet UILabel *transportStateLable;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *carNumberLable;

@property (weak, nonatomic) IBOutlet UIButton *oprationBtn;

@property (weak, nonatomic) IBOutlet UIButton *comfirBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong)NSArray <SFCommond *>*commonds;

@property (nonatomic,strong)id<SfOrderProtocol> model;

- (void)setStatusStr:(NSString *)statusStr;


@end
