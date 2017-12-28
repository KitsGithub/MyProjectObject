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
@property (nonatomic, copy) NSString *BatchId;
@property (nonatomic, assign) BOOL isCloseHistory;
@property (nonatomic, assign) BOOL isBooking;
@property (nonatomic, assign) BOOL ismyCarOrd;
- (instancetype)initWithOrderID:(NSString *)orderID;

@end
