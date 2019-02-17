//
//  AppDelegate.m
//  WISE
//
//  Created by Mohamed Rashwan on 28/09/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize prayerTimesGate;
@synthesize isAppResumingFromBackground;
@synthesize didAppHaveBadgeIcon;

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    [self downloadMissingPrayerTimes];
}

-(void) downloadMissingPrayerTimes
{
    [self refreshReminderNotifications];
    
    [self.logViewController addLog:@"appdelegate didReceiveLocalNotification got notification"];
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber == 1 || self.didAppHaveBadgeIcon == YES)
    {
        self.didAppHaveBadgeIcon = NO;
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        if (isAppResumingFromBackground) {
            
            isAppResumingFromBackground = NO;
            
            [self.logViewController addLog:@"appdelegate didReceiveLocalNotification coming from background"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Prayer times download complete." delegate:self cancelButtonTitle:@"JAK" otherButtonTitles:nil , nil];
            
            [alert show];
        }
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self.logViewController addLog:@"appdelegate didReceiveLocalNotification continue.."];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    //self.activitiesViewController = [[ActivitiesViewController alloc] initWithStyle:UITableViewStylePlain];
    self.settingsViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.logViewController = [[LogViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    [self.logViewController addLog:@"appdelegate didfinishlaunching"];
    
    [self.logViewController addLog:[NSString stringWithFormat:@"OS Ver %ld",[[NSProcessInfo processInfo] operatingSystemVersion].majorVersion]];
    
    //delete self.viewController.settingsViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    prayerTimesGate = [[PrayerTimesGate alloc]init];
    Settings *settings = [prayerTimesGate getCurrentPrayerSettingsRecord];
    
    if(settings != nil)
    {
        [self updateSettings:settings];
    }
    
    UINavigationController *prayersNavigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    //self.activitiesViewController = [[ActivitiesViewController alloc] initWithNibName:nil bundle:NULL];
    //UINavigationController *activitiesNavigationController = [[UINavigationController alloc] initWithRootViewController:self.activitiesViewController];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
    UINavigationController *logNavigationController = [[UINavigationController alloc] initWithRootViewController:self.logViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:
      @[prayersNavigationController, settingsNavigationController]];//, logNavigationController]];
    
    //[tabBarController setViewControllers:
    // @[prayersNavigationController, activitiesNavigationController, settingsNavigationController]];//, logNavigationController]];
    
    self.settingsViewController.reminderSettings =[[ReminderSettings alloc] init];
    [self.settingsViewController.reminderSettings addObserver:self forKeyPath:@"fajrReminder" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber == 1)
    {
        [self.logViewController addLog:@"appdelegate badge is 1"];
        isAppResumingFromBackground = YES;
        [self downloadMissingPrayerTimes];
    }
    else
    {
        [self.logViewController addLog:@"appdelegate badge is 0"];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        if([prayerTimesGate getCurrentPrayerTimesRecord] != nil)
            [self refreshReminderNotifications];
    }
    
    [self.logViewController addLog:@"and reminders are set"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /* Make our view controller the root view controller */
    self.window.rootViewController = tabBarController;
    
    //self.window.rootViewController = self.navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *existingVersion = [defaults objectForKey:@"version"];
    /* 
     major.minor.deploy (build)
     major: Changes if the application interface or functionality gets extreme makeover
     minor: Changes if new features are added to the current version
     deploy: Changes every time fixes or modifications are deployed to public
     build: Changes every time fixes or modifications are deployed for testing
     */
    NSString *correctVersion = @"1.4.1 (1)";
    
    if(existingVersion == nil || ![existingVersion isEqualToString:correctVersion])
    {
        [self.logViewController addLog:[NSString stringWithFormat:@"Load new version"]];
        
        [defaults setObject:correctVersion forKey:@"version"];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // pass nil to indicate this is not a background fetch and we r not interested in storing fetched data
        [prayerTimesGate reloadPrayerTimes:nil];
        
        [self refreshReminderNotifications];
        
        UIAlertView *welcome = [[UIAlertView alloc] initWithTitle:@"Assalamu Alikum <1.4.1 (1)>" message:@"." delegate:self cancelButtonTitle:@"JAK" otherButtonTitles:nil , nil];
        
        //[welcome show];
    }
    
    [self.logViewController addLog:[NSString stringWithFormat:@"Coming from: %@", existingVersion]];
    
    
    
    return YES;
}

/*
- (void) addSearchItem:(NSString *)itemName withID:(NSString *)uid andDescription:(NSString *)desc
{
    // Create an attribute set for an item that represents an image.
    CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    // Set properties that describe attributes of the item such as title, description, and image.
    attributeSet.title = itemName;
    attributeSet.contentDescription = desc;
    
    // Create a searchable item, specifying its ID, associated domain, and the attribute set you created earlier.
    CSSearchableItem *item;
    item = [[CSSearchableItem alloc] initWithUniqueIdentifier:uid domainIdentifier:@"domain1.subdomainA" attributeSet:attributeSet];
    // Index the item.
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error) {
        NSLog(@"Search item indexed");
    }];
}
*/

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    BOOL haveNewPrayerContent = NO;
    BOOL haveNewActivites = NO;
    
    [self fetchNewPrayerTimes:&haveNewPrayerContent];
    //[self.activitiesViewController performRefreshData:&haveNewActivites];
    
    if(haveNewPrayerContent)
        [self.viewController loadPage];
    
    //if(haveNewActivites)
        //[self.activitiesViewController refreshData:nil];
    
    if (haveNewPrayerContent || haveNewActivites)
    {
        completionHandler(UIBackgroundFetchResultNewData);
    }
    else
    {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void) fetchNewPrayerTimes:(BOOL *)paramFetchedNewPrayerTimes
{
    prayerTimesGate = [[PrayerTimesGate alloc]init];
    PrayerTimes *existingPrayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
    PrayerTimes *newPrayerTimes = nil;
    bool fetchedNewPrayerTimes = false;
    
    if(existingPrayerTimes == nil)
    {
        // no record stored for prayer times. whatever we get from server will be considered new.
        fetchedNewPrayerTimes = true;
    }
    else
    {
        // retrieve new prayer times from server and compare with existing record
        [prayerTimesGate reloadPrayerTimes:paramFetchedNewPrayerTimes];
        newPrayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
        
        if(![newPrayerTimes.fajrAzan isEqualToString:existingPrayerTimes.fajrAzan]
           || ![newPrayerTimes.fajrJamaa isEqualToString:existingPrayerTimes.fajrJamaa]
           || ![newPrayerTimes.dhuhrAzan isEqualToString:existingPrayerTimes.dhuhrAzan]
           || ![newPrayerTimes.dhuhrJamaa isEqualToString:existingPrayerTimes.dhuhrJamaa]
           || ![newPrayerTimes.asrAzan isEqualToString:existingPrayerTimes.asrAzan]
           || ![newPrayerTimes.asrJamaa isEqualToString:existingPrayerTimes.asrJamaa]
           || ![newPrayerTimes.maghribAzan isEqualToString:existingPrayerTimes.maghribAzan]
           || ![newPrayerTimes.maghribJamaa isEqualToString:existingPrayerTimes.maghribJamaa]
           || ![newPrayerTimes.ishaAzan isEqualToString:existingPrayerTimes.ishaAzan]
           || ![newPrayerTimes.ishaJamaa isEqualToString:existingPrayerTimes.ishaJamaa]
           )
        {
            fetchedNewPrayerTimes = true;
        }
    }
    
    if(fetchedNewPrayerTimes)
    {
        // fetched new prayer times. update local notification with new times
        [self refreshReminderNotifications];
        
        // update shown prayer times
        [self.viewController loadPage];
        [self.viewController formatNextPrayer];
    }
    
    // If it is requested to indicate whether new data is downloaded or not
    if(paramFetchedNewPrayerTimes != nil)
    {
        // New data is always downloaded if no data exists in our cache
        if(existingPrayerTimes == nil)
            *paramFetchedNewPrayerTimes = YES;
        else
        {
            // If new and existing data are equal, then no new data is downloaded
            if([newPrayerTimes.bgFetchData isEqualToString:existingPrayerTimes.bgFetchData])
                *paramFetchedNewPrayerTimes = NO;
            else
                *paramFetchedNewPrayerTimes = YES;
        }
    }
        
}

- (void) updateSettings:(Settings *)settings
{
    [self.settingsViewController.fajrSwitch setOn:[settings.fajrReminder boolValue]];
    [self.settingsViewController.dhuhrSwitch setOn:[settings.dhuhrReminder boolValue]];
    [self.settingsViewController.asrSwitch setOn:[settings.asrReminder boolValue]];
    [self.settingsViewController.maghribSwitch setOn:[settings.maghribReminder boolValue]];
    [self.settingsViewController.ishaSwitch setOn:[settings.ishaReminder boolValue]];
    [self.settingsViewController.refreshSwitch setOn:[settings.refreshReminder boolValue]];
    [self.settingsViewController.playAdhanSwitch setOn:[settings.playAdhan boolValue]];
}

- (void) cancelAllFutureLocalNotifications
{
    [self.logViewController addLog:[NSString stringWithFormat:@"Remove future notifications"]];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    [self.logViewController addLog:[NSString stringWithFormat:@"Found %ld notifications", eventArray.count]];
    long countRemoved=0;
    long countStayed=0;
    
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        timeZone = [NSTimeZone timeZoneForSecondsFromGMT:timeZone.secondsFromGMT];
        [formatter setTimeZone:timeZone];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ssa"];
        
        // if event is later than now
        if([oneEvent.fireDate compare:[NSDate date]] == NSOrderedDescending)
        {
            [self.logViewController addLog:[NSString stringWithFormat:@"notif msg %@",oneEvent.alertBody]];
            [self.logViewController addLog:[NSString stringWithFormat:@"notif time %@", [formatter stringFromDate:oneEvent.fireDate]]];
            
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            countRemoved += 1;
        }
        else
            countStayed += 1;
    }
    
    [self.logViewController addLog:[NSString stringWithFormat:@"Removed %ld future notifications", countRemoved]];
    [self.logViewController addLog:[NSString stringWithFormat:@"%ld past notification left", countStayed]];
    
}

- (void) refreshReminderNotifications
{
    prayerTimesGate=[[PrayerTimesGate alloc] init];
    PrayerTimes *prayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
    
    /*
    [self addSearchItem:@"Fajr" withID:@"1" andDescription:[NSString stringWithFormat:@"Azan at %@ and Jamaa at %@", prayerTimes.fajrAzan, prayerTimes.fajrJamaa]];
    [self addSearchItem:@"Sunrise" withID:@"1" andDescription:[NSString stringWithFormat:@"%@", prayerTimes.sunriseAzan]];
    [self addSearchItem:@"Dhuhr" withID:@"1" andDescription:[NSString stringWithFormat:@"Azan at %@ and Jamaa at %@", prayerTimes.dhuhrAzan, prayerTimes.dhuhrJamaa]];
    [self addSearchItem:@"Asr" withID:@"1" andDescription:[NSString stringWithFormat:@"Azan at %@ and Jamaa at %@", prayerTimes.asrAzan, prayerTimes.asrJamaa]];
    [self addSearchItem:@"Maghrib" withID:@"1" andDescription:[NSString stringWithFormat:@"Azan at %@ and Jamaa at %@", prayerTimes.maghribAzan, prayerTimes.maghribJamaa]];
    [self addSearchItem:@"Isha" withID:@"1" andDescription:[NSString stringWithFormat:@"Azan at %@ and Jamaa at %@", prayerTimes.ishaAzan, prayerTimes.ishaJamaa]];
    */
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self cancelAllFutureLocalNotifications];
    
    //[self createReminderForPrayerName:@"Test" atTime:@"10:42" withAmOrPm:@"pm"];
    
    if(prayerTimes==nil || prayerTimes.fajrAzan == nil)
    {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not retrieve prayer times" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil , nil];
        
        [error show];
    }
        
    
    // determine if any reminder is switched on
    NSDate *firstReminderDate = nil;
    
    if([self.settingsViewController.fajrSwitch isOn])
    {
        firstReminderDate = [self createReminderForPrayerName:@"Fajr"
                                                       atTime:prayerTimes.fajrAzan
                                                   withAmOrPm:@"am"
                                                    jamaaTime:prayerTimes.fajrJamaa
                                                    extraNote:[NSString stringWithFormat:@"Sunrise at %@", prayerTimes.sunriseAzan]];
    }
    
    if([self.settingsViewController.dhuhrSwitch isOn])
    {
        NSString *ampm = @"pm";
        if([prayerTimes.dhuhrAzan containsString:@"11:"])
            ampm = @"am";
        
        NSDate *reminderDate = [self createReminderForPrayerName:@"Dhuhr"
                                                          atTime:prayerTimes.dhuhrAzan
                                                      withAmOrPm:ampm
                                                       jamaaTime:prayerTimes.dhuhrJamaa
                                                       extraNote:[NSString stringWithFormat:@"Asr at %@", prayerTimes.asrAzan]];
        
        if(firstReminderDate == nil && reminderDate != nil)
            firstReminderDate = reminderDate;
    }
    
    if([self.settingsViewController.asrSwitch isOn])
    {
        NSDate *reminderDate = [self createReminderForPrayerName:@"Asr"
                                                          atTime:prayerTimes.asrAzan
                                                      withAmOrPm:@"pm"
                                                       jamaaTime:prayerTimes.asrJamaa
                                                       extraNote:[NSString stringWithFormat:@"Maghrib at %@", prayerTimes.maghribAzan]];
        
        if(firstReminderDate == nil && reminderDate != nil)
            firstReminderDate = reminderDate;
    }
    
    if([self.settingsViewController.maghribSwitch isOn])
    {
        NSDate *reminderDate = [self createReminderForPrayerName:@"Maghrib"
                                                          atTime:prayerTimes.maghribAzan
                                                      withAmOrPm:@"pm"
                                                       jamaaTime:prayerTimes.maghribJamaa
                                                       extraNote:[NSString stringWithFormat:@"Isha at %@", prayerTimes.ishaAzan]];
        
        if(firstReminderDate == nil && reminderDate != nil)
            firstReminderDate = reminderDate;
    }
    
    if([self.settingsViewController.ishaSwitch isOn])
    {
        NSDate *reminderDate = [self createReminderForPrayerName:@"Isha"
                                                          atTime:prayerTimes.ishaAzan
                                                      withAmOrPm:@"pm"
                                                       jamaaTime:prayerTimes.ishaJamaa
                                                       extraNote:nil];//[NSString stringWithFormat:@"Fajr at %@", prayerTimes.fajrAzan]];
        
        if(firstReminderDate == nil && reminderDate != nil)
            firstReminderDate = reminderDate;
    }
    
    if([self.settingsViewController.refreshSwitch isOn] && firstReminderDate != nil)
    {
        // add code to create reminder to notify if times are not downloaded
        [self.logViewController addLog:[NSString stringWithFormat:@"create refresh notification"]];
        
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                                  categories:nil]];
        }
        
        NSString *alertMessage = [NSString stringWithFormat:@"Today's reminders are not downloaded"];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        // make it next day one hour before first reminder
        NSDate *fireDate = [firstReminderDate dateByAddingTimeInterval:60 * 60 * 23];
        
        notification.fireDate = fireDate;
        notification.timeZone = [[NSCalendar currentCalendar] timeZone];
        //notification.repeatInterval = NSDayCalendarUnit;
        notification.alertBody = alertMessage;
        //notification.soundName = @"GlassPing.mp3";
        
        /* Action settings */
        notification.hasAction = YES;
        notification.alertAction = NSLocalizedString(@"Refresh", nil);
        /* Badge settings */
        notification.applicationIconBadgeNumber = 1;//[UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        /* Additional information, user info */
        //notification.userInfo = @{@"Key 1" : @"Value 1",
        //                          @"Key 2" : @"Value 2"};
        /* Schedule the notification */
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [self.logViewController addLog:[NSString stringWithFormat:@"refresh notify: registered %@",notification.alertBody]];
        
    }// end of added code
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self refreshReminderNotifications];
}


- (NSDate*)createReminderForPrayerName:(NSString *)prayerName atTime:(NSString *)prayerTime withAmOrPm:(NSString *)ampm jamaaTime:(NSString *)jamaaTime extraNote:(NSString *)extraNote {
    
    [self.logViewController addLog:[NSString stringWithFormat:@"create for time %@", prayerTime]];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    timeZone = [NSTimeZone timeZoneForSecondsFromGMT:timeZone.secondsFromGMT];
    [inputFormatter setTimeZone:timeZone];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd 'at' hh:mma"];
    
    NSString *stringDate = [NSString stringWithFormat:@"%ld-%ld-%ld at %@%@",(long)year,(long)month,(long)day,prayerTime,ampm];
    [self.logViewController addLog:[NSString stringWithFormat:@"Complete date %@",stringDate]];
    
    NSDate *formatterDate = [inputFormatter dateFromString:stringDate];
    
    // If data is corrupt then do not create notification
    if(formatterDate == nil)
    {
        [self.logViewController addLog:[NSString stringWithFormat:@"prayerTime %@ is corrupt for %@. Reminder is not created", prayerTime, prayerName]];
        return nil;
    }
    
    NSString *alertMessage;
    
    if([jamaaTime containsString:@"&"])
        alertMessage = [NSString stringWithFormat:@"It's %@ prayer time. Jamaa in %@", prayerName, [jamaaTime stringByReplacingOccurrencesOfString:@"&" withString:@""]];
    else
        alertMessage = [NSString stringWithFormat:@"It's %@ prayer time. Jamaa at %@", prayerName, jamaaTime];
    
    if(extraNote != nil)
        alertMessage = [NSString stringWithFormat:@"%@. %@",alertMessage, extraNote];
    
    NSDate *fireDate;
    
    // loop 5 times to re-register the same notification for coming 5 days
    for (int i=0; i<1; i++)
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        /* Time and timezone settings */
        if(formatterDate == nil)
            [self.logViewController addLog:@"formatterDate is null"];
        else if([formatterDate dateByAddingTimeInterval:60 * 60 * 24 * i] == nil)
            [self.logViewController addLog:@"formatterDate datebyAddingTimeInterval is nil"];
        else if(inputFormatter == nil)
            [self.logViewController addLog:@"inputFormatter is null"];
        
        [self.logViewController addLog:[NSString stringWithFormat:@"registering date %@",[inputFormatter stringFromDate:[formatterDate dateByAddingTimeInterval:60 * 60 * 24 * i] ]]];
        
        fireDate = [formatterDate dateByAddingTimeInterval:60 * 60 * 24 * i];
        
        
        // if notifcation time will be sometime earlier than now, then add one more day.
        // WRONG
        // if notification time is earlier than now, then do not create it aslan. But return the fireDate for reference
        if([fireDate compare:[NSDate date]] == NSOrderedAscending)
        {
            return fireDate;
            //fireDate = [fireDate dateByAddingTimeInterval:60 * 60 * 24];
            //i = i + 1;
        }
        
        notification.fireDate = fireDate;
        notification.timeZone = [[NSCalendar currentCalendar] timeZone];
        //notification.repeatInterval = NSDayCalendarUnit;
        notification.alertBody = alertMessage;
        if([self.settingsViewController.playAdhanSwitch isOn])
            notification.soundName = @"Athan30_echo_low.caf";
        else
            notification.soundName = @"GlassPing.mp3";
        
        /* Action settings */
        notification.hasAction = NO;
        //notification.alertAction = NSLocalizedString(@"View", nil);
        /* Badge settings */
        //notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        /* Additional information, user info */
        //notification.userInfo = @{@"Key 1" : @"Value 1",
        //                          @"Key 2" : @"Value 2"};
        /* Schedule the notification */
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [self.logViewController addLog:[NSString stringWithFormat:@"registered %@",notification.alertBody]];
        [self.logViewController addLog:[NSString stringWithFormat:@"for time %@",[inputFormatter stringFromDate:notification.fireDate]]];\
        
    }
    
    return fireDate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[self.viewController formatNextPrayer];
    [self.logViewController addLog:@"appdelegate applicationWillEnterForeground!"];
    
    // Set this value, so notification function know whether it needs to display alert or not
    self.isAppResumingFromBackground = YES;
    
    // If badge=1, then record this so notification function will know it needs to display alert
    self.didAppHaveBadgeIcon = [UIApplication sharedApplication].applicationIconBadgeNumber == 1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if([prayerTimesGate getCurrentPrayerTimesRecord] != nil)
        [self refreshReminderNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.viewController formatNextPrayer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
