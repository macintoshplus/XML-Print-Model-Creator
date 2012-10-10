//
//  PMCPages.m
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import "PMCPage.h"


@implementation PMCPage

@synthesize title;
@synthesize _listObject;

#pragma mark INIT
- (id)initWithFrame:(NSRect)frame {
    self = [super init];
    if (self) {
				
		_listObject = [[NSMutableArray alloc] init];
		
	}
    return self;
}

#pragma mark -
#pragma mark Delegate

- (void)setDelegate:(id)obj{
	_delegate=obj;
}

- (id)getDelegate{
	return _delegate;
}

#pragma mark -
#pragma mark Gestion des Objets

- (int)objCount
{
	return [_listObject count];
}

- (id)getObjectAtIndex:(int)index
{
	return [_listObject objectAtIndex:index];
}

- (void)deleteObjectAtIndex:(int)index
{
	[self willChangeValueForKey:@"_listObject"];
	NSUndoManager * undo = [_delegate undoManager];
	[[undo prepareWithInvocationTarget:self] addObject:[_listObject objectAtIndex:index] atPlan:index];
	if(![undo isUndoing]){
		[undo setActionName:@"delete object"];
	}
	[_listObject removeObjectAtIndex:index];
	
	[self didChangeValueForKey:@"_listObject"];
}

- (void)updateObject:(id)obj atPlan:(int)plan
{
	[self willChangeValueForKey:@"_listObject"];
	[self deleteObjectAtIndex:plan];
	[self addObject:obj atPlan:plan];
	[self didChangeValueForKey:@"_listObject"];
}

- (void)addObject:(id)obj atPlan:(int)plan
{
	//NSLog(@"addObjet : %@ (%@) AtPlan:%i",[obj name], [obj className], plan);
	
	[self willChangeValueForKey:@"_listObject"];
	NSUndoManager * undo = [_delegate undoManager];
	[[undo prepareWithInvocationTarget:self] deleteObjectAtIndex:plan];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMAddObject",@"Localizable",@"Undo Manager Action")];
	}
	[_listObject insertObject:[obj retain] atIndex:plan];
	
	
	[self didChangeValueForKey:@"_listObject"];
	//NSLog(@"Ajout Objet ! (%i)",[_listObject count]);
}

- (void)placeObjectAtPlan:(int)fromPlan toPlan:(int)toPlan
{
	
	[self willChangeValueForKey:@"_listObject"];
	id obj = [[_listObject objectAtIndex:fromPlan] retain];
	[_listObject removeObjectAtIndex:fromPlan];
	
	[_listObject insertObject:obj atIndex:toPlan];
	[obj release];
		
	NSUndoManager * undo = [_delegate undoManager];
	[[undo prepareWithInvocationTarget:self] placeObjectAtPlan:toPlan toPlan:fromPlan];
	if(![undo isUndoing]){
		[undo setActionName:NSLocalizedStringFromTable(@"UMChangePlan",@"Localizable",@"Undo Manager Action")];
	}
	
	[self didChangeValueForKey:@"_listObject"];
}





#pragma mark -
#pragma mark Other
- (NSMutableArray*)getDataForSave{
	NSMutableArray * ar = [[[NSMutableArray alloc] init] autorelease];
	int max=[_listObject count];
	int i;
	for(i=0;i<max;i++){
		[ar insertObject:[[_listObject objectAtIndex:i] getDataForSave] atIndex:0];
	}
	return ar;//[NSArchiver archivedDataWithRootObject:ar];
}

- (void)setPageWithContent:(NSArray*)ar{
	
}

#pragma mark -
#pragma mark Gestion Souris

/*
- (void)moveDown:(id)sender{
	if(_objSelected>-1){
		NSPoint diff = NSMakePoint(0, 1);
		NSLog(@"Difference %@  !",NSStringFromPoint(diff));
		[[_listObject objectAtIndex:_objSelected] updatePositionWithPoint:diff];
		[self setNeedsDisplay:TRUE];
	}
}*/

#pragma mark -

- (void)exportToModel:(NSXMLElement*)node{
	int i;
	int max=[_listObject count];
	
	for (i=0; i<max; i++) {
		if([[_listObject objectAtIndex:max-i-1] isVisible]) [node addChild:[(PMCFigure*)[_listObject objectAtIndex:max-i-1] exportToModel]];
	}
	
}

@end
