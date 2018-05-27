//
//  TableViewController.m
//  WISE
//
//  Created by Mohamed Rashwan on 14/04/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import "TableViewController.h"
#import "PrayerTimesGate.h"

static NSString *CellIdentifier = @"Cell";




@interface TableViewController ()


@end

@implementation TableViewController

@synthesize reminderSettings;

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 30.0f;
    }
    return 0.0f;
}

- (UILabel *) newLabelWithTitle:(NSString *)paramTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 50.0f, 0, 0)];
    label.text = paramTitle;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    return label;
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return [self newLabelWithTitle:@"  Prayers Reminder"];
    }
    return nil; }

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    self.title=@"Settings";
    self.tabBarItem.image = [UIImage imageNamed:@"settings-25.png"];
    
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:CellIdentifier];
    }
    return self; }

- (void)switchIsChanged:(UISwitch *)paramSender
{
    PrayerTimesGate *prayerTimesGate = [[PrayerTimesGate alloc]init];
    
    [prayerTimesGate reloadSettingsWithFajrReminder:[self.fajrSwitch isOn]
                                      DhuhrReminder:[self.dhuhrSwitch isOn]
                                        AsrReminder:[self.asrSwitch isOn]
                                    MaghribReminder:[self.maghribSwitch isOn]
                                       IshaReminder:[self.ishaSwitch isOn]
                                    RefreshReminder:[self.refreshSwitch isOn]
                                          PlayAdhan:[self.playAdhanSwitch isOn]];
    if([paramSender isOn])
        [self.reminderSettings setValue:[NSNumber numberWithInt:1] forKey:@"fajrReminder"];
    else
        [self.reminderSettings setValue:[NSNumber numberWithInt:0] forKey:@"fajrReminder"];

}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    self.title=@"Settings";
    self.tabBarItem.image = [UIImage imageNamed:@"settings-25.png"];
    
    if (self != nil) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fajrSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    self.dhuhrSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    self.asrSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    self.maghribSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    self.ishaSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    self.refreshSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    self.playAdhanSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    
    [self.fajrSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dhuhrSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.asrSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.maghribSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.ishaSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.refreshSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.playAdhanSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.fajrSwitch.onTintColor = [UIColor purpleColor];
    self.dhuhrSwitch.onTintColor = [UIColor purpleColor];
    self.asrSwitch.onTintColor = [UIColor purpleColor];
    self.maghribSwitch.onTintColor = [UIColor purpleColor];
    self.ishaSwitch.onTintColor = [UIColor purpleColor];
    self.refreshSwitch.onTintColor = [UIColor purpleColor];
    self.playAdhanSwitch.onTintColor = [UIColor purpleColor];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the section
    switch (indexPath.section) {
        case 0:
            
            break;
            
        default:
            break;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Fajr";
            cell.accessoryView = self.fajrSwitch;
            break;
        case 1:
            cell.textLabel.text = @"Dhuhr";
            cell.accessoryView = self.dhuhrSwitch;
            break;
        case 2:
            cell.textLabel.text = @"Asr";
            cell.accessoryView = self.asrSwitch;
            break;
        case 3:
            cell.textLabel.text = @"Maghrib";
            cell.accessoryView = self.maghribSwitch;
            break;
        case 4:
            cell.textLabel.text = @"Isha";
            cell.accessoryView = self.ishaSwitch;
            break;
        case 5:
            cell.textLabel.text = @"Notify if reminders not downloaded";
            cell.accessoryView = self.refreshSwitch;
            break;
        case 6:
            cell.textLabel.text = @"Play real adhan instead of beep";
            cell.accessoryView = self.playAdhanSwitch;
            break;
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==14)
    {
        NSString *title = @"Ishasdfgsdfgsdfgertew wer sdfgdfg     rfgsdfasdf asdfasdf asd afsdf asdfasd s";
        UIFont *font = [UIFont boldSystemFontOfSize: 28];
        
        NSDictionary *attributes = @{NSFontAttributeName: font};
        return [title sizeWithAttributes:attributes].height;
    }
    else
    {
        return 100;
    }
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
