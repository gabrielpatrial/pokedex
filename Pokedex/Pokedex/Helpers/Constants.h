//
//  Constants.h
//  XT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constants : NSObject

#
#pragma mark - General Consts
#
extern NSString * const kAppName;

#
#pragma mark - API Settings
#
extern NSString * const kPokedexURLLive;
extern NSString * const kPokedexURLDebug;

extern NSString * const kPokedexResponseValidationError;

extern NSString * const kPokedexResponseStatusSuccess;
extern NSString * const kPokedexResponseStatusFailure;
extern NSString * const kPokedexResponseValidationError;

extern NSString * const kPokedexResponseStatusKey;
extern NSString * const kPokedexResponseMessageKey;
extern NSString * const kPokedexResponseDataKey;
extern NSString * const kPokedexResponseKeyValueKey;

#
#pragma mark - APNS
#
extern NSString * const kPokedexRequestAuthenticateUser;
extern NSString * const kPokedexRequestGetPokemonCount;
extern NSString * const kPokedexRequestGetAllPokemon;
extern NSString * const kPokedexRequestPokemon;
@end
