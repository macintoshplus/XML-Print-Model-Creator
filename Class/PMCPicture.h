//
//  PMCPicture.h
//  XML Print Model Creator 10.8
//
//  Created by Jean-Baptiste Nahan on 12/10/12.
//  Copyright (c) 2012 Jean-Baptiste Nahan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMCRectangle.h"

@interface PMCPicture : PMCRectangle {

    NSImage * _image;
}

@property (readonly, retain) NSImage * image;

- (id)init;
- (id)initWithData:(NSDictionary*)dico;
- (NSXMLElement*)exportToModel;

- (NSMutableDictionary*)getDataForSave;

- (void)draw;

- (void)selectFile;

@end
