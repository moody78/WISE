//
//  ActivitiesViewController.h
//  WISE
//
//  Created by Mohamed Rashwan on 04/05/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *activities;

- (void) refreshData: (id)paramSender;
- (void) performRefreshData:(BOOL *)paramFetchedNewData;
@end
