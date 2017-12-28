//
//  SFProvenanceCell.h
//  SFLIS
//
//  Created by kit on 2017/12/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFProvenanceProtocol.h"
#import "SFCommond.h"

@interface SFProvenanceCell : UITableViewCell

// 当前主选择卡。发的／订的
@property (nonatomic,assign)SFProvenanceDirection currentDirection;

@property (nonatomic,strong)NSArray <SFCommond *>*commonds;

@property (nonatomic, weak) id<SFProvenanceProtocol> model;

@end
