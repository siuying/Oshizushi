//
//  OshizushiParser.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPParser.h"

@interface OshizushiParser : NSObject <CPParserDelegate>

- (instancetype) init;

- (id)parseVisualFormatLanguage:(NSString *)vfl error:(NSError**)error;

@end
