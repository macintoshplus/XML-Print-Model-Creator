//
//  PMCModelEditor.h
//  XML Print Model Creator
//
//  Created by Jean-Baptiste Nahan on 08/02/09.
//  Copyright 2009 Jean-Baptiste Nahan. All rights reserved.
//

/*
 main_	: fenêtre document
 ol_	: objet contenu dans la vue ObjectList
 tool_	: objet pour les outils
 */

#import <Cocoa/Cocoa.h>
#import "PMCPage.h"
#import "PMCTrait.h"
#import "PMCRectangle.h"
#import "PMCText.h"
#import "PMCTableau.h"
#import "PMCFippedView.h"
#import "PMCPageView.h"
#import "PMCPicture.h"


@interface PMCBook : NSDocument <NSToolbarDelegate>
{
	IBOutlet NSView *main_ObjectListView;
	
    IBOutlet NSSplitView *main_SplitVertical;
    //IBOutlet NSSplitView *main_SplitPropertyVertical;
    IBOutlet NSScrollView *main_ScroolView;
    IBOutlet NSScrollView *main_ScroolPropertyView;
	IBOutlet NSView * tool_ZoomView;
	IBOutlet NSPopUpButton * tool_ZoomMenu;
	IBOutlet NSPopUpButton * ol_PageSelector;
	IBOutlet NSTableView * ol_ObjectTableView;
	IBOutlet NSView * export_exportExtentionSelector;
	IBOutlet NSPopUpButton * export_formatMenu;
	IBOutlet NSButton * export_oneFilePerPage;
	IBOutlet NSButton * export_onlyCurrentPage;
	IBOutlet NSMatrix * export_mode;
	IBOutlet NSButton * export_noExportEmptyPage;
	
	IBOutlet NSArrayController*	figuresArrayController;
	IBOutlet NSArrayController*	pagesArrayController;
	
	/* END PROPERTIES */
	
	NSSavePanel * _exportSavePanel;
	
	/*
	 * Variable contenant la liste des polices disponible et la liste des format papier et leur description.
	 */
	
	NSArray * _pageFormat;
	NSArray * _fontList;
	
	/*
	 * Variable d'instance pour le document.
	 * Ici les propriétés.
	 */
	
	int _format;
	int _orientation;
	
	BOOL _firstPage;
	BOOL _otherPage;
	BOOL _lastPage;
	
	NSString * _formatPagination;
	int _alignPagination;
	int _xPagination;
	int _yPagination;
	BOOL _enabledPagination;
	int _fontIndexPagination;
	int _fontSizePagination;
	NSColor * _colorFontPagination;
	BOOL _boldFontPagination;
	BOOL _italicFontPagination;
	BOOL _underlineFontPagination;
	
	/*
	 * Pointeur des 3 pages possibles en édition.
	 * La page en cour d'utilisation est accessible via le pointeur _actualPage
	 */
	NSMutableArray * pages;
	PMCPage * _actualPage;
	
	/*
	 * Ce tableau contien une copie du tableau contenan les lignes ou les colonnes d'un tableau.
	 * C'est une copie car il faut pouvoir annuler toutes les modifications effectué dans la feuille.
	 */
	NSMutableArray * _tmpArrayObjet;
	int _tmpLastIndexObj;
}

@property (readonly) NSArray * pageFormatList;
@property (readonly) NSArray * fontList;
@property (readonly) NSRect frameWidthFormatAndOrientation;

@property (readonly,assign) int pageFormat;
@property (readonly,assign) int pageOrientation;

@property (readonly,assign) BOOL firstPage;
@property (readonly,assign) BOOL otherPage;
@property (readonly,assign) BOOL lastPage;

@property (readonly,copy) NSString * formatPagination;
@property (readonly,assign) int paginationPositionX;
@property (readonly,assign) int paginationPositionY;
@property (readonly,assign) BOOL enabledPagination;

@property (readonly,copy) NSColor * textColor;
@property (readonly,assign) int textSize;
@property (readonly,assign) int textAlign;
@property (readonly,assign) int textFontIndex;
@property (readonly,assign) BOOL textBold;
@property (readonly,assign) BOOL textItalic;
@property (readonly,assign) BOOL textUnderline;

- (void)unselectObjet:(NSTimer*)theTimer;

- (void)writeSelectedObjectToPasteboard:(NSPasteboard*)pb;
- (BOOL)readObjectFromPasteboard:(NSPasteboard*)pb;

- (IBAction)tool_ZoomChange:(id)sender;

- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)tool_NewLine:(id)sender;
- (IBAction)tool_NewRect:(id)sender;
- (IBAction)tool_NewText:(id)sender;
- (IBAction)tool_NewArray:(id)sender;
- (IBAction)tool_NewPicture:(id)sender;
- (IBAction)tool_deleteSelectedObject:(id)sender;
- (IBAction)tool_orderUpSelectedObject:(id)sender;
- (IBAction)tool_orderDoubleUpSelectedObject:(id)sender;
- (IBAction)tool_orderDownSelectedObject:(id)sender;
- (IBAction)tool_orderDoubleDownSelectedObject:(id)sender;

- (IBAction)exportToPicture:(id)sender;
- (IBAction)export_extensionsChange:(id)sender;
- (NSData*)dataImageForPage:(int)pageIdx widthFormat:(int)intFormat;
- (IBAction)exportToModel:(id)sender;
- (IBAction)exportToSVG:(id)sender;

- (IBAction)importOldXMLSources:(id)sender;

- (void)setFirstPage:(BOOL)val;
- (void)setOtherPage:(BOOL)val;
- (void)setLastPage:(BOOL)val;
- (void)setPageFormat:(int)val;
- (void)setPageOrientation:(int)val;
- (void)setEnabledPagination:(BOOL)val;
- (void)setFormatPagination:(NSString*)val;
- (void)setPaginationPositionX:(int)val;
- (void)setPaginationPositionY:(int)val;

- (void)setTextColor:(NSColor*)val;
- (void)setTextSize:(int)val;
- (void)setTextAlign:(int)val;
- (void)setTextFontIndex:(int)val;
- (void)setTextBold:(BOOL)val;
- (void)setTextItalic:(BOOL)val;
- (void)setTextUnderline:(BOOL)val;

@end
