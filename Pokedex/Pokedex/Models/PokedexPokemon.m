//
//  PokedexPokemon.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import "PokedexPokemon.h"

@implementation PokedexPokemon

+ (instancetype) getFromJSONDictionary:(NSDictionary *)dictionary
{
    PokedexPokemon *pokemon = [self new];
    
    if([dictionary isEqual:[NSNull null]]){
        return pokemon;
    }
    
    pokemon.order = [Utilities jsonStringValue:[dictionary objectForKey:@"order"]];
    pokemon.height = [Utilities jsonStringValue:[dictionary objectForKey:@"height"]];
    pokemon.name = [Utilities jsonStringValue:[dictionary objectForKey:@"name"]];
    pokemon.weight = [Utilities jsonStringValue:[dictionary objectForKey:@"weight"]];
    pokemon.sprites = [dictionary objectForKey:@"sprites"];
    pokemon.imageUrl = [[[[dictionary objectForKey:@"sprites"] objectForKey:@"other"] objectForKey:@"official-artwork"] objectForKey:@"front_default"];
    pokemon.types = [dictionary objectForKey:@"types"];
    NSArray *stats = [dictionary objectForKey:@"stats"];
    NSMutableArray *tempStats = [NSMutableArray new];
    for (NSDictionary *stat in stats) {
        [tempStats addObject:[PokedexPokemonStat getFromJSONDictionary:stat]];
    }
    
    pokemon.stats = [NSArray arrayWithArray:tempStats];
    
    return pokemon;
}

- (NSDictionary *) getMyFirstTypeDictionary
{
    if (self.types.count > 0) {
        return [self.types objectAtIndex:0];
    } else {
        return [NSDictionary new];
    }
}

- (NSArray *) getAllTypesArray
{
    NSMutableArray *typesArray = [NSMutableArray new];

    for (NSDictionary *types in self.types) {
        if (![typesArray containsObject:[[types objectForKey:@"type"] objectForKey:@"name"]]) {
            [typesArray addObject:[[types objectForKey:@"type"] objectForKey:@"name"]];
        }
    }
    return typesArray;
}

- (NSString *) getMyFirstTypeName
{
    NSDictionary *typeDictionay = [self getMyFirstTypeDictionary];
    NSString *type = [[typeDictionay objectForKey:@"type"] objectForKey:@"name"];
    if (type) {
        return type;
    } else {
        return @"";
    }
}

- (NSString *) getDefaultSprite
{
    if ([self.sprites objectForKey:@"front_default"])
    {
        return @"DEFAULT";
    }
    else if ([self.sprites objectForKey:@"front_shiny"])
    {
        return @"SHINY";
    }
    else if ([self.sprites objectForKey:@"front_female"])
    {
        return @"FEMALE";
    }
    else
    {
        return @"-";
    }
}
@end
