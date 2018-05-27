//
//  Settings.m
//  WISE
//
//  Created by Mohamed Rashwan on 17/04/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import "Settings.h"


@implementation Settings

@synthesize fajrReminder;
@synthesize dhuhrReminder;
@synthesize asrReminder;
@synthesize maghribReminder;
@synthesize ishaReminder;
@synthesize refreshReminder;
@synthesize playAdhan;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.fajrReminder forKey:@"fajrReminder"];
    [encoder encodeObject:self.dhuhrReminder forKey:@"dhuhrReminder"];
    [encoder encodeObject:self.asrReminder forKey:@"asrReminder"];
    [encoder encodeObject:self.maghribReminder forKey:@"maghribReminder"];
    [encoder encodeObject:self.ishaReminder forKey:@"ishaReminder"];
    [encoder encodeObject:self.refreshReminder forKey:@"refreshReminder"];
    [encoder encodeObject:self.playAdhan forKey:@"playAdhan"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.fajrReminder = [decoder decodeObjectForKey:@"fajrReminder"];
        self.dhuhrReminder = [decoder decodeObjectForKey:@"dhuhrReminder"];
        self.asrReminder = [decoder decodeObjectForKey:@"asrReminder"];
        self.maghribReminder = [decoder decodeObjectForKey:@"maghribReminder"];
        self.ishaReminder = [decoder decodeObjectForKey:@"ishaReminder"];
        self.refreshReminder = [decoder decodeObjectForKey:@"refreshReminder"];
        self.playAdhan = [decoder decodeObjectForKey:@"playAdhan"];
    }
    return self;
}
@end

@implementation PrayerTimes

@synthesize adjustment;
@synthesize fajrAzan;
@synthesize dhuhrJamaa;
@synthesize dhuhrAzan;
@synthesize sunriseAzan;
@synthesize fajrJamaa;
@synthesize ishaJamaa;
@synthesize ishaAzan;
@synthesize maghribJamaa;
@synthesize maghribAzan;
@synthesize asrJamaa;
@synthesize asrAzan;
@synthesize modifiedOn;
@synthesize bgFetchData;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.adjustment forKey:@"adjustment"];
    [encoder encodeObject:self.fajrAzan forKey:@"fajrAzan"];
    [encoder encodeObject:self.fajrJamaa forKey:@"fajrJamaa"];
    [encoder encodeObject:self.sunriseAzan forKey:@"sunriseAzan"];
    [encoder encodeObject:self.dhuhrAzan forKey:@"dhuhrAzan"];
    [encoder encodeObject:self.dhuhrJamaa forKey:@"dhuhrJamaa"];
    [encoder encodeObject:self.asrAzan forKey:@"asrAzan"];
    [encoder encodeObject:self.asrJamaa forKey:@"asrJamaa"];
    [encoder encodeObject:self.maghribAzan forKey:@"maghribAzan"];
    [encoder encodeObject:self.maghribJamaa forKey:@"maghribJamaa"];
    [encoder encodeObject:self.ishaAzan forKey:@"ishaAzan"];
    [encoder encodeObject:self.ishaJamaa forKey:@"ishaJamaa"];
    if(self.bgFetchData != nil)
        [encoder encodeObject:self.bgFetchData forKey:@"bgFetchData"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    //if((self = [super init])) {
        //decode properties, other class vars
    self.adjustment = [decoder decodeObjectForKey:@"adjustment"];
    self.fajrAzan = [decoder decodeObjectForKey:@"fajrAzan"];
    self.fajrJamaa = [decoder decodeObjectForKey:@"fajrJamaa"];
    self.sunriseAzan = [decoder decodeObjectForKey:@"sunriseAzan"];
    self.dhuhrAzan = [decoder decodeObjectForKey:@"dhuhrAzan"];
    self.dhuhrJamaa = [decoder decodeObjectForKey:@"dhuhrJamaa"];
    self.asrAzan = [decoder decodeObjectForKey:@"asrAzan"];
    self.asrJamaa = [decoder decodeObjectForKey:@"asrJamaa"];
    self.maghribAzan = [decoder decodeObjectForKey:@"maghribAzan"];
    self.maghribJamaa = [decoder decodeObjectForKey:@"maghribJamaa"];
    self.ishaAzan = [decoder decodeObjectForKey:@"ishaAzan"];
    self.ishaJamaa = [decoder decodeObjectForKey:@"ishaJamaa"];
    self.bgFetchData =[decoder decodeObjectForKey:@"bgFetchData"];
    
    //}
    return self;
}

@end
