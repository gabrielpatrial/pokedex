//
//  PokemonCollectionViewCell.m
//  Pokedex
//
//  Created by Gabriel Costa de Oliveira on 2/11/23.
//

#import "PokemonCollectionViewCell.h"

@implementation PokemonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) setupCellUI
{
    self.contentView.layer.cornerRadius = 10.0f;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.layer.masksToBounds = YES;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.cornerRadius = 10.0f;
    self.layer.shadowOpacity = 0.5f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

- (void)setNameLabelWithName:(NSString *)name
{
    if (name) {
        [self.pokemonNameLabel setText:[name uppercaseString]];
    } else
    {
        [self.pokemonNameLabel setText:@"-"];
    }
}

- (void)setTypeLabelWithType:(NSString *)type
{
    if (type) {
        [self.pokemonTypeLabel setText:[type uppercaseString]];
    } else
    {
        [self.pokemonTypeLabel setText:@"-"];
    }
}

- (void)setOrderLabelWithOrder:(NSString *)order
{
    if (order) {
        [self.pokemonOrderLabel setText:[order uppercaseString]];
    } else
    {
        [self.pokemonOrderLabel setText:@"-"];
    }
}

- (void)setSpriteLabelWithSprite:(NSString *)sprite
{
    if (sprite) {
        [self.pokemonSpriteLabel setText:[NSString stringWithFormat:@"Sprite: %@", sprite]];
    } else
    {
        [self.pokemonSpriteLabel setText:@"-"];
    }
}

- (void)setBackgroundColorWithType:(NSString *)type
{
    if ([type isEqualToString:@"grass"])
    {
        [self setBackgroundColor:[UIColor systemGreenColor]];
    } else if ([type isEqualToString:@"fire"])
    {
        [self setBackgroundColor:[UIColor systemRedColor]];
    } else if ([type isEqualToString:@"water"])
    {
        [self setBackgroundColor:[UIColor systemBlueColor]];
    } else if ([type isEqualToString:@"electric"])
    {
        [self setBackgroundColor:[UIColor systemYellowColor]];
    } else if ([type isEqualToString:@"poison"])
    {
        [self setBackgroundColor:[UIColor systemPurpleColor]];
    } else
    {
        [self setBackgroundColor:[UIColor systemGrayColor]];
    }
}

- (void) setupCellWithPokemon:(PokedexPokemon *)pokemon
{
    [self setBackgroundColorWithType:[pokemon getMyFirstTypeName]];
    [self setNameLabelWithName:pokemon.name];
    [self setTypeLabelWithType:[pokemon getMyFirstTypeName]];
    [self setOrderLabelWithOrder:pokemon.order];
    [self setSpriteLabelWithSprite:[pokemon getDefaultSprite]];
}

@end
