//
//  DMComposeViewController.m
//  DotMail
//
//  Created by Robert Widmann on 7/1/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMComposeViewController.h"
#import "DMComposeView.h"
#import "DMToolbarView.h"
#import "DMToolbarButton.h"
#import "DMTokenizingEmailField.h"
#import "MTTokenFieldCell.h"
#import "DMComposeViewModel.h"
#import "DMPopUpButton.h"
#import "MKColorWell.h"
#import "DMFontMenu.h"
#import "DMComposerDocument.h"
#import "DMShadowView.h"
#import "DMLayeredScrollView.h"
#import "DMLabel.h"
#import <Puissant/Puissant.h>

static NSString *const DMTextDidBeginEditingNotification = @"DMTextDidBeginEditingNotification";

@implementation DMComposeViewController

- (instancetype)initWithContentRect:(NSRect)frame inWindow:(NSWindow *)window {
	self = [super init];
	
	_frame = frame;
	_bindingWindow = window;
	_viewModel = [[DMComposeViewModel alloc]init];
	
	return self;
}

- (void)loadView {
	DMComposeView *view = [[DMComposeView alloc]initWithFrame:_frame];
	
	DMToolbarView *toolbar = [[DMToolbarView alloc]initWithFrame:(NSRect){ .origin.y = CGRectGetHeight(_frame) - 48, .size.width = CGRectGetWidth(_frame), .size.height = 48 }];
	toolbar.autoresizingMask = NSViewWidthSizable | NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin;
	
	DMToolbarButton *attachmentButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ComposeToolbarAttach.png"]];
	attachmentButton.frame = (NSRect){ .size = { 30, 30 } };
	[attachmentButton.rac_selectionSignal subscribeNext:^(id _) {
		[[view.window.windowController document] showAttachFilesWindow:nil];
	}];
	
	[toolbar setLeftButtonItem:attachmentButton];
	
	DMToolbarButton *sendButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"SendBtn"]];
	sendButton.frame = (NSRect){ .size = { 80, 28 } };
	@weakify(self);
	sendButton.rac_command = [[RACCommand alloc]initWithEnabled:self.viewModel.sendValidationSignal signalBlock:^RACSignal *(id input) {
		return [RACSignal return:input];
	}];
	[[sendButton.rac_command.executionSignals flattenMap:^RACStream*(id value) {
		@strongify(self);
		return [[self.viewModel sendMessage] doCompleted:^{
			[self.view.window close];
		}];
	}] subscribeCompleted:^{
	}];
	[toolbar setRightButtonItem:sendButton];
	
	DMToolbarButton *saveButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"SaveBtn"]];
	saveButton.frame = (NSRect){ .origin.x = NSMinX(sendButton.frame) - 90, .origin.y = NSMinY(sendButton.frame), .size = { 80, 28 } };
	[saveButton.rac_selectionSignal subscribeNext:^(id _){
		[(DMComposerDocument *)[view.window.windowController document] saveMessage:NSApp];
	}];
	saveButton.autoresizingMask = NSViewMinXMargin;
	[toolbar addSubview:saveButton];
	
	DMLabel *toLabel = [[DMLabel alloc]initWithFrame:(NSRect){ .origin.x = 20, .origin.y = CGRectGetHeight(_frame) - 76, .size = { 30, 20 } }];
	toLabel.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
	toLabel.text = @"To:";
	toLabel.font = [NSFont fontWithName:@"Helvetica-Bold" size:13];
	toLabel.textColor = [NSColor colorWithCalibratedWhite:0.830 alpha:1.000];
	[view addSubview:toLabel];
	
	DMTokenizingEmailField *toField = [[DMTokenizingEmailField alloc]initWithFrame:(NSRect){ .origin.x = 50, .origin.y = CGRectGetHeight(_frame) - 72, .size.width = NSWidth(_frame) - 44, .size.height = 19 }];
	toField.delegate = self.viewModel;
	toField.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin | NSViewWidthSizable;
	[toField setBordered:NO];
	[toField setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.f]];
	[toField setBezeled:NO];
	[toField setFocusRingType:NSFocusRingTypeNone];
	[toField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
	[toField setDelegate:self];
	[view addSubview:toField];
	RACChannelTo(self.viewModel,toFieldAddresses) = RACChannelTo(toField,tokenArray);

	DMLabel *ccLabel = [[DMLabel alloc]initWithFrame:(NSRect){ .origin.x = 20, .origin.y = CGRectGetHeight(_frame) - 108, .size = { 30, 20 } }];
	ccLabel.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
	ccLabel.text = @"Cc:";
	ccLabel.font = [NSFont fontWithName:@"Helvetica-Bold" size:13];
	ccLabel.textColor = [NSColor colorWithCalibratedWhite:0.830 alpha:1.000];
	[view addSubview:ccLabel];
	
	DMTokenizingEmailField *ccField = [[DMTokenizingEmailField alloc]initWithFrame:(NSRect){ .origin.x = 50, .origin.y = CGRectGetHeight(_frame) - 104, .size.width = (NSWidth(_frame)/2) - 44, .size.height = 19 }];
	ccField.delegate = self.viewModel;
	ccField.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin | NSViewWidthSizable;
	[ccField setBordered:NO];
	[ccField setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.f]];
	[ccField setBezeled:NO];
	[ccField setFocusRingType:NSFocusRingTypeNone];
	[ccField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
	[ccField setDelegate:self];
	[view addSubview:ccField];
	RACChannelTo(self.viewModel,ccFieldAddresses) = RACChannelTo(ccField,addresses);
	
	DMTokenizingEmailField *bccField = [[DMTokenizingEmailField alloc]initWithFrame:(NSRect){ .origin.x = (NSWidth(_frame)/2) - 18 + 35, .origin.y = CGRectGetHeight(_frame) - 108, .size.width = (NSWidth(_frame)/2) - 44, .size.height = 19 }];
	bccField.delegate = self.viewModel;
	bccField.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin | NSViewWidthSizable;
	[bccField setBordered:NO];
	[bccField setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.f]];
	[bccField setBezeled:NO];
	[bccField setFocusRingType:NSFocusRingTypeNone];
	[bccField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
	[bccField setDelegate:self];
	[view addSubview:bccField];
	RAC(self.viewModel,bccFieldAddresses) = [RACObserve(bccField,tokenArray) flattenMap:^RACStream *(id value) {
		return [RACSignal return:bccField.addresses];
	}];
	
	DMLabel *subjectLabel = [[DMLabel alloc]initWithFrame:(NSRect){ .origin.x = 20, .origin.y = CGRectGetHeight(_frame) - 140, .size = { 60, 20 } }];
	subjectLabel.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
	subjectLabel.text = @"Subject:";
	subjectLabel.font = [NSFont fontWithName:@"Helvetica-Bold" size:13];
	subjectLabel.textColor = [NSColor colorWithCalibratedWhite:0.830 alpha:1.000];
	[view addSubview:subjectLabel];	
	
	NSTextField *subjectField = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = NSMaxX(subjectLabel.frame), .origin.y = CGRectGetHeight(_frame) - 146, .size.width = NSWidth(_frame) - NSMinX(subjectLabel.frame), .size.height = 30 }];
	subjectField.drawsBackground = NO;
	subjectField.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin | NSViewWidthSizable;
	[subjectField setBordered:NO];
	[subjectField setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.f]];
	[subjectField setBezeled:NO];
	[subjectField setFocusRingType:NSFocusRingTypeNone];
	[subjectField setDelegate:self];
	[view addSubview:subjectField];
	RAC(_bindingWindow,title) = [RACSignal if:[subjectField.rac_textSignal map:^id(NSString *value) {
		return @(value.length != 0);
	}] then:RACObserve(subjectField,stringValue) else:[RACSignal return:@"(No subject)"]];
	[self.viewModel rac_liftSelector:@selector(setSubject:) withSignals:subjectField.rac_textSignal, nil];
	[subjectField rac_liftSelector:@selector(setStringValue:) withSignals:[RACObserve(self.viewModel,subject) filter:^BOOL(id value) {
		return value != nil;
	}], nil];
	
	DMLabel *fromLabel = [[DMLabel alloc]initWithFrame:(NSRect){ .origin.x = 20, .origin.y = CGRectGetHeight(_frame) - 170, .size = { 50, 20 } }];
	fromLabel.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
	fromLabel.text = @"From:";
	fromLabel.font = [NSFont fontWithName:@"Helvetica-Bold" size:13];
	fromLabel.textColor = [NSColor colorWithCalibratedWhite:0.830 alpha:1.000];
	[view addSubview:fromLabel];	
	
	DMPopUpButton *accountsPopupButton = [[DMPopUpButton alloc]initWithFrame:(NSRect){ .origin.x = 72, .origin.y = CGRectGetHeight(_frame) - 174, .size.height = 36, .size.width = NSWidth(_frame) - 76 }];
	accountsPopupButton.autoresizingMask = NSViewMinYMargin | NSViewWidthSizable;
	accountsPopupButton.autoenablesItems = YES;
	[accountsPopupButton setBordered:NO];
	[accountsPopupButton setTransparent:NO];
	[view addSubview:accountsPopupButton];
	[[[RACObserve(PSTAccountManager.defaultManager,accounts) doNext:^(id x) {
		[accountsPopupButton removeAllItems];
	}] flattenMap:^RACStream *(NSArray *accounts) {
		@strongify(self);
		NSMutableArray *fromEmails = @[].mutableCopy;
		for (PSTMailAccount *account in accounts) {
			if (!self.viewModel.email) {
				self.viewModel.email = account.email;
			}
			NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
			[dict setObject:account forKey:@"Account"];
			[dict setObject:account.email forKey:@"Email"];
			[dict setObject:account.name forKey:@"Name"];
			[fromEmails addObject:dict];
		}
		return [RACSignal return:fromEmails];
	}] subscribeNext:^(NSArray *fromEmails) {
		for (NSMutableDictionary *accountDict in fromEmails) {
			MCOAddress *address = [MCOAddress addressWithDisplayName:[accountDict objectForKey:@"Name"] mailbox:[accountDict objectForKey:@"Email"]];
			NSMenuItem *newItem = [[NSMenuItem alloc]initWithTitle:@"" action:NULL keyEquivalent:@""];
			NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
			[attributes setObject:[NSFont fontWithName:@"HelveticaNeue-Bold" size:12] forKey:NSFontAttributeName];
			NSAttributedString *attribTitle = [[NSAttributedString alloc]initWithString:[address nonEncodedRFC822String] attributes:attributes];
			[newItem setAttributedTitle:attribTitle];
			[accountsPopupButton.menu addItem:newItem];
		}
	}];
	[accountsPopupButton.rac_selectionSignal subscribeNext:^(NSPopUpButton *button) {
		@strongify(self);
		self.viewModel.email = button.titleOfSelectedItem;
	}];
	
	WebView *textView = [[WebView alloc]initWithFrame:(NSRect){ .size.width = NSWidth(_frame), .size.height = NSHeight(_frame) - 220 } frameName:nil groupName:nil];
	textView.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
	[view addSubview:textView];
	[textView setEditingDelegate:self];
	[textView setFrameLoadDelegate:self];
	[textView setPolicyDelegate:self];
	[textView setResourceLoadDelegate:self];
	[textView setUIDelegate:self];
	[textView.mainFrame loadHTMLString:[PSTConversation emptyMessageHTML] baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];

	NSView *editingToolbar = [[NSView alloc]initWithFrame:(NSRect){ .origin.y = CGRectGetHeight(_frame) - 220, .size.width = CGRectGetWidth(_frame), .size.height = 48 }];
	editingToolbar.autoresizingMask = NSViewWidthSizable | NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin;
	
	DMPopUpButton *fontPopupButton = [[DMPopUpButton alloc]initWithFrame:(NSRect){ .origin.x = 12, .origin.y = 18, .size = { 90, 26 } }];
	fontPopupButton.autoenablesItems = YES;
	[fontPopupButton setBordered:NO];
	[fontPopupButton setTransparent:NO];
	[fontPopupButton setMenu:DMFontMenu.sharedFontMenu];
	[editingToolbar addSubview:fontPopupButton];
	
	DMPopUpButton *fontSizePopupButton = [[DMPopUpButton alloc]initWithFrame:(NSRect){ .origin.x = 108, .origin.y = 18, .size = { 42, 26 } }];
	fontSizePopupButton.autoenablesItems = YES;
	[fontSizePopupButton setBordered:NO];
	[fontSizePopupButton setTransparent:NO];
	[RACObserve(self.viewModel,fontSizesArray) subscribeNext:^(NSArray *fontSizeArray) {
		[fontSizePopupButton removeAllItems];
		int iter = 0;
		for (NSString *fontSize in fontSizeArray) {
			NSMenuItem *newItem = [[NSMenuItem alloc]initWithTitle:fontSize action:NULL keyEquivalent:@""];
			NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
			[attributes setObject:[NSFont fontWithName:@"HelveticaNeue" size:12] forKey:NSFontAttributeName];
			NSAttributedString *attribTitle = [[NSAttributedString alloc]initWithString:fontSize attributes:attributes];
			[newItem setAttributedTitle:attribTitle];
			[fontSizePopupButton.menu addItem:newItem];
			if (fontSize.integerValue == 14) {
				[fontSizePopupButton selectItemAtIndex:iter];
			}
			iter++;
		}
	}];
	
	[editingToolbar addSubview:fontSizePopupButton];
	
	MKColorWell *colorWell = [[MKColorWell alloc]initWithFrame:(NSRect){ .origin.x = 162, .origin.y = 22, .size = { 13, 4 } }];
	[colorWell awakeFromNib];
	colorWell.color = NSColor.blackColor;
	[colorWell setAnimatePopover:YES];
	[RACObserve(colorWell,color) subscribeNext:^(NSColor *color) {

	}];

	[editingToolbar addSubview:colorWell];
	
	NSButton *fontColorLabel = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = 162, .origin.y = 25, .size = { 13, 17 } }];
	fontColorLabel.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
	[fontColorLabel setBordered:NO];
	[fontColorLabel setAlignment:NSLeftTextAlignment];
	[fontColorLabel setBordered:NO];
	[fontColorLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:13.f]];
	[fontColorLabel setFocusRingType:NSFocusRingTypeNone];
	[fontColorLabel.cell setTruncatesLastVisibleLine:YES];
	fontColorLabel.title = @"A";
	fontColorLabel.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal return:input];
	}];
	[[RACSignal merge:@[ fontColorLabel.rac_command.executionSignals, self.viewModel.colorWellMenuSignal ]] subscribeNext:^(id _) {
		[colorWell mouseDown:NSApplication.sharedApplication.currentEvent];
	}];
	
	[editingToolbar addSubview:fontColorLabel];

	DMToolbarButton *boldButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"BoldStyleBtn"]];
	boldButton.frame = (NSRect){ .origin.x = 202, .origin.y = 20, .size = { 16, 22 } };
	[editingToolbar addSubview:boldButton];
	
	DMToolbarButton *italicButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ItalicStyleBtn"]];
	italicButton.frame = (NSRect){ .origin.x = 222, .origin.y = 20, .size = { 16, 22 } };
	[editingToolbar addSubview:italicButton];
	
	DMToolbarButton *underlineButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"UnderlineStyleBtn"]];
	underlineButton.frame = (NSRect){ .origin.x = 242, .origin.y = 18, .size = { 16, 22 } };
	[editingToolbar addSubview:underlineButton];
	
	DMToolbarButton *leftAlignmentButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ParagraphLeft"]];
	leftAlignmentButton.frame = (NSRect){ .origin.x = 270, .origin.y = 25, .size = { 12, 12 } };
	[leftAlignmentButton setTarget:textView];	[leftAlignmentButton setAction:@selector(alignLeft:)];
	[editingToolbar addSubview:leftAlignmentButton];
	
	DMToolbarButton *centerAlignmentButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ParagraphCenter"]];
	centerAlignmentButton.frame = (NSRect){ .origin.x = 290, .origin.y = 25, .size = { 12, 12 } };
	[centerAlignmentButton setTarget:textView];
	[centerAlignmentButton setAction:@selector(alignCenter:)];
	[editingToolbar addSubview:centerAlignmentButton];
	
	DMToolbarButton *rightAlignmentButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ParagraphRight"]];
	rightAlignmentButton.frame = (NSRect){ .origin.x = 310, .origin.y = 25, .size = { 12, 12 } };
	[rightAlignmentButton setTarget:textView];
	[rightAlignmentButton setAction:@selector(alignRight:)];
	[editingToolbar addSubview:rightAlignmentButton];

	[view addSubview:editingToolbar];
		
	DMShadowView *shadowView = [[DMShadowView alloc]initWithFrame:(NSRect){ .size.width = CGRectGetWidth(_frame), .size.height = 100 }];
	[view addSubview:shadowView];
	
	NSScrollView *containerScrollView = [[DMLayeredScrollView alloc]initWithFrame:(NSRect){ .size.width = CGRectGetWidth(_frame), .size.height = 75 }];
	containerScrollView.backgroundColor = [NSColor colorWithCalibratedWhite:1.000 alpha:1.000];
	containerScrollView.hasHorizontalScroller = YES;
	
	IKImageBrowserView *attachmentImageBrowserView = [[IKImageBrowserView alloc]initWithFrame:containerScrollView.bounds];
	[attachmentImageBrowserView registerForDraggedTypes:@[ NSFilenamesPboardType ]];
	attachmentImageBrowserView.cellsStyleMask = IKCellsStyleTitled | IKCellsStyleShadowed;
	attachmentImageBrowserView.intercellSpacing = (NSSize){ 20, 20 };
	attachmentImageBrowserView.cellSize = (NSSize){ 128, 32 };
	attachmentImageBrowserView.dataSource = self.viewModel;
	attachmentImageBrowserView.draggingDestinationDelegate = self.viewModel;
	containerScrollView.documentView = attachmentImageBrowserView;
	[view addSubview:containerScrollView];
	
	[[RACObserve(self.viewModel,files) map:^id (NSArray *x) {
		shadowView.hidden = (x.count == 0);
		containerScrollView.hidden = (x.count == 0);
		[attachmentImageBrowserView reloadData];
		return @(containerScrollView.isHidden);
	}] subscribeNext:^(NSNumber *hidden) {
		textView.frame = hidden.boolValue ? (NSRect){ .origin.y = 10, .size.width = NSWidth(_frame), .size.height = NSHeight(_frame) - 220 } : (NSRect){ .origin.y = 85, .size.width = NSWidth(_frame) - 20, .size.height = NSHeight(_frame) - 305 };
	}];
	
	[view addSubview:toolbar];

	self.view = view;
}

- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowScriptObject forFrame:(WebFrame *)frame {	
	[webView.windowScriptObject setValue:self forKey:@"WindowController"];
}


@end
