//
//  SFAuthIdentflyTipsView.m
//  SFLIS
//
//  Created by kit on 2017/11/21.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthIdentflyTipsView.h"

@implementation SFAuthIdentflyTipsView {
    UILabel *_tipsLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self stupView];
    }
    return self;
}

- (void)stupView {
    _tipsLabel = [UILabel new];
    _tipsLabel.textColor = [UIColor whiteColor];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.font = [UIFont systemFontOfSize:14];
    _tipsLabel.numberOfLines = 0;
    [self addSubview:_tipsLabel];
}

- (void)setStatusModel:(SFAuthStatusModle *)statusModel {
    _statusModel = statusModel;
    if ([statusModel.verify_status isEqualToString:@"B"]) {
        self.backgroundColor = COLOR_TEXT_COMMON;
        _tipsLabel.text = @"...资料审核中,请等待...";
    } else if ([statusModel.verify_status isEqualToString:@"F"]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ff7373"];
        _tipsLabel.text = [NSString stringWithFormat:@"您的信誉认证未通过，原因如下：\n%@",statusModel.verify_remark];
    }
}

- (void)layoutSubviews {
//    CGSize tipsSize = [_tipsLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
//    _tipsLabel.frame = CGRectMake(20, (CGRectGetHeight(self.frame) - tipsSize.height) * 0.5, tipsSize.width, tipsSize.height);
    _tipsLabel.frame = self.bounds;
}

@end
