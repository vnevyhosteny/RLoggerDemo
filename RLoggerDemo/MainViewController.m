//
//  MainViewController.m
//  RLoggerDemo
//
//  Created by Vladimír Nevyhoštěný on 07.03.15.
//  Copyright (c) 2015 nefa. All rights reserved.
//

#import <RemoteLogger/RemoteLogger.h>
#import "MainViewController.h"

//==============================================================================
@interface MainViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *logLevelButtonCollection;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *logModeSwitchesCollection;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)logLevelAction:(UIButton *)sender;
- (IBAction)logAction:(UIButton *)sender;
- (IBAction)logModeAction:(UISwitch *)sender;

@end

//==============================================================================
@implementation MainViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLogLevel:log_level_all];
}

//------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------
- (void) setLogLevel:(LogLevel)level
{
    for ( __weak UIButton *button in self.logLevelButtonCollection ) {
        [button setTitleColor:( ( button.tag == level ) ? [UIColor blueColor] : [UIColor grayColor] ) forState:UIControlStateNormal];
    }
    [RemoteLogger sharedLogger].logLevel = level;
}

//------------------------------------------------------------------------------
- (IBAction) logLevelAction:(UIButton *)sender
{
    [self setLogLevel:(LogLevel)sender.tag];
}

//------------------------------------------------------------------------------
- (IBAction) logAction:(UIButton *)sender
{
    static unsigned long     itemId     = 0;
    static NSUInteger const  count      = 100;
    static NSDictionary     *levelNames = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *aux = [NSMutableDictionary dictionary];
        for ( __weak UIButton *button in self.logLevelButtonCollection ) {
            [aux setValue:button.titleLabel.text forKey:[NSString stringWithFormat:@"%ld", (long)button.tag]];
        }
        levelNames = [[NSDictionary alloc] initWithDictionary:aux];
    });
    
    LogLevel level                 = log_level_all;
    NSString *message;
    
    for ( NSUInteger i = 0; i < count; i++ ) {
        message = [NSString stringWithFormat:@"%lu Log item with level %@", ++itemId, [levelNames valueForKey:[NSString stringWithFormat:@"%d", level]]];
#if TARGET_IPHONE_SIMULATOR
        NSLog( @"%@", message );
#else
        rlog( level, @"%@", message );
#endif
        self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, message];
        [self.textView scrollRangeToVisible:NSMakeRange( [self.textView.text length], 0 )];

        level = ( ( level < log_level_fatal ) ? ++level : log_level_all );
    }
}

//------------------------------------------------------------------------------
- (IBAction) logModeAction:(UISwitch *)sender
{
    LogMode mode = LogModeNone;
    for ( __weak UISwitch *logSwitch in self.logModeSwitchesCollection ) {
        if ( logSwitch.on ) {
            mode |= logSwitch.tag;
        }
    }
    [RemoteLogger sharedLogger].logMode = mode;
}
@end
