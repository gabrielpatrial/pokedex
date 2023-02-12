//
//  PokemonDetailsViewController.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/12/23.
//

#import "PokemonDetailsViewController.h"

@interface PokemonDetailsViewController ()

@end

@implementation PokemonDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self setupUI];
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

- (void) setupUI
{
    self.view.backgroundColor = [self getColorForType:[self.pokemon getMyFirstTypeName]];
    self.pokemonNameLabel.text = [self.pokemon.name uppercaseString];
    self.pokemonHeight.text = [NSString stringWithFormat:@"Height: %@", self.pokemon.height];
    self.pokemonWeight.text = [NSString stringWithFormat:@"Weight: %@", self.pokemon.weight];
    [self setupStatsLabels];
    [self setupStatsBars];
}

- (void) setupStatsLabels
{
    self.statOneLabel.text = [NSString stringWithFormat:@"%@: %@", [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:0]).name uppercaseString], [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:0]).baseStat uppercaseString]];
    self.statTwoLabel.text = [NSString stringWithFormat:@"%@: %@", [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:1]).name uppercaseString], [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:1]).baseStat uppercaseString]];
    self.statThreeLabel.text = [NSString stringWithFormat:@"%@: %@", [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:2]).name uppercaseString], [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:2]).baseStat uppercaseString]];
    self.statFourLabel.text = [NSString stringWithFormat:@"%@: %@", [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:3]).name uppercaseString], [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:3]).baseStat uppercaseString]];
    self.statFiveLabel.text = [NSString stringWithFormat:@"%@: %@", [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:4]).name uppercaseString], [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:4]).baseStat uppercaseString]];
}

- (void) setupStatsBars
{
    self.statOneBar.progress = [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:0]).baseStat doubleValue]/100;
    self.statTwoBar.progress = [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:1]).baseStat doubleValue]/100;
    self.statThreeBar.progress = [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:2]).baseStat doubleValue]/100;
    self.statFourBar.progress = [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:3]).baseStat doubleValue]/100;
    self.statFiveBar.progress = [((PokedexPokemonStat *)[self.pokemon.stats objectAtIndex:4]).baseStat doubleValue]/100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pokemon.types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *cellTitle = [[self.pokemon getAllTypesArray] objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:[self getColorForType:cellTitle]];
    
    cell.textLabel.text = [cellTitle uppercaseString];
    
    return cell;
}

- (UIColor *) getColorForType:(NSString *)type
{
    if ([type isEqualToString:@"grass"])
    {
        return [UIColor systemGreenColor];
    } else if ([type isEqualToString:@"fire"])
    {
        return [UIColor systemRedColor];
    } else if ([type isEqualToString:@"water"])
    {
        return [UIColor systemBlueColor];
    } else if ([type isEqualToString:@"electric"])
    {
        return [UIColor yellowColor];
    } else if ([type isEqualToString:@"poison"])
    {
        return [UIColor purpleColor];
    } else
    {
        return [UIColor systemGrayColor];
    }
}

@end
