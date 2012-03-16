//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// This file is part of PTImageAlbumViewController.
// modify it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// PTImageAlbumViewController is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PTImageAlbumViewController. If not, see <http://www.gnu.org/licenses/>.
// PTImageAlbumViewController is free software: you can redistribute it and/or
//

#import "PTImageAlbumView.h"

#import "PTImageAlbumViewDataSource.h"

@interface PTImageAlbumView ()

@property (nonatomic, retain) NSMutableArray *data;

@end

@implementation PTImageAlbumView

@synthesize imageAlbumDataSource = _imageAlbumDataSource;

// private
@synthesize data = _data;

#pragma mark - Instance methods

- (NSInteger)numberOfImages
{
    return [self.data count];
}

- (NSString *)originalSourceForImageAtIndex:(NSInteger)index
{
    return [[self.data objectAtIndex:index] objectForKey:@"source"];
}

- (CGSize)originalSizeForImageAtIndex:(NSInteger)index
{
    return [[[self.data objectAtIndex:index] objectForKey:@"size"] CGSizeValue];
}

- (NSString *)thumbnailSourceForImageAtIndex:(NSInteger)index
{
    return [[self.data objectAtIndex:index] objectForKey:@"thumbnailSource"];
}

- (void)reloadData
{
    // Ask data source for number of images
    NSInteger numberOfImages = [self.imageAlbumDataSource numberOfImagesInAlbumView:self];
    
    // Create an images' info array for reusing
    self.data = [NSMutableArray arrayWithCapacity:numberOfImages];
    for (NSInteger i = 0; i < numberOfImages; i++) {
        // Ask datasource for various data
        NSString *originalImageSource = [self.imageAlbumDataSource imageAlbumView:self sourceForImageAtIndex:i];
        CGSize originalImageSize = [self.imageAlbumDataSource imageAlbumView:self sizeForImageAtIndex:i];
        NSString *thumbnailImageSource = [self.imageAlbumDataSource imageAlbumView:self sourceForThumbnailImageAtIndex:i];
        
        [self.data addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              originalImageSource, @"source",
                              [NSValue valueWithCGSize:originalImageSize], @"size",
                              thumbnailImageSource, @"thumbnailSource",
                              nil]];
    }
}

@end
