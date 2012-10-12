//
//  PMCPageView.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 05/03/10.
//  Copyright 2010 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PMCBook.h"

@class PMCFigure;
@class PMCBook;

@interface PMCPageView : NSView {
	
	NSArray *oldFigures;
	NSMutableDictionary *bindingInfo;
	
	float _zoom;
	
	NSRect originalFrame;
	NSRect originalBounds;
	
	NSPoint _startDrag;
	
    PMCBook * book;
    
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
@property (readonly) id paginationContainer;
@property (readonly) NSString *paginationKeyPath;


@property (readonly) NSString * formatPaginationKeyPath;
@property (readonly) NSString * paginationPositionXKeyPath;
@property (readonly) NSString * paginationPositionYKeyPath;
@property (readonly) NSString * enabledPaginationKeyPath;

@property (readonly) NSString * textColorKeyPath;
@property (readonly) NSString * textSizeKeyPath;
@property (readonly) NSString * textAlignKeyPath;
@property (readonly) NSString * textFontIndexKeyPath;
@property (readonly) NSString * textBoldKeyPath;
@property (readonly) NSString * textItalicKeyPath;
@property (readonly) NSString * textUnderlineKeyPath;


@property (readonly) id formatPaginationContainer;
@property (readonly) id paginationPositionXContainer;
@property (readonly) id paginationPositionYContainer;
@property (readonly) id enabledPaginationContainer;

@property (readonly) id textColorContainer;
@property (readonly) id textSizeContainer;
@property (readonly) id textAlignContainer;
@property (readonly) id textFontIndexContainer;
@property (readonly) id textBoldContainer;
@property (readonly) id textItalicContainer;
@property (readonly) id textUnderlineContainer;


@property (readonly) NSArray *figures;
@property (readonly) NSIndexSet *selectionIndexes;
@property (retain) PMCBook * book;


@end
