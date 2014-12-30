#!/bin/sh

api="http://hq.sinajs.cn/list="
dir=`dirname "$0"`
if [ "$dir" = "." ]; then
	dir=$PWD
fi

# 1: 股票名字 
# 2: 今日开盘价
# 3: 昨日收盘价
# 4: 当前价格
# 5: 今日最高价
# 6: 今日最低价
echo -e "\t\t当前\t涨跌额\t涨跌幅(%)\t开盘价\t昨收\t最高\t最低\n"
while :
do
	row=`tput lines`
	for i in `cat $dir/Stocks.dat`
	do
		curl -s $api$i |iconv -f gbk -t utf8 |cut -d '"' -f 2 | awk -F ',' '{ if ( $4 < $3 ) c="\033[32m";else c="\033[31m"; print \
		substr($1, 0,5)"\t"\
		"\033[33m"$4"\033[0m \t"\
		c substr(($4-$3), 0, 5) "\033[0m" "\t    "\
		c substr(($4-$3)/$3*100, 0, 5) "\033[0m" "\t    "\
		$2"\t"\
		$3"\t"\
		$5"\t"\
		$6"\t"}'
		echo -e $p
		let "row-=2"
	done
	let "row-=1"
	sleep 5
	echo -e "\\033[s\c"
	echo -e "\\033[${row};1H\033[K" 
	echo -e "\\033[u\c" 
done
