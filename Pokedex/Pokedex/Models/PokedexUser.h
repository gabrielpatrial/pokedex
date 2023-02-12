//
//  PokedexUser.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//

#import <Foundation/Foundation.h>

@class PokedexUserAccount;

@interface PokedexUser : NSObject

@property (nonatomic) NSInteger userID;

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *name;

+ (instancetype) getFromJSONDictionary:(NSDictionary *)dictionary;

- (BOOL) isLoggedIn;

@end
