//
//  PokedexPokemonStat.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PokedexPokemonStat : NSObject

@property (nonatomic, strong) NSString *baseStat;
@property (nonatomic, strong) NSString *effort;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

+ (instancetype) getFromJSONDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
