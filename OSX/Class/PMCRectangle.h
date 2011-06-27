//
//  Rectangle.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCFigure.h"



@interface PMCRectangle : PMCFigure {
	
	//Spécific Property
	NSColor * _backgroundColor;
	BOOL _backgroundVisible;
	PMCBorderSetting _borderProperty;
	
}

@property (copy) NSColor * bgroundColor;
@property (assign) BOOL backgroundVisibility;
@property (assign) int borderSize;

@property (copy) NSColor * borderLeftColor;
@property (copy) NSColor * borderBottomColor;
@property (copy) NSColor * borderRightColor;
@property (copy) NSColor * borderTopColor;

@property (assign) BOOL borderLeftVisibility;
@property (assign) BOOL borderBottomVisibility;
@property (assign) BOOL borderRightVisibility;
@property (assign) BOOL borderTopVisibility;

- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel;

- (void)draw;

- (void)setBgroundColor:(NSColor*)newBGColor;

- (void)setBackgroundVisibility:(BOOL)isVisibleBG;


- (void)setBorderProperty:(PMCBorderSetting)newBS;
- (PMCBorderSetting)getBorderProperty;

- (void)setBorderSize:(int)newBorderWidth;
- (int)borderSize;


- (void)setBorderColor:(NSColor*)newColor;//change la couleur du bord pour tout les bords en même temps

- (void)setBorderTopColor:(NSColor*)newColor;
- (NSColor*)borderTopColor;

- (void)setBorderRightColor:(NSColor*)newColor;
- (NSColor*)borderRightColor;

- (void)setBorderBottomColor:(NSColor*)newColor;
- (NSColor*)borderBottomColor;

- (void)setBorderLeftColor:(NSColor*)newColor;
- (NSColor*)borderLeftColor;


- (void)setBorderVisibility:(BOOL)isVisible; //change la visibilité du bord pour tous les bords en même temps

- (void)setBorderTopVisibility:(BOOL)isVisible;
- (BOOL)borderTopVisibility;

- (void)setBorderRightVisibility:(BOOL)isVisible;
- (BOOL)borderRightVisibility;

- (void)setBorderBottomVisibility:(BOOL)isVisible;
- (BOOL)borderBottomVisibility;

- (void)setBorderLeftVisibility:(BOOL)isVisible;
- (BOOL)borderLeftVisibility;

- (NSMutableDictionary*)getDataForSave;

@end
