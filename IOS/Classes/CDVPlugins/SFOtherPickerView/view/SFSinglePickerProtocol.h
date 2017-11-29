//
//  SFSinglePickerProtocol.h
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSinglePickerProtocol <NSObject>

@optional
- (void)pickerView:(id)pickerView commitDidSelected:(NSInteger)index resourceArray:(NSArray *)resouceArray;

- (void)pickerViewDidSelectedCancel:(id)pickerView;

@end
