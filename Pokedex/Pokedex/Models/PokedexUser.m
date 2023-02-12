//
//  PokedexUser.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//
#import "PokedexUser.h"

@implementation PokedexUser

- (id)init
{
    self = [super init];
    
    if (self) {
        _userID = -1;
        _userEmail = @"";
        _name = @"";
        _password = @"";
    }
    
    return self;
}

+ (instancetype) getFromJSONDictionary:(NSDictionary *)dictionary
{
    PokedexUser *user = [self new];
    
    if([dictionary isEqual:[NSNull null]]){
        return user;
    }
    
    user.userID = [Utilities jsonIntegerValue:[dictionary objectForKey:@"id"]];
    user.userEmail = [Utilities jsonStringValue:[dictionary objectForKey:@"email"]];
    user.name = [Utilities jsonStringValue:[dictionary objectForKey:@"name"]];

    user.password = @"";
    
    return user;
}

- (BOOL) isLoggedIn
{
    if (_userID > 0){
        return YES;
    } else {
        return NO;
    }
}

#
#pragma mark - 
#
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInteger:_userID forKey:@"userID"];
    [coder encodeObject:_userEmail forKey:@"userEmail"];
    [coder encodeObject:_password forKey:@"password"];

}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    
    if (self != nil){
        _userID = [coder decodeIntegerForKey:@"userID"];
        _userEmail = [coder decodeObjectForKey:@"userEmail"];
        _password = [coder decodeObjectForKey:@"password"];
    }
    
    return self;
}

@end
