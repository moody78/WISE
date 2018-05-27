//
//  AppDelegate.h
//  WISE
//
//  Created by Mohamed Rashwan on 28/09/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrayerTimesGate.h"
#import "Settings.h"
#import "ActivitiesViewController.h"
#import "TableViewController.h"
#import "LogViewController.h"
//#import "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.0.sdk/System/Library/Frameworks/CoreSpotlight.framework/Headers/CoreSpotlight.h"
//#import "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.0.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/UTType.h"
//#import "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.0.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/UTCoreTypes.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic) PrayerTimesGate *prayerTimesGate;
@property (nonatomic) ActivitiesViewController *activitiesViewController;
@property (nonatomic) TableViewController *settingsViewController;
@property (nonatomic) LogViewController *logViewController;
@property (nonatomic) bool isAppResumingFromBackground;
@property (nonatomic) bool didAppHaveBadgeIcon;

-(void) downloadMissingPrayerTimes;
@end

