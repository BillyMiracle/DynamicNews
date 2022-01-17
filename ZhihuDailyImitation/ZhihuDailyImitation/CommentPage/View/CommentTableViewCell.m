//
//  CommentTableViewCell.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/29.
//

#import "CommentTableViewCell.h"
#import "Masonry.h"

#define nameLabelFontSize 17
#define commentLabelFontSize 16
#define replyLabelFontSize 15
#define timeLabelFontSize 14
#define numberOfLikesLabelFontSize 14

@implementation CommentTableViewCell

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
    self.backgroundColor = [UIColor whiteColor];
    _separatorView = [[UIView alloc]init];
    _separatorView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_separatorView];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 18;
    _headImageView.layer.borderWidth = 0;
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(@36);
        make.width.mas_equalTo(@36);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont boldSystemFontOfSize: nameLabelFontSize];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(10);
        make.top.mas_equalTo(_headImageView.mas_top).offset(2);
    }];
    
    _commentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_commentLabel];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    _replyLabel = [[UILabel alloc] init];
    _replyLabel.font = [UIFont systemFontOfSize:replyLabelFontSize];
    _replyLabel.textColor = [UIColor grayColor];
    _replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_replyLabel];
    [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_commentLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(_commentLabel.mas_left);
        make.right.mas_equalTo(_commentLabel.mas_right);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:timeLabelFontSize];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_replyLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.mas_equalTo(_commentLabel.mas_left);
    }];
    
    _foldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _foldButton.titleLabel.font = [UIFont systemFontOfSize:timeLabelFontSize];
    _foldButton.backgroundColor = [UIColor whiteColor];
    _foldButton.tintColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_foldButton];
    [_foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_top);
        make.bottom.mas_equalTo(_timeLabel.mas_bottom);
        make.left.mas_equalTo(_timeLabel.mas_right).offset(2);
    }];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _commentButton.tintColor = [UIColor grayColor];
    [_commentButton setImage:[UIImage imageNamed:@"pinglun2.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_commentButton];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_top);
        make.bottom.mas_equalTo(_timeLabel.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _likeButton.tintColor = [UIColor grayColor];
    [_likeButton setImage:[UIImage imageNamed:@"dianzan2.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_likeButton];
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_top);
        make.bottom.mas_equalTo(_timeLabel.mas_bottom);
        make.right.mas_equalTo(_commentButton.mas_left).offset(-30);
    }];

    _numberOfLikesLabel = [[UILabel alloc] init];
    _numberOfLikesLabel.textColor = [UIColor grayColor];
    _numberOfLikesLabel.font = [UIFont systemFontOfSize:numberOfLikesLabelFontSize];
    [self.contentView addSubview:_numberOfLikesLabel];
    [_numberOfLikesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_top);
        make.bottom.mas_equalTo(_timeLabel.mas_bottom);
        make.right.mas_equalTo(_likeButton.mas_left).offset(-3);
    }];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _separatorView.frame = CGRectMake(0, self.bounds.size.height - 0.3, self.bounds.size.width, 0.3);
}

@end
