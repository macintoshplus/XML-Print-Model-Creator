//
//  PMCTableau.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 24/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCFigure.h"
#import "PMCRectangle.h"

@interface PMCTableauRow : NSObject
{
	NSString * name;
	NSString * genre;
	int hauteurLigne;
	NSColor * colorBG;
	BOOL backgroundVisible;
	int fontIndex;
	int fontSize;
	NSColor * fontColor;
	
	BOOL fontBold;
	BOOL fontItalic;
	BOOL fontUnderline;
	
	BOOL borderTopVisible;
	int borderTopWidth;
	NSColor * borderTopColor;
	
	BOOL borderBottomVisible;
	int borderBottomWidth;
	NSColor * borderBottomColor;
	
	NSUndoManager * undoManager;
	
}

@property (retain) NSUndoManager * undoManager;

@property (retain) NSString * name;
@property (retain) NSString * genre;
@property (assign) int hauteurLigne;
@property (retain) NSColor * colorBG;
@property (assign) BOOL backgroundVisible;
@property (assign) int fontIndex;
@property (assign) int fontSize;
@property (retain) NSColor * fontColor;
@property (assign) BOOL fontBold;
@property (assign) BOOL fontItalic;
@property (assign) BOOL fontUnderline;

@property (assign) BOOL borderTopVisible;
@property (assign) int borderTopWidth;
@property (retain) NSColor * borderTopColor;

@property (assign) BOOL borderBottomVisible;
@property (assign) int borderBottomWidth;
@property (retain) NSColor * borderBottomColor;

- (id)copyWithZone:(NSZone*)zone;
- (id)init;
- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel:(int)idx;
- (NSString*)description;
- (NSColor*)changeColorSpaceNameToRVB:(NSColor*)oldColor;

- (NSMutableDictionary*)getDataForSave;

@end

@interface PMCTableauCol : NSObject
{
	NSString * name;
	NSString * data;
	int colWidth;
	int dataAlign;
	
	NSString * headerData;
	int headerAlign;
	
	BOOL borderRightVisible;
	int borderRightWidth;
	NSColor * borderRightColor;
	
	NSUndoManager * undoManager;
}


@property (retain) NSString * name;
@property (retain) NSString * data;
@property (assign) int colWidth;
@property (assign) int dataAlign;

@property (retain) NSString * headerData;
@property (assign) int headerAlign;

@property (assign) BOOL borderRightVisible;
@property (assign) int borderRightWidth;
@property (retain) NSColor * borderRightColor;

@property (retain) NSUndoManager * undoManager;

- (id)copyWithZone:(NSZone*)zone;
- (id)init;
- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel:(int)idx;
- (NSString*)description;
- (NSColor*)changeColorSpaceNameToRVB:(NSColor*)oldColor;
- (NSMutableDictionary*)getDataForSave;

@end



@interface PMCTableau : PMCRectangle {
	/* Properties */
	NSMutableArray * columnDef;
	NSMutableArray * rowDef;
	
	BOOL showHeader;
	BOOL repeatHeader;
	
	BOOL repeatArrayToOtherPage;
	int topOnOtherPage;
	int heightOnOtherPage;
	
	NSString * dataSource;
	
}

@property (retain) NSMutableArray * columnDef;
@property (retain) NSMutableArray * rowDef;

@property (assign) BOOL showHeader;
@property (assign) BOOL repeatHeader;

@property (assign) BOOL repeatArrayToOtherPage;
@property (assign) int topOnOtherPage;
@property (assign) int heightOnOtherPage;

@property (retain) NSString * dataSource;

- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel;

- (NSMutableDictionary*)getDataForSave;

@end
