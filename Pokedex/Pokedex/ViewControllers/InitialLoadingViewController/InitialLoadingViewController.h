//
//  InitialLoadingViewController.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import <UIKit/UIKit.h>
#import "PokedexPokemon.h"
#import "PokedexPokemonList.h"

NS_ASSUME_NONNULL_BEGIN

@interface InitialLoadingViewController : UIViewController <PokemonAPIDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) PokemonAPI        *pokemonApi;
@property (nonatomic)         double            totalPokemonCount;
@property (nonatomic)         double            currentPokemonCount;
@property (strong, nonatomic) NSMutableArray    *pokemonArray;
@property (strong, nonatomic) NSMutableArray    *pokemonTypesArray;

@end

NS_ASSUME_NONNULL_END
