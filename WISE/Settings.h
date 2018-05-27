//
//  Settings.h
//  WISE
//
//  Created by Mohamed Rashwan on 17/04/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSObject

@property (nonatomic, retain) NSNumber * fajrReminder;
@property (nonatomic, retain) NSNumber * dhuhrReminder;
@property (nonatomic, retain) NSNumber * asrReminder;
@property (nonatomic, retain) NSNumber * maghribReminder;
@property (nonatomic, retain) NSNumber * ishaReminder;
@property (nonatomic, retain) NSNumber * refreshReminder;
@property (nonatomic, retain) NSNumber * playAdhan;
@end


@interface PrayerTimes : NSObject

@property (nonatomic, strong) NSString * adjustment;
@property (nonatomic, strong) NSString * fajrAzan;
@property (nonatomic, strong) NSString * dhuhrJamaa;
@property (nonatomic, strong) NSString * dhuhrAzan;
@property (nonatomic, strong) NSString * sunriseAzan;
@property (nonatomic, strong) NSString * fajrJamaa;
@property (nonatomic, strong) NSString * ishaJamaa;
@property (nonatomic, strong) NSString * ishaAzan;
@property (nonatomic, strong) NSString * maghribJamaa;
@property (nonatomic, strong) NSString * maghribAzan;
@property (nonatomic, strong) NSString * asrJamaa;
@property (nonatomic, strong) NSString * asrAzan;
@property (nonatomic, strong) NSDate * modifiedOn;
@property (nonatomic, strong) NSString * bgFetchData;

@end
