#! ruby -Ks
#↑ruby1.8コードの指定

# Copyright (C) 2011  Hiroaki Sengoku.


require 'vr/vruby'
require 'vr/vrcontrol' #標準コントロール(ボタンやテキストなど)のライブラリ
require 'vr/vrhandler'

#文字コード変換に必要
require 'kconv'


module MyForm

    def construct      #ウインドウが作成された時に呼び出されるメソッド（初期化その1）
    
       move 10,10,600,700 #位置x,位置y,サイズx,サイズy
       
       ##フォームの中身##
       
       #先頭
       addControl(VRStatic,  "label1","◆電子教育プロジェクト～csv作成支援ツール(Ver1.0)◆",10,10,550,40)
       addControl(VRStatic,  "label2","Copyright (C) 2011, E-design",10,40,550,40)       
       addControl(VRStatic,  "label3","-----------------------------------------------------",10,60,550,40)       
       
       #タイトル入力
       addControl(VRStatic,  "label4","タイトルを入力して下さい。",10,100,450,40)
       addControl(VREdit,'edit1',"",10,120,310,25)

       #場所入力
       addControl(VRStatic,  "label5","場所・住所等を入力して下さい。",10,150,450,40)
       addControl(VREdit,'edit2',"",10,170,310,25)
       
       #経緯度入力
       addControl(VRStatic,  "label6","緯度と経度を入力して下さい。",10,210,450,40)
       addControl(VRStatic,  "label7","緯度：",10,230,50,40)
       addControl(VRStatic,  "label8","経度：",170,230,50,40)
       addControl(VREdit,'edit3',"",60,230,100,25)   #緯度
       addControl(VREdit,'edit4',"",230,230,100,25)  #経度
       
       
       #URL入力
       addControl(VRStatic,  "label9","URL・ファイルの場所を指定して下さい。",10,270,450,40)
       addControl(VREdit,'edit5',"",10,290,310,25)
       addControl(VRButton,'button1',"ファイルを選択",330,290,148,25)
       
       #スケール指定
       addControl(VRStatic,  "label10","スケールを指定して下さい（1～10）",10,330,450,40)
       addControl(VREdit,'edit6',"",10,350,100,25)
                    
       #起動
       addControl(VRStatic,  "label11","出力先を指定しcsv書き出しボタンを押すとcsv文字列を作成します。",10,390,500,40)
       addControl(VRStatic,  "label12","クリアボタンを押すと出力先以外を消去出来ます。",10,410,500,40)
       addControl(VRStatic,  "label13","出力先クリアボタンを押すと出力先を消去出来ます。",10,430,500,40)
       addControl(VREdit,'edit7',"",10,450,310,25)
       addControl(VRButton,'button2',"出力先指定",330,450,148,25)       
       
       addControl(VRButton,'button3',"csv書き出し",10,480,100,30,0x0300) #書き出し開始ボタン
       
       #クリアボタン
       addControl(VRButton,'button4',"クリア",120,480,100,30,0x0300) 

       #出力先クリアボタン
       addControl(VRButton,'button6',"出力先クリア",230,480,110,30,0x0300) 
       
       #作業完了
       addControl(VRStatic,  "label14","-----------------------------------------------------",10,510,550,40)       
       addControl(VRStatic,  "label15","作業を完了する場合はcsv作成ボタンを押して下さい。。",10,530,500,40)
       addControl(VRButton,'button5',"csv作成",10,550,100,30,0x0300) 
       
       
       
       addControl(VRStatic,  "label16","-----------------------------------------------------",10,580,550,40)       
       
       #検索開始宣言
       addControl(VRStatic,  "label17","<Status> 処理開始待機中...",10,600,580,80)
       

    end #construct終点


##タイトル##
def self_created   #constructの後に呼び出されるメソッド（初期化その2）
    self.caption = "電子教育プロジェクト～csv作成支援ツール（Ver1.0）" #表題
end


#ファイル選択機能追加
def button1_clicked
    file = openFilenameDialog([["すべて","*.*"],["Ruby Script","*.rb"]])
    @edit5.text = file if file
end

def button2_clicked
    file = saveFilenameDialog([["すべて","*.*"],["Ruby Script","*.rb"]])
    @edit7.text = file if file
end


#csv書き出しボタンをクリックすると・・・
def button3_clicked
    input1 = @edit1.text   #タイトル
    input2 = @edit2.text   #住所等
    input3 = @edit3.text   #緯度
    input4 = @edit4.text   #経度
    input5 = @edit5.text   #URL
    input6 = @edit6.text   #スケール
    input7 = @edit7.text   #出力先

   #結果取得
   self.do_matching(input1, input2, input3, input4, input5, input6, input7)
   
end


#クリアボタン
def button4_clicked
    @edit1.text = ""
    @edit2.text = ""
    @edit3.text = ""
    @edit4.text = ""
    @edit5.text = ""
    @edit6.text = ""

@label17.caption = "<Status> 出力先以外をクリアしました。"
   
end

#出力先クリアボタン
def button6_clicked
    @edit7.text = ""

@label17.caption = "<Status> 出力先をクリアしました。"
   
end


frm=VRLocalScreen.newform #新しくウインドウ（フォーム）を開く準備をします。
frm.extend MyForm        #MyFormモジュールで機能拡張します。
frm.create.show #createで実際にフォームを作成し、showでフォームを表示します。



#処理開始
def frm.do_matching(input1, input2, input3, input4, input5, input6, input7)

    #初期値取得
    title = input1.to_s
    address = input2.to_s
    ido = input3.to_s
    keido = input4.to_s
    url = input5.to_s
    scale = input6.to_s
    output_data = input7.to_s
	

   unless output_data =~ /.csv$/
   output_data = output_data + ".csv"
   end

#エラーフラグ
error_flag = 0

#入力ファイルか出力ファイルが空白なら無視
if title == "" || address == "" || ido == "" || keido == "" || url == "" || scale == "" || output_data == ""
error_flag = 1
end



##これ以降はerror_flag = 0の場合のみ処理
if error_flag == 0

output_row = "x," + title + "," + address + "," + ido + "," + keido + "," + url + "," + scale
output_row = output_row.to_s

fileout = open(output_data, "a")
fileout.puts output_row
fileout.close

output_kekka = "<Status>\n" + output_row + "\nを出力しました。"
@label17.caption = output_kekka


elsif error_flag == 1 #error_flag == 1の場合
@label17.caption = "<ERROR!!> 入力情報に不備があります。\n再度正しく入力して「csv書き出し」をクリックして下さい。"

end #error_flag分岐の終点


end #button3の処理終点



#csv作成ボタン
def button5_clicked
    output_data = @edit7.text   #出力先

   unless output_data =~ /.csv$/
   output_data = output_data + ".csv"
   end

#output_dataをロード
@label17.caption = "<Status> csvファイル作成中..."

newdata = open(output_data)
n1 = 0
array = []
while text = newdata.gets do
      array[n1] = text
      array[n1] = array[n1].chomp
      n1 = n1 + 1

n_t = n1.to_s

end
newdata.close

#フィールド有無チェック
field = "ID,title,address,lat,lon,url,scale"
   unless array[0] == field
   array.unshift(field)
   end

nr = 0
array.each{|rows|
row = rows.to_s

   if nr >= 1 #最初はフィールドだから処理不要
   tmp = []
   tmp = row.split(',')
   tmp[0] = nr
   new_row = tmp.join(',')
   array[nr] = new_row
   end

nr = nr + 1
}

#@arrayを出力
fileout = open(output_data, "w")
ii = 0
final_no = array.size
final_no = final_no - 1

while ii <= final_no
   fileout.puts array[ii]
   ii = ii + 1
end
fileout.close

nr_s = nr - 1
nr_s = nr_s.to_s
label_text = "<Status> 完了（" + nr_s + "件）\n" + output_data + "\nに出力しました。"
@label17.caption = label_text

   
end  #button5終点




end #module終点

VRLocalScreen.messageloop #メッセージループに入ります
