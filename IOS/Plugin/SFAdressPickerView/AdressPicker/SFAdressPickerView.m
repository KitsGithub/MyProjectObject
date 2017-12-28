//
//  SFAdressPickerView.m
//  SFLIS
//
//  Created by kit on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAdressPickerView.h"
#import "SFAdressPickerCell.h"
#import "SFButtonView.h"

@interface SFAdressPickerView () <UIPickerViewDataSource,UIPickerViewDelegate,SFButtonViewDelegate>

/** 省 **/
@property (strong,nonatomic)NSArray *provinceList;
/** 市 **/
@property (strong,nonatomic)NSArray *cityList;
/** 区 **/
@property (strong,nonatomic)NSArray *areaList;

@property (nonatomic, strong) NSArray *alwaysUseArray;

/** 第一级选中的下标 **/
@property (assign, nonatomic)NSInteger selectOneRow;
/** 第二级选中的下标 **/
@property (assign, nonatomic)NSInteger selectTwoRow;
/** 第三级选中的下标 **/
@property (assign, nonatomic)NSInteger selectThreeRow;

@property (nonatomic, strong) NSString *adressStr;

@property (nonatomic,copy)void(^_Nullable completion)(NSString *_Nullable address);

@end

@implementation SFAdressPickerView {
    UIButton *_bjButton;        //背景
    UIView *_contentView;       //容器
    UIButton *_closeButton;     //关闭
    UILabel *_titileLabel;      //标题1
    SFButtonView *_buttonView;  //常用可选框
    UILabel *_tipsLabel;        //标题2
    
    
    UIButton *_commitButton;    //确定按钮
    
    UIPickerView *_picker;
    UIView *_coverView;
    
    BOOL hasSubView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _bjButton = [[UIButton alloc] init];
    [_bjButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    [_bjButton addTarget:self action:@selector(bjViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    _bjButton.alpha = 0;
    [self addSubview:_bjButton];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 400)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _titileLabel = [UILabel new];
    _titileLabel.textColor = BLACKCOLOR;
    _titileLabel.font = [UIFont boldSystemFontOfSize:20];
    _titileLabel.text = @"常用";
    [_contentView addSubview:_titileLabel];
    
    _closeButton = [UIButton new];
    [_closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(bjViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    
    
    _buttonView = [[SFButtonView alloc] init];
    [_buttonView setTitleViewWithArray:self.alwaysUseArray];
    _buttonView.delegate = self;
    [_contentView addSubview:_buttonView];
    
    
    
    _tipsLabel = [UILabel new];
    _tipsLabel.textColor = BLACKCOLOR;
    _tipsLabel.font = [UIFont boldSystemFontOfSize:20];
    _tipsLabel.text = @"省市区选择";
    [_contentView addSubview:_tipsLabel];
    
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = THEMECOLOR;
    [_contentView addSubview:_coverView];
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.tag = 1;
    [_coverView addSubview:lineView1];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.tag = 2;
    [_coverView addSubview:lineView2];
    
    
    _picker = [[UIPickerView alloc] init];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_picker];
    
    
    _commitButton = [[UIButton alloc] init];
    [_commitButton setBackgroundColor:THEMECOLOR];
    [_commitButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [_commitButton setTitle:@"确定" forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(commitButtonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_commitButton];
    
    hasSubView = YES;
    
}

#pragma mark - animation
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_WIDTH, 400);
        _bjButton.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}



- (void)hiddenAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 400);
        _bjButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIAction 
- (void)bjViewDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFAdressPickerViewDidSelectedCancel:)]) {
        [self.delegate SFAdressPickerViewDidSelectedCancel:self];
    }
    if(self.completion){
        self.completion(nil);
    }
    [self hiddenAnimation];
}


- (BOOL)hasAvailableResult
{
    return [self.adressStr containsString:@"-"] && ![self.adressStr hasSuffix:@"-"];
}

- (void)commitButtonDidSelected:(UIButton *)sender {
    
    if (![self hasAvailableResult]) {
        [[[SFTipsView alloc] init] showFailureWithTitle:@"请输入完整地址"];
        return;
    }
    
    //弹框提示
//    [[[SFTipsView alloc] init] showSuccessWithTitle:self.adressStr];
    
    if ([self.delegate respondsToSelector:@selector(SFAdressPickerView:commitDidSelected:)]) {
        [self.delegate SFAdressPickerView:self commitDidSelected:self.adressStr];
    }
    if(self.completion){
        self.completion(self.adressStr);
    }
    [self hiddenAnimation];
}




#pragma mark - setupView
- (void)setupData {
    [self getCityListJSON];//获取数据
    [self getCitydate:0];// 默认显示数据
    [self getAreaDate:0];
}


#pragma mark - Picker DataSource
/**
 *  读取城市文件
 */
- (void)getCityListJSON{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray *provinceList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.provinceList = provinceList;
    
}

- (void)getCitydate:(NSInteger)row{
    
    
    if ([self.provinceList[row][@"type"] intValue] == 0) {
        NSArray *cityArr = [[NSArray alloc] initWithObjects:self.provinceList[row], nil];
        self.cityList = cityArr;
        
    }else{
        NSMutableArray *cityList = [[NSMutableArray alloc] init];
        for (NSArray *cityArr in self.provinceList[row][@"sub"]) {
            [cityList addObject:cityArr];
        }
        self.cityList = cityList;
    }
    
    
}

- (void)getAreaDate:(NSInteger)row{
    if ([self.provinceList[self.selectOneRow][@"type"] intValue] == 0) {
        NSMutableArray *areaList = [[NSMutableArray alloc] init];
        for (NSArray *cityDict in self.provinceList[self.selectOneRow][@"sub"]) {
            [areaList addObject:cityDict];
        }
        self.areaList = areaList;
    }else{
        
        NSMutableArray *areaList = [[NSMutableArray alloc] init];
        for (NSArray *cityDict in self.cityList[row][@"sub"]) {
            [areaList addObject:cityDict];
        }
        self.areaList = areaList;
    }
}


#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceList.count;
    }else if (component == 1){
        return self.cityList.count;
    }else if (component == 2){
        return self.areaList.count;
    }
    return 1;
}

- (NSArray *)areaList
{
    if (!_areaList.count) {
        NSDictionary *title = self.cityList[[_picker selectedRowInComponent:1]];
        _areaList = @[title].mutableCopy;
    }
    return _areaList;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        self.selectOneRow = row;
        [self getCitydate:row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [self getAreaDate:0];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        if ([self.provinceList[self.selectOneRow][@"type"] intValue] == 0) {
            
            self.selectTwoRow = 0;
        }
        self.selectOneRow = row;
        self.selectTwoRow = 0;
        self.selectThreeRow = 0;
        
    }
    if (component == 1){
        
        self.selectTwoRow = row;
        [self getAreaDate:row];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.selectTwoRow = row;
        self.selectThreeRow = 0;
    }
    if (component == 2){
        
        self.selectThreeRow = row;
        
    }
    NSMutableString *regionAddress = [[NSMutableString alloc] init];
    if (self.selectOneRow > 0 &&[self.provinceList[self.selectOneRow][@"type"] intValue] != 0 ) {
        [regionAddress appendFormat:@"%@-",self.provinceList[self.selectOneRow][@"name"]];
        
    }
    if (self.selectTwoRow > 0 || [self.provinceList[self.selectOneRow][@"type"] intValue] == 0){
        [regionAddress appendFormat:@"%@-",self.cityList[self.selectTwoRow][@"name"]];
    }
    NSString *area = self.areaList[self.selectThreeRow][@"name"];
    if (self.selectThreeRow > 0 || ![area isEqualToString:@"请选择"]){
        [regionAddress appendFormat:@"%@",area];
    }
    
    self.adressStr = regionAddress;
}

+ (void)showWithAddress:(NSString * _Nullable )str completion:(void(^_Nullable)(NSString *_Nullable address))completion
{
    SFAdressPickerView *pick = [[SFAdressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    pick.delegate  = pick;
    [[UIApplication sharedApplication].keyWindow addSubview:pick];
    pick.completion = completion;
    [pick showAnimation];
    [pick updateWithAddress:str];
}

- (void)updateWithAddress:(NSString * _Nonnull)address
{
    NSArray *arr = [address componentsSeparatedByString:@"-"];
    if(!arr.count){
        arr  = [address componentsSeparatedByString:@"/"];
    }
    NSInteger province = 0;
    NSInteger city  = 0;
    NSInteger area  = 0;
  
    province = [self provinceIndexWithStr:arr[0]];
    if(province == -1){
        province = 0;
        city  = 0;
        area  = 0;
        return;
    }
    NSArray *cityArray = self.provinceList[province][@"sub"];
    if(arr.count == 2){
        city  = 0;
    }else{
        city  = [self cityIndexWithStr:arr.count == 3 ? arr[1] : arr[1] inArray:cityArray];
    }
    if(city == -1){
        city  = 0;
        area  = 0;
        return;
    }
    NSArray *areaArr = cityArray[city][@"sub"];
    if(arr.count == 2){
        areaArr = cityArray;
    }
    area  = [self areaIndexWithStr:arr.count == 3 ? arr[2] : arr[1] inArray:areaArr];
    if(area == -1){
        area  = 0;
    }
    [_picker selectRow:province inComponent:0 animated:YES];
    [self pickerView:_picker didSelectRow:province inComponent:0];
    if(arr.count == 3){
        [_picker selectRow:city inComponent:1 animated:YES];
        [self pickerView:_picker didSelectRow:city inComponent:1];
    }else{
        [_picker selectRow:0 inComponent:1 animated:YES];
        [self pickerView:_picker didSelectRow:0 inComponent:1];
    }
    [_picker selectRow:area inComponent:2 animated:YES];
    [self pickerView:_picker didSelectRow:area inComponent:2];
}

- (NSInteger)provinceIndexWithStr:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"省" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"市" withString:@""];
    for(int i = 0;i < self.provinceList.count;i++){
        NSString *name = self.provinceList[i][@"name"];
        if([name isEqualToString:str]){
            return i;
        }
    }
    return -1;
}

- (NSInteger)cityIndexWithStr:(NSString *)str inArray:(NSArray *)arr
{
    str = [str stringByReplacingOccurrencesOfString:@"市" withString:@""];
    for(int i = 0;i < arr.count;i++){
        NSString *name = arr[i][@"name"];
        name  = [name stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if([name isEqualToString:str]){
            return i;
        }
    }
    return -1;
}

- (NSInteger)areaIndexWithStr:(NSString *)str inArray:(NSArray *)arr
{
    str = [str stringByReplacingOccurrencesOfString:@"区" withString:@""];
    for(int i = 0;i < arr.count;i++){
        NSString *name = arr[i][@"name"];
        name = [name stringByReplacingOccurrencesOfString:@"区" withString:@""];
        if([name isEqualToString:str]){
            return i;
        }
    }
    return -1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.provinceList[row][@"name"];
        
    }
    if (component == 1){
        if ([self.provinceList[self.selectOneRow][@"type"] intValue] == 0) {
            return self.cityList[0][@"name"];
            
        } else {
            return self.cityList[row][@"name"];
            
        }
    }
    if (component == 2){
        return self.areaList[row][@"name"];
        
    }
    return nil;
}

// 自定义行高
-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

// 自定义列宽
-(CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH / 3;
}


- (UIView *)pickerView:(UIPickerView*)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView*)view {
    SFAdressPickerCell *cellView = (SFAdressPickerCell *)view;
    if (!cellView) {
        cellView = [[SFAdressPickerCell alloc] init];
    }
    
    NSString *targetStr;
    
    if (component == 0) {
        targetStr = self.provinceList[row][@"name"];
        
    }
    if (component == 1){
        if ([self.provinceList[self.selectOneRow][@"type"] intValue] == 0) {
            targetStr = self.cityList[0][@"name"];
            
        } else {
            targetStr = self.cityList[row][@"name"];
            
        }
    }
    if (component == 2){
        targetStr = self.areaList[row][@"name"];
    }
    
    cellView.titleStr = targetStr;
    
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    
    return cellView;
}

#pragma mark - buttonViewDelegate
- (void)SFButtonView:(SFButtonView *)buttonView didSelectedButtonIndex:(NSInteger)index {
    NSString *targetStr = _alwaysUseArray[index];
    
    NSInteger i1 = 0;
    NSInteger i2 = 0;
    [self fineIndexWithCityStr:targetStr index1:&i1 index2:&i2];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_picker selectRow:i1 inComponent:0 animated:NO];
        [self pickerView:_picker didSelectRow:i1 inComponent:0];
        [_picker selectRow:i2 inComponent:1 animated:NO];
        [self pickerView:_picker didSelectRow:i2 inComponent:1];
    });
    
}


- (void)fineIndexWithCityStr:(NSString *)city index1:(NSInteger *)index1 index2:(NSInteger *)index2
{
    for (NSInteger index = 0; index < self.provinceList.count; index++) {
        NSString *name = self.provinceList[index][@"name"];
        NSArray  *subs = self.provinceList[index][@"sub"];
        if ([name isEqualToString:city]) {
               *index1 = index;
               *index2 = 0;
        }else{
            for (int i = 0 ;i < subs.count;i++) {
                NSString *subName = subs[i][@"name"];
                subName = [subName stringByReplacingOccurrencesOfString:@"市" withString:@""];
                city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                if ([subName isEqualToString:city]) {
                    *index1 = index;
                    *index2 = i;
                }
            }
        }
    }
}


#pragma mark - layout 
- (void)layoutSubviews {
    if (hasSubView) {
        
        _bjButton.frame = self.bounds;
//        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 400);
        
        _titileLabel.frame = CGRectMake(20, 20, 45, 20);
        
        CGFloat closeButtonWH = 16;
        _closeButton.frame = CGRectMake(SCREEN_WIDTH - 20 - closeButtonWH, 20, closeButtonWH, closeButtonWH);
        
        CGFloat buttonViewWidth = 76 * 4;
        _buttonView.frame = CGRectMake((SCREEN_WIDTH - buttonViewWidth) * 0.5, CGRectGetMaxY(_titileLabel.frame) + 8, buttonViewWidth, 72);
        
        _tipsLabel.frame = CGRectMake(20, CGRectGetMaxY(_buttonView.frame) + 8, 110, 20);
        
        
        _commitButton.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - 50, SCREEN_WIDTH, 50);
        
        _picker.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - 200 - CGRectGetHeight(_commitButton.frame), SCREEN_WIDTH, 200);
        
        
        _coverView.frame = CGRectMake(0, _picker.center.y - 20, SCREEN_WIDTH, 40);
        
        CGFloat pickerWith = SCREEN_WIDTH / 3;
        for (UIView *view in _coverView.subviews) {
            NSInteger index = view.tag;
            view.frame = CGRectMake(pickerWith * index, 0, 1, 40);
        }
        
        hasSubView = NO;
    }
}

- (NSArray *)alwaysUseArray {
    if (!_alwaysUseArray) {
        _alwaysUseArray = @[@"北京",@"上海",@"广东",@"深圳",@"杭州",@"东莞",@"重庆",@"天津"];
    }
    return _alwaysUseArray;
}


@end
