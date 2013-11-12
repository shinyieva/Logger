//
//  Logger.m
//  Logger
//
//  Created by Aurigae on 30/09/13.
//  Copyright (c) 2013 shinyieva. All rights reserved.
//

#import "Logger.h"

#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"

@interface Logger ()
{
    NSDictionary *_logColors;
}

@end

@implementation Logger

+ (Logger *)sharedInstance
{
    static Logger *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Logger alloc] init];
        // Do any other initialisation stuff here
    });
    return _sharedInstance;
}

- (void)configureLogger
{
    // Sends log statements to Xcode console - if available
    setenv("XcodeColors", "YES", 1);
    
    [[DDASLLogger sharedInstance] setLogFormatter:[Logger sharedInstance]];
    //Configure the framework
    [[DDTTYLogger sharedInstance] setLogFormatter:[Logger sharedInstance]];
    // And we're going to enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [self _configureLogColor];
    
    //Define purple color for fatal (wtf) level
    UIColor *purpleColor = [UIColor colorWithRed:(104/255.0)
                                           green:(30/255.0)
                                            blue:(126/255.0)
                                           alpha:1.0];
    
    
    //Define red color for error level
    UIColor *redColor = [UIColor colorWithRed:(216/255.0)
                                        green:(39/255.0)
                                         blue:(53/255.0)
                                        alpha:1.0];
    
    
    //Define orange color for warning level
    UIColor *orangeColor = [UIColor colorWithRed:(255/255.0)
                                           green:(116/255.0)
                                            blue:(53/255.0)
                                           alpha:1.0];
    
    
    //Define blue color for notice level
    UIColor *blueColor = [UIColor colorWithRed:(0/255.0)
                                         green:(121/255.0)
                                          blue:(231/255.0)
                                         alpha:1.0];
    
    
    //Define green color for info level
    UIColor *greenColor = [UIColor colorWithRed:(0/255.0)
                                          green:(158/255.0)
                                           blue:(71/255.0)
                                          alpha:1.0];
    
    
    //Define black color for debug level
    
    
    //Log statements will be sent to the Xcode console
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
}

- (void)_configureLogColor
{
    _logColors = [self _getColorsFromPlist];
    
    UIColor *wtfColor = nil;
    UIColor *errorColor = nil;
    UIColor *warningColor = nil;
    UIColor *noticeColor = nil;
    UIColor *infoColor = nil;
    UIColor *debugColor = nil;
    
    if (_logColors) {
        wtfColor = [self _getColor:@"fatal"];
        errorColor = [self _getColor:@"error"];
        warningColor = [self _getColor:@"warning"];
        noticeColor = [self _getColor:@"notice"];
        infoColor = [self _getColor:@"info"];
        debugColor = [self _getColor:@"debug"];
        
    } else {
        //Define purple color for fatal (wtf) level
        wtfColor = [UIColor colorWithRed:(104/255.0)
                                   green:(30/255.0)
                                    blue:(126/255.0)
                                   alpha:1.0];
        
        //Define red color for error level
        errorColor = [UIColor colorWithRed:(216/255.0)
                                     green:(39/255.0)
                                      blue:(53/255.0)
                                     alpha:1.0];
        
        //Define orange color for warning level
        warningColor = [UIColor colorWithRed:(255/255.0)
                                       green:(116/255.0)
                                        blue:(53/255.0)
                                       alpha:1.0];
        
        //Define black color for notice level
        noticeColor = [UIColor blackColor];
        
        //Define green color for info level
        infoColor = [UIColor colorWithRed:(0/255.0)
                                    green:(158/255.0)
                                     blue:(71/255.0)
                                    alpha:1.0];
        
        
        //Define blue color for debug level
        debugColor = [UIColor colorWithRed:(0/255.0)
                                     green:(121/255.0)
                                      blue:(231/255.0)
                                     alpha:1.0];
    }
    
    [[DDTTYLogger sharedInstance] setForegroundColor:wtfColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_FATAL];
    [[DDTTYLogger sharedInstance] setForegroundColor:errorColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:warningColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_WARN];
    [[DDTTYLogger sharedInstance] setForegroundColor:noticeColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_NOTICE];
    [[DDTTYLogger sharedInstance] setForegroundColor:infoColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:debugColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_DEBUG];
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"[%@.%@] %@", [logMessage fileName],
            [logMessage methodName],
            logMessage->logMsg];
}

#pragma mark - UIColor Utils

- (UIColor *)_getColor:(NSString*)colorName
{
    //Default
    NSString *hexColor = nil;
    
    if(_logColors&& colorName){
        hexColor = [_logColors objectForKey:colorName];
        return [self _colorWithHexValue:hexColor];
    }
    
    return [UIColor blackColor];
}

- (UIColor *)_colorWithHexValue:(NSString*)hexValue
{
    //Default
    UIColor *defaultResult = [UIColor blackColor];
    
    //Strip prefixed # hash
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    //Determine if 3 or 6 digits
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3) {
        componentLength = 1;
    } else if ([hexValue length] == 6) {
        componentLength = 2;
    } else {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    //Seperate the R,G,B values
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}

#define kLogColorFileName @"LogColors"

- (NSDictionary *)_getColorsFromPlist
{
    NSDictionary *plistDict = nil;
    NSString *error;
    NSPropertyListFormat format;
    NSString *colorsPath = [[NSBundle mainBundle] pathForResource:kLogColorFileName
                                                           ofType:@"plist"];
    NSData *colorsData = [NSData dataWithContentsOfFile:colorsPath];
    
    plistDict = [NSPropertyListSerialization propertyListFromData:colorsData
                                                 mutabilityOption:NSPropertyListImmutable
                                                           format:&format
                                                 errorDescription:&error];
    if (!plistDict) {
        NSLog(@"Error reading plist from file '%s', error = '%s'",
              [colorsPath UTF8String],
              [error UTF8String]);
    }
    
    return plistDict;
}

@end
