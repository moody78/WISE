//
//  TableViewController.h
//  WISE
//
//  Created by Mohamed Rashwan on 14/04/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderSettings.h"

@interface TableViewController : UITableViewController
@property (nonatomic, strong) UISwitch *fajrSwitch;
@property (nonatomic, strong) UISwitch *dhuhrSwitch;
@property (nonatomic, strong) UISwitch *asrSwitch;
@property (nonatomic, strong) UISwitch *maghribSwitch;
@property (nonatomic, strong) UISwitch *ishaSwitch;
@property (nonatomic, strong) UISwitch *refreshSwitch;
@property (nonatomic, strong) UISwitch *playAdhanSwitch;

@property (nonatomic, strong) ReminderSettings *reminderSettings;

- (void)switchIsChanged:(UISwitch *)paramSender;
@end


