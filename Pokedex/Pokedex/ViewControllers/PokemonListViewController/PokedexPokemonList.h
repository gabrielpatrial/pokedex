//
//  ViewController.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import <UIKit/UIKit.h>
#import "PokemonCollectionViewCell.h"
#import "FilterListViewController.h"
#import "PokemonDetailsViewController.h"

@interface PokedexPokemonList : UIViewController <PokemonAPIDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (strong, nonatomic) PokemonAPI        *pokemonApi;
@property (nonatomic)         NSInteger         selectedTag;
@property (strong, nonatomic) NSMutableArray    *pokemonArray;
@property (strong, nonatomic) NSMutableArray    *pokemonFilteredArray;
@property (strong, nonatomic) NSArray           *pokemonTypesArray;
@property (strong, nonatomic) NSArray           *selectedFilters;

@end

