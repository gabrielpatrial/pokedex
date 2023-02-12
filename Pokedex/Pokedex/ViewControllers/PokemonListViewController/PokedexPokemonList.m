//
//  ViewController.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import "PokedexPokemonList.h"

@interface PokedexPokemonList ()

@end

@implementation PokedexPokemonList

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedTag = -1;
    _selectedFilters = [NSArray new];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PokemonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PokemonCollectionViewCell_ID"];
    self.pokemonFilteredArray = [self.pokemonArray copy];
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

- (void) setPokemonFilteredArray:(NSMutableArray *)pokemonFilteredArray
{
    _pokemonFilteredArray = pokemonFilteredArray;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_pokemonFilteredArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PokemonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PokemonCollectionViewCell_ID" forIndexPath:indexPath];
    PokedexPokemon *pokemon = [self.pokemonFilteredArray objectAtIndex:indexPath.row];
    [cell setupCellWithPokemon:pokemon];
    [cell setupCellUI];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - [self getCollectionViewSpacing];
    return CGSizeMake(width/2, width/2);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PokemonDetailsViewController *pokedexPokemonDetails = (PokemonDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"pokedexPokemonDetails"];
    pokedexPokemonDetails.pokemon = [self.pokemonFilteredArray objectAtIndex:indexPath.row];
    pokedexPokemonDetails.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pokedexPokemonDetails animated:YES completion:nil];
}

- (CGFloat) getCollectionViewSpacing
{
    return [self getCollectionViewCellWidth];
}

- (CGFloat) getCollectionViewCellWidth
{
    CGFloat spacing = self.collectionViewFlowLayout.minimumInteritemSpacing + self.collectionViewFlowLayout.sectionInset.left + self.collectionViewFlowLayout.sectionInset.right + 2;
    return spacing;
}

- (PokedexPokemon *)pokemonWithOrder:(NSNumber *)order
{
    for(PokedexPokemon *pokemon in self.pokemonFilteredArray)
    {
        if ([pokemon.order isEqualToString:[order stringValue]]) {
            return pokemon;
        }
    }
    return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFilterListSegue"]) {
        FilterListViewController *vc = segue.destinationViewController;
        vc.pokemonTypesArray = [self.pokemonTypesArray copy];
        vc.selectedFilters = [NSMutableArray arrayWithArray:self.selectedFilters];
        vc.delegate = self;
    }
}

- (void) ValueSelectedDelegateCall:(NSArray *)filters
{
    
    self.selectedFilters = filters;
    
    if (filters.count == 0) {
        self.pokemonFilteredArray = self.pokemonArray;
        return;
    }
    NSMutableArray *newFilteredArray = [NSMutableArray new];
    for (NSString *type in filters) {
        for (PokedexPokemon *pokemon in _pokemonArray) {
            NSArray *types = [pokemon getAllTypesArray];
            if ([types containsObject:type]) {
                [newFilteredArray addObject:pokemon];
            }
        }
    }
    
    self.pokemonFilteredArray = newFilteredArray;
}

- (void) PokemonAPIFinishedProcessingWithResponse:(PokemonAPIResponse *)response
{
    
}

@end
