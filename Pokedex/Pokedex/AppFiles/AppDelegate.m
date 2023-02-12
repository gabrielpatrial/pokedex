//
//  AppDelegate.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[DatabaseConnector sharedConnection] close];
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *dbDirectory           = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];
    NSString *path                  = [dbDirectory stringByAppendingPathComponent:DB_NAME];
    
    id connection = [[DatabaseConnector sharedConnection] initConnection];
    
    if (connection)
    {
        NSLog(@"CREATED DB");
    } else {
        NSLog(@"FAILED TO CREATE DB");
    }

    if ([DatabaseConnector executeQuery:@"CREATE TABLE IF NOT EXISTS POKEMON (ID INTEGER PRIMARY KEY AUTOINCREMENT, POKEMON_NAME TEXT, JSON BLOB)"])
    {
        NSLog(@"CREATED TABLE");
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
