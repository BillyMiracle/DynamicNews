//
//  MainPageView.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/17.
//

#import "MainPageView.h"
#import "MainPageCell.h"
#import "SDWebImage.h"
#import "SDImageCacheConfig.h"
#import "SDImageCache.h"
#import "Masonry.h"
#import "FMDB.h"

#define selfWidth self.frame.size.width

//#define numberOfHeadPages _topStoriesImages.count
#define numberOfHeadPages 5

#define topStoryTitleFont 25
#define topStoryHintFont 18

#define titleLabelFont 25
#define dayLabelFont 22
#define monthLabelFont 12

#define scrollTime 4

#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height

#define navBarHeight 60

@interface MainPageView()

@property (nonatomic, strong) FMDatabase *stringDataBase;
@property (nonatomic, strong) NSString *objectsFilePath;
@property (nonatomic, strong) FMDatabase *imageDataBase;
@property (nonatomic, strong) NSString *imageObjectsFilePath;

@property (nonatomic, assign) NSInteger normalImageSumNumber;
@property (nonatomic, assign) NSInteger topImageSumNumber;

@end

@implementation MainPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, frame.size.width, frame.size.height - (statusBarHeight + navBarHeight)) style:UITableViewStyleGrouped];
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.sectionFooterHeight = 0;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, selfWidth)];
    _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, selfWidth)];
    _headPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((_headScrollView.frame.size.width - 155), _headScrollView.frame.size.height - 30, 200, 30)];
    
    [self addSubview:_mainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"updateData" object:nil];
    
    _mainTableView.backgroundColor = [UIColor whiteColor];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _mainTableView.showsVerticalScrollIndicator = NO;
    
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.bounces = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _mainTableView.showsVerticalScrollIndicator = NO;
    
    [_mainTableView registerClass:[MainPageCell class] forCellReuseIdentifier:@"Normal"];
    [_mainTableView registerClass:[MainPageCell class] forCellReuseIdentifier:@"Date"];
    [_mainTableView registerClass:[MainPageCell class] forCellReuseIdentifier:@"Head"];
    
    _days = [NSNumber numberWithInt:0];
    _shouldUpdate = NO;
    
    [self addObserver:self forKeyPath:@"numberOfSections" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    [scrollTimer fire];
    [self initTimerFunction];
    
//    [SDImageCache sharedImageCache].config.maxDiskSize = 1024 * 1024 * 1;
//    [SDImageCache sharedImageCache].config.maxDiskAge = 60 * 10;
    
    _topImageSumNumber = 0;
    _normalImageSumNumber = 0;
    
    return  self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return (_storiesTitles.count >= 6 ? 7 : _storiesTitles.count + 1);
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _numberOfSections - 1) {
        return 100;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _numberOfSections - 1) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _loadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiazai.png"]];
        [_footerView addSubview:_loadView];
        _loadView.frame = CGRectMake((selfWidth - 30) / 2, 20, 30, 30);
        _loadView.hidden = YES;
        return _footerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return selfWidth;
    } else if (indexPath.row != 0) {
        return 110;
    } else {
        return 30;
    }
}
#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"%ld", [SDImageCache sharedImageCache].totalDiskCount);
    
    if ((indexPath.row == 0) && (indexPath.section != 0)) {
        MainPageCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"Date" forIndexPath:indexPath];
        
        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        //定义一个时间字段的旗标，指定会获取指定年、月、日、时、分、秒、星期的信息
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
        //获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components: unitFlags fromDate: _dates[indexPath.section - 1]];
        
        cell.cellDateLabel.text = [NSString stringWithFormat:@"%ld 月 %ld 日", comp.month, comp.day];
        
        return cell;
    } else if ((indexPath.row == 0) && (indexPath.section == 0)) {
        
        MainPageCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"Head" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initHeadView];
            
        [cell.contentView addSubview:_headView];
            
        return cell;
        
    } else {
        
        MainPageCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"Normal" forIndexPath:indexPath];
        if (_networkConnection) {
            [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:_storiesImages[indexPath.section * 6 + indexPath.row - 1]] placeholderImage:[UIImage imageNamed:@"wufajiazai.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType type, NSURL *url) {
//                NSLog(@"%@", image);
#pragma mark InsertNormalImage
                
                if (self->_normalImageSumNumber < 6) {
                    [self creatTable];
                    NSData *imgData = UIImagePNGRepresentation(image);
                    [self insert:@1 image:imgData];
                    self->_normalImageSumNumber++;
                }
            }];
        } else {
            if (indexPath.section * 6 + indexPath.row - 1 >= _normalImagesDataArray.count) {
                UIImage *image = [UIImage imageNamed:@"wufajiazai.png"];
                cell.cellImageView.image = image;
            } else {
                UIImage *image = [UIImage imageWithData: _normalImagesDataArray[indexPath.section * 6 + indexPath.row - 1]];
                cell.cellImageView.image = image;
            }
            
        }
        
        
        //UILabel折行左右对齐并且行首不出现符号处理
        NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
        if (@available(iOS 9.0, *)) {
            descStyle.allowsDefaultTighteningForTruncation  = YES;
            descStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        cell.cellTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:_storiesTitles[indexPath.section * 6 + indexPath.row - 1] attributes:@{NSParagraphStyleAttributeName: descStyle}];
        cell.cellHintLabel.attributedText = [[NSAttributedString alloc] initWithString:_storiesHints[indexPath.section * 6 + indexPath.row - 1] attributes:@{NSParagraphStyleAttributeName: descStyle}];
        return cell;
        
    }
}

- (void)initTimerFunction {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:scrollTime target:self selector:@selector(autoSelectPage) userInfo:nil repeats:YES];
    NSRunLoop* mainloop = [NSRunLoop mainRunLoop];
    [mainloop addTimer:timer forMode:NSRunLoopCommonModes];
    scrollTimer = timer;
}

- (void)headPageControlValueChanged {
    [scrollTimer invalidate];
    CGPoint offset = _headScrollView.contentOffset;
    offset.x = selfWidth * _headPageControl.currentPage;
    [_headScrollView setContentOffset:offset animated:YES];
    [scrollTimer fire];
    [self initTimerFunction];
}

- (void)autoSelectPage {
    if (_headScrollView.contentOffset.x == 0) {
        [_headScrollView setContentOffset:CGPointMake(selfWidth * numberOfHeadPages, 0) animated:NO];
    } else if (_headScrollView.contentOffset.x / selfWidth == (numberOfHeadPages + 1)) {
        [_headScrollView setContentOffset:CGPointMake(selfWidth, 0) animated:NO];
    }
    [_headScrollView setContentOffset:CGPointMake(_headScrollView.contentOffset.x + selfWidth, 0) animated:YES];
    _headPageControl.currentPage = ((int)(_headScrollView.contentOffset.x / selfWidth) + 1) % numberOfHeadPages;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainTableView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height + 0.1 >= scrollView.contentSize.height && _shouldUpdate) {
            _loadView.hidden = NO;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
            animation.fromValue = [NSNumber numberWithFloat:0.f];
            animation.toValue = [NSNumber numberWithFloat: M_PI * 5];
            animation.duration = 3;
            animation.autoreverses = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
            [_loadView.layer addAnimation:animation forKey:nil];
            [self updateData];
        }
    } else if (scrollView == _headScrollView) {
        CGFloat offset = _headScrollView.contentOffset.x;
        CGFloat pagewi = selfWidth;
        _headPageControl.currentPage = (int)(offset / pagewi) % numberOfHeadPages;
        if(offset == 0) {
            [_headScrollView setContentOffset:CGPointMake(selfWidth * numberOfHeadPages, 0) animated:NO];
        }
        if(offset / pagewi == (numberOfHeadPages + 1)) {
            [_headScrollView setContentOffset:CGPointMake(selfWidth, 0) animated:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _headScrollView) {
        [scrollTimer fire];
        [self initTimerFunction];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _headScrollView) {
        [scrollTimer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _headScrollView) {
        CGFloat offset = _headScrollView.contentOffset.x;
        CGFloat pagewi = selfWidth;
        _headPageControl.currentPage = (int)(offset / pagewi) % numberOfHeadPages;
        if(offset == 0) {
            [_headScrollView setContentOffset:CGPointMake(selfWidth * numberOfHeadPages, 0) animated:NO];
        }
        if(offset / pagewi == (numberOfHeadPages + 1)) {
            [_headScrollView setContentOffset:CGPointMake(selfWidth, 0) animated:NO];
        }
    }
}

#pragma mark headView生成
- (void)initHeadView {
    
    _headScrollView.contentSize = CGSizeMake(selfWidth * (numberOfHeadPages + 2), selfWidth);
    _headScrollView.backgroundColor = [UIColor blueColor];
    _headScrollView.pagingEnabled = YES;
    _headScrollView.delegate = self;
    
    _headScrollView.showsVerticalScrollIndicator = NO;
    _headScrollView.showsHorizontalScrollIndicator = NO;
    
    _headScrollView.bounces = NO;
    
//循环创建几个topStories
    for (NSInteger i = 0; i < numberOfHeadPages + 2; ++i) {
        UIImageView *imageView = [self initializeImageViewWithIndex: i];
        [_headScrollView addSubview:imageView];
    }
    
    _headPageControl.numberOfPages = numberOfHeadPages;
    _headPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _headPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_headPageControl addTarget:self action:@selector(headPageControlValueChanged) forControlEvents:UIControlEventValueChanged];
    
    
    [_headView addSubview: _headScrollView];
    [_headView addSubview:_headPageControl];
    
    [_headScrollView setContentOffset:CGPointMake(selfWidth * numberOfHeadPages, 0) animated:NO];
    _headPageControl.currentPage = 0;
    
}

#pragma mark headView中topStory图片点击
- (void)clickTopStory:(UITapGestureRecognizer *) gestureRecognizer {
//    NSLog(@"%d", gestureRecognizer.name.intValue);
    NSNotification *notification = [NSNotification notificationWithName:@"clickTopStory" object:nil userInfo:@{@"key":[NSNumber numberWithInt:gestureRecognizer.name.intValue]}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSLog(@"%ld %ld", _storiesImages.count, indexPath.section * 6 + indexPath.row - 1);
    
    if (indexPath.row != 0) {
        NSInteger number = indexPath.section * 6 + indexPath.row - 1;
        NSNotification *notification = [NSNotification notificationWithName:@"clickStory" object:nil userInfo:@{@"key":[NSNumber numberWithInteger: number]}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
}

#pragma mark 生成topStories
- (UIImageView*)initializeImageViewWithIndex:(NSInteger) i {
    UIImageView *imageView = [[UIImageView alloc] init];
    UIView *colorView = [[UIView alloc] init];
    [imageView addSubview:colorView];
    if (_networkConnection) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:_topStoriesImages[i % numberOfHeadPages]] placeholderImage:[UIImage imageNamed:@"wufajiazai.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType type, NSURL *url) {
//设置图片渐变背景
            colorView.frame = CGRectMake(0, selfWidth - 150, selfWidth, 150);

            UIColor *colorOne = [[[self class] mostColor:image] colorWithAlphaComponent:1.0];
//            UIColor *colorTwo = [[[self class] mostColor:image] colorWithAlphaComponent:0.67];
//            UIColor *colorThree = [[[self class] mostColor:image] colorWithAlphaComponent:0.33];
            UIColor *colorFour = [[[self class] mostColor:image] colorWithAlphaComponent:0.0];
            
            NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorFour.CGColor, nil];
            CAGradientLayer *gradient = [CAGradientLayer layer];
            //设置开始和结束位置(设置渐变的方向)
            gradient.startPoint = CGPointMake(0, 0.8);
            gradient.endPoint = CGPointMake(0, 0);
            gradient.colors = colors;
            gradient.frame = CGRectMake(0, 0, selfWidth, 150);
            [colorView.layer insertSublayer:gradient atIndex:0];

            
#pragma mark InsertTopImage
            if (i < numberOfHeadPages && self->_topImageSumNumber < 5) {
                [self creatTable];
                NSData *imgData = UIImagePNGRepresentation(image);
                [self insert:@0 image:imgData];
                self->_topImageSumNumber++;
            }
        }];
    } else {
//设置图片渐变背景
        UIImage *image = [UIImage imageWithData:_topImagesDataArray[i % numberOfHeadPages]];
        imageView.image = image;
        colorView.frame = CGRectMake(0, selfWidth - 150, selfWidth, 150);

        UIColor *colorOne = [[[self class] mostColor:image] colorWithAlphaComponent:1.0];
        UIColor *colorTwo = [[[self class] mostColor:image] colorWithAlphaComponent:0.0];

        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(0, 0);
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0, selfWidth, 150);
        [colorView.layer insertSublayer:gradient atIndex:0];
    }
    
    imageView.frame = CGRectMake(selfWidth * i, 0, selfWidth, selfWidth);
    
    UILabel *topTitleLabel = [[UILabel alloc] init];
    topTitleLabel.font = [UIFont boldSystemFontOfSize:topStoryTitleFont];
    topTitleLabel.numberOfLines = 0;
    topTitleLabel.text = _topStoriesTitles [i % numberOfHeadPages];
    //UILabel折行左右对齐并且行首不出现符号处理
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    if (@available(iOS 9.0, *)) {
        descStyle.allowsDefaultTighteningForTruncation  = YES;
    }
    if (_topStoriesTitles[i % numberOfHeadPages]) {
        topTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:_topStoriesTitles[i % numberOfHeadPages] attributes:@{NSParagraphStyleAttributeName:descStyle}];
    }
    //allowsDefaultTighteningForTruncation 这个方法是设置缩进的 他和lineBreakMode这个属性有一定的冲突性 所有要想设置行首不出现符号 需要allowsDefaultTighteningForTruncation = YES; 然后删除lineBreakMode的设置 这样就ok了！allowsDefaultTighteningForTruncation 只有iOS 9.0,以后才有
    topTitleLabel.textColor = [UIColor whiteColor];
    topTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [colorView addSubview:topTitleLabel];
    
    UILabel *topHintLabel = [[UILabel alloc] init];
    [colorView addSubview:topHintLabel];
    topHintLabel.font = [UIFont systemFontOfSize:topStoryHintFont];
    topHintLabel.frame = CGRectMake(20, 150 - 60, selfWidth - 40, 30);
    topHintLabel.textColor = [UIColor lightTextColor];
    topHintLabel.text = _topStoriesHints[i % numberOfHeadPages];
    
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topHintLabel.mas_top);
        make.left.mas_equalTo(imageView.mas_left).offset(20);
        make.right.mas_equalTo(imageView.mas_right).offset(-20);
    }];
    
    //添加点击
    [imageView setUserInteractionEnabled: YES];
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopStory:)];
    click.name = [NSString stringWithFormat:@"%ld", 100 + i % numberOfHeadPages];
    [imageView addGestureRecognizer:click];
    
    return imageView;
}

#pragma mark AddNavBarView
- (void)addNavBarView {
    
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, self.frame.size.width, navBarHeight)];
//添加点击
    [_navBarView setUserInteractionEnabled: YES];
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadView)];
    [_navBarView addGestureRecognizer:click];
    _navBarView.backgroundColor = [UIColor whiteColor];
    
    _headButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_navBarView addSubview:_headButton];
    _headButton.layer.masksToBounds = YES;
    _headButton.layer.cornerRadius = (navBarHeight - 18) / 2;
    _headButton.layer.borderWidth = 0;
    [_headButton setBackgroundImage:[UIImage imageNamed:@"HEAD.jpg"] forState:UIControlStateNormal];
    [_headButton addTarget:self action:@selector(pressHead) forControlEvents:UIControlEventTouchUpInside];
    [_headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_navBarView.mas_top).offset(9);
        make.bottom.mas_equalTo(_navBarView.mas_bottom).offset(-9);
        make.right.mas_equalTo(_navBarView.mas_right).offset(-9);
        make.width.mas_equalTo(navBarHeight - 18);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    [_navBarView addSubview:leftView];
    
    _dayLabel = [[UILabel alloc] init];
    [leftView addSubview:_dayLabel];
    _dayLabel.font = [UIFont systemFontOfSize:dayLabelFont];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftView.mas_top);
        make.left.mas_equalTo(leftView.mas_left);
        make.right.mas_equalTo(leftView.mas_right);
    }];
    
    _monthLabel = [[UILabel alloc] init];
    [leftView addSubview:_monthLabel];
    _monthLabel.font = [UIFont systemFontOfSize:monthLabelFont];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dayLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(leftView.mas_left);
        make.bottom.mas_equalTo(leftView.mas_bottom);
        make.right.mas_equalTo(leftView.mas_right);
    }];
    
    if (_todayDate) {
        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        //定义一个时间字段的旗标，指定会获取指定年、月、日、时、分、秒、星期的信息
        unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
        //获取不同时间字段的信息
        
        NSDateComponents *comp = [gregorian components: unitFlags fromDate: _todayDate];
        _dayLabel.text = [NSString stringWithFormat:@"%ld", comp.day];
        switch (comp.month) {
            case 1:
                _monthLabel.text = @"一月";
                break;
            case 2:
                _monthLabel.text = @"二月";
                break;
            case 3:
                _monthLabel.text = @"三月";
                break;
            case 4:
                _monthLabel.text = @"四月";
                break;
            case 5:
                _monthLabel.text = @"五月";
                break;
            case 6:
                _monthLabel.text = @"六月";
                break;
            case 7:
                _monthLabel.text = @"七月";
                break;
            case 8:
                _monthLabel.text = @"八月";
                break;
            case 9:
                _monthLabel.text = @"九月";
                break;
            case 10:
                _monthLabel.text = @"十月";
                break;
            case 11:
                _monthLabel.text = @"十一月";
                break;
            default:
                _monthLabel.text = @"十二月";
                break;
        }
    }
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_navBarView.mas_left).offset(9);
        make.centerY.mas_equalTo(_headButton.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [_navBarView addSubview:lineView];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.mas_right).offset(9);
        make.width.mas_equalTo(@1);
        make.top.mas_equalTo(leftView.mas_top);
        make.bottom.mas_equalTo(leftView.mas_bottom);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [_navBarView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:titleLabelFont];
    _titleLabel.text = @"知乎日报";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right).offset(9);
        make.top.mas_equalTo(_navBarView.mas_top).offset(9);
        make.bottom.mas_equalTo(_navBarView.mas_bottom).offset(-9);
    }];
    
    [self addSubview:_navBarView];
}

- (void)pressHead {
    NSNotification *notification = [NSNotification notificationWithName:@"pressHead" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark UpdateData

- (void)updateData {
    if (_shouldUpdate) {
        NSNotification *notification = [NSNotification notificationWithName:@"getBefore" object:nil userInfo:@{@"Days": _days}];
        if (_networkConnection) {
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
    _shouldUpdate = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"numberOfSections"]) {
        _shouldUpdate = YES;
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"numberOfSections"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateData" object:nil];
}

- (void)clickHeadView {
    [_mainTableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark CreatTable
- (void)creatTable {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents firstObject];
    _objectsFilePath = [documentsPath stringByAppendingPathComponent:@"objects.db"];
    _stringDataBase = [FMDatabase databaseWithPath:_objectsFilePath];
    if ([_stringDataBase open]) {
//        NSLog(@"打开成功");
        NSString *createTableSql = @"create table if not exists ObjectTable(id integer primary key autoincrement,Type integer,Titles text,Hints text,IDs text)";
        BOOL success=[_stringDataBase executeUpdate:createTableSql];
        if (success) {
//            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
    _imageObjectsFilePath = [documentsPath stringByAppendingPathComponent:@"images.db"];
    _imageDataBase = [FMDatabase databaseWithPath:_imageObjectsFilePath];
    if ([_imageDataBase open]) {
//        NSLog(@"打开成功");
        NSString *createTableSql = @"create table if not exists ObjectTable(id integer primary key autoincrement,Type integer,Image bolb)";
        BOOL success=[_imageDataBase executeUpdate:createTableSql];
        if (success) {
//            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
}

- (void)insert:(NSNumber *)Type image:(NSData *)Images {
    NSString *insertSQL=@"insert into ObjectTable (Type,Image) values (?,?)";
    BOOL success=[_imageDataBase executeUpdate:insertSQL, Type, Images];
    if (success) {
//        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

+ (UIColor *)mostColor:(UIImage*)image {
    
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    //缩小图片，加快计算速度
    CGSize thumbSize = CGSizeMake(image.size.width / 20, image.size.height / 20);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, thumbSize.width, thumbSize.height, 8, thumbSize.width * 4, colorSpace,bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    //统计每个点的像素值
    unsigned char *data = CGBitmapContextGetData(context);
    if (data == NULL) {
        return nil;
    }
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = image.size.height / 30; y < thumbSize.height; y++) {
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha = data[offset + 3];
            //去除透明
            if (alpha > 0) {
                //去除白色
                if (red >= 180 || green >= 180 || blue >= 180) {
                    
                } else {
                    NSArray *clr = @[@(red), @(green), @(blue), @(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    //找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if (tmpCount < MaxCount) {
            continue;
        }
        MaxCount = tmpCount;
        MaxColor = curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue] / 255.0f) green:([MaxColor[1] intValue] / 255.0f) blue:([MaxColor[2] intValue] / 255.0f) alpha:([MaxColor[3] intValue] / 255.0f)];
}



@end
