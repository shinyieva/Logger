//
//  Logger.h
//  Logger
//
//  Created by Aurigae on 30/09/13.
//  Copyright (c) 2013 shinyieva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogConstants.h"

#ifdef Release
static const int ddLogLevel = LOG_LEVEL_ERROR;
#else
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#endif

@interface Logger : NSObject <DDLogFormatter>

- (void)configureLogger;

+ (Logger *)sharedInstance;

@end
