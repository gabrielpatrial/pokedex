//
//  PokemonAPI.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//

#import "PokemonAPI.h"
#import "PokemonAPIResponse.h"
#import "PokedexUser.h"

@implementation PokemonAPI

@synthesize delegate;

- (id)init
{
    self = [super init];
    
    self.internetReachability = [Reachability reachabilityWithHostName:kPokedexURLLive];
    
    return self;
}


#
#pragma mark - User Service Calls
#
-(void) authenticateUser
{
    NSString *email = [Shared sharedInstance].currentUser.userEmail;
    NSString *password = [Shared sharedInstance].currentUser.password;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kPokedexRequestAuthenticateUser, nil]
                                                                         forKeys:[NSArray arrayWithObjects:@"cmd", nil]];
    
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:password forKey:@"password"];
    
    NSString *route = @"login";
    
    [self executeXTCommandWithParameters:parameters atRoute:route forHTTPMethod:@"POST"];
}

#
#pragma mark - Pokemon Service Calls
#
-(void) getPokemonCount
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kPokedexRequestGetPokemonCount, nil]
                                                                         forKeys:[NSArray arrayWithObjects:@"cmd", nil]];
    NSString *route = @"pokemon";
    
    [self executeXTCommandWithParameters:parameters atRoute:route forHTTPMethod:@"GET"];
}

-(void) getAllPokemonWithCount:(NSString *)count
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kPokedexRequestGetAllPokemon, nil]
                                                                         forKeys:[NSArray arrayWithObjects:@"cmd", nil]];
    NSString *route = [NSString stringWithFormat:@"pokemon?limit=%@", count];
    
    [self executeXTCommandWithParameters:parameters atRoute:route forHTTPMethod:@"GET"];
}

- (void) getPokemonWithUrl:(NSString *)url
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kPokedexRequestPokemon, nil]
                                                                         forKeys:[NSArray arrayWithObjects:@"cmd", nil]];
    NSString *route = [NSString stringWithFormat:@"pokemon/%@", [url lastPathComponent]];
    
    [self executeXTCommandWithParameters:parameters atRoute:route forHTTPMethod:@"GET"];
}

#
#pragma mark - Execute XT API Service Call
#
- (NSString *) getAppServerURLString
{
    
#ifdef DEBUG
    return kPokedexURLDebug;
#endif
    
    NSString *serverURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"server_url"];
    
    if (serverURL.length == 0){
        serverURL = kPokedexURLLive;
        [[NSUserDefaults standardUserDefaults] setObject:serverURL forKey:@"server_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![serverURL hasSuffix:@"/"]){
        serverURL = [NSString stringWithFormat:@"%@/", serverURL];
        [[NSUserDefaults standardUserDefaults] setObject:serverURL forKey:@"server_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return serverURL;
}

- (BOOL) validInternetConnectionWithParameters:(NSDictionary *)parameters
{
    NetworkStatus internetSatus = [self.internetReachability currentReachabilityStatus];
    if (internetSatus == NotReachable){
        PokemonAPIResponse *r = [PokemonAPIResponse new];
        PokemonAPIError *e = [PokemonAPIError new];
        //
        NSString *keyValue = [parameters objectForKey:@"key_value"];
        NSString *cmd = [parameters objectForKey:@"cmd"];
        //
        r.keyValue = keyValue;
        r.commandProcessed = cmd;
        //
        e.errorID = @"100";
        e.description = @"No internet connection detected";
        r.error = e;
        //
        dispatch_async (dispatch_get_main_queue (),  ^{
            [self.delegate PokemonAPIFinishedProcessingWithResponse:r];
        });
        //
        return NO;
    } else {
        return YES;
    }
}

- (void) executeXTCommandWithParameters:(NSDictionary *)parameters atRoute:(NSString *)route forHTTPMethod:(NSString *)httpMethod
{
    //
    //make sure the interwebs are working
    //
    if (![self validInternetConnectionWithParameters:parameters]){
        return;
    }
    
    NSMutableString *urlString = [[NSMutableString alloc] init];
    NSData *imageData;
    NSData *videoData;
    NSData *pdfData;
    NSData *fileData;
    
    NSString *url = [self getAppServerURLString];
    
    [urlString appendString:url];
    [urlString appendString:route];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 120;
    [request setURL:[NSURL URLWithString:urlString]];
    
    if ([httpMethod isEqualToString:@"PUT"] || [httpMethod isEqualToString:@"DELETE"]){
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:httpMethod];
    }
    
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";//@"----0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"c6653d27-ce49-48fc-8c28-b2d7685f4e83" forHTTPHeaderField:@"x-client-app-key"];

    NSMutableData *body = [NSMutableData data];
    
    //XTLog(@"Executing %@ at Route %@ with URL %@", [parameters objectForKey:@"cmd"], route, urlString);
    
    if (![httpMethod isEqualToString:@"GET"]){
        //
        for(int i = 0; i < [[parameters allKeys] count]; i++) {
            NSString * key = [[parameters allKeys] objectAtIndex:i];
            if ([key isEqualToString:@"image"]){
                UIImage *image = (UIImage *) [parameters objectForKey:@"image"];
                image = nil;
            } else if ([key isEqualToString:@"video"]){
                videoData = [parameters objectForKey:@"video"];
            } else if ([key isEqualToString:@"pdf"]){
                pdfData = [parameters objectForKey:@"pdf"];
            } else if ([key isEqualToString:@"file"]){
                fileData = [parameters objectForKey:@"file"];
            } else if (![key isEqualToString:@"cmd"] && ![key isEqualToString:@"object"]){
                NSString *body1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
                NSString *body2 = [parameters objectForKey:key];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[body1 dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[body2 dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        //
        if ([httpMethod isEqualToString:@"PUT"]){
            NSString *body1 = @"Content-Disposition: form-data; name=\"_method\"\r\n\r\n";
            NSString *body2 = @"PUT";
            //
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[body1 dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[body2 dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //
        if ([httpMethod isEqualToString:@"DELETE"]){
            NSString *body1 = @"Content-Disposition: form-data; name=\"_method\"\r\n\r\n";
            NSString *body2 = @"DELETE";
            //
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[body1 dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[body2 dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //
        if (imageData){
            NSString *imageName = @"item_note.jpg";
            //
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
        }
        //
        if (videoData){
            NSString *videoName = [parameters objectForKey:@"key_value"];
            if (videoName.length == 0){
                videoName = @"iphone.mov";
            }
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video\"; filename=\"%@\"\r\n", videoName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: video/mov\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:videoData];
        }
        //
        if (pdfData){
            NSString *fileName = [parameters objectForKey:@"key_value"];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pdf\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:pdfData];
        }
        //
        if (fileData){
            NSString *fileName = [parameters objectForKey:@"key_value"];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:fileData];
        }
        //
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        [request setHTTPBody:body];
    
    }
    
    __block NSDictionary *blockParameters = [[NSDictionary alloc] initWithDictionary:parameters];
        
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [self processXTResponse:response withData:data andError:error forParameters:blockParameters];
        blockParameters = nil;
        }
     ]
     resume
    ] ;
        
}

- (BOOL) validStatusCodeForResponse:(NSURLResponse *)response withData:(NSData *)data andError:(NSError *)error forParameters:(NSDictionary *)parameters
{
    //200 - success
    
    //400 - bad request
    //401 - unauthorized
    //403 - forbidden
    //404 - not found
    
    //500 - internal server error
    //503 - service unavailable
    //504 - gateway timeout
    
    //-999 - cancelled
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    long statusCode = (long) httpResponse.statusCode;
    
    if (statusCode == 200){
        return YES;
    }
    
    NSError *serializeError = nil;
    NSDictionary *dictionary = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingMutableContainers
                                error:&serializeError];
    
    NSString *keyValue = [parameters objectForKey:@"key_value"];
    NSString *cmd = [parameters objectForKey:@"cmd"];
    
    NSString *desc;
    
    id obj = [dictionary objectForKey:@"msg"];
    if ([obj isKindOfClass:[NSString class]]){
        desc = (NSString *) obj;
    } else if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *d = (NSDictionary *) obj;
        desc = [NSString stringWithFormat:@"%@", d];
    } else {
        if (error){
            desc = error.description;
        }
    }
    
    PokemonAPIResponse *r = [PokemonAPIResponse new];
    r.keyValue = keyValue;
    r.commandProcessed = cmd;
    
    PokemonAPIError *e = [PokemonAPIError new];
    e.errorID = [NSString stringWithFormat:@"%ld", statusCode];
    e.description = desc;
    
    r.error = e;
    
    dispatch_async (dispatch_get_main_queue (),  ^{
        [self.delegate PokemonAPIFinishedProcessingWithResponse:r];
    });
    
    return NO;
}

- (void) processXTResponse:(NSURLResponse *)response withData:(NSData *)data andError:(NSError *)error forParameters:(NSDictionary *)parameters
{
    NSString *keyValue = [parameters objectForKey:@"key_value"];
    NSString *cmd = [parameters objectForKey:@"cmd"];
    
    if (error && error.code == -999){
        return;
    }
    
    if (![self validStatusCodeForResponse:response withData:data andError:error forParameters:parameters]){
        return;
    }
    
    [self writeNSDataToOutput:data];
    
    PokemonAPIResponse *r = [[PokemonAPIResponse alloc] init];
    PokemonAPIError *e = nil;
    
    if (data.length > 0 && error == nil){
        if ([cmd isEqualToString:kPokedexRequestGetPokemonCount]){
            r = [self processGetPokemonCuntResponseWithData:data forParameters:parameters];
        } else if ([cmd isEqualToString:kPokedexRequestGetAllPokemon]) {
            r = [self processGetAllPokemonResponseWithData:data forParameters:parameters];
        } else if ([cmd isEqualToString:kPokedexRequestPokemon]) {
            r = [self processGetPokemonResponseWithData:data forParameters:parameters];
        }
    } else {
        e = [[PokemonAPIError alloc] init];
        e.errorID = [NSString stringWithFormat:@"%li", (long)error.code];
        e.description = @"Oh no!!  Something happened!";
        r.error = e;
    }
    
    r.keyValue = keyValue;
    
    if ([e.errorID isEqualToString:@"-999"]){
        return;
    } else {
        dispatch_async (dispatch_get_main_queue (),  ^{
            [self.delegate PokemonAPIFinishedProcessingWithResponse:r];
        });
    }
}

#
#pragma mark - Responses
#
- (PokemonAPIResponse *) processGetPokemonCuntResponseWithData:(NSData *)data forParameters:(NSDictionary *)parameters
{
    PokemonAPIResponse *r = [PokemonAPIResponse new];
    
    NSError *serializeError = nil;
    NSDictionary *dictionary = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingMutableContainers
                                error:&serializeError];
    
    r.commandProcessed = [parameters objectForKey:@"cmd"];
    r.responseObject = [dictionary objectForKey:@"count"];
    
    return r;
}

- (PokemonAPIResponse *) processGetAllPokemonResponseWithData:(NSData *)data forParameters:(NSDictionary *)parameters
{
    PokemonAPIResponse *r = [PokemonAPIResponse new];
    
    NSError *serializeError = nil;
    NSDictionary *dictionary = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingMutableContainers
                                error:&serializeError];
    
    r.commandProcessed = [parameters objectForKey:@"cmd"];
    r.status = [Utilities jsonStringValue:[dictionary objectForKey:kPokedexResponseStatusKey]];
    r.message = [Utilities jsonStringValue:[dictionary objectForKey:kPokedexResponseMessageKey]];
    r.responseArray = [dictionary objectForKey:@"results"];
    
    return r;
}

- (PokemonAPIResponse *) processGetPokemonResponseWithData:(NSData *)data forParameters:(NSDictionary *)parameters
{
    PokemonAPIResponse *r = [PokemonAPIResponse new];
    
    NSError *serializeError = nil;
    NSDictionary *dictionary = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:NSJSONReadingMutableContainers
                                error:&serializeError];
    
    r.commandProcessed = [parameters objectForKey:@"cmd"];
    r.status = [Utilities jsonStringValue:[dictionary objectForKey:kPokedexResponseStatusKey]];
    r.message = [Utilities jsonStringValue:[dictionary objectForKey:kPokedexResponseMessageKey]];
    r.responseDictionary = dictionary;
    NSString *queuery = [NSString stringWithFormat:@"INSERT INTO POKEMON (POKEMON_NAME, JSON) VALUES (\"%@\", \"%@\")", [Utilities jsonStringValue:[dictionary objectForKey:@"name"]], [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    [DatabaseConnector executeQuery:queuery];
    
    return r;
}

#
#pragma mark - Debug Info
#

- (void) writeNSDataToOutput:(NSData *)data
{    
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON >> %@", s);
}



@end
