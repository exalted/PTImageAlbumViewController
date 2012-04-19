//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "PTDemoViewController.h"

@interface PTDemoViewController ()

@property (nonatomic, readonly) NSArray *exampleData;

@end

#define kPTDemoSourceKey        @"source"
#define kPTDemoSizeKey          @"size"
#define kPTDemoThumbnailKey     @"thumbnail"

@implementation PTDemoViewController

@synthesize exampleData = _exampleData;

- (NSArray *)exampleData
{
    if (_exampleData == nil) {
        _exampleData = [NSArray arrayWithObjects:

                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm8.staticflickr.com/7053/6885649635_7d29d75a31_b.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(1024.0, 768.0)], kPTDemoSizeKey,
                         @"http://farm8.staticflickr.com/7053/6885649635_7d29d75a31_t.jpg", kPTDemoThumbnailKey,
                         nil],

                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm8.staticflickr.com/7052/6859587887_2f2df80989_b.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(1024.0, 683.0)], kPTDemoSizeKey,
                         @"http://farm8.staticflickr.com/7052/6859587887_2f2df80989_t.jpg", kPTDemoThumbnailKey,
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm1.staticflickr.com/188/417924629_6832e79c98_z.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(500.0, 500.0)], kPTDemoSizeKey,
                         @"http://farm1.staticflickr.com/188/417924629_6832e79c98_t.jpg", kPTDemoThumbnailKey,
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm4.staticflickr.com/3338/3274183756_10411ace99_b.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(572.0, 528.0)], kPTDemoSizeKey,
                         @"http://farm4.staticflickr.com/3338/3274183756_10411ace99_t.jpg", kPTDemoThumbnailKey,
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm8.staticflickr.com/7040/6888124857_df14f44fd7_b.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(800.0, 613.0)], kPTDemoSizeKey,
                         @"http://farm8.staticflickr.com/7040/6888124857_df14f44fd7_t.jpg", kPTDemoThumbnailKey,
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm4.staticflickr.com/3503/3266055425_eed1ecc779_b.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(1024.0, 768.0)], kPTDemoSizeKey,
                         @"http://farm4.staticflickr.com/3503/3266055425_eed1ecc779_t.jpg", kPTDemoThumbnailKey,
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://farm1.staticflickr.com/10/11621713_3ac2d1c5d7_b.jpg", kPTDemoSourceKey,
                         [NSValue valueWithCGSize:CGSizeMake(1024.0, 681.0)], kPTDemoSizeKey,
                         @"http://farm1.staticflickr.com/10/11621713_3ac2d1c5d7_t.jpg", kPTDemoThumbnailKey,
                         nil],
                        
                        nil];
    }
    return _exampleData;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photos";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    ////////////////////////////////////////////////////////////////////////////
    
    /*
     * Decide which interface orientations do you want to support (we can handle
     * them all!)
     */
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    return YES;
}

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    return [self.exampleData count];
}

- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index
{
    return [[[self.exampleData objectAtIndex:index] objectForKey:kPTDemoSizeKey] CGSizeValue];
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index
{
    return [[self.exampleData objectAtIndex:index] objectForKey:kPTDemoSourceKey];
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index
{
    return [[self.exampleData objectAtIndex:index] objectForKey:kPTDemoThumbnailKey];
}

@end
