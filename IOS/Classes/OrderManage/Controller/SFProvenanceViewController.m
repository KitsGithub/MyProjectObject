//
//  SFProvenanceViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFProvenanceViewController.h"
#import "SFSegmentView.h"
#import "SFOrderTableViewCell.h"
#import "SFOrderListTableViewDelegate.h"
#import "SFOrderManage.h"

//跳转
#import "SFEvalViewController.h"
#import "SFDetailViewController.h"
#import "SFCarDetailController.h"
#import "SFReleaseViewController.h"

@interface SFProvenanceViewController ()


@property (nonatomic,strong)SFSegmentView *segment;

@property (nonatomic,strong)SFSegmentView *segmentToolBar;

@property (nonatomic,strong)UITableView  *tableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)SFOrderListTableViewDelegate *orderDelegate;

@end

@implementation SFProvenanceViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    
    [self setup];
    
    return self;
}

- (instancetype)init
{
    self  = [super init];
    [self setup];
    return self;
}

- (void)setup
{
    self.currentprovenanceType  = SFTakingStatusUnkown;
}

- (NSArray *)titleItems
{
    if([SFAccount currentAccount].role  == SFUserRoleCarownner){
        return @[@"我发的车",@"我接的单"];
    }else{
        return @[@"我发的货",@"我订的车",];
    }
}

- (void)backAction {
    if (self.isPopToRootVc) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = COLOR_BG;
    
    [(BaseNavigationController *)self.navigationController  SetBottomLineViewHiden:NO];
    
    self.navigationController.navigationItem.backBarButtonItem.action = @selector(backAction);
    
    __weak typeof(self) wself = self;
    _segment   = [[SFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 30 + 64 + 64 + 15*2, 44) items:[self titleItems] font:FONT_COMMON_16];
    _segment.lineWidth  = 80;
    _segment.selectedBlock = ^(NSInteger index) {
        wself.currentDirection  = index;
        [wself.orderDelegate loadNewData];
    };
    self.navigationItem.titleView  = _segment;
    
    CGFloat bary  = 44 + [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *line1   = [[UIView alloc] initWithFrame:CGRectMake(0, bary, [UIScreen mainScreen].bounds.size.width, 1)];
    line1.backgroundColor  = COLOR_BG;
    [self.view addSubview:line1];
    
    _segmentToolBar = [[SFSegmentView alloc] initWithFrame:CGRectMake(0, bary, [UIScreen mainScreen].bounds.size.width, 44) items:[self items] font:[UIFont systemFontOfSize:14]];
    _segmentToolBar.selectedBlock = ^(NSInteger idx) {
        wself.currentProvenanceIndex   = idx;
        [wself.orderDelegate loadNewData];
    };
    
    [self.view addSubview:_segmentToolBar];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentToolBar.frame) + 1, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_segmentToolBar.frame)) style:(UITableViewStylePlain)];
    _tableView.backgroundColor  = COLOR_BG;
    [_tableView registerNib:[UINib nibWithNibName:@"SFOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFOrderTableViewCell"];
    [self.view addSubview:_tableView];
    
    self.orderDelegate  = [[SFOrderListTableViewDelegate alloc] initWithViewController:self tableView:self.tableView];
    self.orderDelegate.loadNewDataCommond = ^(SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getProvenanceListWithDirection:wself.currentDirection Type:[wself statusStr] page:1 Success:suc fault:err];
    };
    self.orderDelegate.loadMoreDataCommond = ^(NSInteger page,SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getProvenanceListWithDirection:wself.currentDirection Type:[wself statusStr] page:page Success:suc fault:err];
    };
    self.orderDelegate.comondWithStatus = ^NSArray<SFCommond *> *(SFOrderType orderStatus, SFTakingStatus takingStatus) {
        return [wself commondsWithTakingStaus:takingStatus];
    };
    
    [self.orderDelegate setSelectedCellWithModle:^(id<SfOrderProtocol>model) {
        if (([SFAccount currentAccount].role == SFUserRoleGoodsownner && wself.currentDirection == 0) || ([SFAccount currentAccount].role == SFUserRoleCarownner && wself.currentDirection == 1)) {
            SFDetailViewController *detail = [[SFDetailViewController alloc] init];
            detail.wwwFolderName = SFWL_H5_PATH;
            detail.startPage = @"ProvenanceDetail.html";
            detail.title = @"物源详情";
            detail.orderID = model.guid;
            [wself.navigationController pushViewController:detail animated:YES];
        } else if (([SFAccount currentAccount].role == SFUserRoleGoodsownner && wself.currentDirection == 1) || ([SFAccount currentAccount].role == SFUserRoleCarownner && wself.currentDirection == 0)) {
            SFCarDetailController *carDetail = [[SFCarDetailController alloc] init];
//            carDetail.wwwFolderName = SFWL_H5_PATH;
//            carDetail.startPage = @"carsDetail.html";
//            carDetail.orderID = model.guid;
//            carDetail.showType = NO;
//            carDetail.title = @"车辆详情";
            [wself.navigationController pushViewController:carDetail animated:YES];
        }
        
        
    }];
    [self.orderDelegate loadNewData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCurrentDirection:_currentDirection];
    [self setCurrentProvenanceIndex:_currentProvenanceIndex];
    
}


- (NSArray<SFCommond *>*)commondsWithTakingStaus:(SFTakingStatus)status
{
    __weak typeof(self) wSelf = self;
    if (self.currentDirection  == SFProvenanceDirectionPublish) {
        if (status  == SFTakingStatusCancel || status == SFTakingStatusFinish || status == SFTakingStatusRefuse) {
            return nil;
        }else if (status == SFTakingStatusPublished) {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"编辑";
            cmd.commond = ^(id<SfOrderProtocol> model) {
                SFReleaseViewController *release = [[SFReleaseViewController alloc] init];
                if ([SFAccount currentAccount].role == SFUserRoleCarownner) {
                    release.startPage = @"release_car.html";
                    release.title = @"发布车源";
                } else {
                    release.startPage = @"release_good.html";
                    release.title = @"发布货源";
                }
                
                release.orderId = model.guid;
                [wSelf.navigationController pushViewController:release animated:YES];
            };
            return @[cmd];
        } else {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"撤销";
            __weak typeof(self)wself = self;
            cmd.commond = ^(id<SfOrderProtocol> model) {
                [SFOrderManage recallCarOrderWithId:[model guid] Success:^(BOOL isSuc) {
                    if (isSuc) {
                        [[SFTipsView shareView] showSuccessWithTitle:@"撤销成功"];
                        [wself.orderDelegate loadNewData];
                    }else{
                        [[SFTipsView shareView] showFailureWithTitle:@"撤销失败"];
                    }

                } fault:^(SFNetworkError *err) {
                    [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
                }];
            };
            return @[cmd];
        }
    }else{
        if (status  == SFTakingStatusPublished) {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"撤销";
            __weak typeof(self)wself = self;
            cmd.commond = ^(id<SfOrderProtocol> model) {
                [SFOrderManage cancelGoodOrderWithId:[model guid] Success:^(BOOL isSuc) {
                    if (isSuc) {
                        [[SFTipsView shareView] showSuccessWithTitle:@"撤销成功"];
                        [wself.orderDelegate loadNewData];
                    }else{
                        [[SFTipsView shareView] showFailureWithTitle:@"撤销失败"];
                    }

                } fault:^(SFNetworkError *err) {
                    [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
                }];
            };
            return @[cmd];
        }
        return nil;
    }
}

- (void)setCurrentDirection:(SFProvenanceDirection)currentDirection
{
    _currentDirection  = currentDirection;
    _segmentToolBar.items = [self items];
    if (self.segment.currentIndex  != currentDirection) {
        self.segment.currentIndex  = currentDirection;
    }
    self.currentProvenanceIndex  = 0;
}

- (void)setCurrentProvenanceIndex:(NSInteger)currentProvenanceIndex
{
    _currentProvenanceIndex  = currentProvenanceIndex;
    if (self.segmentToolBar.currentIndex  != currentProvenanceIndex) {
        self.segmentToolBar.currentIndex = currentProvenanceIndex;
    }
}

- (void)setCurrentprovenanceType:(SFTakingStatus)currentprovenanceType
{
    _currentprovenanceType   = currentprovenanceType;
}

- (NSString *)statusStr
{
    return [self codeArr][self.currentProvenanceIndex];
}

- (NSArray *)codeArr
{
    SFProvenanceType type = SFProvenanceTypeCreate([SFAccount currentAccount].role, self.currentDirection);
    NSArray *arr = SFProvenanceTypeGetCodeArr(type);
    return [@[@""] arrayByAddingObjectsFromArray:arr];
}

- (NSArray *)items
{
    SFProvenanceType type = SFProvenanceTypeCreate([SFAccount currentAccount].role, self.currentDirection);
    NSArray *arr = SFProvenanceTypeGetDescArr(type);
    return [@[@"全部"] arrayByAddingObjectsFromArray:arr];
}





@end

