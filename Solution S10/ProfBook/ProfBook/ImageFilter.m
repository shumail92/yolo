//
//  ImageFilter.m
//  ProfBook
//
//  Created by Christian Wahl on 06.04.17.
//  Copyright © 2017 TUM. All rights reserved.
//  see http://altitudelabs.com/blog/real-time-filter/ for implementation help and source

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageFilter:NSObject
+ (UIImage*) applyContactFilterToImage: (UIImage*) image;
+ (CIImage*) applyInstantFilterToImage: (CIImage*) image;
+ (CIImage*) applyVignetteFilterToImage: (CIImage*) image;
@end

@implementation ImageFilter:NSObject
+ (UIImage*) applyContactFilterToImage: (UIImage*) image {
    // Convert to CIImage to process with the filter api
    CIImage *sourceCIImage =  [[CIImage alloc] initWithImage:image];
    CIImage *processedImage = [self applyVignetteFilterToImage:sourceCIImage];
    processedImage = [self applyInstantFilterToImage:processedImage];
    return [[UIImage alloc] initWithCIImage:processedImage];
}

+ (CIImage*) applyInstantFilterToImage: (CIImage*) image {
    CIFilter *effectFilter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    [effectFilter setValue:image forKey:kCIInputImageKey];
    CIImage *filteredImage = [effectFilter outputImage];
    return filteredImage;
}

+ (CIImage*) applyVignetteFilterToImage: (CIImage*) image {
    CGSize imageSize = image.extent.size;
    CIFilter *vignetteFilter = [CIFilter filterWithName:@"CIVignetteEffect"];
    
    CIVector *size = [CIVector vectorWithX:imageSize.width/2 Y:imageSize.height/2];
    [vignetteFilter setValue:image forKey:kCIInputImageKey];
    [vignetteFilter setValue:size forKey:kCIInputCenterKey];
    [vignetteFilter setValue:@(imageSize.width/2) forKey:kCIInputRadiusKey];
    CIImage *filteredImage = [vignetteFilter outputImage];
    return filteredImage;
}
@end
