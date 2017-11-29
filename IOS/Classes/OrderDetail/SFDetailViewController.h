//
//  SFDetailViewController.h
//  SFLIS
//
//  Created by kit on 2017/11/7.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseCordvaViewController.h"

@interface SFDetailViewController : BaseCordvaViewController

@property (nonatomic, copy) NSString *orderID;

- (instancetype)initWithOrderID:(NSString *)orderID;

@end
