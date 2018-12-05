//
//  TodayViewController.m
//  PrayerTimesWidget
//
//  Created by Mohamed Rashwan on 05/10/2014.
//  Copyright (c) 2014 Beamstart. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

@synthesize prayerTimesGate;
@synthesize touchFlag;
@synthesize backColor;
@synthesize textColor;

@synthesize reminderSettings;

-(void) loadPage
{
    PrayerTimes *prayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
    
    self.hijriDate.text = @"99 Jumadal Akhira";
    self.hijriDate.text = [prayerTimesGate getIslamicDate:prayerTimes.adjustment longDate:false];
    
    self.fajrTitle.text = @"Fajr";
    self.fajrAzan.text = prayerTimes.fajrAzan;
    self.fajrJamaa.text = prayerTimes.fajrJamaa;
    
    self.sunriseTitle.text = @"Sunrise";
    self.sunriseAzan.text = prayerTimes.sunriseAzan;
    self.sunriseJamaa.text = @"-";
    
    self.dhuhrTitle.text = @"Dhuhr";
    self.dhuhrAzan.text = prayerTimes.dhuhrAzan;
    self.dhuhrJamaa.text = prayerTimes.dhuhrJamaa;
    
    self.asrTitle.text = @"Asr";
    self.asrAzan.text = prayerTimes.asrAzan;
    self.asrJamaa.text = prayerTimes.asrJamaa;
    
    self.maghribTitle.text = @"Maghrib";
    self.maghribAzan.text = prayerTimes.maghribAzan;
    self.maghribJamaa.text = prayerTimes.maghribJamaa;
    
    self.ishaTitle.text = @"Isha";
    self.ishaAzan.text = prayerTimes.ishaAzan;
    self.ishaJamaa.text = prayerTimes.ishaJamaa;
    
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    defaultMarginInsets.left = 0;
    defaultMarginInsets.bottom = 5;
    
    return defaultMarginInsets;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchFlag = true;
    backColor = self.view.backgroundColor;
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchFlag = false;
    self.view.backgroundColor = self.backColor;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.view.backgroundColor = self.backColor;
    
    if(touchFlag == true)
    {
        [self drawPrayerTimes];
        [self formatNextPrayer];
        /*
        NSURL *url = [NSURL URLWithString:@"wiseprayer://"];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {
            NSLog(@"fun=%s after completion. success=%d", __func__, success);
        }];
        [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
        */
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion >= 10)
    {
        self.textColor = [UIColor blackColor];
        [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeCompact];
    }
    else
    {
        self.textColor = [UIColor whiteColor];
        self.preferredContentSize = CGSizeMake(0, 110);
    }
    
    // Do any additional setup after loading the view from its nib.
    
    //    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Add"
    //                                   style:UIBarButtonItemStyleBordered target:self action:@selector(performLoadPage:)];
    
    /*
    UIColor* customBlue = [[UIColor alloc] initWithRed:26.0f/255.0f green:17.0f/255.0f blue:50.0f/255.0f alpha:1];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //[gradient setStartPoint:CGPointMake(0.0, 0.5)];
    //[gradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[customBlue CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    */
    
    [self drawPrayerTimes];
    [self formatNextPrayer];
    
}

- (void) formatNextPrayer
{
    PrayerTimes *prayerTimes = [prayerTimesGate getCurrentPrayerTimesRecord];
    NSString *dhuhrAmPm = @"pm";
    
    if([[prayerTimes.dhuhrAzan substringToIndex:2] isEqualToString:@"11"])
        dhuhrAmPm=@"am";
    
    
    if([[prayerTimesGate getPrayerTimeAt:prayerTimes.fajrAzan ampm:@"am"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.fajrTitle.frame.origin.x + 10, self.fajrTitle.frame.origin.y + 5);}];
        
        [self.fajrTitle setTextColor:[UIColor blueColor]];
        [self.fajrAzan setTextColor:[UIColor blueColor]];
        [self.fajrJamaa setTextColor:[UIColor blueColor]];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.sunriseAzan ampm:@"am"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.sunriseTitle.frame.origin.x + 10, self.sunriseTitle.frame.origin.y + 5);}];
        
        [self.sunriseTitle setTextColor:[UIColor blueColor]];
        [self.sunriseAzan setTextColor:[UIColor blueColor]];
        [self.sunriseJamaa setTextColor:[UIColor blueColor]];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.dhuhrAzan ampm:dhuhrAmPm] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.dhuhrTitle.frame.origin.x + 10, self.dhuhrTitle.frame.origin.y + 5);}];
        
        [self.dhuhrTitle setTextColor:[UIColor blueColor]];
        [self.dhuhrAzan setTextColor:[UIColor blueColor]];
        [self.dhuhrJamaa setTextColor:[UIColor blueColor]];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.asrAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.asrTitle.frame.origin.x + 10, self.asrTitle.frame.origin.y + 5);}];
        
        [self.asrTitle setTextColor:[UIColor blueColor]];
        [self.asrAzan setTextColor:[UIColor blueColor]];
        [self.asrJamaa setTextColor:[UIColor blueColor]];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.maghribAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.maghribTitle.frame.origin.x + 10, self.maghribTitle.frame.origin.y + 5);}];
        
        [self.maghribTitle setTextColor:[UIColor blueColor]];
        [self.maghribAzan setTextColor:[UIColor blueColor]];
        [self.maghribJamaa setTextColor:[UIColor blueColor]];
    }
    else if([[prayerTimesGate getPrayerTimeAt:prayerTimes.ishaAzan ampm:@"pm"] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.ishaTitle.frame.origin.x + 10, self.ishaTitle.frame.origin.y + 5);}];
        
        [self.ishaTitle setTextColor:[UIColor blueColor]];
        [self.ishaAzan setTextColor:[UIColor blueColor]];
        [self.ishaJamaa setTextColor:[UIColor blueColor]];
    }
    else if([[[prayerTimesGate getPrayerTimeAt:prayerTimes.ishaAzan ampm:@"pm"] dateByAddingTimeInterval:60*60*24] compare:[NSDate date]] == NSOrderedDescending)
    {
        [UIView animateWithDuration:0.5f animations:^{self.nextPrayerIndicator.center = CGPointMake(self.fajrTitle.frame.origin.x + 10, self.fajrTitle.frame.origin.y + 10);}];
        
        [self.fajrTitle setTextColor:[UIColor blueColor]];
        [self.fajrAzan setTextColor:[UIColor blueColor]];
        [self.fajrJamaa setTextColor:[UIColor blueColor]];
    }
    else
    {
        self.nextPrayerIndicator.text = @"";
    }

    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self formatNextPrayer];
    
    //Trigger the obeserver to reload notifications [not sure this works]
    [self.reminderSettings setValue:[NSNumber numberWithInt:1] forKey:@"fajrReminder"];
}

- (void)drawPrayerTimes
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    float width = 75.0f;
    float height = 15.0f;
    float horizontalSpacing = 10;
    float fontSize = 14.0f;
    float headerFontSize = 14.0f;
    
    float left = ([[UIScreen mainScreen] bounds].size.width - (width * 3) - (horizontalSpacing * 2)) / 2;
    float left2 = left + width + horizontalSpacing;
    float left3 = left2 + width + horizontalSpacing;
    float verticalSpacing = 0;
    float top0 = 0;
    float top1 = top0 + height + verticalSpacing;
    float top2 = top1 + height + verticalSpacing;
    float top3 = top2 + height + verticalSpacing;
    float top4 = top3 + height + verticalSpacing;
    float top5 = top4 + height + verticalSpacing;
    float top6 = top5 + height + verticalSpacing;
    
    float hijriWidth = left2 - (left / 2);
    float hijriLeft = left / 2;
    
    self.hijriDate = [[UILabel alloc]initWithFrame:CGRectMake(hijriLeft, top0, hijriWidth, height)];
    self.hijriDate.textAlignment = NSTextAlignmentCenter;
    
    self.azanTitle = [[UILabel alloc]initWithFrame:CGRectMake(left2,top0,width,height)];
    self.jamaaTitle = [[UILabel alloc]initWithFrame:CGRectMake(left3,top0,width,height)];
    
    self.fajrTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top1, width, height)];
    self.fajrAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top1, width, height)];
    self.fajrJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top1, width, height)];
    
    self.sunriseTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top2, width, height)];
    self.sunriseAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top2, width, height)];
    self.sunriseJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top2, width, height)];
    
    self.dhuhrTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top3, width, height)];
    self.dhuhrAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top3, width, height)];
    self.dhuhrJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top3, width, height)];
    
    self.asrTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top4, width, height)];
    self.asrAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top4, width, height)];
    self.asrJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top4, width, height)];
    
    self.maghribTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top5, width, height)];
    self.maghribAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top5, width, height)];
    self.maghribJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top5, width, height)];
    
    self.ishaTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top6, width, height)];
    self.ishaAzan = [[UILabel alloc] initWithFrame:CGRectMake(left2, top6, width, height)];
    self.ishaJamaa = [[UILabel alloc] initWithFrame:CGRectMake(left3, top6, width, height)];
    
    self.nextPrayerIndicator = [[UILabel alloc] initWithFrame:CGRectMake(left, top0, width, height)];
    self.nextPrayerIndicator.text = @">>";
    self.nextPrayerIndicator.textColor = [UIColor blueColor];
    
    self.azanTitle.text = @"Start";
    self.azanTitle.textColor = self.textColor;
    
    self.jamaaTitle.text = @"Jamaah";
    self.jamaaTitle.textColor = self.textColor;
    
    self.fajrTitle.textColor = self.textColor;
    self.sunriseTitle.textColor = self.fajrTitle.textColor;
    self.dhuhrTitle.textColor = self.fajrTitle.textColor;
    self.asrTitle.textColor = self.fajrTitle.textColor;
    self.maghribTitle.textColor = self.fajrTitle.textColor;
    self.ishaTitle.textColor = self.fajrTitle.textColor;
    
    self.fajrAzan.textColor = self.textColor;
    self.sunriseAzan.textColor = self.fajrAzan.textColor;
    self.dhuhrAzan.textColor = self.fajrAzan.textColor;
    self.asrAzan.textColor = self.fajrAzan.textColor;
    self.maghribAzan.textColor = self.fajrAzan.textColor;
    self.ishaAzan.textColor = self.fajrAzan.textColor;
    
    self.fajrJamaa.textColor = self.textColor;
    self.sunriseJamaa.textColor = self.fajrJamaa.textColor;
    self.dhuhrJamaa.textColor = self.fajrJamaa.textColor;
    self.asrJamaa.textColor = self.fajrJamaa.textColor;
    self.maghribJamaa.textColor = self.fajrJamaa.textColor;
    self.ishaJamaa.textColor = self.fajrJamaa.textColor;
    
    self.hijriDate.font = [UIFont systemFontOfSize:10.0f];
    self.azanTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.jamaaTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.fajrTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.sunriseTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.dhuhrTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.asrTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.maghribTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    self.ishaTitle.font = [UIFont boldSystemFontOfSize:headerFontSize];
    
    self.fajrAzan.font = [UIFont systemFontOfSize:fontSize];
    self.fajrJamaa.font = [UIFont systemFontOfSize:fontSize];
    self.sunriseAzan.font = [UIFont systemFontOfSize:fontSize];
    self.sunriseJamaa.font = [UIFont systemFontOfSize:fontSize];
    self.dhuhrAzan.font = [UIFont systemFontOfSize:fontSize];
    self.dhuhrJamaa.font = [UIFont systemFontOfSize:fontSize];
    self.asrAzan.font = [UIFont systemFontOfSize:fontSize];
    self.asrJamaa.font = [UIFont systemFontOfSize:fontSize];
    self.maghribAzan.font = [UIFont systemFontOfSize:fontSize];
    self.maghribJamaa.font = [UIFont systemFontOfSize:fontSize];
    self.ishaAzan.font = [UIFont systemFontOfSize:fontSize];
    self.ishaJamaa.font = [UIFont systemFontOfSize:fontSize];
    
    //self.fajrTitle.backgroundColor = [UIColor blackColor];
    prayerTimesGate = [[PrayerTimesGate alloc]init];
    
    // pass nil to indicate this is not a background fetch and we r not interested in storing fetched data
    [prayerTimesGate reloadPrayerTimes:nil];
    
    [self loadPage];
    
    [self.view addSubview:self.hijriDate];
    [self.view addSubview:self.azanTitle];
    [self.view addSubview:self.jamaaTitle];
    
    [self.view addSubview:self.fajrTitle];
    [self.view addSubview:self.fajrAzan];
    [self.view addSubview:self.fajrJamaa];
    
    [self.view addSubview:self.sunriseTitle];
    [self.view addSubview:self.sunriseAzan];
    [self.view addSubview:self.sunriseJamaa];
    
    [self.view addSubview:self.dhuhrTitle];
    [self.view addSubview:self.dhuhrAzan];
    [self.view addSubview:self.dhuhrJamaa];
    
    [self.view addSubview:self.asrTitle];
    [self.view addSubview:self.asrAzan];
    [self.view addSubview:self.asrJamaa];
    
    [self.view addSubview:self.maghribTitle];
    [self.view addSubview:self.maghribAzan];
    [self.view addSubview:self.maghribJamaa];
    
    [self.view addSubview:self.ishaTitle];
    [self.view addSubview:self.ishaAzan];
    [self.view addSubview:self.ishaJamaa];
    
    [self.view addSubview:self.nextPrayerIndicator];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    
    completionHandler(NCUpdateResultNewData);
}

@end
