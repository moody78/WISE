//
//  ActivitiesViewController.m
//  WISE
//
//  Created by Mohamed Rashwan on 04/05/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "PrayerTimesGate.h"

static NSString *CellIdentifier = @"Cell";

@interface CustomCell:UITableViewCell
@end
@implementation CustomCell
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle // or whatever style you want
                reuseIdentifier:reuseIdentifier];
    return self;
}
@end

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

@synthesize activities;

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
    if (section == 100){
        return [self newLabelWithTitle:@"  Activities"];
    }
    return nil; }

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    [self initializeScreen];
    
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[CustomCell class]
               forCellReuseIdentifier:CellIdentifier];
    }
    return self; }

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    [self initializeScreen];
    
    if (self != nil) { }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self initializeScreen];
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self initializeScreen];
}

- (void) initializeScreen
{
    self.title=@"Today's Activities";
    self.tabBarItem.image = [UIImage imageNamed:@"overtime-25.png"];
    
    UIColor* customBlue = [[UIColor alloc] initWithRed:26.0f/255.0f green:17.0f/255.0f blue:50.0f/255.0f alpha:1];
    
    int removeIndex = -1;

    do
    {
        NSArray *sublayers = self.tableView.layer.sublayers;
        int i=0;
        removeIndex = -1;
        
        for (CALayer *layer in sublayers)
        {
            if([layer isKindOfClass:[CAGradientLayer class]])
            {
                removeIndex = i;
            }
            
            i = i + 1;
        }
        
        if(removeIndex>-1)
        {
            NSLog(@"Remove gradient layer @%u",removeIndex);
            [self.tableView.layer.sublayers[removeIndex] removeFromSuperlayer];
        }

    }while(removeIndex > -1);

    NSLog(@"Number of layers = %u", (uint)self.tableView.layer.sublayers.count);

    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //[gradient setStartPoint:CGPointMake(0.0, 0.5)];
    //[gradient setEndPoint:CGPointMake(1.0, 0.5)];
    gradient.name = @"gradient";
    
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[customBlue CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
    [self.tableView.layer insertSublayer:gradient atIndex:0];
    
    self.activities = [[[PrayerTimesGate alloc] init] getTodaysActivity:nil];

}

- (void) refreshData:(id)paramSender
{
    [self performRefreshData:nil];
}

- (void) performRefreshData:(BOOL *)paramFetchedNewData
{
    self.activities = [[[PrayerTimesGate alloc] init] getTodaysActivity:paramFetchedNewData];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData:)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        self.tableView.scrollEnabled = NO;
    }
    else {
        self.tableView.scrollEnabled = YES;
    }

    self.tableView.scrollEnabled = YES;
    
    // Do any additional setup after loading the view.
    /*
    
    float height = 23.0f;
    
    
    //float left = ([[UIScreen mainScreen]bounds].size.width - (width * 3) - (horizontalSpacing * 2) + 25) / 2;
    float verticalSpacing = 10;
    float top0 = (([[UIScreen mainScreen]bounds].size.height - (height * 3) - (verticalSpacing * 5) - 100) / 2);
    
    for (int i = 0; i < activities.count; i++)
    {
        
        
        
        UILabel * entry = [[UILabel alloc] initWithFrame:CGRectMake(0, top0, [[UIScreen mainScreen] bounds].size.width, height)];
        entry.textAlignment = NSTextAlignmentCenter;
        
        if(i%2==0)
        {
            entry.font = [UIFont boldSystemFontOfSize:18.0f];
        }
        else
        {
            // Draw line at bottom
            top0 = top0 + verticalSpacing + height;
            
            UIView *lineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, entry.frame.origin.y + top0, entry.frame.size.width, 1)];
            lineViewBottom.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:lineViewBottom];
        }

        
        
        
        entry.text = [activities objectAtIndex:i];
        entry.textColor = [UIColor whiteColor];
        
        [self.view addSubview:entry];
        
        top0 = top0 + verticalSpacing + height;
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return activities.count / 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    // Configure the section
    switch (indexPath.section) {
        case 0:
            
            break;
            
        default:
            break;
    }
    
    
    // Configure the cell...
    
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@\r\n%@", [activities objectAtIndex:indexPath.row], [activities objectAtIndex:indexPath.row + 1]];
    
    
    long index = indexPath.row * 4;
    
    cell.textLabel.text = [activities objectAtIndex:index];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ @ %@",[activities objectAtIndex:index + 1],[activities objectAtIndex:index + 2],[activities objectAtIndex:index + 3]];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     long index = indexPath.row * 4;
     
     NSString *cellString = [NSString stringWithFormat:@"%@\r\n%@ - %@ @ %@", [activities objectAtIndex:index], [activities objectAtIndex:index + 1],[activities objectAtIndex:index + 2],[activities objectAtIndex:index + 3]];
     
     CGSize size = [cellString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];

     //CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
     
     if(size.height<100)
         return 100;
     else
         return size.height + 20;
    
 }


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
