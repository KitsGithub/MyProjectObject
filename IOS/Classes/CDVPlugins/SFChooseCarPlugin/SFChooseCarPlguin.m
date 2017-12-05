//
//  SFChooseCarPlguin.m
//  SFLIS
//
//  Created by kit on 2017/12/4.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChooseCarPlguin.h"
#import "SFChooseCarrierCarController.h"
#import "SFCarListModel.h"
@implementation SFChooseCarPlguin {
    NSMutableArray *_carNum;
    CDVInvokedUrlCommand *_command;
    NSString *_fromId;
}

- (void)chooseCar:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        _command = command;
        _carNum = [NSMutableArray array];
        NSMutableDictionary *dic = [command argumentAtIndex:0];
        _fromId = dic[@"fromId"];
        _carNum = dic[@"cars"];
        [self jumpToSelectedCar];
        
    }];
}

- (void)jumpToSelectedCar {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        SFChooseCarrierCarController *car = [[SFChooseCarrierCarController alloc] init];
        car.typeMode = TypeMode_H5MoreChooser;
        [car setResultReturnBlock:^(NSArray<SFCarListModel *> *modelArray) {
            [self sendMessageToH5:modelArray];
        }];
        car.selectedCarArray = _carNum;
        [self.viewController.navigationController pushViewController:car animated:YES];
    });
}

- (void)sendMessageToH5:(NSArray *)array {
    
    NSMutableArray *jsonArray = [SFCarListModel mj_keyValuesArrayWithObjectArray:array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"message"] = jsonArray;
    dic[@"fromId"] = _fromId;
    dic[@"price"] = @"请输入价格";
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:dic];
    [self.commandDelegate sendPluginResult:result callbackId:_command.callbackId];
}

@end
