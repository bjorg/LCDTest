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

#import <Cocoa/Cocoa.h>
#import "PatternView.h"

@implementation PatternView

- (id)initWithFrame:(NSRect)frame withTestMode:(TestMode)testMode {
	
	// initialize the base class and set our starting mode
    [super initWithFrame:frame];
	mode = testMode;
	state = 0;
	position = 0.0;
	
	// check if we need to create a timer
	if(testMode == TESTMODE_PIXEL_RESPONSE_TIME) {
		timer = [[NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
												  target:self
												selector:@selector(nextPosition)
												userInfo:nil
												 repeats:YES] retain];
	}
    return self;
}

- (void)drawDeadPixelsBackground {
	
	// NOTE: this method draws a solid background in different colors.
	
	// check current state to determine the color to display
	switch(state) {
		default:
			state = 0;
			
			// FALL THROUGH
			
		case 0:
			[[NSColor redColor] set];
			break;
		case 1:
			[[NSColor blueColor] set];
			break;
		case 2:
			[[NSColor greenColor] set];
			break;
		case 3:
			[[NSColor whiteColor] set];
			break;
		case 4:
			[[NSColor grayColor] set];
			break;
		case 5:
			[[NSColor blackColor] set];
			break;
	}
	
	// repaing the whole region
    NSRectFill([self bounds]);
}

- (void)drawColorGradientBackground {
	NSRect vertical_rectangle = [self bounds];
	
	// NOTE: this method draw a color gradient with a different color in each corner;
	//		 the screen is split into 5x5 rectangles, which are painted individually;
	//		 I tried using the Quarz gradient fuctions that were added to OS X 10.2 (Jaguar)
	//		 but they only allow two colors gradients.
	NSColor* top_left_color;
	NSColor* top_right_color;
	NSColor* bottom_left_color;
	NSColor* bottom_right_color;
	
	// check current state to determine the colors to display
	switch(state) {
		default:
			state = 0;
			
			// FALL THROUGH
			
		case 0:
			top_left_color = [NSColor redColor];
			top_right_color = [NSColor blueColor];
			bottom_right_color = [NSColor blackColor];
			bottom_left_color = [NSColor greenColor];
			break;
		case 1:
			top_left_color = [NSColor greenColor];
			top_right_color = [NSColor redColor];
			bottom_right_color = [NSColor blueColor];
			bottom_left_color = [NSColor blackColor];
			break;
		case 2:
			top_left_color = [NSColor blackColor];
			top_right_color = [NSColor greenColor];
			bottom_right_color = [NSColor redColor];
			bottom_left_color = [NSColor blueColor];
			break;
		case 3:
			top_left_color = [NSColor blueColor];
			top_right_color = [NSColor blackColor];
			bottom_right_color = [NSColor greenColor];
			bottom_left_color = [NSColor redColor];
			break;
	}
	
	// show wait cursor
	QDDisplayWaitCursor(TRUE);
	
	// loop over vertical rectangles
	float x_start;
	float x_end = (float)vertical_rectangle.size.width;
	float x_increment = 5.0;
	float y_start;
	float y_end = (float)vertical_rectangle.size.height;
	float y_increment = 5.0;
	for(x_start = 0.0; x_start < x_end; x_start += x_increment) {
		
		// compute vertical update rectangle
		NSRect vertical_slice, vertical_remainder;
		NSDivideRect(vertical_rectangle, &vertical_slice, &vertical_remainder, x_increment, NSMinXEdge);
		vertical_rectangle = vertical_remainder;
		
		// compute color extremities
		float fraction = x_start / x_end;
		NSColor* top_color = [top_left_color blendedColorWithFraction:fraction ofColor:top_right_color];
		NSColor* bottom_color = [bottom_left_color blendedColorWithFraction:fraction ofColor:bottom_right_color];
		
		// loop over horizontal rectangles
		for(y_start = 0.0; y_start < y_end; y_start += y_increment) {
			
			// compute horizontal update rectangle
			NSRect horizontal_slice, horizontal_remainder;
			NSDivideRect(vertical_slice, &horizontal_slice, &horizontal_remainder, y_increment, NSMinYEdge);
			vertical_slice = horizontal_remainder;
			
			// draw color
			[[bottom_color blendedColorWithFraction:(y_start / y_end) ofColor:top_color] set];
			NSRectFillUsingOperation(horizontal_slice, NSCompositeSourceOver);
		}
	}

	// hide wait cursor
	QDDisplayWaitCursor(FALSE);
}

- (void)drawCalibrationBackground {
	NSRect vertical_rectangle = [self bounds];
	
	// NOTE: this method draws a black and white alternating vertical stripes; this
	//		 patterns exhibits errors in the phase and shift adjustments of the
	//		 analog-to-digital circuitry in LCDs.
	
	// loop over vertical rectangles
	int x_start;
	int x_end = vertical_rectangle.size.width;
	for(x_start = 0; x_start < x_end; ++x_start) {
		
		// compute vertical update rectangle
		NSRect vertical_slice, vertical_remainder;
		NSDivideRect(vertical_rectangle, &vertical_slice, &vertical_remainder, 1.0, NSMinXEdge);
		vertical_rectangle = vertical_remainder;

		if((x_start & 1) == 0) {
			[[NSColor whiteColor] set];
		} else {
			[[NSColor blackColor] set];
		}
		NSRectFillUsingOperation(vertical_slice, NSCompositeSourceOver);
	}
}

- (void)drawPanelAlignmentBackground {
	NSRect rect = [self bounds];
	
	// NOTE: this method draws a colored box on a black background; this pattern exhibits
	//		 alignment issues in multi-panel LCDs found in many projectors; the alignment
	//       error is shown by color bleeding on one or more of the rectangle's edges.
	
	// set the background to black
	[[NSColor blackColor] set];
	NSRectFill(rect);
	
	// check the current state to determine the color of the box
	switch(state) {
		default:
			state = 0;
			
			// FALL THROUGH
			
		case 0:
			[[NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.0 alpha:1.0] set];
			break;
		case 1:
			[[NSColor colorWithDeviceRed:1.0 green:0.0 blue:1.0 alpha:1.0] set];
			break;
		case 2:
			[[NSColor colorWithDeviceRed:0.0 green:1.0 blue:1.0 alpha:1.0] set];
			break;
		case 3:
			[[NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:1.0] set];
			break;
		case 4:
			[[NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
			break;
		case 5:
			[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0] set];
			break;
	}
	
	// compute the colored box boundaries and fill it with the chosen color
	rect.origin.x = rect.size.width / 4;
	rect.origin.y = rect.size.height / 4;
	rect.size.width /= 2;
	rect.size.height /= 2;
	NSRectFill(rect);
}

- (void)setColorForIteration:(int)number {
	switch(number % 8) {
		case 0:
			[[NSColor yellowColor] set];
			break;
		case 1:
			[[NSColor magentaColor] set];
			break;
		case 2:
			[[NSColor cyanColor] set];
			break;
		case 3:
			[[NSColor redColor] set];
			break;
		case 4:
			[[NSColor greenColor] set];
			break;
		case 5:
			[[NSColor blueColor] set];
			break;
		case 6:
			[[NSColor brownColor] set];
			break;
		case 7:
			[[NSColor whiteColor] set];
			break;
	}
}

- (void)drawPixelResponseBackground {
	NSRect screen_rect = [self bounds];
	
	// set the background to black
	[[NSColor blackColor] set];
	NSRectFill(screen_rect);
	
	// check if we need to reset the box
	if(position >= screen_rect.size.height) {
		position = 0.0;
		++iteration;
	}
	
	// compute the colored box boundaries and fill it with the chosen color
	NSRect motion_rect;
	motion_rect.origin.x = screen_rect.size.width / 4;
	motion_rect.origin.y = position;
	motion_rect.size.width = screen_rect.size.width / 2;
	motion_rect.size.height = 1.0;
	
	// draw box
	[self setColorForIteration:iteration];
	NSRectFill(motion_rect);
	
	// check if we need to draw a second box
	if(position >= screen_rect.size.height - motion_rect.size.height) {
		motion_rect.origin.y = position - screen_rect.size.height;
		[self setColorForIteration:(iteration + 1)];
		NSRectFill(motion_rect);
	}
}

- (void)drawRect:(NSRect)rect {
	
	// check the current mode to determine the active test pattern to draw
	switch(mode) {
		case TESTMODE_DEAD_PIXELS:
			[self drawDeadPixelsBackground];
			break;
		case TESTMODE_COLOR_GRADIENT:
			[self drawColorGradientBackground];
			break;
		case TESTMODE_CALIBRATION:
			[self drawCalibrationBackground];
			break;
		case TESTMODE_PANEL_ALIGNMENT:
			[self drawPanelAlignmentBackground];
			break;
		case TESTMODE_PIXEL_RESPONSE_TIME:
			[self drawPixelResponseBackground];
			break;
	}
}


- (BOOL)isOpaque {
	
	// let the display sub-system know that it doesn't need to draw 
	// items covered by this view control
    return YES;
}

- (BOOL)acceptsFirstResponder {
	
	// indicate that we are willing to get keyboard events
	return YES;
}

- (void)mouseUp:(NSEvent*)event {
	
	// mouse-clicks change the state
	[self nextState];
}

- (void)keyDown:(NSEvent*)event {
	
	// check which key was pressed
	switch([event keyCode]) {
		case 49: // space
			
			// space key changes the state
			[self nextState];
			break;
		case 12: // 'q' or 'Q'
		case 53: // or escape key close the view
			
			// check if we have a timer
			if(timer) {
				[timer invalidate];
				[timer release];
				timer = nil;
			}

			// close view
			[[self window] close];
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

- (void)nextState {
	
	// check if the current mode has multiple states
	switch(mode) {
		case TESTMODE_DEAD_PIXELS:
		case TESTMODE_PANEL_ALIGNMENT:
		case TESTMODE_COLOR_GRADIENT:
		case TESTMODE_PIXEL_RESPONSE_TIME:
			
			// increase state
			++state;
			NSLog(@"next state %d", state);
			
			// force refresh
			[self setNeedsDisplay:YES];
			break;
		default:
			break;
	}
}

- (void)prevState {
	
	// check if the current mode has multiple states
	switch(mode) {
		case TESTMODE_DEAD_PIXELS:
		case TESTMODE_PANEL_ALIGNMENT:
		case TESTMODE_COLOR_GRADIENT:
		case TESTMODE_PIXEL_RESPONSE_TIME:
			
			// increase state
			--state;
			NSLog(@"next state %d", state);
			
			// force refresh
			[self setNeedsDisplay:YES];
			break;
		default:
			break;
	}
}

- (void)nextPosition {
	if(state >= 100) {
		state = 100;
	} else if(state <= 0) {
		state = 1;
	}
	position += state + 1;
	
	// force refresh
	[self setNeedsDisplay:YES];
}

@end
