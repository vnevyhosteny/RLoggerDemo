//
//  RemoteLogger.h
//  Logger
//
//  Created by Vladimír Nevyhoštěný on 18.01.15.
//  Copyright (c) 2015 Vladimír Nevyhoštěný. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for RemoteLogger.
FOUNDATION_EXPORT double RemoteLoggerVersionNumber;

//! Project version string for RemoteLogger.
FOUNDATION_EXPORT const unsigned char RemoteLoggerVersionString[];


#pragma mark -
#pragma mark Log Levels

typedef enum {
    log_level_all               = 0, // The default value
    log_level_detailed_debug    = 1,
    log_level_debug             = 2,
    log_level_info              = 3,
    log_level_warning           = 4,
    log_level_error             = 5, // Use for the production build
    log_level_fatal             = 6
} LogLevel;

typedef enum {
    LogModeNone                 = 0,
    LogModeConsole              = 1, // The default value
    LogModeFile                 = 2,
    LogModeRemote               = 4
} LogMode;

// Default file size for logging in the file (8MB), see maxLogBufferSize property.
extern unsigned long long const DefaultLogBufferSize;

void remote_log( const char *fileName, const NSUInteger lineNumber, const LogLevel logLevel, NSString *format, ... );

// Use this macro for logging.
#define rlog( logLevel, format, ... ) remote_log( __FILE__, __LINE__, logLevel, format, ##__VA_ARGS__ );

//==============================================================================
@interface RemoteLogger : NSObject

@property (nonatomic, readwrite) LogMode            logMode;
@property (nonatomic, readwrite) LogLevel           logLevel;
@property (nonatomic, readonly)  NSDateFormatter   *dateFormatter;
@property (nonatomic, readwrite) NSString          *logFolderName;
// Log file name. If not set, the appId property will be used.
@property (nonatomic, readwrite) NSString          *logFileName;
// Application bundle id.
@property (nonatomic, readonly)  NSString          *appId;
// String value, inserted in each log message right after time stamp. Default = nil.
@property (nonatomic, readwrite)  NSString         *logPrefix;
@property (nonatomic, readwrite) unsigned long long maxLogBufferSize;
// Max. log row count stored in the remote logging buffer. (4096)
@property (nonatomic, readwrite) NSUInteger         maxRemoteRowsCount;

+ (instancetype) sharedLogger;
+ (instancetype) createLoggerWithLogFolderName:(NSString*)logFolderName
                                   logFileName:(NSString*)logFileName
                                       logMode:(LogMode)logMode
                                      logLevel:(LogLevel)logLevel;

@end
