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

#import "PixelResponsePattern.h"


@implementation PixelResponsePattern

/*
 * Private Methods
 */
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

- (void)setForeColorForIteration:(int)number {
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
			[[NSColor blackColor] set];
			break;
		case 7:
			[[NSColor whiteColor] set];
			break;
	}
}

- (void)setBackColorForIteration:(int)number {
	[[NSColor grayColor] set];
}

/*
 * Overridden Methods
 */
- (id)initWithFrame:(NSRect)frame asPreview:(bool)preview_only {
	
	// initialize the base class
    [super initWithFrame:frame asPreview:preview_only];
	position = 0.0;
	
	// create a timer
	timer = [[NSTimer scheduledTimerWithTimeInterval:(preview ? (1.0 / 20.0) : (1.0 / 60.0))
											  target:self
											selector:@selector(nextPosition)
											userInfo:nil
											 repeats:YES] retain];
    return self;
}

- (void)close {
	if(timer) {
		[timer invalidate];
		[timer release];
		timer = nil;
	}
	[super close];
}

- (void)nextState {
	if(!preview) {
		[super nextState];
	}
}

- (void)prevState {
	if(!preview) {
		[super prevState];
	}
}

- (void)drawRect:(NSRect)_rect {
	NSRect screen_rect = [self bounds];
	
	// set the background to black
	[self setBackColorForIteration:iteration];
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
	motion_rect.size.height = screen_rect.size.height / 4;
	
	// draw box
	[self setForeColorForIteration:iteration];
	NSRectFill(motion_rect);
	
	// check if we need to draw a second box
	if(position >= screen_rect.size.height - motion_rect.size.height) {
		motion_rect.origin.y = position - screen_rect.size.height;
		[self setForeColorForIteration:(iteration + 1)];
		NSRectFill(motion_rect);
	}
}

@end
