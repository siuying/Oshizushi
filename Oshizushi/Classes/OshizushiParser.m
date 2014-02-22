//
//  OshizushiParser.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OshizushiParser.h"
#import "OshizushiTokeniser.h"
#import "OshizushiGrammar.h"
#import "CoreParse.h"

#define LOG_LEVEL_DEF oshiLibLogLevel
#import "DDLog.h"
static const int oshiLibLogLevel = LOG_LEVEL_VERBOSE;


@interface OshizushiParser()
@property (nonatomic, strong) CPParser *parser;
@property (nonatomic, strong) OshizushiTokeniser *tokenizer;
@end

@implementation OshizushiParser

-(instancetype) init
{
    self = [super init];
    self.tokenizer = [[OshizushiTokeniser alloc] init];
    self.parser = [[CPLALR1Parser alloc] initWithGrammar:[[OshizushiGrammar alloc] init]];
    self.parser.delegate = self;
    return self;
}

- (id)parseVisualFormatLanguage:(NSString *)vfl error:(NSError**)error
{
    CPTokenStream* stream = [self.tokenizer tokenise:vfl];
    return [self.parser parse:stream];
}

#pragma mark - 

- (id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    NSArray *children = [syntaxTree children];
    switch ([[syntaxTree rule] tag]) {
        case 1:
        {
            return (CPKeywordToken *)[children objectAtIndex:0];
        }
            break;
        case 2:
        case 3:
        {
            CPKeywordToken* token = (CPKeywordToken *)[children objectAtIndex:0];
            return [token keyword];
        }
        default:
            break;
    }
    return syntaxTree;
}

- (CPRecoveryAction *)parser:(CPParser *)parser didEncounterErrorOnInput:(CPTokenStream *)inputStream expecting:(NSSet *)acceptableTokens {
    DDLogError(@"error parsing: %@, acceptable tokens: %@", inputStream, acceptableTokens);
    return [CPRecoveryAction recoveryActionStop];
}

@end
