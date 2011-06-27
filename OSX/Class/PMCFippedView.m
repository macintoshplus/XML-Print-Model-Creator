//
//  PMCFippedView.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 26/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCFippedView.h"


@implementation PMCFippedView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)isFlipped{
	return TRUE;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	[super drawRect:rect];
}

@end
