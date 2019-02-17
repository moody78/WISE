//
//  PrayerTimesGate.c
//  WISE
//
//  Created by Mohamed Rashwan on 05/10/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import "PrayerTimesGate.h"

@implementation PrayerTimesGate

@synthesize timeLocation;

- (id)init
{
    self = [super init];
    if (self)
    {
        // superclass successfully initialized, further
        // initialization happens here ...
    }
    return self;
}



- (NSDate *) getPrayerTimeAt:(NSString*)azanTime ampm:(NSString*)ampm
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd 'at' hh:mma"];
    
    NSString *stringDate = [NSString stringWithFormat:@"%ld-%ld-%ld at %@%@",(long)year,(long)month,(long)day,azanTime,ampm];
    NSDate *formatterDate = [inputFormatter dateFromString:stringDate];
    
    return formatterDate;
}

- (NSString *) getHijriAdjustmentFromHTML:(NSString*)content
{
    NSString *delimiter = @"writeIslamicDate(";
    
    NSRange range1 = timeLocation;
    range1.length = content.length - range1.location;
    
    range1 = [content rangeOfString:delimiter options:0 range:range1];
    range1.length=25;
    NSRange range2 = [content rangeOfString:@")" options:0 range:range1];
    timeLocation.location = range1.location + delimiter.length;
    timeLocation.length = range2.location - range1.location - delimiter.length;
    
    return [content substringWithRange:timeLocation];
}

- (NSString*) getAzanTimeFromHTML:(NSString*)content
{
    NSString *delimiter = @"<p>";
    
    NSRange range1 = timeLocation;
    range1.length = content.length - range1.location;
    
    range1 = [content rangeOfString:@"widget-title" options:0 range:range1];
    range1.length=100;
    range1 = [content rangeOfString:delimiter options:0 range:range1];
    range1.length=100;
    NSRange range2 = [content rangeOfString:@"</p>" options:0 range:range1];
    timeLocation.location = range1.location + delimiter.length;
    timeLocation.length = range2.location - range1.location - delimiter.length;
    
    return [content substringWithRange:timeLocation];
}

- (NSString*) getJamaaTimeFromHTML:(NSString*)content
{
    NSString *delimiter = @"<p><span>Jama'ah</span><br />";
    
    NSRange range1 = timeLocation;
    range1.length=100;
    range1 = [content rangeOfString:delimiter options:0 range:range1];
    range1.length=100;
    NSRange range2 = [content rangeOfString:@"</p>" options:0 range:range1];
    timeLocation.location = range1.location + delimiter.length;
    timeLocation.length = range2.location - range1.location - delimiter.length;
    
    return [content substringWithRange:timeLocation];
}

- (NSMutableArray*) getTodaysActivity:(BOOL*)paramFetchedNewActivities
{
    return nil;
    NSString *wiseUrlString = @"https://wise-web.org/activities/";//appindex.php";
    NSURL *wiseURL = [NSURL URLWithString:wiseUrlString];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfURL:wiseURL
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    
    NSMutableArray *serverActivities = [[NSMutableArray alloc] init];
    
    // The start of each today's activity entry
    NSString *searchStart = @"<tr><td>";
    //NSString *searchStartWithNoSpace = @"<tr><td align='left'><b>";
    
    NSRange rangeSearch = [content rangeOfString:@"<td><b>Activity</b></td>"];
    rangeSearch.location = rangeSearch.location + 10;
    rangeSearch.length = content.length - rangeSearch.location;
    
    NSRange rangeStart = [content rangeOfString:searchStart options:0 range:rangeSearch];
    NSRange rangeEndTable = [content rangeOfString:@"</table>" options:0 range:rangeSearch];

    while (rangeStart.length > 0 && rangeStart.location < rangeEndTable.location) {
        rangeSearch = rangeStart;
        rangeSearch.length = content.length - rangeSearch.location;
        
        NSRange rangeEnd = [content rangeOfString:@"</td>" options:0 range:rangeSearch];
        rangeSearch.location = rangeStart.location + rangeStart.length;
        rangeSearch.length = rangeEnd.location - rangeSearch.location;
        NSString *todaysActivityHeader = [content substringWithRange:rangeSearch];
        rangeSearch.location = rangeEnd.location + rangeEnd.length + 4;
        rangeSearch.length = content.length - rangeSearch.location;
        rangeEnd = [content rangeOfString:@"</td>" options:0 range:rangeSearch];

        // if search fails because content has no space, then do it again with no space
        //if(rangeEnd.location == 0 && rangeEnd.length > content.length)
          //  rangeEnd = [content rangeOfString:searchBodyEndWithNoSpace options:0 range:rangeSearch];

        rangeSearch.length = rangeEnd.location - rangeSearch.location;
        NSString *todaysActivityFor = [content substringWithRange:rangeSearch];

        rangeSearch.location = rangeEnd.location + rangeEnd.length + 4;
        rangeSearch.length = content.length - rangeSearch.location;
        rangeEnd = [content rangeOfString:@"</td>" options:0 range:rangeSearch];
        rangeSearch.length = rangeEnd.location - rangeSearch.location;
        NSString *todaysActivityBody = [content substringWithRange:rangeSearch];

        rangeSearch.location = rangeEnd.location + rangeEnd.length + 4;
        rangeSearch.length = content.length - rangeSearch.location;
        rangeEnd = [content rangeOfString:@"</td>" options:0 range:rangeSearch];
        rangeSearch.length = rangeEnd.location - rangeSearch.location;
        NSString *todaysActivityVenue = [content substringWithRange:rangeSearch];
        
        rangeSearch.length = content.length - rangeSearch.location;
        rangeStart = [content rangeOfString:searchStart options:0 range:rangeSearch];

        // if search fails because content has no space, then do it again with no space
        //if(rangeStart.location == 0 && rangeStart.length > content.length)
          //  rangeStart = [content rangeOfString:searchStart options:0 range:rangeSearch];
        
        [serverActivities addObject:[todaysActivityHeader stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [serverActivities addObject:[todaysActivityBody stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [serverActivities addObject:[todaysActivityFor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [serverActivities addObject:[todaysActivityVenue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.beamstart.wise.SharingDefaults"];
    NSMutableArray *savedActivities = [defaults objectForKey:@"activities"];
    
    if (paramFetchedNewActivities != nil) *paramFetchedNewActivities = NO;
    
    if(serverActivities == nil || serverActivities.count == 0)
        return savedActivities;
    else
    {
        if(savedActivities == nil || savedActivities.count != serverActivities.count)
        {
            if (paramFetchedNewActivities != nil) *paramFetchedNewActivities = YES;
            [defaults setObject:serverActivities forKey:@"activities"];
            return serverActivities;
        }
        else
        {
            
            for(int i=0; i<serverActivities.count;i++)
            {
                NSString *savedEntry = [savedActivities objectAtIndex:i];
                NSString *serverEntry = [serverActivities objectAtIndex:i];
                if(![savedEntry isEqualToString:serverEntry])
                {
                    if (paramFetchedNewActivities != nil) *paramFetchedNewActivities = YES;
                    [defaults setObject:serverActivities forKey:@"activities"];
                    return serverActivities;
                }
            }
        }
    }
    
    return savedActivities;
}

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
                               BgFetchData:(NSString *)paramBgFetchData{
    PrayerTimes *newPrayerTimes = [[PrayerTimes alloc] init];
    
    if(newPrayerTimes == nil){
        NSLog(@"Failed to create the new prayer times record");
        return NO;
    }
    
    newPrayerTimes.adjustment = paramAdjustment;
    newPrayerTimes.fajrAzan = paramFajrAzan;
    newPrayerTimes.fajrJamaa = paramFajrJamaa;
    newPrayerTimes.sunriseAzan = paramSunriseAzan;
    newPrayerTimes.dhuhrAzan = paramDhuhrAzan;
    newPrayerTimes.dhuhrJamaa = paramDhuhrJamaa;
    newPrayerTimes.asrAzan = paramAsrAzan;
    newPrayerTimes.asrJamaa = paramAsrJamaa;
    newPrayerTimes.maghribAzan = paramMaghribAzan;
    newPrayerTimes.maghribJamaa = paramMaghribJamaa;
    newPrayerTimes.ishaAzan = paramIshaAzan;
    newPrayerTimes.ishaJamaa = paramIshaJamaa;
    newPrayerTimes.modifiedOn = paramModifiedOn;
    newPrayerTimes.bgFetchData = paramBgFetchData;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.beamstart.wise.SharingDefaults"];
    NSData *encodedObject;
    //NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newPrayerTimes];
    if (@available(iOS 11.0, *)) {
        encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newPrayerTimes requiringSecureCoding:false error:nil];
        [defaults setObject:encodedObject forKey:@"prayerTimes"];
    } else {
        // Fallback on earlier versions
        encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newPrayerTimes];
    }
    
    return YES;
    }

- (BOOL) createNewSettingsWithFajrReminder:(bool)paramFajrReminder
                             DhuhrReminder:(bool)paramDhuhrReminder
                               AsrReminder:(bool)paramAsrReminder
                           MaghribReminder:(bool)paramMaghribReminder
                              IshaReminder:(bool)paramIshaReminder
                           RefreshReminder:(bool)paramRefreshReminder
                                 PlayAdhan:(bool)paramPlayAdhan{
    
    Settings *newSettings =[[Settings alloc] init];
    
    newSettings.fajrReminder = [NSNumber numberWithBool:paramFajrReminder];
    newSettings.dhuhrReminder = [NSNumber numberWithBool:paramDhuhrReminder];
    newSettings.asrReminder = [NSNumber numberWithBool:paramAsrReminder];
    newSettings.maghribReminder = [NSNumber numberWithBool:paramMaghribReminder];
    newSettings.ishaReminder = [NSNumber numberWithBool:paramIshaReminder];
    newSettings.refreshReminder = [NSNumber numberWithBool:paramRefreshReminder];
    newSettings.playAdhan = [NSNumber numberWithBool:paramPlayAdhan];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.beamstart.wise.SharingDefaults"];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newSettings];
    [defaults setObject:encodedObject forKey:@"settings"];
    
    return YES;
}


- (PrayerTimes *) getCurrentPrayerTimesRecord{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.beamstart.wise.SharingDefaults"];
    
    NSData *encodedObject = [defaults objectForKey:@"prayerTimes"];
    PrayerTimes *prayerTimesRecord = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    if(prayerTimesRecord != nil)
    {
        return prayerTimesRecord;
    }
    else
        return nil;
}

- (Settings *) getCurrentPrayerSettingsRecord{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.beamstart.wise.SharingDefaults"];
    
    NSData *encodedObject = [defaults objectForKey:@"settings"];
    Settings *settingsRecord = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];

    
    if(settingsRecord != nil)
        return settingsRecord;
    else
        return nil;
}


-(void) reloadSettingsWithFajrReminder:(bool)paramFajrReminder
                         DhuhrReminder:(bool)paramDhuhrReminder
                           AsrReminder:(bool)paramAsrReminder
                       MaghribReminder:(bool)paramMaghribReminder
                          IshaReminder:(bool)paramIshaReminder
                       RefreshReminder:(bool)paramRefreshReminder
                             PlayAdhan:(bool)paramPlayAdhan
{
    [self createNewSettingsWithFajrReminder:paramFajrReminder
                              DhuhrReminder:paramDhuhrReminder
                                AsrReminder:paramAsrReminder
                            MaghribReminder:paramMaghribReminder
                               IshaReminder:paramIshaReminder
                            RefreshReminder:paramRefreshReminder
                                  PlayAdhan:paramPlayAdhan];
    
}

@synthesize responseData;

-(void) loadUrl:(NSString *)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [conn start];
    
    if(conn){
        // Data Received
        self.responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //NSString *string = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
}

-(void) reloadPrayerTimes:(BOOL *)paramFetchedNewPrayerTimes{
    
    //NSString *wiseUrlString = @"https://www.wise-web.org";///appindex.php";
    //NSString *wiseUrlString = @"http://www.google.com";
    NSString *wiseUrlString = @"https://prayertimes-functions.azurewebsites.net/api/PrayerTimesTranslator?code=88qupa6LqnWajbvtbNx8P9ssOo2SnFaInK39aP9gv0OQKIKQCH1h4g==&name=wise";
    [self loadUrl:wiseUrlString];
    NSURL *wiseURL = [NSURL URLWithString:wiseUrlString];
    NSError *error;
    NSString *wisePage = [NSString stringWithContentsOfURL:wiseURL
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    
    NSString *fajrAzan;
    NSString *fajrJamaa;
    
    NSString *sunrise;
    
    NSString *dhuhrAzan;
    NSString *dhuhrJamaa;
    
    NSString *asrAzan;
    NSString *asrJamaa;
    
    NSString *maghribAzan;
    NSString *maghribJamaa;
    
    NSString *ishaAzan;
    NSString *ishaJamaa;
    
    NSString *adjustment;
    
    // We are only interested in data coming as part of background fetch. So:
    // if reloading data as part of background fetch, then store whatever we retrieve for future comparison
    // if reloading data as part of user interaction, then do not store anything. Leave as nil.
    NSString *bgFetchData = nil;
    if(paramFetchedNewPrayerTimes != nil)
        bgFetchData = wisePage;
    
    NSLog(@"content = %@",wisePage);
    
    NSData *data = [wisePage dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    timeLocation.location = 0;
    adjustment = [parsedObject objectForKey:@"adjustment"];// [self getHijriAdjustmentFromHTML:wisePage];
    
    timeLocation.location = 0;
    
    fajrAzan = [parsedObject objectForKey:@"FajrAzan"];// [self getAzanTimeFromHTML:wisePage];
    fajrJamaa = [parsedObject objectForKey:@"FajrJamaah"];// [self getJamaaTimeFromHTML:wisePage];
    
    sunrise = [parsedObject objectForKey:@"Sunrise"];// [self getAzanTimeFromHTML:wisePage];
    
    dhuhrAzan = [parsedObject objectForKey:@"DhuhrAzan"];// [self getAzanTimeFromHTML:wisePage];
    dhuhrJamaa = [parsedObject objectForKey:@"DhuhrJamaah"];// [self getJamaaTimeFromHTML:wisePage];
    
    asrAzan = [parsedObject objectForKey:@"AsrAzan"];// [self getAzanTimeFromHTML:wisePage];
    asrJamaa = [parsedObject objectForKey:@"AsrJamaah"];// [self getJamaaTimeFromHTML:wisePage];
    
    maghribAzan = [parsedObject objectForKey:@"MaghribAzan"];// [self getAzanTimeFromHTML:wisePage];
    maghribJamaa = [parsedObject objectForKey:@"MaghribJamaah"];// [self getJamaaTimeFromHTML:wisePage];
    
    ishaAzan = [parsedObject objectForKey:@"IshaAzan"];// [self getAzanTimeFromHTML:wisePage];
    ishaJamaa = [parsedObject objectForKey:@"IshaJamaah"];// [self getJamaaTimeFromHTML:wisePage];
    
    if([fajrAzan length] != 0)
    {
        
        [self createNewPrayerTimesWithAdjustment: adjustment FajrAzan:fajrAzan FajrJamaa:fajrJamaa SunrsiseAzan:sunrise DhuhrAzan:dhuhrAzan DhuhrJamaa:dhuhrJamaa AsrAzan:asrAzan AsrJamaa:asrJamaa MaghribAzan:maghribAzan MaghribJamaa:maghribJamaa IshaAzan:ishaAzan IshaJamaa:ishaJamaa ModifiedOn:[NSDate date] BgFetchData:bgFetchData];
        
    }
}


- (NSInteger) gmod:(NSInteger)n m:(NSInteger)m
{
    return ((n%m)+m)%m;
}

-(NSInteger *) kuwaitiCalendar:(NSInteger)adjust
{
    NSDate *today = [NSDate date];
    if(adjust != 0) {
        NSInteger adjustmili = 60 * 60 * 24 * adjust;
        NSTimeInterval todaymili = [today timeIntervalSince1970] *  1000;
        todaymili += adjustmili;
        today = [today dateByAddingTimeInterval:adjustmili];
        //today = [[NSDate date] dateByAddingTimeInterval:todaymili];
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    NSInteger day = [components day];
    NSInteger month = [components month] - 1;
    NSInteger year = [components year];

    NSInteger m = month+1;
    NSInteger y = year;
    if(m < 3) {
        y -= 1;
        m += 12;
    }
    
    NSInteger a = floor(y/100.);
    NSInteger b = 2 - a + floor(a/4.);
    if(y < 1583) b = 0;
    if(y == 1582) {
        if(m > 10)  b = -10;
        if(m == 10) {
            b = 0;
            if(day>4) b = -10;
        }
    }
    
    NSInteger jd = floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + day + b - 1524;
    
    b = 0;
    if(jd > 2299160){
        a = floor((jd - 1867216.25) / 36524.25);
        b = 1 + a - floor(a / 4.);
    }
    
    NSInteger bb = jd + b + 1524;
    NSInteger cc = floor((bb - 122.1) / 365.25);
    NSInteger dd = floor(365.25 * cc);
    NSInteger ee = floor((bb - dd)/30.6001);
    day =(bb - dd) - floor(30.6001 * ee);
    month = ee - 1;
    if(ee > 13) {
        cc += 1;
        month = ee - 13;
    }
    year = cc - 4716;
    
    NSInteger wd = 0;
    
    if(adjust) {
        wd = [self gmod:jd + 1 - adjust m:7] + 1;
    } else {
        wd = [self gmod:jd + 1 m:7] + 1;
    }
    
    double iyear = 10631./30.;
    NSInteger epochastro = 1948084;
    //NSInteger epochcivil = 1948085;
    
    double shift1 = 8.01 / 60.;
    
    NSInteger z = jd - epochastro;
    NSInteger cyc = floor(z / 10631.);
    z = z - 10631 * cyc;
    NSInteger j = floor((z - shift1) / iyear);
    NSInteger iy = 30 * cyc + j;
    z = z - floor(j * iyear + shift1);
    NSInteger im = floor((z + 28.5001) / 29.5);
    if(im == 13) im = 12;
    NSInteger _id = z - floor(29.5001 * im - 29);
    
    static NSInteger myRes[8];
    myRes[0] = day; //calculated day (CE)
    myRes[1] = month - 1; //calculated month (CE)
    myRes[2] = year; //calculated year (CE)
    myRes[3] = jd - 1; //julian day number
    myRes[4] = wd - 1; //weekday number
    myRes[5] = _id; //islamic date
    myRes[6] = im - 1; //islamic month
    myRes[7] = iy; //islamic year
    
    return myRes;
}

-(NSString *) getIslamicDate:(NSString *)adjust longDate:(bool)longDate
{
    NSString * wdNames[] = {@"Ahad",@"Ithnin",@"Thulatha",@"Arbaa",@"Khamis",@"Jumuah",@"Sabt"};
    NSString * iMonthNames[] = {@"Muharram",@"Safar",@"Rabi'ul Awwal",@"Rabi'ul Akhir",
                                @"Jumadal Ula",@"Jumadal Akhira",@"Rajab",@"Sha'ban",
                                @"Ramadan",@"Shawwal",@"Dhul Qa'ada",@"Dhul Hijja"};
    
    
    if([adjust isEqualToString:@""])
        adjust = @"0";
    
    NSInteger* iDate = [self kuwaitiCalendar:[adjust intValue]];
    
    NSString * outputIslamicDate;
    
    if(longDate == true)
        outputIslamicDate = [NSString stringWithFormat:@"%@, %ld %@ %ld AH",wdNames[iDate[4]],iDate[5],iMonthNames[iDate[6]],iDate[7]];
    else
        outputIslamicDate = [NSString stringWithFormat:@"%ld %@",iDate[5],iMonthNames[iDate[6]]];
    
                                    
    return outputIslamicDate;
}

@end

