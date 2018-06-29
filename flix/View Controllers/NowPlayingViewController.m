//
//  ViewController.m
//  flix
//
//  Created by emersonmalca on 5/9/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "MovieCell.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NowPlayingViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<NSDictionary*> *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set table view data source
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //search bar
    self.searchBar.delegate = self;
    
    // Initialize movies array
    self.movies = [NSMutableArray array];
    // Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(didPullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Fetch movies
    [self.activityIndicator startAnimating];
    [self fetchMovies];
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
            
            NSArray<NSDictionary*> *movies = dataDictionary[@"results"];
            for (NSDictionary *movie in movies) {
                NSString *title = movie[@"title"];
                NSLog(@"%@", title);
            }
            [self.movies setArray:movies];
            
            //filter
            self.filteredData = self.movies;
            
            // Update UI in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                [self.activityIndicator stopAnimating];
            });
        }
        
    }];
    [task resume];
}

- (void)didPullToRefresh:(UIRefreshControl *)refreshControl {
    [self fetchMovies];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.row];
    NSString *title = movie[@"title"];
    NSString *overview = movie[@"overview"];
    cell.titleLabel.text = title;
    cell.overviewLabel.text = overview;
    
    NSString *posterPathString = movie[@"poster_path"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:posterPathString]];
    [cell.posterImageView setImageWithURL:url];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate]; //here is the problem we need to use the titles in a string array not the movies
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath != nil) {
        NSDictionary *movie = self.movies[indexPath.row];
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.movie = movie;
    }
}

@end
