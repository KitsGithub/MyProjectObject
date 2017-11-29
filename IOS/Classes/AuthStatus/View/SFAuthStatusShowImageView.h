//
//  SFAuthStatusShowImageView.h
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAuthStatusModle.h"

@interface SFAuthStatusShowImageView : UIView

@property (nonatomic,strong)SFAuthStatusModle *statusModel;
@property (nonatomic,assign)SFAuthType  type;
@property (nonatomic, assign) BOOL edittingEnable;
@property (nonatomic, weak) UIViewController *wSelfVC;

- (instancetype)initWithFrame:(CGRect)frame authType:(SFAuthType)type statusModel:(SFAuthStatusModle *)statusModel;
- (NSDictionary *)getImageArray;

@end
