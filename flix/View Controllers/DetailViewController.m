//
//  DetailViewController.m
//  flix
//
//  Created by emersonmalca on 5/27/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewLabel;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If we have a movie set
    if (self.movie != nil) {
        self.titleLabel.text = self.movie[@"title"];
        self.releaseDateLabel.text = self.movie[@"release_date"];
        self.overviewLabel.text = self.movie[@"overview"];
        
        NSString *backdropPath = self.movie[@"backdrop_path"];
        NSString *posterPath = self.movie[@"poster_path"];
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSURL *backdropURL = [NSURL URLWithString:[baseURLString stringByAppendingString:backdropPath]];
        NSURL *posterURL = [NSURL URLWithString:[baseURLString stringByAppendingString:posterPath]];
        [self.backdropImageView setImageWithURL:backdropURL];
        [self.posterImageView setImageWithURL:posterURL];
        [self.overviewLabel sizeToFit];
        [self.titleLabel sizeToFit];
    }
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

@end
