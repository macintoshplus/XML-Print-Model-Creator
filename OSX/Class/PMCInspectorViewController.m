//
//  PMCInspectorViewController.m
//  XML Print Model Creator
//
//  Created by Jean Baptiste Nahan on 04/03/10.
//  Copyright 2010 Jean Baptiste Nahan. All rights reserved.
//

#import "PMCInspectorViewController.h"
#import "PMCPaletteInspectorViewController.h"
#import "PMCArrayInspectorViewController.h"
#import "PMCPropertiesView.h"

NSString* SelectionContext = @"selection";

@implementation PMCInspectorViewController

- (id) init
{
	if(self = [super init])
	{
		_sizeInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"SizeInspector" bundle:[NSBundle mainBundle]];
		[_sizeInspectorViewController loadView];
		
		_lineInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"LineInspector" bundle:[NSBundle mainBundle]];
		[_lineInspectorViewController loadView];
		
		_documentInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"DocumentInspector" bundle:[NSBundle mainBundle]];
		[_documentInspectorViewController loadView];
		
		_borderBackgroundInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"BorderBackgroundInspector" bundle:[NSBundle mainBundle]];
		[_borderBackgroundInspectorViewController loadView];
		
		_rectangleInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"RectangleInspector" bundle:[NSBundle mainBundle]];
		[_rectangleInspectorViewController loadView];
		
		_textInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"TextInspector" bundle:[NSBundle mainBundle]];
		[_textInspectorViewController loadView];
		
		_fontInspectorViewController = [[PMCPaletteInspectorViewController alloc] initWithNibName:@"FontInspector" bundle:[NSBundle mainBundle]];
		[_fontInspectorViewController loadView];
		
		_arrayInspectorViewController = [[PMCArrayInspectorViewController alloc] initWithNibName:@"ArrayInspector" bundle:[NSBundle mainBundle]];
		[_arrayInspectorViewController loadView];
		
		
	}
	
	return self;
}


- (void) awakeFromNib
{
	[figuresArrayController addObserver:self forKeyPath:@"selection" options:0 context:SelectionContext];
	[self observeValueForKeyPath:@"" ofObject:nil change:nil context:SelectionContext];
	
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == SelectionContext) 
	{
		// Determine the class of selected objects
		NSArray* selectedObjects = [object valueForKeyPath:@"selectedObjects"];
		Class objectsClass = [PMCInspectorViewController classOfObjects:selectedObjects];
		
		//retrait de toutes les palettes
		if([_sizeInspectorViewController viewVisible])
		{
			[_sizeInspectorViewController setRepresentedObject:nil];
			[_sizeInspectorViewController removeView];
		}
		if([_lineInspectorViewController viewVisible])
		{
			[_lineInspectorViewController setRepresentedObject:nil];
			[_lineInspectorViewController removeView];
		}
		if([_documentInspectorViewController viewVisible])
		{
			[_documentInspectorViewController setRepresentedObject:nil];
			[_documentInspectorViewController removeView];
		}
		if([_borderBackgroundInspectorViewController viewVisible])
		{
			[_borderBackgroundInspectorViewController setRepresentedObject:nil];
			[_borderBackgroundInspectorViewController removeView];
		}
		if([_rectangleInspectorViewController viewVisible])
		{
			[_rectangleInspectorViewController setRepresentedObject:nil];
			[_rectangleInspectorViewController removeView];
		}
		if([_fontInspectorViewController viewVisible])
		{
			[_fontInspectorViewController setRepresentedObject:nil];
			[_fontInspectorViewController removeView];
		}
		if([_arrayInspectorViewController viewVisible])
		{
			[_arrayInspectorViewController setRepresentedObject:nil];
			[_arrayInspectorViewController removeView];
		}
		if([_textInspectorViewController viewVisible])
		{
			[_textInspectorViewController setRepresentedObject:nil];
			[_textInspectorViewController removeView];
		}
		
		
		// Ajout des palettes
		PMCPropertiesView * pv = [[[PMCPropertiesView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 260.0, 1.0)] autorelease];
		
		//NSLog(@"setInspectorForObject: %@",name);
		if([selectedObjects count]==0){
			//Proptiété du document
			[_documentInspectorViewController setRepresentedObject:documentObjectController];
			[_documentInspectorViewController insertViewInSuperview:pv];
			
			[_fontInspectorViewController setRepresentedObject:documentObjectController];
			[_fontInspectorViewController insertViewInSuperview:pv];
			
		}else if([[objectsClass className] isEqualToString:@"PMCTrait"]){
			//Proptiété d'un trait
			[_lineInspectorViewController setRepresentedObject:figuresArrayController];
			[_lineInspectorViewController insertViewInSuperview:pv];
			
			[_sizeInspectorViewController setRepresentedObject:figuresArrayController];
			[_sizeInspectorViewController insertViewInSuperview:pv];
		}else if([[objectsClass className] isEqualToString:@"PMCText"]){
			//Proptiété d'un texte
			[_textInspectorViewController setRepresentedObject:figuresArrayController];
			[_textInspectorViewController insertViewInSuperview:pv];
			
			[_fontInspectorViewController setRepresentedObject:figuresArrayController];
			[_fontInspectorViewController insertViewInSuperview:pv];
			
			[_borderBackgroundInspectorViewController setRepresentedObject:figuresArrayController];
			[_borderBackgroundInspectorViewController insertViewInSuperview:pv];
			
			[_sizeInspectorViewController setRepresentedObject:figuresArrayController];
			[_sizeInspectorViewController insertViewInSuperview:pv];
		}else if([[objectsClass className] isEqualToString:@"PMCRectangle"]){
			//Proptiété d'un rectangle
			[_rectangleInspectorViewController setRepresentedObject:figuresArrayController];
			[_rectangleInspectorViewController insertViewInSuperview:pv];
			
			[_borderBackgroundInspectorViewController setRepresentedObject:figuresArrayController];
			[_borderBackgroundInspectorViewController insertViewInSuperview:pv];
			
			[_sizeInspectorViewController setRepresentedObject:figuresArrayController];
			[_sizeInspectorViewController insertViewInSuperview:pv];
		}else if([[objectsClass className] isEqualToString:@"PMCTableau"]){
			//Proptiété d'un tableau
			[_arrayInspectorViewController setRepresentedObject:figuresArrayController];
			[_arrayInspectorViewController insertViewInSuperview:pv];
			
			[_borderBackgroundInspectorViewController setRepresentedObject:figuresArrayController];
			[_borderBackgroundInspectorViewController insertViewInSuperview:pv];
			
			[_sizeInspectorViewController setRepresentedObject:figuresArrayController];
			[_sizeInspectorViewController insertViewInSuperview:pv];
		}else{
			//Affiche la palette de la taille/position pour les objets selectionné qui ne sont pas du même type !
			[_sizeInspectorViewController setRepresentedObject:figuresArrayController];
			[_sizeInspectorViewController insertViewInSuperview:pv];
		}
		
		[inspectorView setDocumentView:pv];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

// Returns the class of an array of objects.
// If the objects don't have the same class, NULL is returned.
+ (Class) classOfObjects:(NSArray*)objects
{
	Class objectsClass;
	NSEnumerator* enumerator = [objects objectEnumerator];
	
	// Take the class of the first object
	objectsClass = [[enumerator nextObject] class];
	
	// Compare other objects class with the 1st object's.
	id object;
	while(object = [enumerator nextObject])
	{
		if([object class] != objectsClass)	// The current object has not the same class as previous ones
		{
			objectsClass = NULL;	
		}
	}
	
	return objectsClass;
}

	
@end
