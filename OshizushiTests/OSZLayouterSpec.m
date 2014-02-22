//
//  OSZLayouterSpec.m
//  Oshizushi
//
//  Created by Francis Chong on 2/22/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OSZLayouter.h"


SPEC_BEGIN(OSZLayouterSpec)

describe(@"OSZLayouter", ^{
    __block OSZLayouter* layouter;
    __block UIView* superview;
    
    beforeEach(^{
        layouter = [[OSZLayouter alloc] init];
        superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    });
    
    context(@"Pin to one edge", ^{
        it(@"should layout |-5-[view(100)]", ^{
            UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
            [superview addSubview:view];
            
            NSDictionary* views = NSDictionaryOfVariableBindings(view);
            [layouter layoutWithVisualFormat:@"|-5-[view(100)]" metrics:nil views:views];
            
            [[theValue(view.frame.origin.x) should] equal:theValue(5)];
            [[theValue(view.frame.origin.y) should] equal:theValue(0)];
            [[theValue(view.frame.size.width) should] equal:theValue(100)];
        });
    });
});

SPEC_END
