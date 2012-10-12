//
//  PMCInspectorViewController.h
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 04/03/10.
//  Copyright 2010 Jean Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMCPaletteInspectorViewController;
@class PMCArrayInspectorViewController;

@interface PMCInspectorViewController : NSObject {
	
	IBOutlet NSArrayController*	figuresArrayController;
	IBOutlet NSObjectController*	documentObjectController;
	IBOutlet NSScrollView*		inspectorView;
	
	PMCPaletteInspectorViewController * _sizeInspectorViewController;
	PMCPaletteInspectorViewController * _lineInspectorViewController;
	PMCPaletteInspectorViewController * _documentInspectorViewController;
	PMCPaletteInspectorViewController * _borderBackgroundInspectorViewController;
	PMCPaletteInspectorViewController * _rectangleInspectorViewController;
	PMCPaletteInspectorViewController * _textInspectorViewController;
	PMCPaletteInspectorViewController * _fontInspectorViewController;
	PMCPaletteInspectorViewController * _pictureInspectorViewController;
	PMCArrayInspectorViewController * _arrayInspectorViewController;
}

+ (Class) classOfObjects:(NSArray*)objects;

@end
