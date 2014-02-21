//
//  OSZDirection.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CPTokeniser.h"
#import "CPParser.h"

typedef NS_ENUM(NSUInteger, OSZDirectionValue) {
    OSZDirectionVertical,
    OSZDirectionHorizontal
};

@interface OSZDirection : NSObject <CPParseResult>

@property (nonatomic, assign) OSZDirectionValue value;

@end
