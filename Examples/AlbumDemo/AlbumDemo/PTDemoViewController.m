//
//  PTDemoViewController.m
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 17.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import "PTDemoViewController.h"

@implementation PTDemoViewController

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
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    return YES;
}

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    return 7;
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index
{
    NSArray *urls = [NSArray arrayWithObjects:
                     @"http://farm8.staticflickr.com/7053/6885649635_7d29d75a31_b.jpg",
                     @"http://farm8.staticflickr.com/7052/6859587887_2f2df80989_b.jpg",
                     @"http://farm1.staticflickr.com/188/417924629_6832e79c98_z.jpg",
                     @"http://farm4.staticflickr.com/3338/3274183756_10411ace99_b.jpg",
                     @"http://farm8.staticflickr.com/7040/6888124857_df14f44fd7_b.jpg",
                     @"http://farm4.staticflickr.com/3503/3266055425_eed1ecc779_b.jpg",
                     @"http://farm1.staticflickr.com/10/11621713_3ac2d1c5d7_b.jpg",
                     nil];
    
    return [urls objectAtIndex:index];
}

- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index
{
    NSArray *sizes = [NSArray arrayWithObjects:
                      [NSValue valueWithCGSize:CGSizeMake(1024.0, 768.0)],
                      [NSValue valueWithCGSize:CGSizeMake(1024.0, 683.0)],
                      [NSValue valueWithCGSize:CGSizeMake(500.0, 500.0)],
                      [NSValue valueWithCGSize:CGSizeMake(572.0, 528.0)],
                      [NSValue valueWithCGSize:CGSizeMake(800.0, 613.0)],
                      [NSValue valueWithCGSize:CGSizeMake(1024.0, 768.0)],
                      [NSValue valueWithCGSize:CGSizeMake(1024.0, 681.0)],
                      nil];
    
    return [[sizes objectAtIndex:index] CGSizeValue];
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index
{
    NSArray *urls = [NSArray arrayWithObjects:
                     @"http://farm8.staticflickr.com/7053/6885649635_7d29d75a31_t.jpg",
                     @"http://farm8.staticflickr.com/7052/6859587887_2f2df80989_t.jpg",
                     @"http://farm1.staticflickr.com/188/417924629_6832e79c98_t.jpg",
                     @"http://farm4.staticflickr.com/3338/3274183756_10411ace99_t.jpg",
                     @"http://farm8.staticflickr.com/7040/6888124857_df14f44fd7_t.jpg",
                     @"http://farm4.staticflickr.com/3503/3266055425_eed1ecc779_t.jpg",
                     @"http://farm1.staticflickr.com/10/11621713_3ac2d1c5d7_t.jpg",
                     nil];
    
    return [urls objectAtIndex:index];
}

@end
