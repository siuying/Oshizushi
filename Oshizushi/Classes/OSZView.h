//
//  OSZView.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPParser.h"

@interface OSZView : NSObject <CPParseResult>

@property (nonatomic, strong) NSString* name;

@end
