//
//  CommentPageView.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/24.
//

#import "CommentPageView.h"
#import "CommentTableViewCell.h"
#import "SDWebImage.h"

#define selfWidth self.frame.size.width
#define selfHeight self.frame.size.height
#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define navBarHeight 45

#define numberLabelFontSize 24
#define hintLabelFontSize 20
#define titleLabelFontSize 20

@interface CommentPageView ()

@property (nonatomic, strong) NSCalendar* gregorian;
@property (nonatomic, assign) unsigned unitFlags;
@property (nonatomic, strong) NSDateFormatter *stampFormatter;
@property (nonatomic, strong) NSDateFormatter *stampFormatter2;
@property (nonatomic, strong) NSDateFormatter *todayStampFormatter;

@end

@implementation CommentPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addTopView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, selfWidth, selfHeight - (statusBarHeight + navBarHeight)) style:UITableViewStyleGrouped];
    [self addSubview:_commentTableView];
    
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.sectionFooterHeight = 0;
    _commentTableView.sectionHeaderHeight = 0;
    _commentTableView.backgroundColor = [UIColor whiteColor];
    _commentTableView.bounces = NO;
    _commentTableView.showsVerticalScrollIndicator = NO;
    _commentTableView.estimatedRowHeight = 100;
    
    [_commentTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    _unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    _stampFormatter = [[NSDateFormatter alloc] init];
    [_stampFormatter setDateFormat:@"MM-dd HH:mm"];
    _stampFormatter2 = [[NSDateFormatter alloc] init];
    [_stampFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm"];
    _todayStampFormatter = [[NSDateFormatter alloc] init];
    [_todayStampFormatter setDateFormat:@"HH:mm"];
    
    return  self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_numberOfSections == 2 && section == 0) {
        return _longComments.count;
    } else {
        return _shortComments.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _numberOfSections - 1) {
        return 30;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _numberOfSections - 1) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 30)];
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.text = @"已显示全部评论";
        hintLabel.font = [UIFont systemFontOfSize:hintLabelFontSize];
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.frame = CGRectMake(0, (30 - hintLabel.font.lineHeight) / 2, selfWidth, hintLabel.font.lineHeight);
        [_footView addSubview:hintLabel];
        return _footView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 40)];
    _headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:titleLabelFontSize];
    if (_numberOfSections == 2 && section == 0) {
        titleLabel.text = [NSString stringWithFormat:@"%lu 条长评", _longComments.count];
    } else {
        titleLabel.text = [NSString stringWithFormat:@"%lu 条短评", _shortComments.count];
    }
    titleLabel.frame = CGRectMake(15, (40 - titleLabel.font.lineHeight) / 2, selfWidth - 15, titleLabel.font.lineHeight);
    [_headerView addSubview:titleLabel];
    return _headerView;
}

#pragma mark CellForRowAtIndexPath

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [_commentTableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDate *now = [NSDate date];
    NSDateComponents *comp = [_gregorian components:_unitFlags fromDate:now];
    
    if (indexPath.section == 0 && _numberOfSections == 2) {
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:_longCommentHeadImages[indexPath.row]] placeholderImage:[UIImage imageNamed:@"wufajiazai.png"]];
        cell.nameLabel.text = _longCommentAuthors[indexPath.row];
        cell.commentLabel.numberOfLines = 0;
        cell.commentLabel.text = _longComments[indexPath.row];
        NSString * timeStampString = _longCommentTime[indexPath.row];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: [timeStampString doubleValue]];
        NSDateComponents *comp2 = [_gregorian components:_unitFlags fromDate:date];
        if ((comp.day == comp2.day) &&(comp.month == comp2.month) && (comp.year == comp2.year)) {
            cell.timeLabel.text = [NSString stringWithFormat:@"今天 %@", [_todayStampFormatter stringFromDate:date]];
        } else if (comp.year != comp2.year) {
            cell.timeLabel.text = [_stampFormatter2 stringFromDate:date];
        } else {
            cell.timeLabel.text = [_stampFormatter stringFromDate:date];
        }
#pragma mark longCommentReplyLabel
        if (![_longCommentReplyTo[indexPath.row] isEqualToString:@"NOREPLY"]) {
            cell.replyLabel.text = _longCommentReplyTo[indexPath.row];
            cell.replyLabel.hidden = NO;
        } else {
            cell.replyLabel.text = nil;
            cell.replyLabel.hidden = YES;
        }
        
        NSNumber *num = _longCommentShouldFold[indexPath.row];
        if (num.intValue == 0) {
            cell.replyLabel.numberOfLines = 2;
            [cell.foldButton setTitle:@"· 展开全文" forState:UIControlStateNormal];
        } else {
            cell.replyLabel.numberOfLines = 0;
            [cell.foldButton setTitle:@"· 收起" forState:UIControlStateNormal];
        }
        NSInteger count = [self textHeightFromTextString: _longCommentReplyTo[indexPath.row] width:(cell.frame.size.width - 76) fontSize:15].height / cell.replyLabel.font.lineHeight;
        if (count <= 2) {
            cell.foldButton.hidden = YES;
        } else {
            cell.foldButton.hidden = NO;
        }
        cell.foldButton.tag = indexPath.row;
        [cell.foldButton addTarget:self action:@selector(pressLongFold:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row == _longComments.count - 1 && _shortComments.count == 0) {
            cell.separatorView.hidden = YES;
        }
        cell.numberOfLikesLabel.text = _longCommentNumberOfLikes[indexPath.row];
        if ([_longCommentNumberOfLikes[indexPath.row] isEqualToString:@"0"]) {
            cell.numberOfLikesLabel.hidden = YES;
        } else {
            cell.numberOfLikesLabel.hidden = NO;
        }
        
        
    } else {
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:_shortCommentHeadImages[indexPath.row]] placeholderImage:[UIImage imageNamed:@"wufajiazai.png"]];
        cell.nameLabel.text = _shortCommentAuthors[indexPath.row];
        cell.commentLabel.numberOfLines = 0;
        cell.commentLabel.text = _shortComments[indexPath.row];
        NSString * timeStampString = _shortCommentTime[indexPath.row];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStampString doubleValue]];
        NSDateComponents *comp2 = [_gregorian components:_unitFlags fromDate:date];
        if ((comp.day == comp2.day) &&(comp.month == comp2.month) && (comp.year == comp2.year)) {
            cell.timeLabel.text = [NSString stringWithFormat:@"今天 %@", [_todayStampFormatter stringFromDate:date]];
        } else if (comp.year != comp2.year) {
            cell.timeLabel.text = [_stampFormatter2 stringFromDate:date];
        } else {
            cell.timeLabel.text = [_stampFormatter stringFromDate:date];
        }
        
#pragma mark shortCommentReplyLabel
        
        if (![_shortCommentReplyTo[indexPath.row] isEqualToString:@"NOREPLY"]) {
            cell.replyLabel.text = _shortCommentReplyTo[indexPath.row];
            cell.replyLabel.hidden = NO;
        } else {
            cell.replyLabel.text = nil;
            cell.replyLabel.hidden = YES;
        }
        
        NSNumber *num = _shortCommentShouldFold[indexPath.row];
        if (num.intValue == 0) {
            cell.replyLabel.numberOfLines = 2;
            [cell.foldButton setTitle:@"· 展开全文" forState:UIControlStateNormal];
        } else {
            cell.replyLabel.numberOfLines = 0;
            [cell.foldButton setTitle:@"· 收起" forState:UIControlStateNormal];
        }
        NSInteger count = [self textHeightFromTextString: _shortCommentReplyTo[indexPath.row] width:(cell.frame.size.width - 76) fontSize:15].height / cell.replyLabel.font.lineHeight;
        if (count <= 2) {
            cell.foldButton.hidden = YES;
        } else {
            cell.foldButton.hidden = NO;
        }
        cell.foldButton.tag = indexPath.row;
        [cell.foldButton addTarget:self action:@selector(pressShortFold:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row == _shortComments.count - 1) {
            cell.separatorView.hidden = YES;
        }
        cell.numberOfLikesLabel.text = _shortCommentNumberOfLikes[indexPath.row];
        if ([_shortCommentNumberOfLikes[indexPath.row] isEqualToString:@"0"]) {
            cell.numberOfLikesLabel.hidden = YES;
        } else {
            cell.numberOfLikesLabel.hidden = NO;
        }
    }
    
    return cell;
}



- (void)addTopView {
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, statusBarHeight + navBarHeight)];

    _topView.backgroundColor = [UIColor whiteColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(0, statusBarHeight + 5, 50, 35);
    [_backButton setTintColor:[UIColor blackColor]];
    [_backButton setImage:[UIImage imageNamed:@"iconfont-left.png"] forState:UIControlStateNormal];
    [_topView addSubview:_backButton];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:numberLabelFontSize];
    _numberLabel.frame = CGRectMake(50, statusBarHeight + (navBarHeight - _numberLabel.font.lineHeight) / 2, selfWidth - 100, _numberLabel.font.lineHeight);
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_numberLabel];
    _numberLabel.text = @"0 条评论";
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight - 0.5, self.frame.size.width, 0.5)];
    _shadowView.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_shadowView];
    
    [_topView setUserInteractionEnabled: YES];
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTop)];
    [_topView addGestureRecognizer:click];
    
    [self addSubview:_topView];
}

- (void)clickTop {
    [_commentTableView setContentOffset:CGPointZero animated:YES];
}

- (void)initNumberLabel {
    _numberLabel.text = [NSString stringWithFormat:@"%lu 条评论", _longComments.count + _shortComments.count];
}

- (void)pressShortFold:(UIButton *)button {
    
    NSNumber *num = _shortCommentShouldFold[button.tag];
    if (num.intValue == 0) {
        _shortCommentShouldFold[button.tag] = @1;
    } else {
        _shortCommentShouldFold[button.tag] = @0;
    }
//    [_testTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_commentTableView reloadData];
}

- (void)pressLongFold:(UIButton *)button {
    
    NSNumber *num = _longCommentShouldFold[button.tag];
    if (num.intValue == 0) {
        _longCommentShouldFold[button.tag] = @1;
    } else {
        _longCommentShouldFold[button.tag] = @0;
    }
//    [_testTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_commentTableView reloadData];
}

-(CGSize)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    //计算 label需要的宽度和高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}

@end
