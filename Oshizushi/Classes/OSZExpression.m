//
//  OSZExpression.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OSZExpression.h"
#import "OSZView.h"
#import "CoreParse.h"
#import "ObjectiveSugar.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;

@interface OSZExpression()
@property (nonatomic, strong) NSMutableArray* views;
@end

@implementation OSZExpression

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    self = [super init];
    self.direction = [syntaxTree valueForTag:@"direction"];
    _views = [NSMutableArray array];

    OSZView* view = [[syntaxTree children] objectAtIndex:2];
    if (view) {
        [self.views addObject:view];
    }
    
    NSArray* leadingElements = [[syntaxTree valueForTag:@"leading"] flatten];
    if (leadingElements && [leadingElements count] > 0) {
        CPKeywordToken* token = [leadingElements firstObject];
        if ([[token keyword] isEqualToString:@"|"]) {
            self.pinToLeadingEdge = YES;
        }
    }

    
    NSArray* trailingElements = [[syntaxTree valueForTag:@"trailing"] flatten];
    if (trailingElements && [trailingElements count] > 0) {
        CPKeywordToken* token = [trailingElements lastObject];
        if ([[token keyword] isEqualToString:@"|"]) {
            self.pinToTrailingEdge = YES;
        }
    }

    return self;
}

@end
