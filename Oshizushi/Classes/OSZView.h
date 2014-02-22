//
//  OSZView.h
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSZConnection;
@class OSZPredicate;

@interface OSZView : NSObject

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) OSZConnection* connection;

@property (nonatomic, strong) OSZPredicate* predicate;

@end
