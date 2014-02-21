//
//  OshizushiTokeniser.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OshizushiTokeniser.h"
#import "CoreParse.h"

@implementation OshizushiTokeniser

-(id) init {
    self = [super init];

    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"V:"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"H:"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"|"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"-"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@","]];

    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"("]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@")"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"["]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"]"]];

    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@">="]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"<="]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"="]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@">"]];
    [self addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"<"]];
    
    [self addTokenRecogniser:[CPIdentifierRecogniser identifierRecogniser]];
    
    CPNumberRecogniser *number = [CPNumberRecogniser numberRecogniser];
    number.recognisesFloats = NO;
    number.recognisesInts = NO;
    [self addTokenRecogniser:number];
    [self addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
    
    return self;
}

@end
