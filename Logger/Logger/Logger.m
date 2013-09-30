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
    
    //Define purple color for fatal (wtf) level
    UIColor *purpleColor = [UIColor colorWithRed:(104/255.0)
                                           green:(30/255.0)
                                            blue:(126/255.0)
                                           alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:purpleColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_FATAL];
    
    //Define red color for error level
    UIColor *redColor = [UIColor colorWithRed:(216/255.0)
                                        green:(39/255.0)
                                         blue:(53/255.0)
                                        alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:redColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_ERROR];
    
    //Define orange color for warning level
    UIColor *orangeColor = [UIColor colorWithRed:(255/255.0)
                                           green:(116/255.0)
                                            blue:(53/255.0)
                                           alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:orangeColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_WARN];
    
    //Define blue color for notice level
    UIColor *blueColor = [UIColor colorWithRed:(0/255.0)
                                         green:(121/255.0)
                                          blue:(231/255.0)
                                         alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:blueColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_NOTICE];
    
    //Define green color for info level
    UIColor *greenColor = [UIColor colorWithRed:(0/255.0)
                                          green:(158/255.0)
                                           blue:(71/255.0)
                                          alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:greenColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_INFO];
    
    //Define black color for debug level
    [[DDTTYLogger sharedInstance] setForegroundColor:purpleColor
                                     backgroundColor:nil
                                             forFlag:LOG_FLAG_DEBUG];
    
    //Log statements will be sent to the Xcode console
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"[%@.%@] %@", [logMessage fileName],
            [logMessage methodName],
            logMessage->logMsg];
}

@end
