//
//  FilterListViewController.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/12/23.
//

#import "FilterListViewController.h"

@interface FilterListViewController ()

@end

@implementation FilterListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
    self.backButton.layer.cornerRadius = 10;
    self.backButton.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pokemonTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *cellTitle = [self.pokemonTypesArray objectAtIndex:indexPath.row];
    if ([self.selectedFilters containsObject:cellTitle]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO     scrollPosition:UITableViewScrollPositionNone];
        [cell setSelected:YES animated:NO];
    } else {
        [cell setSelected:NO animated:NO];
    }
    
    cell.textLabel.text = cellTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_selectedFilters containsObject:[self.pokemonTypesArray objectAtIndex:indexPath.row]])
    {
        [_selectedFilters addObject:[self.pokemonTypesArray objectAtIndex:indexPath.row]];
    } else
    {
        [_selectedFilters removeObject:[self.pokemonTypesArray objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_selectedFilters containsObject:[self.pokemonTypesArray objectAtIndex:indexPath.row]])
    {
        [_selectedFilters addObject:[self.pokemonTypesArray objectAtIndex:indexPath.row]];
    } else
    {
        [_selectedFilters removeObject:[self.pokemonTypesArray objectAtIndex:indexPath.row]];
    }
}
- (IBAction)backButtonClicked:(id)sender
{
    [self.delegate ValueSelectedDelegateCall:self.selectedFilters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
@end
