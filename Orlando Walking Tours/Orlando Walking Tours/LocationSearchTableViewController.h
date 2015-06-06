//
//  LocationSearchTableViewController.h
//  Orlando Walking Tours
//
//  Created by Manuel_Arredondo on 6/6/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoricLocation.h"

@protocol SearchResultsDelegate <NSObject>

-(void)selectedSearchedHistoricalLocation:(HistoricLocation*)location;
-(void)saveSearchedLocation:(HistoricLocation*)location;

@end

@interface LocationSearchTableViewController : UITableViewController

@property (nonatomic,strong) NSArray*filteredLocations;
@property (nonatomic,weak)   id<SearchResultsDelegate> delegate;

@end
