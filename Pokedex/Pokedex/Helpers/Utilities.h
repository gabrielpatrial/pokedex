//
//  Utilities.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//


#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSDate *) zeroOutSecondsForDate:(NSDate *)fromDate;
+ (NSString *) dateToString:(NSDate *)date;
+ (NSString *) dateToISOString:(NSDate *)date;
+ (NSString *) getUTCFormattedDate:(NSDate *)localDate;
+ (NSString *) dateToShortString:(NSDate *)date;
+ (NSString *) dateTimeToTimeString:(NSDate *)date;
+ (NSString *) dateTimeToShortString:(NSDate *)date;

+ (NSString *) boolToString:(BOOL)boolValue;
+ (NSString *) boolToPrettyString:(BOOL)boolValue;

+ (NSString *)downloadFileToCache:(NSString *)downloadURL saveWithFileName:(NSString *)fileName redownloadIfExist:(BOOL)redownload;

+ (float) convertMetersToMiles:(float)meters;
+ (NSString *) timeAgoStringFromDate:(NSDate *)date;
+ (NSString *) currencyStringFromFloat:(CGFloat)f;

#
# pragma mark - JSON Helper Methods
#
+ (NSString *) jsonStringValue:(id)value;
+ (NSDate *) jsonDateValue:(id)value;
+ (BOOL) jsonBoolValue:(id)value;
+ (NSInteger) jsonIntegerValue:(id)value;
+ (CGFloat) jsonFloatValue:(id)value;

+ (NSInteger) getLabelPrintOverage;

@end
