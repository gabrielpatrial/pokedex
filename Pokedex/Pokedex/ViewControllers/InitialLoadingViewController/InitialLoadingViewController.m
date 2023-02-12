//
//  InitialLoadingViewController.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import "InitialLoadingViewController.h"

@interface InitialLoadingViewController ()

@end

@implementation InitialLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pokemonApi = [[PokemonAPI alloc] init];
    _pokemonArray = [NSMutableArray new];
    _pokemonTypesArray = [NSMutableArray new];
    [self.pokemonApi getPokemonCount];
    [self.pokemonApi setDelegate:self];
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

- (void) PokemonAPIFinishedProcessingWithResponse:(PokemonAPIResponse *)response
{
    NSLog(@"DELEGATE PROCESS -> START \n\r");
    if (response.error)
    {
        NSLog(@"Response error -> Ackownledged!");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"There was an error getting your Pokedex." preferredStyle:UIAlertControllerStyleAlert];
        //
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            nil;
        }]];
        //
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
        //
        return;
    }
    else if ([response.commandProcessed isEqualToString:kPokedexRequestGetPokemonCount])
    {
        self.totalPokemonCount  = [response.responseObject integerValue];
        [self.pokemonApi getAllPokemonWithCount:response.responseObject];
    }
    else if ([response.commandProcessed isEqualToString:kPokedexRequestGetAllPokemon])
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            for (NSDictionary *result in response.responseArray)
            {
                [self.pokemonApi getPokemonWithUrl:[result objectForKey:@"url"]];
            }
        });
    }
    else if ([response.commandProcessed isEqualToString:kPokedexRequestPokemon])
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            PokedexPokemon *pokemon = [PokedexPokemon getFromJSONDictionary:response.responseDictionary];
            [self.pokemonArray addObject:pokemon];
            [self addThisPokemonTypesToPokemonTypesList:pokemon.types];
        });
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.currentPokemonCount++;
            double currentProgress = self.currentPokemonCount/self.totalPokemonCount;
            [self.progressView setProgress:currentProgress animated:YES];
        });
    }
    
    if (_currentPokemonCount == _totalPokemonCount - 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^ {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PokedexPokemonList *pokedexPokemonList = (PokedexPokemonList *)[storyboard instantiateViewControllerWithIdentifier:@"pokedexPokemonList"];
            [self sortPokemonArray];
            pokedexPokemonList.pokemonArray = self.pokemonArray;
            pokedexPokemonList.pokemonTypesArray = [NSArray arrayWithArray:self.pokemonTypesArray];
            pokedexPokemonList.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:pokedexPokemonList animated:YES completion:nil];
        });
    }
}

- (void) addThisPokemonTypesToPokemonTypesList:(NSArray *)types
{
    for (NSDictionary *type in types) {
        [self addTypeToPokemonTypesList:[[type objectForKey:@"type"] objectForKey:@"name"]];
    }
}

- (void) addTypeToPokemonTypesList:(NSString *)type
{
    if (![self.pokemonTypesArray containsObject:type]) {
        [self.pokemonTypesArray addObject:type];
    }
}

- (void) sortPokemonArray
{
    NSArray *sortedArray;
    sortedArray = [self.pokemonArray sortedArrayUsingComparator:^NSComparisonResult(PokedexPokemon *a, PokedexPokemon *b) {
        return [a.name compare:b.name];
    }];
    self.pokemonArray = sortedArray;
}

@end
