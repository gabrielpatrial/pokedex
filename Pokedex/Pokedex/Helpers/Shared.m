//
//  Shared.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//


#import "Shared.h"
static Shared* sharedInstance;

@implementation Shared

+ (Shared*)sharedInstance
{
    if (!sharedInstance){
        sharedInstance = [[Shared alloc] init];
    }
    
    return sharedInstance;
}


- (void) setCurrentUser:(PokedexUser *)currentUser
{
    _currentUser = currentUser;
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_currentUser requiringSecureCoding:NO error:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"XTUser"];
    [defaults synchronize];
}


@end
