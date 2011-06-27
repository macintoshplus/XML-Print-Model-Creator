//
//  PMCPages.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PMCObjectPageDidChange @"PMCObjectPageDidChange"

@class PMCModelEditor;

@interface PMCPages : NSView {
	
	NSRect originalFrame;
	NSRect originalBounds;
	
	NSMutableArray * _listObject;
	
	float _zoom;
	NSBezierPath * bp;
	NSBezierPath * bp2;
	
	NSPoint _startDrag;
	int _objSelected;
	
	id _delegate;
}


- (float)actualZoom;
- (void)setZoom:(float)newZoom;
//- (void)testSizeAndCenter; //teste la taille et centre le dessin --- MARCHE PAS BIEN ---


- (void)setDelegate:(id)obj;
- (id)getDelegate;

- (void)reDraw;
- (int)objCount;
- (id)getObjectAtIndex:(int)index;
- (void)deleteObjectAtIndex:(int)index;
- (void)updateObject:(id)obj atPlan:(int)plan;
- (void)addObject:(id)obj atPlan:(int)plan;
- (void)placeObjectAtPlan:(int)fromPlan toPlan:(int)toPlan;
- (void)searchObjectAtPoint:(NSPoint)point;

- (NSMutableArray*)getDataForSave;
- (void)setPageWithContent:(NSArray*)ar;

- (void)setSelectedObject:(int)index;
- (void)clearSelectedObject;
- (int)getSelectedObjectIndex;
- (void)exportToModel:(NSXMLElement*)node;

- (IBAction)deleteSelectedObject:(id)sender;
- (IBAction)orderUpSelectedObject:(id)sender;
- (IBAction)orderDoubleUpSelectedObject:(id)sender;
- (IBAction)orderDownSelectedObject:(id)sender;
- (IBAction)orderDoubleDownSelectedObject:(id)sender;

@end
