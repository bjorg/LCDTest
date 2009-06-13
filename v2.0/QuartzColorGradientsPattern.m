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

#import "QuartzColorGradientsPattern.h"

static float active_red = 0;
static float active_green = 0;
static float active_blue = 0;

static CGRect convertToCGRect(NSRect rect) {
    return *(CGRect*)&rect;
}

static void  myCalculateShadingValues(void *info, const float *in, float *out) {
	out[0] = active_red;
	out[1] = active_green;
	out[2] = active_blue;
	out[3] = 1 - *in;
}

static CGFunctionRef myGetFunction(CGColorSpaceRef colorspace) {
    static const float input_value_range[2] = { 0, 1 };
    static const float output_value_ranges[8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0, &myCalculateShadingValues, NULL };
	
    size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace); 
    return CGFunctionCreate(NULL,  
							1,  
							input_value_range,  
							components,  
							output_value_ranges,  
							&callbacks); 
}

@implementation QuartzColorGradientsPattern

- (void)drawRect:(NSRect)_rect {		
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGRect bounds = convertToCGRect([self bounds]);
    float width = bounds.size.width;
    float height = bounds.size.height;
    CGPoint center;
	CGShadingRef shading;
	
	// set transform
    CGContextSaveGState(context); 
	CGAffineTransform myTransform = CGAffineTransformMakeScale(width, height); 
	CGContextConcatCTM(context, myTransform); 
	
	// create colorspace and shading function
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();  
    CGFunctionRef shading_function = myGetFunction(colorspace); 
	
	// clear background
    CGContextSetRGBFillColor(context, 0, 0, 0, 1); 
    CGContextFillRect(context, bounds);
	
	// create bottom-left shader and draw
	center = CGPointMake(0, 0);
	active_red = 0;
	active_green = 1;
	active_blue = 0;
    shading = CGShadingCreateRadial(colorspace,  
									center, 0,
									center, 1,
									shading_function,
									false, false);
    CGContextDrawShading(context, shading); 
    CGShadingRelease(shading);
    
	// create top-left shader and draw
	center = CGPointMake(0, 1);
	active_red = 1;
	active_green = 0;
	active_blue = 0;
    shading = CGShadingCreateRadial(colorspace,  
									center, 0,
									center, 1,
									shading_function,
									false, false);
    CGContextDrawShading(context, shading); 
    CGShadingRelease(shading);
    
	// create top-right shader and draw
	center = CGPointMake(1, 1);
	active_red = 0;
	active_green = 0;
	active_blue = 1;
    shading = CGShadingCreateRadial(colorspace,  
									center, 0,
									center, 1,
									shading_function,
									false, false);
    CGContextDrawShading(context, shading); 
    CGShadingRelease(shading);
    
	// release allocated resources
	CGColorSpaceRelease(colorspace); 
    CGFunctionRelease(shading_function);
    CGContextRestoreGState(context);
}

@end
