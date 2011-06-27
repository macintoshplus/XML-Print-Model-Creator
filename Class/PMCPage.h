//
//  PMCPages.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMCModelEditor;

@interface PMCPage : NSObject {
	
	NSString * title;
	
	NSMutableArray * _listObject;
	
	//NSBezierPath * bp;
	//NSBezierPath * bp2;
	
	id _delegate;
}

@property (copy) NSString * title;
@property (copy) NSMutableArray * _listObject;

- (void)setDelegate:(id)obj;
- (id)getDelegate;

- (int)objCount;
- (id)getObjectAtIndex:(int)index;
- (void)deleteObjectAtIndex:(int)index;
- (void)updateObject:(id)obj atPlan:(int)plan;
- (void)addObject:(id)obj atPlan:(int)plan;
- (void)placeObjectAtPlan:(int)fromPlan toPlan:(int)toPlan;

- (NSMutableArray*)getDataForSave;
- (void)setPageWithContent:(NSArray*)ar;

- (void)exportToModel:(NSXMLElement*)node;


@end
