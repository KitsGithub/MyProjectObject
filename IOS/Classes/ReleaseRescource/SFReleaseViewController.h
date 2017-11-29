//
//  SFReleaseViewController.h
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseCordvaViewController.h"

@interface SFReleaseViewController : BaseCordvaViewController

@property (nonatomic,copy)NSString *orderId;

@property (nonatomic,copy)void(^completion)(BOOL isSuc);


@end
