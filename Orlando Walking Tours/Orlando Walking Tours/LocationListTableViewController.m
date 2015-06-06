//
//  LocationListTableViewController.m
//  Orlando Walking Tours
//
//  Created by Andrew Kozlik on 1/31/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import "LocationListTableViewController.h"
#import "LocationDetailViewController.h"
#import "HistoricLocation.h"
#import "LocationTableViewCell.h"
#import "LocationSearchTableViewController.h"

@interface LocationListTableViewController ()<UISearchResultsUpdating,UISearchBarDelegate,SearchResultsDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation LocationListTableViewController
{
    UISearchController*searchController;
    LocationSearchTableViewController*searchResultsViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchResultsViewController = [LocationSearchTableViewController new];
    searchResultsViewController.filteredLocations = [NSMutableArray new];
    searchResultsViewController.delegate = self;
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsViewController];
    searchController.searchResultsUpdater = self;
    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.dimsBackgroundDuringPresentation = YES;
    searchController.searchBar.delegate = self;
    [searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = searchController.searchBar;
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    
    self.locationsArray = [NSMutableArray new];
    NSString *locationsUrlString = @"https://brigades.opendatanetwork.com/resource/hzkr-id6u.json";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:locationsUrlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        for (NSDictionary *loc in json)
        {
            HistoricLocation *location = [HistoricLocation MR_createEntity];
            location.address = [loc objectForKey:@"address"];
            location.locationDescription = [loc objectForKey:@"downtown_walking_tour"];
            location.locationTitle  = [loc objectForKey:@"name"];
            location.locationType = [loc objectForKey:@"type"];
            
            double lat = [[[loc objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
            double lng = [[[loc objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
            
//            CLLocation *locationObj = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
//            location.location = locationObj;

            location.latitude = [NSNumber numberWithDouble:lat];
            location.longitude = [NSNumber numberWithDouble:lng];
            
            [self.locationsArray addObject:location];
        }

        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }] resume];
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString*currentText = searchController.searchBar.text;

    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"(locationTitle CONTAINS [cd] %@)",
                                    currentText];
    
    NSArray*location = self.locationsArray;

    NSArray*result = [self.locationsArray filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"filtered table to [%ld]",result.count);
    
    //    searchResultsViewController.filteredLocations = [self.locationsArray filteredArrayUsingPredicate:resultPredicate];
    searchResultsViewController.filteredLocations = result;
    [searchResultsViewController.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    HistoricLocation *historicLocation = [_locationsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = historicLocation.locationTitle;
    cell.saveButton.tag = indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoricLocation *historicLocation = [self.locationsArray objectAtIndex:indexPath.row];
    self.selectedHistoricLocation = historicLocation;
    [self performSegueWithIdentifier:@"LocationDetailSegue" sender:self];
}

-(void)selectedSearchedHistoricalLocation:(HistoricLocation *)location
{
    self.selectedHistoricLocation = location;
    [self performSegueWithIdentifier:@"LocationDetailSegue" sender:self];
    
    [searchResultsViewController dismissViewControllerAnimated:YES completion:^(){}];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LocationDetailSegue"])
    {
        // Get reference to the destination view controller
        LocationDetailViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.historicLocation = self.selectedHistoricLocation;
        vc.delegate = self;
    }
}

#pragma mark - Custom Delegate Methods
-(void)locationDetailViewController:(LocationDetailViewController *)controller didSelectHistoricLocation:(HistoricLocation *)location
{
    if ([self.delegate respondsToSelector:@selector(locationListTableViewController:didSelectHistoricLocation:)])
    {
        [self.delegate locationListTableViewController:self didSelectHistoricLocation:location];
    }
}

#pragma mark - Button Actions

-(void)saveSearchedLocation:(HistoricLocation*)location
{
    if ([self.delegate respondsToSelector:@selector(locationListTableViewController:didSelectHistoricLocation:)])
    {
        [self.delegate locationListTableViewController:self didSelectHistoricLocation:location];
    }    
}

-(void)tappedSave:(UIButton *)sender
{
    HistoricLocation *location = [self.locationsArray objectAtIndex:sender.tag];

    if ([self.delegate respondsToSelector:@selector(locationListTableViewController:didSelectHistoricLocation:)])
    {    
        [self.delegate locationListTableViewController:self didSelectHistoricLocation:location];
    }
}

@end
