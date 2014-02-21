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

@interface OshizushiParser()
@property (nonatomic, strong) CPLALR1Parser *parser;
@property (nonatomic, strong) OshizushiTokeniser *tokenizer;
@end

@implementation OshizushiParser

-(instancetype) init
{
    self = [super init];
    self.tokenizer = [[OshizushiTokeniser alloc] init];
    self.parser = [[CPLALR1Parser alloc] initWithGrammar:[[OshizushiGrammar alloc] init]];
    return self;
}

- (id)parseVisualFormatLanguage:(NSString *)vfl error:(NSError**)error
{
    CPTokenStream* stream = [self.tokenizer tokenise:vfl];
    return [self.parser parse:stream];
}

@end
