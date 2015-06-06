//
//  MapViewController.h
//  Orlando Walking Tours
//
//  Created by Jordan Weaver on 6/6/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoricLocation.h"
#import <MapKit/MapKit.h>
#import "LocationListTableViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

//@property (nonatomic, retain) NSMutableArray *locationsArray;

@property (nonatomic, retain) NSMutableArray *locationsArray;
@property (nonatomic, retain) HistoricLocation *selectedHistoricLocation;

@property (nonatomic, retain) LocationListTableViewController *locationListController;
@property (nonatomic, retain) NSMutableArray *loadedArray;

@property BOOL currentLoc;

@property (weak, nonatomic) IBOutlet MKMapView *minMap;

@property (weak) id delegate;

@property (nonatomic, retain) NSMutableArray *annArray;





@end
