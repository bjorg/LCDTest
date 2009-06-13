// Copyright 2004, 2005 Steve Bjorg
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

#import "PatternView.h"


@implementation PatternView

- (id)initWithFrame:(NSRect)frame {
	return [self initWithFrame:frame asPreview:NO];
}

- (id)initWithFrame:(NSRect)frame asPreview:(bool)preview_only {
	if(self = [super initWithFrame:frame]) {
		
		// set our starting state
		state = 0;
		preview = preview_only;
	}
	return self;
}

- (void)nextState {

	// increase state
	++state;
	NSLog(@"next state %d", state);
			
	// force refresh
	[self setNeedsDisplay:YES];
}

- (void)prevState {
	
	// increase state
	--state;
	NSLog(@"previous state %d", state);
	
	// force refresh
	[self setNeedsDisplay:YES];
}

- (void)close {
	[[self window] close];
}

- (BOOL)isOpaque {
	
	// let the display sub-system know that it doesn't need to draw 
	// items covered by this view control
    return YES;
}

- (BOOL)acceptsFirstResponder {
	
	// indicate that we are willing to get keyboard events
	return !preview;
}

- (void)mouseUp:(NSEvent*)event {
	if(!preview) {
		
		// mouse-clicks change the state
		[self nextState];
	}
}

- (void)keyDown:(NSEvent*)event {
	if(!preview) {
		
		// check which key was pressed
		switch([event keyCode]) {
			case 12: // 'q' or 'Q'
			case 53: // Esc key
				
				// close view
				[self close];
				break;
			case 49: // space
				
				// space key changes the state
				[self nextState];
				break;
			case 126: // cursor up
				
				// space key changes the state
				[self nextState];
				break;
			case 125: // cursor down
				
				// space key changes the state
				[self prevState];
				break;
			default:
				
				// log the key-code (in case we want to add it here)
				NSLog(@"key code %d", (unsigned int)[event keyCode]);
		}
	}
}

@end
