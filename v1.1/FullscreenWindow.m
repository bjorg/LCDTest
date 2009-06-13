// Copyright 2004 Steve Bjorg
//
// This file is part of LCDTest.
// 
// LCDTest is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// LCDTest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with LCDTest; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#import "FullscreenWindow.h"
#import "PatternView.h"
#import <ApplicationServices/ApplicationServices.h>


@implementation FullscreenWindow

- (id)initFullScreenWithTestMode:(TestMode)testMode withScreen:(NSScreen*)screen {
	
	// capture the complete screen
	NSNumber* screen_number = [[screen deviceDescription] objectForKey:@"NSScreenNumber"];
	CGDirectDisplayID display_id = (CGDirectDisplayID)[screen_number pointerValue];
	if(CGDisplayCapture(display_id) != kCGErrorSuccess) {
		NSLog(@"unable to capture display(s)");
		
		// TODO: show error message
		
		return nil;
	}
	NSLog(@"display(s) captured");
	
	// determine appropriate window level so that no window occurs in front of our fullscreen window
	int window_level = CGShieldingWindowLevel();
	
	// retrieve screen size for main screen
	NSRect screen_rectangle = [screen frame];
	
	// the origin contains the offset from the main frame, we don't need it
	screen_rectangle.origin.x = 0;
	screen_rectangle.origin.y = 0;
	
	// continue base class initialization
	self = [super initWithContentRect:screen_rectangle styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:screen];
	if(self == nil) {
		NSLog(@"super initialization failed");
		if(CGReleaseAllDisplays() != kCGErrorSuccess) {
			NSLog(@"unable to release display(s)");
			[NSApp terminate:nil];
		} else {
			NSLog(@"display(s) released");
		}
		return nil;
	}

	// set window level to the top-most position
	[self setLevel:window_level];
	
	// add test view to window
    [self setContentView:[[[PatternView alloc] initWithFrame:screen_rectangle withTestMode:testMode] autorelease]];
	
	// hide cursor
	[NSCursor hide];
	
	// return result
	return self;
}

- (id)initDeadPixelsTestWithScreen:(NSScreen*)screen {
	
	// call the common initializer with the dead-pixel constant
	return [self initFullScreenWithTestMode:TESTMODE_DEAD_PIXELS withScreen:screen];
}

- (id)initColorGradientTestWithScreen:(NSScreen*)screen {

	// call the common initializer with the color-gradient constant
	return [self initFullScreenWithTestMode:TESTMODE_COLOR_GRADIENT withScreen:screen];
//	return [self initFullScreenWithTestMode:TESTMODE_PIXEL_RESPONSE_TIME withScreen:screen];
}

- (id)initPanelAlignmentTestWithScreen:(NSScreen*)screen {
	
	// call the common initializer with the panel-alignment constant
	return [self initFullScreenWithTestMode:TESTMODE_PANEL_ALIGNMENT withScreen:screen];
}

- (id)initCalibrationTestWithScreen:(NSScreen*)screen {
	
	// call the common initializer with the calibration constant
	return [self initFullScreenWithTestMode:TESTMODE_CALIBRATION withScreen:screen];
}

- (BOOL)canBecomeKeyWindow {
	
	// we need to return YES so that we can receive keyboard events.
	return YES;
}

- (void)close {
	
	// release the display we captured
	if(CGReleaseAllDisplays() != kCGErrorSuccess) {
		
		// failed to release, terminating the application seems to be only way out!
		NSLog(@"unable to release display(s)");
		[NSCursor unhide];
		[NSApp terminate:nil];
		return;
	}
	NSLog(@"display(s) released");
	
	// show cursor
	[NSCursor unhide];

	// close window
	[super close];
}

@end
