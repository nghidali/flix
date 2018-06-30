//
//  RelatedMoviesViewController.m
//  flix
//
//  Created by Natalie Ghidali on 6/29/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "RelatedMoviesViewController.h"
#import "MovieCell.h"
#import "RelatedMoviesCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface RelatedMoviesViewController() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray<NSDictionary*> *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RelatedMoviesViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchMovies {
    NSNumber *movieId = [NSNumber numberWithLong:self.movie[@"id"]];
    //movieId = [[NSNumber numberWithLong:movieId] stringValue];
    NSString* URLString = @"https://api.themoviedb.org/3/movie/";
    URLString = [URLString stringByAppendingString:[movieId stringValue]]; //problem
    URLString = [URLString stringByAppendingString:@"/similar/?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // This will run when the network request returns
        if (error) {
            NSLog(@"%@", error);
        } else if (data) {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.movies = dataDictionary[@"results"];
            [self.collectionView reloadData];
        }
        
    }];
    [task resume];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RelatedMoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RelatedMoviesCollectionViewCell" forIndexPath:indexPath]; 
    
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

@end
