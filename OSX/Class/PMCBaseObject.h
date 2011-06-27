//
//  PMCBaseObject.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 10/02/09.
//  Copyright 2009 Jean Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct PMCBorderSetting {
	BOOL topVisible;
	NSColor * topColor;
	BOOL rightVisible;
	NSColor * rightColor;
	BOOL bottomVisible;
	NSColor * bottomColor;
	BOOL leftVisible;
	NSColor * leftColor;
	int borderSize;
} PMCBorderSetting;

@interface PMCBaseObject : NSObject {
	//Global property
	NSString * _name;
	NSRect _sizeAndPosition;
	NSRect _savedSizeAndPosition;
	
	BOOL _isVisible;
	
	NSMutableArray * _vectorPath;
	
	NSArray * _fontList;
}

@property (retain) NSString * name;

//Init
- (id)initWithName:(NSString*)name;
- (id)initWithName:(NSString*)name andSizeAndPosition:(NSRect)rect;
- (id)initWithData:(NSDictionary*)dico;

//Accessor
//- (void)setName:(NSString*)name;
- (NSString*)getName;

- (NSXMLElement*)exportToModel;

- (void)setSizeAndPosition:(NSRect)rect;
- (NSRect)getSizeAndPosition;

- (void)setVisible:(BOOL)visible;
- (BOOL)isVisible;
//
- (void)draw;

- (BOOL)containsPoint:(NSPoint)point;
- (void)updatePositionWithPoint:(NSPoint)point; //met a jour la position
- (void)hotUpdatePositionWithPoint:(NSPoint)point;//met à jour la position selon la position sauvegardé
- (void)savePosition; //sauvegarde la position et la taille en cours 

- (NSMutableDictionary*)getDataForSave;

@end
