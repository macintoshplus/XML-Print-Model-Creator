//
//  Text.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCFigure.h"
#import "PMCRectangle.h"

@interface PMCText : PMCRectangle {
	NSString * _content;
	NSColor * _textColor;
	//NSFont * _textFont;
	TextEncoding _textEncoding;
	int _textSize;
	int _fontIndex;
	int _textAlign;
	
	BOOL _bold;
	BOOL _italic;
	BOOL _underline;
	
}

@property (readonly,copy) NSString * content;
@property (readonly,copy) NSColor * textColor;
@property (readonly,assign) int textSize;
@property (readonly,assign) int textAlign;
@property (readonly,assign) int textFontIndex;
@property (readonly,assign) BOOL textBold;
@property (readonly,assign) BOOL textItalic;
@property (readonly,assign) BOOL textUnderline;


- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel;

- (void)setContent:(NSString*)newText;

- (void)setTextColor:(NSColor*)newColor;

- (void)setTextSize:(int)newSize;

- (void)setTextAlign:(int)newSize;

- (void)setTextFontIndex:(int)newFont;

- (void)setTextBold:(BOOL)newVal;

- (void)setTextItalic:(BOOL)newVal;

- (void)setTextUnderline:(BOOL)newVal;

- (void)setTextEncoding:(TextEncoding)newTE;
- (TextEncoding)getTextEncoding;

- (void)draw;

- (NSMutableDictionary*)getDataForSave;

@end
