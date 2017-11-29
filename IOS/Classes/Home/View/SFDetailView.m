
//
//  SFDetailView.m
//  SFLIS
//
//  Created by kit on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDetailView.h"
#import "GoodsSupply.h"

@interface SFDetailView ()

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, weak) GoodsSupply *model;

@end

@implementation SFDetailView {
    UIView *_lineView;
    
    BOOL _isShowLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"dadada"];
    [self addSubview:_lineView];
}

- (void)setModel:(GoodsSupply *)model withIsShowLine:(BOOL)showLine {
    self.showLine = showLine;
    self.model = model;
}

- (void)setShowLine:(BOOL)showLine {
    _isShowLine = showLine;
    _lineView.hidden = !showLine;
}


- (void)setModel:(GoodsSupply *)model {
    _model = model;
    
    /*
     "goods_type":"水果","goods_name":"苹果","goods_size":12.0,"goods_weight":12.0,"weight_unit":"吨","car_type":"高栏车","car_long":"13.5","car_count":2,"shipment_date":121212,"valid_date":
     */
    
    
    NSString *carLong = [NSString stringWithFormat:@"%@",model.car_long];
    NSString *carCount = [NSString stringWithFormat:@"%@辆",model.car_count];
    
    NSArray *titleArray;
    
    if ([model respondsToSelector:@selector(goods_weight)] && model.goods_weight) {
        _isShowLine  = YES;
        NSString *weight = [NSString stringWithFormat:@"%@%@",model.goods_weight,model.weight_unit];
        titleArray = @[model.goods_type,model.goods_name,weight,model.car_type,carLong,carCount];
    }else{
        _isShowLine  = NO;
        titleArray = @[model.car_type,carLong,carCount];
    }
    
    self.titleArray = [titleArray mutableCopy];
    
    [self resetDetailView];
    
    [self setNeedsLayout];
}



- (void)resetDetailView {
    
    for (UIButton *button in self.buttonArray) {
        button.hidden = YES;
    }
    
    for (NSInteger index = 0; index < self.titleArray.count; index++) {
        UIButton *button = self.buttonArray[index];
        [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
        button.hidden = NO;
    }
}



- (void)layoutSubviews {
    
    UIView *lastView;
    for (NSInteger index = 0; index < self.titleArray.count; index++) {
        UIButton *button = self.buttonArray[index];
        CGSize titleSize = [self.titleArray[index] sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (index == 2 && _isShowLine) {
            button.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + 20, 0, titleSize.width, titleSize.height);
            
            _lineView.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + 10, CGRectGetMinY(lastView.frame), 1, CGRectGetHeight(lastView.frame));
            
        } else {
            button.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + 5, 0, titleSize.width, titleSize.height);
        }
        
        lastView = button;
    }
    
}


- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
        for (NSInteger index = 0; index < 10; index++) {
            UIButton *btn = [UIButton new];
            btn.layer.cornerRadius = 1;
            btn.clipsToBounds = YES;
            btn.hidden = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor colorWithHexString:@"3D3D3D"] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            [self addSubview:btn];
            
            [_buttonArray addObject:btn];
        }
    }
    return _buttonArray;
}

@end
