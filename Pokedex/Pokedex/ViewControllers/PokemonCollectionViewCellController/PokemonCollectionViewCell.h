//
//  PokemonCollectionViewCell.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import <UIKit/UIKit.h>
#import "PokedexPokemon.h"

NS_ASSUME_NONNULL_BEGIN

@interface PokemonCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *pokemonTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pokemonOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *pokemonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pokemonSpriteLabel;

@property (strong, nonatomic) PokedexPokemon *pokemon;

- (void) setupCellWithPokemon:(PokedexPokemon *)pokemon;
- (void) setupCellUI;

@end

NS_ASSUME_NONNULL_END
