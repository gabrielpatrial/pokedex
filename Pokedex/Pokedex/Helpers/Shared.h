//
//  Shared.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//


#import <Foundation/Foundation.h>
#import "PokedexUser.h"

@interface Shared : NSObject

@property (nonatomic, retain) PokedexUser *currentUser;
@property (nonatomic, retain) NSDate *lastDateUserOpenedApp;

+ (Shared*)sharedInstance;

@end
