#import <Foundation/Foundation.h>

@interface PokemonAPIError : NSObject

@property (nonatomic, retain) NSString *errorID;
@property (nonatomic, retain) NSString *description;

@end

//----------------------------------------------------------
//----------------------------------------------------------

@interface PokemonAPI : NSObject

@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *keyValue;
@property (nonatomic, retain) NSString *commandProcessed;
@property (nonatomic, retain) XTError *error;
@property (nonatomic, retain) NSDictionary *parameters;
@property (nonatomic, retain) NSDictionary *responseDictionary;
@property (nonatomic, retain) NSArray *responseArray;
@property (nonatomic) id responseObject;
@property (nonatomic) NSInteger responseInteger;

@end
