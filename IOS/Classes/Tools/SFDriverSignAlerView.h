//
//  SFDriverSignAlerView.h
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFDriverSignAlerView : UIView

@property (nonatomic, copy) NSString *loactionStr;

- (void)showAnimation;
- (void)hiddenAnimation;

@end
