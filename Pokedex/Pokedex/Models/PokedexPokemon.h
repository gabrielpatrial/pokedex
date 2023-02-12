//
//  PokedexPokemon.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import <Foundation/Foundation.h>
#import "PokedexPokemonStat.h"

NS_ASSUME_NONNULL_BEGIN

@interface PokedexPokemon : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *desription;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *stats;
@property (nonatomic, strong) NSDictionary *sprites;

+ (instancetype) getFromJSONDictionary:(NSDictionary *)dictionary;

- (NSDictionary *) getMyFirstTypeDictionary;
- (NSString *) getMyFirstTypeName;
- (NSString *) getDefaultSprite;
- (NSArray *) getAllTypesArray;
- (void) getImageFromUrl;
@end

NS_ASSUME_NONNULL_END
