//
//  TodayViewController.h
//  PrayerTimesWidget
//
//  Created by Mohamed Rashwan on 05/10/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PrayerTimesGate.h"

@interface TodayViewController : UIViewController

@property (nonatomic, strong) UILabel *hijriDate;

@property (nonatomic, strong) UILabel *azanTitle;
@property (nonatomic, strong) UILabel *jamaaTitle;

@property (nonatomic, strong) UILabel *fajrTitle;
@property (nonatomic, strong) UILabel *sunriseTitle;
@property (nonatomic, strong) UILabel *dhuhrTitle;
@property (nonatomic, strong) UILabel *asrTitle;
@property (nonatomic, strong) UILabel *maghribTitle;
@property (nonatomic, strong) UILabel *ishaTitle;

@property (nonatomic, strong) UILabel *fajrAzan;
@property (nonatomic, strong) UILabel *sunriseAzan;
@property (nonatomic, strong) UILabel *dhuhrAzan;
@property (nonatomic, strong) UILabel *asrAzan;
@property (nonatomic, strong) UILabel *maghribAzan;
@property (nonatomic, strong) UILabel *ishaAzan;

@property (nonatomic, strong) UILabel *fajrJamaa;
@property (nonatomic, strong) UILabel *sunriseJamaa;
@property (nonatomic, strong) UILabel *dhuhrJamaa;
@property (nonatomic, strong) UILabel *asrJamaa;
@property (nonatomic, strong) UILabel *maghribJamaa;
@property (nonatomic, strong) UILabel *ishaJamaa;

@property (nonatomic, strong) UILabel *nextPrayerIndicator;

@property (nonatomic) PrayerTimesGate *prayerTimesGate;
@property (nonatomic) bool touchFlag;
@property (nonatomic) UIColor* backColor;
@property (nonatomic) UIColor* textColor;

@property (nonatomic, strong) ReminderSettings *reminderSettings;

- (void)drawPrayerTimes;
- (void) formatNextPrayer;
@end
