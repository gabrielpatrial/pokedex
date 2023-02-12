//
//  Constants.m
//  XT
//


#import "Constants.h"

@implementation Constants

#
# pragma mark - general consts
#
NSString * const kAppName = @"Pokedex";

#
#pragma mark - API Settings
#
NSString * const kPokedexURLLive =  @"https://pokeapi.co/api/v2/";
NSString * const kPokedexURLDebug = @"https://pokeapi.co/api/v2/";

NSString * const kPokedexResponseStatusSuccess = @"1";
NSString * const kPokedexResponseStatusFailure = @"0";
NSString * const kPokedexResponseStatusValidationError = @"-11";

NSString * const kPokedexResponseStatusKey = @"status";
NSString * const kPokedexResponseMessageKey = @"msg";
NSString * const kPokedexResponseDataKey = @"data";
NSString * const kPokedexResponseKeyValueKey = @"key_value";

#
#pragma mark - APNS
#
NSString * const kPokedexRequestAuthenticateUser = @"authenticate_user";
NSString * const kPokedexRequestGetPokemonCount = @"get_pokemon_count";
NSString * const kPokedexRequestGetAllPokemon = @"get_all_pokemon";
NSString * const kPokedexRequestPokemon = @"get_pokemon";

@end
