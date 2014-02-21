//
//  OshizushiGrammar.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OshizushiGrammar.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@implementation OshizushiGrammar

-(instancetype) init
{
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Oshizushi" ofType:@"grammar"];
    return [self initWithPath:path];
}

-(instancetype) initWithPath:(NSString*)path
{
    NSError* error;
    NSString* grammar = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!grammar) {
        if (error) {
            DDLogError(@"missing grammar file %@, error: %@", path, error);
            [NSException raise:NSInvalidArgumentException format:@"missing grammar file %@, error: %@", path, error];
        } else {
            DDLogError(@"missing grammar file %@", path);
            [NSException raise:NSInvalidArgumentException format:@"missing grammar file %@", path];
        }
    }
    self = [super initWithStart:@"CSSSelectorGroup" backusNaurForm:grammar error:&error];
    if (!self) {
        if (error) {
            DDLogError(@"error compile language = %@", error);
        }
    }
    return self;
}

@end
