//
//  PokemonAPI.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@class PokemonAPIResponse;

@protocol PokemonAPIDelegate <NSObject>

@required

- (void) PokemonAPIFinishedProcessingWithResponse:(PokemonAPIResponse *)response;

@end

@interface PokemonAPI : NSObject
{
    id <PokemonAPIDelegate> delegate;
}

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *appServerReachability;

@property(retain) id delegate;

- (void) authenticateUser;
- (void) getPokemonCount;
- (void) getAllPokemonWithCount:(NSString *)count;
- (void) getPokemonWithUrl:(NSString *)url;
@end
