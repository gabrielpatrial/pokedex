//
//  FilterListViewController.h
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ValueSelectionDelegate <NSObject>

@required

- (void) ValueSelectedDelegateCall:(NSArray *) filters;

@end


@interface FilterListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    id <ValueSelectionDelegate> delegate;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSArray           *pokemonTypesArray;
@property (strong, nonatomic) NSMutableArray    *selectedFilters;

@property(retain) id                                delegate;


@end

NS_ASSUME_NONNULL_END
