//
//  SFUserView.m
//  SFLIS
//
//  Created by kit on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFUserView.h"
#import "SFDetailView.h"

#define NameFont [UIFont boldSystemFontOfSize:12]
#define SubFont [UIFont systemFontOfSize:12]

CGFloat iconWH = 38;

@interface SFUserView ()

@property (nonatomic, assign) ResourceType resourceType;
@property (nonatomic, weak) GoodsSupply *model;

@end

@implementation SFUserView {
    UIImageView *_userIcon;         //头像
    UILabel *_userName;             //用户名
    UILabel *_times;                //接单数
    
    UILabel *_userIdentifly;    //用户身份(是否认证)
    SFDetailView *_detailView;
    
    BOOL hasSubView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default_Head"]];
    _userIcon.layer.cornerRadius = iconWH * 0.5;
    _userIcon.clipsToBounds = YES;
    [self addSubview:_userIcon];
    
    _userName = [UILabel new];
    _userName.font = NameFont;
    _userName.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:_userName];
    
    _times = [UILabel new];
    _times.font = SubFont;
    _times.textColor = [UIColor colorWithHexString:@"999999"];
    _times.text = @"发货：";
    [self addSubview:_times];
    
    
    
    _userIdentifly = [UILabel new];
    _userIdentifly.backgroundColor = THEMECOLOR;
    _userIdentifly.layer.cornerRadius = 1;
    _userIdentifly.clipsToBounds = YES;
    _userIdentifly.textColor = [UIColor colorWithHexString:@"3D3D3D"];
    _userIdentifly.font = [UIFont systemFontOfSize:10];
    _userIdentifly.text = @"已认证";
    _userIdentifly.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_userIdentifly];
    
    
    _detailView = [SFDetailView new];
    
    [self addSubview:_detailView];
    
    hasSubView = YES;
    
}

- (void)setModel:(GoodsSupply *)model withResourceType:(ResourceType)resourceType {
    _resourceType = resourceType;
    
    
    if (model.head_src.length) {
        NSString *headURL = [NSString stringWithFormat:@"%@%@",Resource_URL,model.head_src];
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"Default_Head"] options:(SDWebImageContinueInBackground)];
    } else {
        [_userIcon setImage:[UIImage imageNamed:@"Default_Head"]];
    }
    
    [_detailView setModel:model withIsShowLine:!resourceType];
    self.model = model;
}



- (void)setModel:(GoodsSupply *)model {
    
    
    
    _model = model;
    
    _userName.text = model.name;
    
    if (!model.issueCount.length) {
        model.issueCount = @"0";
    }
    _times.text = [NSString stringWithFormat:@"发货:%@次",model.issueCount];
    
    hasSubView = YES;
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    
    if (hasSubView) {
        _userIcon.frame = CGRectMake(11, 0, iconWH, iconWH);
        
        _detailView.frame = CGRectMake(CGRectGetMaxX(_userIcon.frame) + 5, CGRectGetMinY(_userIcon.frame), SCREEN_WIDTH - CGRectGetMaxX(_userIcon.frame) - 5, 20);
        
        _userIdentifly.frame = CGRectMake(CGRectGetMaxX(_userIcon.frame) + 10, CGRectGetMaxY(_userIcon.frame) - 15, 36, 14);
        
        CGFloat a = SCREEN_WIDTH;
        CGSize nameSize;
        if (a == 320) {
            nameSize = [_userName.text sizeWithFont:NameFont maxSize:CGSizeMake(100, 20)];
        } else {
            nameSize = [_userName.text sizeWithFont:NameFont maxSize:CGSizeMake(MAXFLOAT, 20)];
        }
        _userName.frame = CGRectMake(CGRectGetMaxX(_userIdentifly.frame) + 5, CGRectGetMinY(_userIdentifly.frame), nameSize.width, nameSize.height);
        
        
        CGFloat width = CGRectGetWidth(self.frame) - CGRectGetMaxX(_userName.frame);
        
        CGSize timesSize = [_times.text sizeWithFont:SubFont maxSize:CGSizeMake(width, 20)];
        _times.frame = CGRectMake(CGRectGetMaxX(_userName.frame) + 5, CGRectGetMinY(_userName.frame), timesSize.width, timesSize.height);
        
        hasSubView = NO;
    }
}

@end
