//
//  OshizushiParser.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSZExpression;

@interface OshizushiParser : NSObject

- (instancetype) init;

- (OSZExpression*)parseVisualFormatLanguage:(NSString *)input;

@end
