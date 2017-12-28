//
//  SFOrderCell.h
//  SFLIS
//
//  Created by kit on 2017/12/18.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SfOrderProtocol.h"
#import "SFCommond.h"

@interface SFOrderCell : UITableViewCell

@property (nonatomic, weak) id <SfOrderProtocol> model;
@property (nonatomic,strong)NSArray <SFCommond *>*commonds;

@end
