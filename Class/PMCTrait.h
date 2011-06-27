//
//  Trait.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCFigure.h"



@interface PMCTrait : PMCFigure {
	NSColor * _color;
	int _style;
	int _width;
	NSRect correctedFrame;
}

@property (copy) NSColor * color;
@property (assign) int style;

- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel;

- (void)setColor:(NSColor*)newColor;

- (void)setStyle:(int)newStyle;
/*
- (void)setWidth:(int)newWidth;
- (int)getWidth;
*/
- (NSMutableDictionary*)getDataForSave;

@end
