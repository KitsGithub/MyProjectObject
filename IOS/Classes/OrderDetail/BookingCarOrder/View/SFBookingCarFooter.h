//
//  SFBookingCarFooter.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddActionBlock)();

@interface SFBookingCarFooter : UITableViewHeaderFooterView

@property (nonatomic, copy) AddActionBlock addAction;

@end
