//
//  PrayerTimesGate.h
//  WISE
//
//  Created by Mohamed Rashwan on 05/10/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

//#import "PrayerTimes.h"
#import "Settings.h"

#ifndef WISE_PrayerTimesGate_h
#define WISE_PrayerTimesGate_h
#endif

@interface PrayerTimesGate : NSObject 

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property (strong, nonatomic) NSMutableData *responseData;

@property (nonatomic) NSRange timeLocation;

- (id)init;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSString*) getAzanTimeFromHTML:(NSString*)content;

- (NSString*) getJamaaTimeFromHTML:(NSString*)content;

- (BOOL) createNewPrayerTimesWithAdjustment:(NSString *) paramAdjustment
                                   FajrAzan:(NSString *)paramFajrAzan
                                FajrJamaa:(NSString *)paramFajrJamaa
                             SunrsiseAzan:(NSString *)paramSunriseAzan
                                DhuhrAzan:(NSString *)paramDhuhrAzan
                               DhuhrJamaa:(NSString *)paramDhuhrJamaa
                                  AsrAzan:(NSString *)paramAsrAzan
                                 AsrJamaa:(NSString *)paramAsrJamaa
                              MaghribAzan:(NSString *)paramMaghribAzan
                             MaghribJamaa:(NSString *)paramMaghribJamaa
                                 IshaAzan:(NSString *)paramIshaAzan
                                IshaJamaa:(NSString *)paramIshaJamaa
                               ModifiedOn:(NSDate *)paramModifiedOn
                              BgFetchData:(NSString *)paramBgFetchData;

- (PrayerTimes *) getCurrentPrayerTimesRecord;

-(void) reloadPrayerTimes:(BOOL *)paramFetchedNewPrayerTimes;

- (Settings *) getCurrentPrayerSettingsRecord;

-(void) reloadSettingsWithFajrReminder:(bool)paramFajrReminder
                         DhuhrReminder:(bool)paramDhuhrReminder
                           AsrReminder:(bool)paramAsrReminder
                       MaghribReminder:(bool)paramMaghribReminder
                          IshaReminder:(bool)paramIshaReminder
                       RefreshReminder:(bool)paramRefreshReminder
                             PlayAdhan:(bool)paramPlayAdhan;

- (BOOL) createNewSettingsWithFajrReminder:(bool)paramFajrReminder
                             DhuhrReminder:(bool)paramDhuhrReminder
                               AsrReminder:(bool)paramAsrReminder
                           MaghribReminder:(bool)paramMaghribReminder
                              IshaReminder:(bool)paramIshaReminder
                           RefreshReminder:(bool)paramRefreshReminder
                                 PlayAdhan:(bool)paramPlayAdhan;

- (NSMutableArray*) getTodaysActivity:(BOOL*)paramFetchedNewActivities;

- (NSDate *) getPrayerTimeAt:(NSString*)azanTime ampm:(NSString*)ampm;

- (NSInteger) gmod:(NSInteger)n m:(NSInteger)m;

-(NSInteger *) kuwaitiCalendar:(NSInteger)adjust;

-(NSString *) getIslamicDate:(NSString *)adjust longDate:(bool)longDate;



@end
