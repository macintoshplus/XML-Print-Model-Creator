//
//  PMCPropertiesView.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 12/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PMCPropertiesView : NSView {
	int _actualY;
}

- (void)addView:(NSView*)aView;

@end
