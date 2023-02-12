//
//  PokemonDetailsViewController.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/12/23.
//

#import <UIKit/UIKit.h>
#import "PokedexPokemon.h"

NS_ASSUME_NONNULL_BEGIN

@interface PokemonDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *pokemonImageView;
@property (weak, nonatomic) IBOutlet UILabel *pokemonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pokemonHeight;
@property (weak, nonatomic) IBOutlet UILabel *pokemonWeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PokedexPokemon *pokemon;

//Stat_1
@property (weak, nonatomic) IBOutlet UILabel *statOneLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *statOneBar;

//Stat_2
@property (weak, nonatomic) IBOutlet UILabel *statTwoLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *statTwoBar;

//Stat_3
@property (weak, nonatomic) IBOutlet UILabel *statThreeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *statThreeBar;

//Stat_4
@property (weak, nonatomic) IBOutlet UILabel *statFourLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *statFourBar;

//Stat_5
@property (weak, nonatomic) IBOutlet UILabel *statFiveLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *statFiveBar;

@end

NS_ASSUME_NONNULL_END
