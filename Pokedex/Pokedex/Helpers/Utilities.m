//
//  Utilities.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *) dateToString:(NSDate *)date
{
    if (!date){
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *) dateToShortString:(NSDate *)date
{
    if (!date){
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *) dateTimeToShortString:(NSDate *)date
{
    if (!date){
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"MM/dd/yy h:mm a"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *) dateTimeToTimeString:(NSDate *)date
{
    if (!date){
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"hh:mm a"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *) dateToISOString:(NSDate *)date
{
    if (!date){
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return [formatter stringFromDate:date];
}

+ (NSString *) getUTCFormattedDate:(NSDate *)localDate
{
    if (!localDate){
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

+ (NSDate *)zeroOutSecondsForDate:(NSDate *)fromDate;
{
    if (fromDate == nil){
        return nil;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *fromDateComponents = [gregorian components:unitFlags fromDate:fromDate];
    return [gregorian dateFromComponents:fromDateComponents];
}

+ (NSString *)downloadFileToCache:(NSString *)downloadURL saveWithFileName:(NSString *)fileName redownloadIfExist:(BOOL)redownload
{
    //Storing to cache storage
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (fileName == nil){
        fileName = [documentsDirectory  stringByAppendingPathComponent:[downloadURL lastPathComponent]];
    } else {
        fileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    }
    
    NSString *pathDirectory = [fileName stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([pathDirectory isEqualToString:@""]== NO) {
        if ([fileManager fileExistsAtPath: pathDirectory] == NO) {
            [fileManager createDirectoryAtPath:pathDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if (redownload == YES) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
    
    if ([fileManager fileExistsAtPath: fileName] == NO) {
        NSURL *url = [NSURL URLWithString:downloadURL];
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        [data writeToFile:fileName atomically:YES];
    }
    
    return fileName;
}

+ (NSString *) timeAgoStringFromDate:(NSDate *)date
{
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    
    NSDate *now = [NSDate date];
    
    if (!date){
        date = [NSDate date];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond)
                                               fromDate:date
                                                 toDate:now
                                                options:0];
    
    if (components.year > 0) {
        formatter.allowedUnits = NSCalendarUnitYear;
    } else if (components.month > 0) {
        formatter.allowedUnits = NSCalendarUnitMonth;
    } else if (components.weekOfMonth > 0) {
        formatter.allowedUnits = NSCalendarUnitWeekOfMonth;
    } else if (components.day > 0) {
        formatter.allowedUnits = NSCalendarUnitDay;
    } else if (components.hour > 0) {
        formatter.allowedUnits = NSCalendarUnitHour;
    } else if (components.minute > 0) {
        formatter.allowedUnits = NSCalendarUnitMinute;
    } else {
        formatter.allowedUnits = NSCalendarUnitSecond;
    }
    
    NSString *formatString = NSLocalizedString(@"%@ ago", @"Used to say how much time has passed. e.g. '2 hours ago'");
    NSString *returnString = [NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]];
    
    if ([returnString.uppercaseString isEqualToString:@"0 SECONDS AGO"]){
        returnString = @"just now";
    }
    
    return returnString;
}

+ (float) convertMetersToMiles:(float)meters
{
    return meters * 0.000621371;
}

+ (NSString *) boolToString:(BOOL)boolValue
{
    if (boolValue){
        return @"true";
    } else {
        return @"false";
    }
}

+ (NSString *) boolToPrettyString:(BOOL)boolValue
{
    if (boolValue){
        return @"Yes";
    } else {
        return @"No";
    }
}

#
# pragma mark - JSON Helper Methods
#
+ (NSString *) jsonStringValue:(id)value
{
    if([value isEqual:[NSNull null]]){
        return @"";
    } else if (value == nil){
        return @"";
    } else if ([value isKindOfClass:[NSString class]]){
        return (NSString *) value;
    } else if ([value isKindOfClass:[NSNumber class]]){
        return ((NSNumber *) value).stringValue;
    } else {
        return @"UNKNOWN TYPE";
    }
}

+ (NSDate *) jsonDateValue:(id)value
{
    NSString *dateString = [self jsonStringValue:value];
    
    if (dateString.length == 0 || [[dateString substringToIndex:10] isEqualToString:@"1970-01-01"]){
        return nil;
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // Always use this locale when parsing fixed format date strings
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:posix];
        NSDate *d = [formatter dateFromString:dateString];
        //
        //NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        //d = [d dateByAddingTimeInterval:timeZoneSeconds];
        //
        if (d){
            return d;
        } else {
            [formatter setDateFormat:@"yyyy-MM-dd"];
            return [formatter dateFromString:dateString];
        }
    }
}

+ (BOOL) jsonBoolValue:(id)value
{
    if (value == [NSNull null] || value == nil){
        return NO;
    } else {
        return [value boolValue];
    }
}

+ (NSInteger) jsonIntegerValue:(id)value
{
    if (value == [NSNull null] || value == nil){
        return 0;
    } else {
        return [value integerValue];
    }
}

+ (CGFloat) jsonFloatValue:(id)value
{
    if (value == [NSNull null] || value == nil){
        return 0;
    } else {
        return [value floatValue];
    }
}

+ (NSString *) currencyStringFromFloat:(CGFloat)f
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.alwaysShowsDecimalSeparator = NO;
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSize = 3;
    
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencySymbol = @"$";
    formatter.currencyDecimalSeparator = @".";
    formatter.currencyGroupingSeparator = @",";
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:f]];
}

+ (NSInteger) getLabelPrintOverage
{
    NSInteger overage = 5;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *s = [userDefaults objectForKey:@"label_overage"];
    
    if (!s){
        //
        NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        if(!settingsBundle) {
            NSLog(@"Could not find Settings.bundle");
            return overage;
        }
        //
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
        
        for(NSDictionary *prefSpecification in preferences) {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if([key isEqualToString:@"label_overage"]) {
                NSString *s = [prefSpecification objectForKey:@"DefaultValue"];
                [userDefaults setObject:s forKey:@"label_overage"];
                [userDefaults synchronize];
                return s.integerValue;
            }
        }
    }
    
    if (s.length > 0 && s.integerValue > -1){
        overage = s.integerValue;
    }
    
    return overage;
}

@end
