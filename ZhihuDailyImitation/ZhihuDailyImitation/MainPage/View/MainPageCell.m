//
//  MainPageCell.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/18.
//

#import "MainPageCell.h"
#import "Masonry.h"

#define cellTitleFont 19
#define cellHintFont 14
#define cellDateFont 16

@implementation MainPageCell

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
    if ([self.reuseIdentifier isEqualToString:@"Normal"]) {
        
        _leftView = [[UIView alloc] init];
        [self.contentView addSubview:_leftView];
        
        _cellTitleLabel = [[UILabel alloc] init];
        _cellTitleLabel.numberOfLines = 2;
        _cellTitleLabel.font = [UIFont boldSystemFontOfSize:cellTitleFont];
        [_leftView addSubview:_cellTitleLabel];
        
        _cellHintLabel = [[UILabel alloc] init];
        _cellHintLabel.numberOfLines = 2;
        _cellHintLabel.font = [UIFont systemFontOfSize:cellHintFont];
        _cellHintLabel.textColor = [UIColor grayColor];
        [_leftView addSubview:_cellHintLabel];
        
        _cellImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_cellImageView];
        _cellImageView.layer.masksToBounds = YES;
        _cellImageView.layer.cornerRadius = 2;
        _cellImageView.layer.borderWidth = 0;
        
        [_cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_leftView.mas_top);
            make.right.mas_equalTo(_leftView.mas_right);
            make.left.mas_equalTo(_leftView.mas_left);
        }];
        
        [_cellHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cellTitleLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(_leftView.mas_right);
            make.left.mas_equalTo(_leftView.mas_left);
            make.bottom.mas_equalTo(_leftView.mas_bottom);
        }];
        
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.contentView.mas_top).offset(15).priority(500);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(_cellImageView.mas_left).offset(-15);
//            make.centerY.mas_equalTo(_cellImageView.mas_centerY).priority(500);
            make.centerY.mas_equalTo(_cellImageView.mas_centerY);
        }];
        
    } else if ([self.reuseIdentifier isEqualToString:@"Date"]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _cellDateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_cellDateLabel];
        _cellTitleLabel.numberOfLines = 1;
        _cellDateLabel.font = [UIFont systemFontOfSize:cellDateFont];
        
        _cellLineView = [[UIView alloc] init];
        _cellLineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_cellLineView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineHeight = _cellDateLabel.font.lineHeight;
    _cellDateLabel.frame = CGRectMake(15, (30 - lineHeight) / 2, 90, lineHeight);
    _cellLineView.frame = CGRectMake(105, 14.5, self.frame.size.width - 105, 1);
    
    _cellImageView.frame = CGRectMake(self.frame.size.width - 95, 15, 80, 80);
    
}

@end
