//
//  MapViewController.m
//  Orlando Walking Tours
//
//  Created by Jordan Weaver on 6/6/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize locationsArray, minMap, annArray, locationListController, loadedArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    annArray = [NSMutableArray new];

    minMap.delegate = self;
    
    for (int i=0; i<[loadedArray count]; i++) {
        MKPointAnnotation *location = [[MKPointAnnotation alloc]init];
        double latitude = (long)[locationsArray[i] latitude];
        double longitude = (long) [locationsArray[i] longitude];
        location.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        location.title = [locationsArray[i] locationTitle];
        [annArray addObject:location];
    }
    
    
    
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (fullyRendered)
    {
        CLLocationCoordinate2D mapCoordinate = CLLocationCoordinate2DMake(28.53686, -81.379564);
        
        MKCoordinateSpan mapSpan = MKCoordinateSpanMake(1, 1);
        
        MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapCoordinate, mapSpan);
        
        [mapView setRegion:mapRegion animated:YES];
        
        for (int i = 0; i<[annArray count]; i++)
        {
            [minMap addAnnotation:annArray[i]];
        }
        
    }
}


//View for Annotation is not being hit at this time.


//allocate and annomate drop pins here
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString* reuse = @"reuse";
    MKPinAnnotationView* pins = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuse];
    
    if ([annotation isEqual: minMap.userLocation]) {
        return nil;
    }
    
    if (pins == nil) {
        //loop through array
        for (int i = 0; i<[annArray count]; i++) {
            pins = [[MKPinAnnotationView alloc]initWithAnnotation:annArray[i] reuseIdentifier:reuse];
        }
    }
    
    pins.animatesDrop = YES;
    pins.canShowCallout = YES;
    
    return pins;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
