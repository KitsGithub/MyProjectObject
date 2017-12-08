//
//  SFHomeViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFHomeViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

//跳转
#import "SFPersonalCenterController.h"      //个人中心
#import "SFOrderDetailController.h"         //货源详情
#import "SFCarDetailController.h"           //车源详情
#import "LoginViewController.h"             //登录
#import "SFIdentflyPhoneController.h"       //司机签到
#import "SFSearchViewController.h"          //搜索
//请求
#import "HomeRequestHelper.h"

//自定义控件
#import "HomeViewCell.h"
#import "SFHomeNavBar.h"
#import "SDCycleScrollView.h"


static CGFloat maxDistance = 200;
static NSInteger PageSize = 10;        //数据源每页长度


static NSString *HomeViewCellReusedID = @"HomeViewCellReusedID";


@interface SFHomeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,SFHomeNavBarDelegate,HomeViewCellDelegate,FMDB_Manager_DataSource,FMDB_Manager_Delegate>

@property (weak, nonatomic) SDCycleScrollView *bannerView;
@property (nonatomic, weak) SFHomeNavBar *navBar;

@property (nonatomic, assign) ResourceType resourceType;
@property (nonatomic, strong) NSMutableArray <GoodsSupply *>*dataArray;
@property (nonatomic, strong) NSMutableArray <GoodsSupply *>*orderListArray;
@property (nonatomic, strong) NSMutableArray <GoodsSupply *>*carListArray;

@property (nonatomic, assign) NSUInteger goodsListPageControl;
@property (nonatomic, assign) NSUInteger carListPageControl;

@end

@implementation SFHomeViewController{
    UITableView *_tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //防止banner 卡在屏幕中间
    [_bannerView adjustWhenControllerViewWillAppera];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //布局
    [self setupView];
    [self setupNavigationBar];
    [self setupBanner];
    
    //创建数据库相关
    [self creatDB];
    [self getDataFromDB];
    
    //请求数据
//    [self requestBanner];
    [self requestList:self.goodsListPageControl];
    [self getCarList:self.carListPageControl];
    
    self.view.backgroundColor  = COLOR_BG;
    
    [self addNotification];
    
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:SF_LOGIN_SUCCESS_N object:nil];
}

- (void)loginSuccess {
    self.goodsListPageControl = self.carListPageControl = 1;
    
    [self requestList:self.goodsListPageControl];
    [self getCarList:self.carListPageControl];
}

#pragma mark - 网络请求
/**
 请求 banner 数据
 */
//- (void)requestBanner {
//    [HomeRequestHelper fectchBannerInfoListWithSuccess:^(NSArray<id<BannerInfoProtocol>> *result) {
//        self.bannerView.imageURLStringsGroup  = result;
//        self.bannerView.showPageControl = result.count > 1;
//    } fault:^(SFNetworkError *err) {
//        self.bannerView.showPageControl = NO;
//    }];
//}



/**
 获取货源接口

 @param pageControl 页码
 */
- (void)requestList:(NSInteger)pageControl {
    [HomeRequestHelper fetchGoodsSuplyListWithPage:pageControl num:PageSize Success:^(NSArray<GoodsSupply *> *result) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        if (pageControl == 1) {
            self.orderListArray = [result mutableCopy];
            [self saveGoodListToDB:self.orderListArray];
        } else {
            [self.orderListArray addObjectsFromArray:result];
        }
        
        [_tableView reloadData];
        
    } fault:^(SFNetworkError *err) {
        
        //失败则从数据库中拿出缓存数据
        if (pageControl == 1) {
            __weak typeof(self) weakSelf = self;
            [[FMDB_Manager shareManager] SearchTable:[GoodsSupply class] withOptions:@"1" callBack:^(NSArray<NSObject *> *array) {
                
                weakSelf.orderListArray = [array copy];
                [_tableView reloadData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                
            }];
        }
    }];
}

/**
 获取车源列表

 @param pageControl : 页码
 */
- (void)getCarList:(NSInteger)pageControl {
    [HomeRequestHelper fetchCardListwithPage:pageControl num:PageSize Success:^(NSArray<CarsSupply *> *result) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (result.count) {
            if (pageControl == 1) {
                self.carListArray = [result mutableCopy];
                [self saveCarListToDB:self.carListArray];
            } else {
                [self.carListArray addObjectsFromArray:[result copy]];
            }
        }
        
        [_tableView reloadData];
        
        
    } fault:^(SFNetworkError *err) {
        //失败则从数据库中拿出缓存数据
        if (pageControl == 1) {
            __weak typeof(self) weakSelf = self;
            [[FMDB_Manager shareManager] SearchTable:[CarsSupply class] withOptions:@"1" callBack:^(NSArray<NSObject *> *array) {
                
                weakSelf.carListArray = [array copy];
                [_tableView reloadData];
                
                [_tableView.mj_footer endRefreshing];
                [_tableView.mj_header endRefreshing];
                
            }];
        }
        
    }];
}

#pragma mark - UIAction
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex  = selectedIndex;
}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    SFIdentflyPhoneController *driverSign = [[SFIdentflyPhoneController alloc] init];
    driverSign.titleStr = @"司机签到";
    driverSign.identiflyType = IdentiflyType_Driver;
    BaseNavigationController *baseVc = [[BaseNavigationController alloc] initWithRootViewController:driverSign];
    [self presentViewController:baseVc animated:YES completion:nil];
}

#pragma mark SFHomeNavBar Delegate

/**
 个人中心
 */
- (void)SFHomeNavBar:(SFHomeNavBar *)navBar didClickUserIcon:(UIButton *)userIcon {
    NSLog(@"点击了头像");
    SFUserInfo *info = SF_USER;
    if (!info.user_id.length) {
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
        
    } else {
        
        SFPersonalCenterController *pc = [[SFPersonalCenterController alloc] init];
        pc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pc animated:YES];
    }
    
}

//切换数据展示类型
- (void)SFHomeNavBar:(SFHomeNavBar *)navBar didChangeReourceType:(NSUInteger)resouceType {
    self.resourceType = resouceType;
    [_tableView reloadData];
//    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


/**
 搜索
 */
- (void)SFHomeNavBar:(SFHomeNavBar *)navBar didClickSearchIcon:(UIButton *)searchIcon {
    SFSearchViewController *vc = [[SFSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark HomeViewCell Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewCell *cell = (HomeViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self HomeViewCell:cell didClickOptionButton:nil];
}

- (void)HomeViewCell:(HomeViewCell *)cell didClickOptionButton:(UIButton *)button {
    NSLog(@"点击了功能按钮");
    
    SFUserInfo *account = SF_USER;
    if (account.role == SFUserRoleUnknown) {
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
        return;
    }
//    if (self.resourceType == Resource_Order && account.role == SFUserRoleGoodsownner) {
//        [[[SFTipsView alloc] init] showFailureWithTitle:@"货主不能预订货物"];
//        return;
//    } else if (self.resourceType == Resource_Car && account.role == SFUserRoleCarownner) {
//        [[[SFTipsView alloc] init] showFailureWithTitle:@"车主不能预订车辆"];
//        return;
//    }
    
    BaseViewController *ToVc;
    if (self.resourceType == Resource_Order) {
        ToVc = (BaseViewController *)[[SFOrderDetailController alloc] initWithOrderID:cell.model.guid];
    } else {
        ToVc = (BaseViewController *)[[SFCarDetailController alloc] initWithOrderID:cell.model.guid];
    }
    ToVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ToVc animated:YES];
}

#pragma mark - 布局
- (void)setupNavigationBar {
    self.fd_prefersNavigationBarHidden = YES;
    
    SFHomeNavBar *navBar = [[SFHomeNavBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 + STATUSBAR_HEIGHT)];
    self.navBar = navBar;
    self.navBar.delegate = self;
    [self.view addSubview:self.navBar];
}

- (void)setupBanner {
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) delegate:self placeholderImage:[UIImage new]];
    cycleView.localizationImageNamesGroup = @[@"Banner_Driver"];
    cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleView.currentPageDotColor = THEMECOLOR;
    self.bannerView = cycleView;
    _tableView.tableHeaderView = self.bannerView;
}

- (void)setupView {
    
    self.carListPageControl = 1;
    self.goodsListPageControl = 1;
    
    __weak typeof(self) weakSelf = self;
    
    //tableView初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.resourceType == Resource_Order) {
            weakSelf.goodsListPageControl ++;
            [weakSelf requestList:weakSelf.goodsListPageControl];
        } else {
            weakSelf.carListPageControl ++;
            [weakSelf getCarList:weakSelf.carListPageControl];
        }
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.resourceType == Resource_Order) {
            weakSelf.goodsListPageControl = 1;
            [weakSelf requestList:weakSelf.goodsListPageControl];
        } else {
            weakSelf.carListPageControl = 1;
            [weakSelf getCarList:weakSelf.carListPageControl];
        }
        
    }];
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[HomeViewCell class] forCellReuseIdentifier:HomeViewCellReusedID];
    
}

#pragma mark - 数据库相关
- (void)getDataFromDB {
    __weak typeof(self) weakSelf = self;
    [[FMDB_Manager shareManager] SearchTable:[GoodsSupply class] withOptions:@"1" callBack:^(NSArray<NSObject *> *array) {
        
        weakSelf.orderListArray = [array copy];
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    }];
    
    [[FMDB_Manager shareManager] SearchTable:[CarsSupply class] withOptions:@"1" callBack:^(NSArray<NSObject *> *array) {
        
        weakSelf.carListArray = [array copy];
        [_tableView reloadData];
        
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        
    }];
}

//创建数据库相关
- (void)creatDB {
    FMDB_Manager *manager = [FMDB_Manager shareManager];
    manager.dataSource = self;
    manager.delegate = self;
    
    [manager creatTableIfNotExistWithModelClass:[GoodsSupply class] callBack:^(BOOL success) {
        if (success) {
            NSLog(@"SFWL_GoodListTable 创建表成功");
        }
    }];
    
    [manager creatTableIfNotExistWithModelClass:[CarsSupply class] callBack:^(BOOL success) {
        if (success) {
            NSLog(@"SFWL_CarListTable 创建表成功");
        }
    }];
    
    NSLog(@"数据库路径 - %@",DBPath);
}

/**
 保存货源列表 第一页数据
 */
- (void)saveGoodListToDB:(NSArray *)modelArray {
    
    //清空第一页数据
    [[FMDB_Manager shareManager] DeletedDataFromTable:[GoodsSupply class] withOptions:@"1" callBack:^(BOOL success) {
        if (success) {
            NSLog(@"删除所有的数据成功");
        }
    }];
    if (self.orderListArray.count) {
        [[FMDB_Manager shareManager] InsertDataInTable:[GoodsSupply class]
                                       withModelsArray:[self.orderListArray copy]
                                              callBack:^(BOOL success)
         {
             if (success) {
                 NSLog(@"插入成功");
             }
         }];
    }
    
}

/**
保存车源列表 第一页数据
 */
- (void)saveCarListToDB:(NSArray *)modelArray {
    //清空第一页数据
    [[FMDB_Manager shareManager] DeletedDataFromTable:[CarsSupply class] withOptions:@"1" callBack:^(BOOL success) {
        if (success) {
            NSLog(@"删除所有的数据成功");
        }
    }];
    
    [[FMDB_Manager shareManager] InsertDataInTable:[CarsSupply class] withModelsArray:[self.carListArray copy] callBack:^(BOOL success) {
        if (success) {
            NSLog(@"插入成功");
        }
    }];
}

#pragma mark FMDBManager delegate
//指定表名
- (NSString *)tableNameWithModelClass:(id)Class {
    if (Class == [GoodsSupply class]) {
        return @"SFWL_GoodListTable";
    } else if (Class == [CarsSupply class]){
        return @"SFWL_CarListTable";
    }
    return @"";
}

- (NSString *)dbPath {
    NSLog(@"dbpath = %@",DBPath);
    return DBPath;
}





#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.resourceType == Resource_Order) {
        self.dataArray = self.orderListArray;
    } else {
        self.dataArray = self.carListArray;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeViewCellReusedID forIndexPath:indexPath];
    cell.delegate = self;
    [cell setModel:self.dataArray[indexPath.section] withResourceType:self.resourceType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 138;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return .001;
    } else
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .001;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y <= 50) {
        [self.navBar setSearchImage:@"Home_Search"];
        
    } else {
        [self.navBar setSearchImage:@"Home_Search_BlackStyle"];
    }
    
    if (y < maxDistance) {
        CGFloat alpha = y / maxDistance;
        alpha = alpha < 0 ? 0 : alpha;
        self.navBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
        [self.navBar setLineViewHidden:YES];
    } else {
        self.navBar.backgroundColor = [UIColor whiteColor];
        [self.navBar setLineViewHidden:NO];
    }
}

@end
