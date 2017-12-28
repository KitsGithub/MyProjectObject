//
//  SFOrderManageController.m
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderManageController.h"
#import "SFOrderListTableViewDelegate.h"

//跳转
#import "SFEvalViewController.h"
#import "SFOrderDetailViewContoller.h"
#import "SFCarDetailController.h"

//自定义View
#import "SFOrderCell.h"

@interface SFOrderManageController ()

@property (weak, nonatomic) IBOutlet UIButton *waiteForCommitBtn;

@property (weak, nonatomic) IBOutlet UIButton *waiteForSentBtn;

@property (weak, nonatomic) IBOutlet UIButton *waitForPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *waiteForEvalBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBarTop;

@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) SFOrderListTableViewDelegate *orderDelegate;

@end

@implementation SFOrderManageController

- (instancetype)init
{
    if (self = [super initWithNibName:@"SFOrderManageController" bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的订单"];
    
    CGFloat buttonW = SCREEN_WIDTH / 5;
    CGFloat buttonH = CGRectGetHeight(self.topBar.frame);
    
    NSArray *titleArray = @[@"待派车",@"待发货",@"待收货",@"待评价",@"已完成"];
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *button = [UIButton new];
        [self.topBar addSubview:button];
        button.frame = CGRectMake(index *buttonW, 0, buttonW, buttonH);
        button.tag = index + 1;
        [button setImage:[UIImage imageNamed:titleArray[index]] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(toDetailWithType:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((buttonW - 30) * 0.5, 18, 30, 30)];
        [button addSubview:imageV];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 15, buttonW, 12)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        titleLabel.text = titleArray[index];
        [button addSubview:titleLabel];
        
    }
    
    
    [(BaseNavigationController *)self.navigationController SetBottomLineViewHiden:NO];
    
    self.toBarTop.constant  = STATUSBAR_HEIGHT + 44.0;
    [self.view updateConstraintsIfNeeded];
    
    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.view.backgroundColor  = COLOR_LINE_DARK;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SFOrderCell class] forCellReuseIdentifier:@"SFOrderCell"];
    
    __weak typeof(self)wself = self;
    self.orderDelegate  = [[SFOrderListTableViewDelegate alloc] initWithViewController:self tableView:self.tableView];
    
    [self.orderDelegate setSetTableViewCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        SFOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFOrderCell"];
        id <SfOrderProtocol>model =  wself.orderDelegate.dataArray[indexPath.row];
        cell.model = model;
        cell.commonds = [wself firstCommondWithTakingStaus:model.orderType];
        return cell;
    }];
    
    
    self.orderDelegate.loadNewDataCommond = ^(SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getOrderListWithType:SFOrderTypeAll page:1 Success:suc fault:err];
    };
    self.orderDelegate.loadMoreDataCommond = ^(NSInteger page,SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getOrderListWithType:SFOrderTypeAll page:page Success:suc fault:err];
    };
    self.orderDelegate.comondWithStatus = ^NSArray<SFCommond *> *(SFOrderType orderStatus, SFTakingStatus takingStatus) {
        return [wself firstCommondWithTakingStaus:orderStatus];
    };
    
    [self.orderDelegate setSelectedCellWithModle:^(id<SfOrderProtocol>model) {
        
        SFOrderDetailViewContoller *detail = [[SFOrderDetailViewContoller alloc] init];
        detail.wwwFolderName = SFWL_H5_PATH;
        detail.orderID = model.guid;
        detail.hidesBottomBarWhenPushed = YES;
        
        if (SF_USER.role == SFUserRoleCarownner) {
            detail.startPage = @"orderCardetail.html";
        } else {
            detail.startPage = @"orderdetail.html";
        }
        
        detail.title = @"订单详情";
        [wself.navigationController pushViewController:detail animated:YES];

    }];
    [self.orderDelegate loadNewData];
    
    [self addNotification];
    
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:SF_LOGIN_SUCCESS_N object:nil];
}

- (void)loginSuccess {
    [self.orderDelegate loadNewData];
}

- (NSArray <SFCommond *> *)firstCommondWithTakingStaus:(SFOrderType)status {
    switch (status) {
        case SFOrderTypeWaiteForDelivery:
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"确认收货";
            cmd.commond = ^(id  _Nullable obj) {
                
            };
            return @[cmd];
            break;
        }
        case SFOrderTypeWaiteForEvaluate:
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"去评价";
            cmd.commond = ^(SFOrder *obj) {
                SFEvalViewController *vc = [[SFEvalViewController alloc] init];
                vc.hidesBottomBarWhenPushed  = YES;
                vc.orderId  = obj.order_no;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return @[cmd];
            break;
        }
        case SFOrderTypeFinish:
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"删除";
            cmd.commond = ^(id  _Nullable obj) {
                NSLog(@"订单 - 删除");
                
            };
            return @[cmd];
            break;
        }
        case SFOrderTypeWaiteToSelecterCar: {
            //待派车
            if (SF_USER.role == SFUserRoleCarownner) {
                SFCommond *cmd = [SFCommond new];
                cmd.name = @"分配司机";
                cmd.commond = ^(id  _Nullable obj) {
                    NSLog(@"分配司机");
                };
                
                SFCommond *cmd2 = [SFCommond new];
                cmd2.name = @"查看详情";
                cmd2.commond = ^(id  _Nullable obj) {
                    NSLog(@"车主查看详情");
                };
                return @[cmd,cmd2];
                
            } else if (SF_USER.role == SFUserRoleGoodsownner) {
                SFCommond *cmd = [SFCommond new];
                cmd.name = @"查看详情";
                cmd.commond = ^(id  _Nullable obj) {
                    NSLog(@"货主查看详情");
                };
                return @[cmd];
            }
            
        }
        default:
            return nil;
            break;
    }
}

#pragma mark  button action
//- (void)waitToSendCar:(id)sender {
//    [self toDetailWithType:(1)];
//}
//
//- (void)waiteForSent:(id)sender {
//    NSLog(@"waiteForSent");
//    [self toDetailWithType:(2)];
//}
//
//- (void)waiteForDelivery:(id)sender {
//    NSLog(@"waiteForPay");
//    [self toDetailWithType:(3)];
//}
//
//- (void)inTransit
//{
//    [self toDetailWithType:(3)];
//}
//
//- (void)waiteForEval:(id)sender {
//    NSLog(@"waiteForEval");
//    [self toDetailWithType:(4)];
//}
//
//- (void)finish:(id)sender {
//    NSLog(@"finish");
//    [self toDetailWithType:(5)];
//}

- (void)toDetailWithType:(UIButton *)sender
{
    SFOrderListViewController *vc = [[SFOrderListViewController alloc] initWithIndex:sender.tag];
    vc.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
}







@end
