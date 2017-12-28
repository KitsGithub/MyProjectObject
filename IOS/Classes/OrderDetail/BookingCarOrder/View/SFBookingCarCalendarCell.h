//
//  SFBookingCarCalendarCell.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFBookingCarCalendarCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, copy, readonly) NSString *calendarTime;
@property (nonatomic, copy, readonly) NSString *remarkStr;

@end
