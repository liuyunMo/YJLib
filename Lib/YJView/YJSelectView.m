//
//  YJSelectView.m
//  YJSwear
//
//  Created by zhongyy on 13-8-23.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJSelectView.h"

@implementation YJSelectView
-(void)setResultBlock:(YJResBlock)resultBlock
{
    SET_BLOCK(_resultBlock, resultBlock);
}
-(void)showInView:(UIView *)view
{
    self.clipsToBounds=YES;
    float width=self.frame.size.width;
    float height=self.frame.size.height;
    width=width>0?width:290;
    height=height>0?height:400;
    
    float span=10;
    
    float butHeight=34;
    float butWidth=86.5;
    float spanBu=(width-2*butWidth)/3;
    
    float tabHeght=height-butHeight-span*3-self.customView.frame.size.height-40;
    
    
    
    __block typeof(self)bSelf=self;
    for (int i=0; i<2; i++) {
        YJButton *but=[[YJButton alloc] initWithFrame:CGRectMake(spanBu+(spanBu+butWidth)*i, height-butHeight-span, butWidth, butHeight) event:^(YJButton *bu){
            [bSelf tapButton:bu];
        }];
        but.flagStr=[NSString stringWithFormat:@"%d",i];
        [self addSubview:but];
        [but release];
    }
    if (self.customView) {
        [self addSubview:self.customView];
        [_customView release];
    }
    
    YJButton *but=[[YJButton alloc] initWithFrame:CGRectMake((width-204)/2, height-butHeight-span-45, 204, 35) event:^(YJButton *bu) {
        [bSelf tapButton:bu];
    }];
    but.flagStr=@"2";
    [but setImageWithKeyString:@"new_other"];
    [self addSubview:but];
    [but release];
    
    UITableView *tab=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, tabHeght) style:UITableViewStylePlain];
    tab.delegate=self;
    tab.dataSource=self;
    tab.rowHeight=40;
    tab.showsVerticalScrollIndicator=NO;
    tab.backgroundColor=[UIColor clearColor];
    [self addSubview:tab];
    [tab release];
    
    self.center=view.center;
    [view addSubview:self];
}
-(void)tapButton:(YJButton *)bu
{
    __block typeof(self) bSelf=self;
    if ([bu.flagStr intValue]==2) {
        YJAlertInputView *inputView=[[YJAlertInputView alloc] initWithTitle:@"自定义惩罚方式"];
        inputView.resultBlock=^(id ctx ,NSString*content)
        {
            if (!stringDeleteWhitespaceAndNewline(content)) {
                bSelf.hidden=NO;
            }else{
                if (self.resultBlock) {
                    _resultBlock(bSelf,content);
                    [bSelf removeFromSuperview];
                }
            }
        };
        [inputView showInView:KEY_WINDOW];
        [inputView release];
        self.hidden=YES;
        return;
    }
    
    NSString *str=[bu.flagStr intValue]==1?[self.items objectAtIndex:_selectIndex]:nil;
    if (self.resultBlock) {
        _resultBlock(bSelf,str);
        [bSelf removeFromSuperview];
    }
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_title release];
    [_items release];
    SAFE_BLOCK_RELEASE(_resultBlock);
    [super dealloc];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=_selectIndex)
    {
        UITableViewCell *lastCell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        lastCell.accessoryType=UITableViewCellAccessoryNone;
        UITableViewCell *curCell=[tableView cellForRowAtIndexPath:indexPath];
        curCell.accessoryType=UITableViewCellAccessoryCheckmark;
        _selectIndex=indexPath.row;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *la=[[UILabel alloc] initWithFrame:vi.bounds];
    la.textAlignment=UITextAlignmentCenter;
    la.backgroundColor=COLOR_WITH_RGB(245, 245, 245);
    [vi addSubview:la];
    [la release];
    la.text=self.title;
    vi.layer.shadowOffset=CGSizeMake(0, 1);
    vi.layer.shadowRadius=M_PI/2;
    vi.layer.shadowOpacity=.5;
    vi.layer.shadowColor=[UIColor blackColor].CGColor;
    return [vi autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (NULL==cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textColor=COLOR_WITH_RGB(100, 100, 100);
    }
    if(_selectIndex==indexPath.row)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.textLabel.text=[self.items objectAtIndex:indexPath.row];
    return cell;
}
@end
