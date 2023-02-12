#import <UIKit/UIKit.h>
#include <sys/xattr.h>

#import "DatabaseConnector.h"

@interface DatabaseConnector (Private)
- (void) createEditableCopyOfDatabaseIfNeeded;
- (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
- (void) initializeDatabase;
@end

@implementation DatabaseConnector

static DatabaseConnector *conn = NULL;

@synthesize database = g_database;

+ (DatabaseConnector *) sharedConnection
{
    if (!conn)
    {
        conn = [[DatabaseConnector alloc] initConnection];
    }
    return conn;
}

#pragma mark - Static Methods

+(BOOL) executeQuery:(NSString *)query
{
    
    sqlite3         *database;
    sqlite3_stmt    *statement;
    const char      *sql;
    BOOL            isExecuted = NO;

    database        = [DatabaseConnector sharedConnection].database;
    statement       = nil;
    sql             = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement , NULL) != SQLITE_OK)
    {
        return isExecuted;
    }

    if(SQLITE_DONE == sqlite3_step(statement))
    {
        isExecuted  = YES;
    }

    sqlite3_finalize(statement);
    statement       = nil;

    printf("%s\n", sqlite3_errmsg(database));
    return isExecuted;
}
+(NSMutableArray *) fetchResults:(NSString *)query
{
    NSString            *errorMsg;
    NSMutableArray      *results;
    NSMutableString     *hex;
    NSError             *error;
    NSData              *data;
    NSMutableDictionary *rowDict;
    NSData              *content;
    sqlite3             *database;
    sqlite3_stmt        *statement;
    const char          *sql;
    id                  value;
    id                  json;
    const unsigned char *bytes;
    
    results             = [NSMutableArray arrayWithCapacity:0];
    database            = [DatabaseConnector sharedConnection].database;
    statement           = nil;
    sql                 = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement , NULL) != SQLITE_OK)
    {
        errorMsg        = [NSString stringWithFormat:@"Failed to prepare query statement - '%s'.", sqlite3_errmsg(database)];
        [DatabaseConnector errorMessage:errorMsg];
        return results;
    }

    while (sqlite3_step(statement) == SQLITE_ROW)
    {

        value           = nil;
        rowDict         = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0 ; i < sqlite3_column_count(statement) ; i++)
        {
            if (sqlite3_column_type(statement,i) == SQLITE_INTEGER)
            {
                value   = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
            }
            else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT)
            {
                value   = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
            }
            else if (sqlite3_column_type(statement, i) == SQLITE_BLOB)
            {
                content = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)];
                bytes   = (const unsigned char *)content.bytes;
                hex     = [NSMutableString new];
                for (NSInteger i = 0; i < content.length; i++)
                {
                    [hex appendFormat:@"%02x", bytes[i]];
                }
                value   =  [NSString stringWithString:hex];
            }
            else
            {
                if (sqlite3_column_text(statement,i) != nil)
                {
                    value       = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                    error       = nil;
                    data        = [value dataUsingEncoding:NSUTF8StringEncoding];
                    json        = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    
                    if (!error)
                    {
                        value   = json;
                    }
                    
                }
                else
                {
                    value       = @"";
                }
            }
            if (value)
            {
                [rowDict setObject:value forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
            }
        }

        [results addObject:rowDict];
    }

    sqlite3_finalize(statement);
    statement = nil;

    return results;
}
+(int) rowCountForTable:(NSString *)table where:(NSString *)where{
    sqlite3_stmt    *statement;
    sqlite3         *database;
    const char      *sql;

    int             tableCount  = 0;
    NSString        *query      = @"";

    if (where != nil && ![where isEqualToString:@""])
    {
        query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@", table,where];
    }
    else
    {
        [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", table];
    }

    statement   = nil;
    database    = [DatabaseConnector sharedConnection].database;
    sql         = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement , NULL) != SQLITE_OK)
    {
        return 0;
    }

    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        tableCount = sqlite3_column_int(statement,0);
    }

    sqlite3_finalize(statement);
    return tableCount;
}
+(void) errorMessage:(NSString *)msg
{

}
+(void) closeConnection
{
    sqlite3 *database = [DatabaseConnector sharedConnection].database;
    if (sqlite3_close(database) != SQLITE_OK)
    {

        NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(database)];
        [DatabaseConnector errorMessage:errorMsg];
    }
}
-(id) initConnection
{

    self = [super init];

    if (self)
    {
        if (g_database == nil)
        {
            [self createEditableCopyOfDatabaseIfNeeded];
            [self initializeDatabase];
        }
    }
    return self;
}

#pragma mark - Save Database

-(void)createEditableCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    BOOL            success;
    
    NSFileManager   *fileManager;
    NSError         *error;
    NSArray         *paths;
    NSString        *documentsDirectory;
    NSString        *dbDirectory;
    NSString        *writableDBPath;
    NSString        *defaultDBPath;

    fileManager         = [NSFileManager defaultManager];
    paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory  = [paths objectAtIndex:0];
    dbDirectory         = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];
    
    if (![fileManager fileExistsAtPath:dbDirectory])
    {
        [fileManager createDirectoryAtPath:dbDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        [self addSkipBackupAttributeToItemAtURL:[[NSURL alloc] initFileURLWithPath:dbDirectory isDirectory:YES]];
    }
    
    writableDBPath      = [dbDirectory stringByAppendingPathComponent:DB_NAME];
    success             = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) return;
    
    defaultDBPath       = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    success             = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success)
    {
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to create writable database file with message - %@.", [error localizedDescription]];
        [DatabaseConnector errorMessage:errorMsg];
    }
}

-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];

    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;

    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark - Open the database connection and retrieve minimal information for all objects.

-(void)initializeDatabase
{
    NSArray             *paths;
    NSString            *documentsDirectory;
    NSString            *dbDirectory;
    NSString            *path;
    
    paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory  = [paths objectAtIndex:0];
    dbDirectory         = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];
    path                = [dbDirectory stringByAppendingPathComponent:DB_NAME];

    if (sqlite3_open([path UTF8String], &g_database) != SQLITE_OK) {
        sqlite3_close(g_database);
        g_database = nil;
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(g_database)];
        [DatabaseConnector errorMessage:errorMsg];
    }
}

-(void)close
{

    if (g_database) {
        if (sqlite3_close(g_database) != SQLITE_OK) {
            NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(g_database)];
            [DatabaseConnector errorMessage:errorMsg];
        }
        g_database = nil;
    }
}

@end
