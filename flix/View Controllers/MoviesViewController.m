//
//  MoviesViewController.m
//  flix
//
//  Created by Natalie Ghidali on 6/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface MoviesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray<NSDictionary*> *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    //resize collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing) *(postersPerLine - 1) / postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // This will run when the network request returns
        if (error) {
            NSLog(@"%@", error);
        } else if (data) {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.movies = dataDictionary[@"results"];
            // Update UI in main thread
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        }
        
    }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    NSString *posterPathString = movie[@"poster_path"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:posterPathString]];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:url];

    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return self.movies.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *cell = (UICollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath != nil) {
        NSDictionary *movie = self.movies[indexPath.row];
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.movie = movie;
    }
}

@end
