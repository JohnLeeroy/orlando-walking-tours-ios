//
//  LocationSearchTableViewController.m
//  Orlando Walking Tours
//
//  Created by Manuel_Arredondo on 6/6/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import "LocationSearchTableViewController.h"
#import "LocationTableViewCell.h"
#import "HistoricLocation.h"

@interface LocationSearchTableViewController ()

@end

@implementation LocationSearchTableViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    if(cell==nil)
    {
        cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
    }

    HistoricLocation *historicLocation = [_filteredLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = historicLocation.locationTitle;
    cell.saveButton.tag = indexPath.row;
    [cell.saveButton addTarget:self action:@selector(saveTapped:) forControlEvents:UIControlEventAllEvents];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoricLocation *historicLocation = [_filteredLocations objectAtIndex:indexPath.row];
    
    if([_delegate respondsToSelector:@selector(selectedSearchedHistoricalLocation:)])
    {
        [_delegate selectedSearchedHistoricalLocation:historicLocation];
    }
}

-(IBAction)saveTapped:(UIButton*)sender
{
    HistoricLocation *location = [_filteredLocations objectAtIndex:sender.tag];
    
    if([_delegate respondsToSelector:@selector(saveSearchedLocation:)])
    {
        [_delegate saveSearchedLocation:location];
    }
}

@end
