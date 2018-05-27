//
//  LogViewController.h
//  WISE
//
//  Created by Mohamed Rashwan on 16/05/2015.
//  Copyright (c) 2015 Beamstart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UITableViewController

@property (nonatomic) NSString *logdata;

- (void) reloadData;
- (void) addLog:(NSString *) newLogdata;

@end
