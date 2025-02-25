# 清空txt
> test1.txt
username=`dialog --stdout --inputbox "您好!我想要統計大眾對於諾羅病毒的認知。\n現在要建立您的個人資料，請輸入你的名字(帳號):" 10 80`;
# dialog --title "你輸入的帳號" --msgbox "$username" 10 80;
passw=`dialog --stdout --passwordbox "請輸入您的密碼:" 10 80`;
gender=`dialog --stdout --title "您的生理性別" --radiolist "單選" 10 30 2 1 "男" on 2 "女" off`;
birth=`dialog --stdout --calendar "請選擇生日" 15 50 9 6 1997`;
echo "您的帳號: $username" >> test1.txt
echo "您的密碼: $passw" >> test1.txt
echo "您的性別: $gender" >> test1.txt
echo "您的生日: $birth" >> test1.txt
dialog --stdout --title "歡迎來到衛教小測驗(是非題)" --yesno "請問諾羅病毒用酒精消毒有用嗎?" 10 50;
if [ $? -eq 0 ]; then
	ans="Yes, 錯!酒精消毒沒用，請使用洗手乳或肥皂"
else
	ans="No, 是的，酒精消毒沒用，請使用洗手乳或肥皂"
fi
#ans=`dialog --stdout --title "答案" --msgbox "酒精消毒沒用，請用使用洗手乳或肥皂" 10 50`;
echo "問題:諾羅病毒用酒精消毒有用嗎?" >> test1.txt
echo "回答: $ans" >> test1.txt
question2=`dialog --stdout --title "問題2" --menu "請問下列何者不是感染諾羅病毒的症狀?" 15 50 3 1 "嘔吐" 2 "腹瀉" 3 "發燒" 4 "以上皆是得到諾羅的症狀"`
if [ "$question2" = "1" ]; then
	ans2="1, 錯!感染諾羅還有其他症狀，正確答案為 4 以上皆是得到諾羅的症狀"
elif [ "$question2" = "2" ]; then
	ans2="2, 錯!感染諾羅還有其他症狀，正確答案為 4 以上皆是得到諾羅的症狀"
elif [ "$question2" = "3" ]; then
	ans2="3, 錯!感染諾羅還有其他症狀，正確答案為 4 以上皆是得到諾羅的症狀"
else
	ans2="4, 是的，以上皆是感染諾羅的症狀"
fi
echo "問題:請問下列何者不是感染諾羅病毒的症狀? 1 嘔吐 2 腹瀉 3 發燒 4 以上皆是得到諾羅的症狀" >> test1.txt
echo "回答: $ans2" >> test1.txt

question3=`dialog --stdout --title "問題3(複選題)" --checklist "請問感染諾羅病毒後，應採取甚麼行為?" 15 50 3 1 "由於此病原具有高度的傳播能力，儘量在家休息，不要去上學或上班。" on 2 "補充水分及電解質，避免脫水或電解質不平衡。" on 3 "生病期間患者最好不要為家人準備食物，建議在症狀消失至少2-3天後再開始。" off`
if [[ "$question3" == *"1"* || "$question3" == *"2"* || "$question3" == *"3"* ]]; then
	ans3="錯!感染諾羅後還有其他應採取的行為，正確答案為 1, 2, 3 皆是感染諾羅病毒後，應採取的行為"
elif [[ ( "$question3" == *"1"* && "$question3" == *"2"* ) || ( "$question3" == *"1"* && "$question3" == *"3"* ) || ( "$question3" == *"2"* && "$question3" == *"3"* ) ]]; then
	ans3="錯!感染諾羅後還有其他應採取的行為，正確答案為 1, 2, 3 皆是感染諾羅病毒後，應採取的行為"
else
	ans3="1, 2, 3 皆是感染諾羅病毒後，應採取的行為"
fi

echo "問題:請問感染諾羅病毒後，應採取甚麼行為?" >> test1.txt
echo "回答: $ans3" >> test1.txt
dialog --title "對答紀錄" --textbox ~/test1.txt 30 100

db_user="sharon"
db_passw="dv107"
db_name="test1_20250225"
db_host="localhost"

mysql -u$db_user -p$db_passw -h $db_host -D $db_name -e "
create table if not exists test1_ans (
question text not null,
ans text not null);
"

mysql -u$db_user -p"$db_passw" -h $db_host -D $db_name -e "
insert into test1_ans (question, ans)
values ('請問諾羅病毒用酒精消毒有用嗎?', '$ans'),
('請問下列何者不是感染諾羅病毒的症狀?', '$ans2'),
('請問感染諾羅病毒後，應採取甚麼行為?', '$ans3');"

mysql -u$db_user -p"$db_passw" -h $db_host -D $db_name -e "
select * from test1_ans;"



