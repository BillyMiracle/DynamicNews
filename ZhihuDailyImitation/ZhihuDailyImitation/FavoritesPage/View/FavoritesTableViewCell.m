//
//  FavoritesTableViewCell.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/31.
//

#import "FavoritesTableViewCell.h"
#import "Masonry.h"

#define cellTitleFont 19

@implementation FavoritesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _cellImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_cellImageView];
    _cellImageView.layer.masksToBounds = YES;
    _cellImageView.layer.cornerRadius = 2;
    _cellImageView.layer.borderWidth = 0;
    
    _cellTitleLabel = [[UILabel alloc] init];
    _cellTitleLabel.numberOfLines = 2;
    _cellTitleLabel.font = [UIFont boldSystemFontOfSize: cellTitleFont];
    [self.contentView addSubview:_cellTitleLabel];
    
    [_cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_cellImageView.mas_left).offset(-15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(_cellImageView);
    }];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _cellImageView.frame = CGRectMake(self.frame.size.width - 95, 15, 80, 80);
    
}

@end
