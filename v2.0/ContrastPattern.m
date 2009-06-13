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

#import "ContrastPattern.h"

#define BLOCK_COUNT					8
#define BLOCK_WIDTH_SPACING_RATIO	7

@implementation ContrastPattern

- (void)drawRect:(NSRect)_rect {
	int i;

	// compute the colored box boundaries and fill it with the chosen color
	NSRect screen_rect = [self bounds];
	NSRect rect;
	
	// repaint the upper half
	[[NSColor blackColor] set];
	rect.origin.x = 0;
	rect.origin.y = screen_rect.size.height / 2;
	rect.size.width = screen_rect.size.width;
	rect.size.height = screen_rect.size.height / 2;
	NSRectFill(rect);
	
	float block_spacing = screen_rect.size.width / (BLOCK_COUNT + 1 + BLOCK_WIDTH_SPACING_RATIO * BLOCK_COUNT);
	float block_width = BLOCK_WIDTH_SPACING_RATIO * block_spacing;
	rect.origin.x = block_spacing;
	rect.origin.y = 5 * screen_rect.size.height / 8;
	rect.size.width = block_width;
	rect.size.height = screen_rect.size.height / 4;
	for(i = 0; i < 8; ++i, rect.origin.x += block_spacing + block_width) {
		[[NSColor colorWithCalibratedWhite:((i + 1) * 1.0 / 64) alpha:1.0] set];
		NSRectFill(rect);
	}
	
	// repaint the lower half
	[[NSColor whiteColor] set];
	rect.origin.x = 0;
	rect.origin.y = 0;
	rect.size.width = screen_rect.size.width;
	rect.size.height = screen_rect.size.height / 2;
    NSRectFill(rect);

	rect.origin.x = screen_rect.size.width - (block_spacing + block_width);
	rect.origin.y = screen_rect.size.height / 8;
	rect.size.width = block_width;
	rect.size.height = screen_rect.size.height / 4;
	for(i = 0; i < 8; ++i, rect.origin.x -= block_spacing + block_width) {
		[[NSColor colorWithCalibratedWhite:(1.0 - (i + 1) * 1.0 / 64) alpha:1.0] set];
		NSRectFill(rect);
	}
}

@end
