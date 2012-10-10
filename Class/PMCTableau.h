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
	/*NSString * name;
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
	
	NSUndoManager * undoManager;*/
	
}

@property (retain) NSUndoManager * undoManager;

@property (readonly,retain) NSString * name;
@property (readonly,retain) NSString * genre;
@property (readonly,assign) int hauteurLigne;
@property (readonly,retain) NSColor * colorBG;
@property (readonly,assign) BOOL backgroundVisible;
@property (readonly,assign) int fontIndex;
@property (readonly,assign) int fontSize;
@property (readonly,retain) NSColor * fontColor;
@property (readonly,assign) BOOL fontBold;
@property (readonly,assign) BOOL fontItalic;
@property (readonly,assign) BOOL fontUnderline;

@property (readonly,assign) BOOL borderTopVisible;
@property (readonly,assign) int borderTopWidth;
@property (readonly,retain) NSColor * borderTopColor;

@property (readonly,assign) BOOL borderBottomVisible;
@property (readonly,assign) int borderBottomWidth;
@property (readonly,retain) NSColor * borderBottomColor;

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
	/*NSString * name;
	NSString * data;
	int colWidth;
	int dataAlign;
	
	NSString * headerData;
	int headerAlign;
	
	BOOL borderRightVisible;
	int borderRightWidth;
	NSColor * borderRightColor;
	
	NSUndoManager * undoManager;*/
}


@property (readonly,retain) NSString * name;
@property (readonly,retain) NSString * data;
@property (readonly,assign) int colWidth;
@property (readonly,assign) int dataAlign;

@property (readonly,retain) NSString * headerData;
@property (readonly,assign) int headerAlign;

@property (readonly,assign) BOOL borderRightVisible;
@property (readonly,assign) int borderRightWidth;
@property (readonly,retain) NSColor * borderRightColor;

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
	/*NSMutableArray * columnDef;
	NSMutableArray * rowDef;
	
	BOOL showHeader;
	BOOL repeatHeader;
	
	BOOL repeatArrayToOtherPage;
	int topOnOtherPage;
	int heightOnOtherPage;
	
	NSString * dataSource;*/
	
}

@property (retain) NSMutableArray * columnDef;
@property (retain) NSMutableArray * rowDef;

@property (readonly,assign) BOOL showHeader;
@property (readonly,assign) BOOL repeatHeader;

@property (readonly,assign) BOOL repeatArrayToOtherPage;
@property (readonly,assign) int topOnOtherPage;
@property (readonly,assign) int heightOnOtherPage;

@property (readonly,retain) NSString * dataSource;

- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel;

- (NSMutableDictionary*)getDataForSave;

@end
