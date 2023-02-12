#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DB_NAME @"pokedex.db"

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseConnector : NSObject

{
    @private sqlite3 *g_database;
}

@property (nonatomic,assign,readwrite) sqlite3 *database;

+ (DatabaseConnector *) sharedConnection;
+ (BOOL) executeQuery:(NSString *)query;
+ (NSMutableArray *) fetchResults:(NSString *)query;
+ (int) rowCountForTable:(NSString *)table where:(NSString *)where;
+ (void) errorMessage:(NSString *)msg;
+ (void) closeConnection;

- (id)initConnection;
- (void)close;

@end

NS_ASSUME_NONNULL_END
