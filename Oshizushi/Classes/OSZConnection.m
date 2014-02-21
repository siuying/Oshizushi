//
//  OSZPadding.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZConnection.h"
#import "CoreParse.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@implementation OSZConnection

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    self = [super init];

    self.value = -1;

    NSArray* children = [syntaxTree children];
    if ([children count] == 1) {
    } else if ([children count] == 3) {
        CPToken* token = [children objectAtIndex:1];
        if ([token isNumberToken]) {
            CPNumberToken* numberToken = (CPNumberToken*) token;
            self.value = [[numberToken number] integerValue];
        }
        
        if ([token isKeywordToken]) {
            CPKeywordToken* keywordToken = (CPKeywordToken*) token;
            self.merticName = [keywordToken keyword];
        }
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Unexpected connection node: %@", syntaxTree];
    }

    return self;
}

@end
