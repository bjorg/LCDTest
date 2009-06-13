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

#import "ColorGradientsPattern.h"

//static float minmax(float lower, float value, float upper) {
//	if(value < lower) {
//		return lower;
//	} else if(value > upper) {
//		return upper;
//	}
//	return value;
//}

static float max(float left, float right) {
	return (left < right) ? right : left;
}

@implementation ColorGradientsPattern

- (void)drawRect:(NSRect)_rect {		
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
		case 4:
			top_left_color = [NSColor magentaColor];
			top_right_color = [NSColor cyanColor];
			bottom_right_color = [NSColor blackColor];
			bottom_left_color = [NSColor yellowColor];
			break;
		case 5:
			top_left_color = [NSColor yellowColor];
			top_right_color = [NSColor magentaColor];
			bottom_right_color = [NSColor cyanColor];
			bottom_left_color = [NSColor blackColor];
			break;
		case 6:
			top_left_color = [NSColor blackColor];
			top_right_color = [NSColor yellowColor];
			bottom_right_color = [NSColor magentaColor];
			bottom_left_color = [NSColor cyanColor];
			break;
		case 7:
			top_left_color = [NSColor cyanColor];
			top_right_color = [NSColor blackColor];
			bottom_right_color = [NSColor yellowColor];
			bottom_left_color = [NSColor magentaColor];
			break;
	}
	
	// show wait cursor
	QDDisplayWaitCursor(TRUE);
	
	// loop over vertical rectangles
	float x_start;
	float x_end = (float)vertical_rectangle.size.width;
	float x_increment = (int)max(2.0, vertical_rectangle.size.width / 256.0);
	float y_start;
	float y_end = (float)vertical_rectangle.size.height;
	float y_increment = (int)max(2.0, vertical_rectangle.size.height / 256.0);
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

@end
