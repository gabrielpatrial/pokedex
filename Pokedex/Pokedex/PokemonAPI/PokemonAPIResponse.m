//
//  PokemonAPIResponse.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//

#import "PokemonAPIResponse.h"

//----------------------------------------------------------
//----------------------------------------------------------

@implementation PokemonAPIError

@synthesize errorID = _errorID;
@synthesize description = _description;

@end

//----------------------------------------------------------
//----------------------------------------------------------

@implementation PokemonAPIResponse

@synthesize status = _status;
@synthesize message = _message;
@synthesize keyValue = _keyValue;
@synthesize commandProcessed = _commandProcessed;
@synthesize error = _error;
@synthesize parameters = _parameters;
@synthesize responseDictionary = _responseDictionary;
@synthesize responseArray = _responseArray;
@synthesize responseObject = _responseObject;
@end

