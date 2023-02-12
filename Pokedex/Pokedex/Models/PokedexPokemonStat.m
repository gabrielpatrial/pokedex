//
//  PokedexPokemonStat.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import "PokedexPokemonStat.h"

@implementation PokedexPokemonStat

+ (instancetype) getFromJSONDictionary:(NSDictionary *)dictionary
{
    PokedexPokemonStat *stat = [self new];
    
    if([dictionary isEqual:[NSNull null]]){
        return stat;
    }
    
    stat.baseStat = [Utilities jsonStringValue:[dictionary objectForKey:@"base_stat"]];
    stat.effort = [Utilities jsonStringValue:[dictionary objectForKey:@"effort"]];
    stat.name = [Utilities jsonStringValue:[[dictionary objectForKey:@"stat"] objectForKey:@"name"]];
    stat.url = [Utilities jsonStringValue:[[dictionary objectForKey:@"stat"] objectForKey:@"url"]];
    
    return stat;
}
@end
