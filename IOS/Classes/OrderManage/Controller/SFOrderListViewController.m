//
//  SFOrderListViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderListViewController.h"
#import "SFOrderListTableViewDelegate.h"
#import "SFEvalViewController.h"
#import "SFOrderDetailViewContoller.h"
#import "SFAllotCarController.h"
#import "SFSegmentView.h"

#import "SFOrderCell.h"

@interface SFOrderListViewController ()
@property (weak, nonatomic) IBOutlet SFSegmentView *topBar;
@property (weak, nonatomic) IBOutlet UIView *contentLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineCenterX;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBarTop;


@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *waiteForCommitBtn;
@property (weak, nonatomic) IBOutlet UIButton *waiteForSentBtn;
@property (weak, nonatomic) IBOutlet UIButton *waiteForPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *waiteForEvalBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray <SfOrderProtocol>*dataArray;


@property (nonatomic,strong)SFOrderListTableViewDelegate *orderDelegate;

@end

@implementation SFOrderListViewController

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [self init];
    self.currentIndex  = index;
    return self;
}
- (instancetype)init
{
    if (self = [super initWithNibName:@"SFOrderListViewController" bundle:nil]) {
        
    }
    return self;
}




- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex  = currentIndex;
    [self updateWithIndex:currentIndex];
}


- (void)updateWithIndex:(NSInteger)currentIndex
{
    if (self.topBar.currentIndex  != currentIndex) {
        self.topBar.currentIndex   = currentIndex;
    }
    [self.orderDelegate loadNewData];
}


- (UIButton *)tapBtnWithType:(SFOrderType)type
{
    switch (type) {
        case SFOrderTypeAll:
            return self.allBtn;
            break;
        case 1:
            return self.waiteForPayBtn;
        case 2:
            return self.finishBtn;
        case 3:
            return self.waiteForEvalBtn;
        case 4:
            return self.waiteForSentBtn;
        case 5:
            return self.waiteForCommitBtn;
        default:
            return self.allBtn;
            break;
    }
}

- (NSString *)titleWithType:(SFOrderType)type
{
    switch (type) {
//        case SFOrderTypeAll:
//            return @"全部订单";
//            break;
//        case 1:
//            return @"待支付订单";
//        case SFOrderTypeFinish:
//            return @"已完成订单";
//        case SFOrderTypeWaiteForEval:
//            return @"待评价订单";
//        case SFOrderTypeWaiteForSent:
//            return @"待发货订单";
//        case SFOrderTypeWaitForCommit:
//            return @"待成交订单";
        default:
            return @"我的订单";
            break;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.toBarTop.constant  = [UIApplication sharedApplication].statusBarFrame.size.height + 44.0;

    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.view.backgroundColor  = COLOR_LINE_DARK;
    [(BaseNavigationController *)self.navigationController SetBottomLineViewHiden:NO];
    
    __weak typeof(self)wself = self;
    self.orderDelegate  = [[SFOrderListTableViewDelegate alloc] initWithViewController:self tableView:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SFOrderCell class] forCellReuseIdentifier:@"SFOrderLisCell"];
    
    [self.orderDelegate setSetTableViewCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        SFOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFOrderLisCell"];
        id <SfOrderProtocol>model =  wself.orderDelegate.dataArray[indexPath.row];
        cell.model = model;
        cell.commonds = [wself firstCommondWithTakingStaus:model.orderType];
        return cell;
    }];
    
    self.orderDelegate.loadNewDataCommond = ^(SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getOrderListWithType:[wself statusStr] page:1 Success:suc fault:err];
    };
    
    self.orderDelegate.loadMoreDataCommond = ^(NSInteger page,SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getOrderListWithType:[wself statusStr] page:page Success:suc fault:err];
    };
    
    self.orderDelegate.comondWithStatus = ^NSArray<SFCommond *> *(SFOrderType orderStatus, SFTakingStatus takingStatus) {
        NSMutableArray *marr = [NSMutableArray new];
        SFCommond *firCommond = [wself firstCommondWithTakingStaus:orderStatus];
        if (firCommond) {
            [marr addObject:firCommond];
        }
        return marr;
    };
    
    [self.orderDelegate setSelectedCellWithModle:^(id<SfOrderProtocol>model) {
        
        
        SFOrderDetailViewContoller *detail = [[SFOrderDetailViewContoller alloc] init];
        detail.wwwFolderName = SFWL_H5_PATH;
        detail.title = @"订单详情";
        detail.orderID = model.guid;
        if (model.goods_order.length) {
            detail.startPage = @"orderdetail.html";
        } else {
            detail.startPage = @"orderCardetail.html";
        }
//        if (SF_USER.role == SFUserRoleCarownner) {
//            detail.startPage = @"orderCardetail.html";
//            detail.orderID = model.guid;
//
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            params[@"OrderId"] = model.guid;
//            params[@"UserId"] = USER_ID;
//            [[SFNetworkManage shared] postWithPath:@"CarsBooking/GetOrderDetails" params:params success:^(id result) {
//
//
//            } fault:^(SFNetworkError *err) {
//
//            }];
//
//
//        } else {
//            detail.startPage = @"orderdetail.html";
//            detail.orderID = model.guid;
//        }

        [wself.navigationController pushViewController:detail animated:YES];
        
    }];
    
    [self.orderDelegate loadNewData];
    self.topBar.font = [UIFont systemFontOfSize:14];
    self.topBar.items = [self items];
    
    self.topBar.selectedBlock = ^(NSInteger idx) {
        wself.currentIndex  = idx;
       
    };
    
    [wself updateWithIndex:self.currentIndex];
    
    self.title  = @"订单列表";
    
}

//确认发货
- (void)comfirSentOrderId:(NSString *)orderId
{
    __weak typeof(self)wself = self;
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"OrderId"]   = orderId;
    mdic[@"UserId"] = USER_ID;
    [[SFNetworkManage shared] postWithPath:@"Order/ComfireGoodsDeliver" params:mdic success:^(id result) {
        BOOL isSuc = result;
        if (isSuc) {
            [[SFTipsView shareView] showSuccessWithTitle:@"确认发货成功"];
            [wself.orderDelegate loadNewData];
        }else{
            [[SFTipsView shareView] showSuccessWithTitle:@"确认发货失败"];
        }
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
}

//确认收货
- (void)comfireReceiveWithOrderId:(NSString *)orderId
{
    __weak typeof(self)wself = self;
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"OrderId"]   = orderId;
    mdic[@"UserId"] = USER_ID;
    [[SFNetworkManage shared] postWithPath:@"Order/ComfireGoodsReceipt" params:mdic success:^(id result) {
        BOOL isSuc = result;
        if (isSuc) {
            [[SFTipsView shareView] showSuccessWithTitle:@"确认收货成功"];
            [wself.orderDelegate loadNewData];
        }else{
            [[SFTipsView shareView] showSuccessWithTitle:@"确认收货失败"];
        }
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
}



- (NSArray <SFCommond *> *)firstCommondWithTakingStaus:(SFOrderType)status
{
    __weak typeof(self) weakSelf = self;
    switch (status) {
        case SFOrderTypeWaiteForSent:   //等待发货
        {
            SFCommond *cmd = [SFCommond new];
            if (SF_USER.role == SFUserRoleGoodsownner) {
                cmd.name  = @"确认发货";
                cmd.commond = ^(id  _Nullable obj) {
                    id <SfOrderProtocol> model = obj;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认发货" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认发货" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf comfirSentOrderId:model.guid];
                    }];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                };
            } else {
                cmd.name = @"查看详情";
                cmd.commond = ^(id <SfOrderProtocol> model) {
                    SFOrderDetailViewContoller *detail = [[SFOrderDetailViewContoller alloc] init];
                    detail.wwwFolderName = SFWL_H5_PATH;
                    detail.title = @"订单详情";
                    if (SF_USER.role == SFUserRoleCarownner) {
                        detail.startPage = @"orderCardetail.html";
                    } else {
                        detail.startPage = @"orderdetail.html";
                    }
                    detail.orderID = model.goods_order;
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                };
            }
            return @[cmd];
            break;
        }
        case SFOrderTypeWaiteForDelivery: //等待收货
        {
            SFCommond *cmd = [SFCommond new];
            if (SF_USER.role == SFUserRoleGoodsownner) {
                cmd.name  = @"确认收货";
                cmd.commond = ^(id  _Nullable obj) {
                    id <SfOrderProtocol> model = obj;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认收货" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认收货" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf comfireReceiveWithOrderId:model.guid];
                    }];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                };
            } else {
                cmd.name  = @"待收货";
            }
            return @[cmd];
            break;
        }
//        case SFOrderTypeWaiteForPay:
        case SFOrderTypeWaiteForEvaluate:   //待评价
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"去评价";
            cmd.commond = ^(id  _Nullable obj) {
                id <SfOrderProtocol> model = obj;
                SFEvalViewController *vc = [[SFEvalViewController alloc] init];
                vc.hidesBottomBarWhenPushed  = YES;
                vc.orderId = model.guid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return @[cmd];
            break;
        }
        case SFOrderTypeFinish:         //已完成
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"查看详情";
            cmd.commond = ^(id <SfOrderProtocol> model) {
                SFOrderDetailViewContoller *detail = [[SFOrderDetailViewContoller alloc] init];
                detail.wwwFolderName = SFWL_H5_PATH;
                detail.title = @"订单详情";
                if (SF_USER.role == SFUserRoleCarownner) {
                    detail.startPage = @"orderCardetail.html";
                } else {
                    detail.startPage = @"orderdetail.html";
                }
                detail.orderID = model.goods_order;
                [weakSelf.navigationController pushViewController:detail animated:YES];
            };
            return @[cmd];
            break;
        }
        case SFOrderTypeWaiteToSelecterCar: {
            //待派车
            if (SF_USER.role == SFUserRoleCarownner) {
                SFCommond *cmd = [SFCommond new];
                cmd.name  = @"分配车辆";
                cmd.commond = ^(id <SfOrderProtocol> model) {
                    SFAllotCarController *vc = [[SFAllotCarController alloc] init];
                    vc.hidesBottomBarWhenPushed  = YES;
                    vc.orderId = model.guid;
                    [vc setReturnBlock:^{
                        [weakSelf.orderDelegate loadNewData];
                    }];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
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

- (void)webDidload
{
    [SVProgressHUD dismiss];
}
      
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (NSString *)statusStr
{
    return [self codeArr][self.currentIndex];
}

- (NSArray *)codeArr
{
    return [[SFOrder new] statusCodeArr];
}

- (NSArray *)items
{
    NSArray *arr = [[SFOrder new] statusDescArr];
    return [@[@"全部"] arrayByAddingObjectsFromArray:arr];
}


@end
