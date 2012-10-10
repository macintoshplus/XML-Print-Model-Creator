//
//  PMCBaseObject.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 10/02/09.
//  Copyright 2009 Jean Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>


extern NSString *FigureDrawingBoundsKey;
extern NSString *FigureDrawingContentsKey;

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

@protocol PMCFigure

- (void)draw;
- (NSRect)drawingBounds;
- (BOOL)containsPoint:(NSPoint)point;
- (BOOL)isVisible;

@end

@interface PMCFigure : NSObject <PMCFigure> {
	//Global property
	NSString * _name;
	//NSRect _sizeAndPosition;
	NSRect _savedSizeAndPosition;
	
	float x;
	float y;
	float width;
	float height;
	
	BOOL _isVisible;
	
	NSMutableArray * _vectorPath;
	
	NSArray * _fontList;
	
	NSUndoManager * undoManager;
}

@property (readonly,retain) NSString * name;
@property (retain) NSUndoManager * undoManager;
@property (readonly,assign) float x;
@property (readonly,assign) float y;
@property (readonly,assign) float width;
@property (readonly,assign) float height;
@property (readonly,assign) BOOL visible;

@property (readonly) NSArray * fontList;

//@property (assign) NSRect sizeAndPosition;

//Init
- (id)initWithName:(NSString*)name;
- (id)initWithName:(NSString*)name andSizeAndPosition:(NSRect)rect;
- (id)initWithData:(NSDictionary*)dico;

//Accessor
//- (void)setName:(NSString*)name;
- (NSString*)getName;

- (void)setOrigine:(NSPoint)point;

- (NSXMLElement*)exportToModel;

- (void)setSizeAndPosition:(NSRect)rect;
- (NSRect)drawingBounds;
- (NSRect)getSizeAndPosition;

- (void)setVisible:(BOOL)visible;
- (BOOL)isVisible;

// fonction de dessin de l'objet -- A surcharger !
- (void)draw;

- (BOOL)containsPoint:(NSPoint)point;
- (void)updatePositionWithPoint:(NSPoint)point; //met a jour la position
- (void)hotUpdatePositionWithPoint:(NSPoint)point;//met à jour la position selon la position sauvegardé
- (void)fixDragWithPoint:(NSPoint)point; //fix la position de l'objet après le déplacement
- (void)savePosition; //sauvegarde la position et la taille en cours 

- (NSMutableDictionary*)getDataForSave;

- (NSColor*)changeColorSpaceNameToRVB:(NSColor*)oldColor; //change l'espace de couleur pour le RVB

@end
