//
//  PMCPageView.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 05/03/10.
//  Copyright 2010 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMCFigure;

@interface PMCPageView : NSView {
	
	NSArray *oldFigures;
	NSMutableDictionary *bindingInfo;
	
	float _zoom;
	
	NSRect originalFrame;
	NSRect originalBounds;
	
	NSPoint _startDrag;
	
}

@property (readonly,assign) float zoom;
@property (copy) NSArray *oldFigures;

- (void)sendNotificationOpenRowSheet:(id)sender;
- (void)sendNotificationOpenColSheet:(id)sender;

- (void)startObservingFigures:(NSArray *)figures;
- (void)stopObservingFigures:(NSArray *)figures;

- (void)setZoom:(float)newZoom;

// bindings-related -- infoForBinding and convenience methods

- (NSDictionary *)infoForBinding:(NSString *)bindingName;

@property (readonly) id figuresContainer;
@property (readonly) NSString *figuresKeyPath;
@property (readonly) id selectionIndexesContainer;
@property (readonly) NSString *selectionIndexesKeyPath;
@property (readonly) id formatContainer;
@property (readonly) NSString *formatKeyPath;
@property (readonly) id orientationContainer;
@property (readonly) NSString *orientationKeyPath;
@property (readonly) NSArray *figures;
@property (readonly) NSIndexSet *selectionIndexes;


@end
