//
//  SFOrderManageController.m
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderManageController.h"
#import "SFOrderListTableViewDelegate.h"
#import "SFEvalViewController.h"

#import "SFDetailViewController.h"
#import "SFCarDetailController.h"

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
    
    [(BaseNavigationController *)self.navigationController SetBottomLineViewHiden:NO];
    
    self.toBarTop.constant  = STATUSBAR_HEIGHT + 44.0;
    [self.view updateConstraintsIfNeeded];
    
    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.view.backgroundColor  = COLOR_LINE_DARK;
    
    __weak typeof(self)wself = self;
    self.orderDelegate  = [[SFOrderListTableViewDelegate alloc] initWithViewController:self tableView:self.tableView];
    self.orderDelegate.loadNewDataCommond = ^(SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getOrderListWithType:SFOrderTypeAll page:1 Success:suc fault:err];
    };
    self.orderDelegate.loadMoreDataCommond = ^(NSInteger page,SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getOrderListWithType:SFOrderTypeAll page:page Success:suc fault:err];
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

        SFDetailViewController *detail = [[SFDetailViewController alloc] init];
        detail.wwwFolderName = SFWL_H5_PATH;
        detail.startPage = @"orderdetail.html";
        detail.title = @"订单详情";
        detail.orderID = model.goods_order;
        detail.hidesBottomBarWhenPushed = YES;
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

- (SFCommond *)firstCommondWithTakingStaus:(SFOrderType)status
{
    switch (status) {
        case SFOrderTypeWaiteForDelivery:
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"确认收货";
            cmd.commond = ^(id  _Nullable obj) {
                
            };
            return cmd;
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
            return cmd;
            break;
        }
        case SFOrderTypeFinish:
        {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"删除";
            cmd.commond = ^(id  _Nullable obj) {
                
            };
            return cmd;
            break;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark  button action
- (IBAction)waiteForSent:(id)sender {
    NSLog(@"waiteForSent");
    [self toDetailWithType:(1)];
}

- (IBAction)waiteForDelivery:(id)sender {
    NSLog(@"waiteForPay");
    [self toDetailWithType:(2)];
}

- (IBAction)inTransit
{
    [self toDetailWithType:(2)];
}

- (IBAction)waiteForEval:(id)sender {
    NSLog(@"waiteForEval");
    [self toDetailWithType:(3)];
}
- (IBAction)finish:(id)sender {
    NSLog(@"finish");
    [self toDetailWithType:(4)];
}

- (void)toDetailWithType:(NSInteger)type
{
    SFOrderListViewController *vc = [[SFOrderListViewController alloc] initWithIndex:type];
    vc.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
}







@end
