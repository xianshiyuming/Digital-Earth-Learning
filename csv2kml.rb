#! ruby -Ks
#↑ruby1.8コードの指定

# Copyright (C) 2011  Hiroaki Sengoku.


require 'vr/vruby'
require 'vr/vrcontrol' #標準コントロール(ボタンやテキストなど)のライブラリ

#文字コード変換に必要
require 'kconv'


module MyForm

    def construct      #ウインドウが作成された時に呼び出されるメソッド（初期化その1）
    
       move 10,10,600,380 #位置x,位置y,サイズx,サイズy
       
       ##フォームの中身##
       
       #先頭
       addControl(VRStatic,  "label1","◆kmlファイル作成システム(Ver1.0)◆",10,10,550,40)
       addControl(VRStatic,  "label2"," Copyright (C) E-design",10,40,550,40)
       addControl(VRStatic,  "label3","-----------------------------------------------------",10,60,550,40)       
       
       #ファイル選択
       addControl(VRStatic,  "label4","入力ファイルを指定して下さい。",10,80,450,40)
       addControl(VRButton,'button1',"ファイルを選択",330,100,148,25)
       addControl(VREdit,'edit1',"",10,100,310,25)

       #出力ファイル名指定
       addControl(VRStatic,  "label5","出力ファイルを指定して下さい。",10,140,450,40)
       addControl(VRButton,'button2',"ファイルを選択",330,160,148,25)
       addControl(VREdit,'edit2',"",10,160,310,25)
                    
       #起動
       addControl(VRStatic,  "label6","入力・出力ファイル名を指定したら、開始をクリックして下さい。",10,200,500,40)
       addControl(VRStatic,  "label7","（※kmlファイルは入力ファイルと同じフォルダに出力されます。）",10,220,550,40)
       addControl(VRButton,'button3',"開始",10,245,100,30,0x0300) #検索開始ボタン
       
       
       addControl(VRStatic,  "label8","-----------------------------------------------------",10,280,550,40)       
       
       #検索開始宣言
       addControl(VRStatic,  "label9","<Status> 処理開始待機中...",10,300,600,40)
       

    end #construct終点



##タイトル##
def self_created   #constructの後に呼び出されるメソッド（初期化その2）
    self.caption = "kmlファイル作成システム（Ver1.0）" #表題
end


#ファイル選択機能追加
def button1_clicked
    file = openFilenameDialog([["すべて","*.*"],["Ruby Script","*.rb"]])
    @edit1.text = file if file
end

def button2_clicked
    file = saveFilenameDialog([["すべて","*.*"],["Ruby Script","*.rb"]])
    @edit2.text = file if file
end


#検索ボタンをクリックすると・・・
def button3_clicked
    input_data = @edit1.text
    output_data = @edit2.text  

   #結果取得
   self.do_matching(input_data, output_data)
   
end


frm=VRLocalScreen.newform #新しくウインドウ（フォーム）を開く準備をします。
frm.extend MyForm        #MyFormモジュールで機能拡張します。
frm.create.show #createで実際にフォームを作成し、showでフォームを表示します。


#処理開始
def frm.do_matching(input_data, output_data)
	text1 = input_data
	text2 = output_data
	
	#検索開始宣言
        @label9.caption = "<Status> 変換処理を開始します..."
	sleep(2)
	

##初期情報設定##
input_data = text1
output_data = text2


#エラーフラグ
error_flag = 0

#入力ファイルか出力ファイルが空白なら無視
if input_data == "" || output_data == ""
error_flag = 1
end



##これ以降はerror_flag = 0の場合のみ処理
if error_flag == 0


##データロード##

@label9.caption = "<Status> 入力データロード中..."

newdata = open(input_data)
n1 = 0
array = []
while text = newdata.gets do
      array[n1] = text
      array[n1] = array[n1].chomp
      n1 = n1 + 1

n_t = n1.to_s

end
newdata.close

size = array.size
size = size.to_s
cp_text = "<Status> ロード完了（" + size + "件入力）"

@label9.caption = cp_text
	

#############################################################
	
#kml書き換え

def make_kml(v1,v2,v3,v4,v5,v6)
  id = v1.to_s
  name = v2.to_s
  address = v3.to_s
  lat = v4.to_s
  lng = v5.to_s
  url = v6.to_s
  
  out = ""
  
 out1 = " <Placemark id=\""+id+"\">\n"+
    " <name>"+name+"</name>\n"+
    " <Point>\n"+
    " <coordinates>"+lng+","+lat+"</coordinates>\n"+
    " </Point>\n"+
    " <Style id=\"sn_arrow\">\n"+
            "<IconStyle>\n"+
                "<scale>0.5</scale>\n"+
                "<Icon>\n"+
                "<href>http://maps.google.com/mapfiles/kml/shapes/arrow.png</href>\n"+
                "</Icon>\n"+
                 "<hotSpot x=\"32\" y=\"1\" xunits=\"pixels\" yunits=\"pixels\"/>\n"+
            "</IconStyle>\n"+
    "</Style>\n"+
    " <description><![CDATA[\n"+
    "<table width=\"292\">\n<tr>\n<td>\n"+address+"</td>\n</tr>\n<tr>\n<td>\n"
 
 
        if url =~ /.JPG$/ || url =~ /.jpg$/ || url =~ /.PNG$/ || url =~ /.png$/ || url =~ /.BMP$/ || url =~ /.bmp$/ || url =~ /.JPEG$/ || url =~ /.jpeg$/ || url =~ /.GIF$/ || url =~ /.gif$/
	out2 = "<img src=\"" + url + "\"/>"
		
	else
	out2 = "<object height=\"300\" width=\"350\">\n"+
               " <description>"+address+"</description>\n"+
               "<param value="+url+" name=\"movie\">\n"+
               "<param value=\"transparent\" name=\"wmode\">\n"+
               "<embed wmode=\"transparent\" type=\"application/x-shockwave-flash\" src="+url+" height=\"300\" width=\"350\">\n"+
               "</object>\n"
        end
 

out3 = "</td>\n</tr>\n</table>"+
       "]]></description>\n"+
       " </Placemark>"


out = out1 + out2 + out3
out = out.to_s

  return out

end


#ツアー作成

def make_tour(v1,v2,v3,v4)
  id = v1.to_s
  lat = v2.to_s
  lng = v3.to_s
  scale = v4.to_s

  tourcontents = ""

tourcontents = "<gx:FlyTo>\n"+        
                "<gx:duration>10.0</gx:duration>\n<LookAt>\n"+    
                    "<longitude>"+lng+"</longitude>\n"+
                    "<latitude>"+lat+"</latitude>\n"+
                    "<altitude>0</altitude>\n"+
                    "<range>"+scale+"</range>\n"+
                    "<tilt>0</tilt>\n"+
                    "<heading>0</heading>\n"+
                "</LookAt>\n</gx:FlyTo>\n"+
            "<gx:AnimatedUpdate>\n<gx:duration>0.0</gx:duration>\n"+    
                "<Update>\n<targetHref/>\n<Change>\n"+    
                    "<Placemark targetId=\""+id+"\">\n"+
                      "<gx:balloonVisibility>1</gx:balloonVisibility>\n"+
                    "</Placemark>\n</Change>\n</Update>\n</gx:AnimatedUpdate>\n"+
              "<gx:Wait>\n<gx:duration>5.0</gx:duration>\n</gx:Wait>\n"+
            "<gx:AnimatedUpdate>\n<gx:duration>0.0</gx:duration>\n"+    
                 "<Update>\n<targetHref/>\n"+    
                 "<Change>\n<Placemark targetId=\""+id+"\">\n"+
                      "<gx:balloonVisibility>0</gx:balloonVisibility>\n"+
                 "</Placemark>\n</Change>\n</Update>\n</gx:AnimatedUpdate>\n"+        
              "<gx:Wait>\n<gx:duration>1.0</gx:duration>\n</gx:Wait>"

            
   return tourcontents

end



#フィールドの処理
field = array[0]
array.delete_at(0)

#placemarkの格納
place_set = []

#tourの格納
tour_set = []


@label9.caption = "<Status> 処理中..."

na = 0
array.each{|rows|
row = rows.to_s
tmp = []
tmp = row.split(',')

id = tmp[0]
name = tmp[1].toutf8
address = tmp[2].toutf8
lat = tmp[3]
lon = tmp[4]
url = tmp[5]

url = url.gsub(/\\/, "/")

scale = tmp[6].to_s

   #ツアーの標高設定
   if scale == "1"
   altitude = 5000
   
   elsif scale == "2"
   altitude = 7500
   
   elsif scale == "3"
   altitude = 10000
   
   elsif scale == "4"
   altitude = 20000
   
   elsif scale == "5"
   altitude = 50000
   end
   

kml_text = make_kml(id,name,address,lat,lon,url)
tour_text = make_tour(id,lat,lon,altitude)

#結果格納
place_set[na] = kml_text
tour_set[na] = tour_text


na = na + 1
}


###結果作成###
result = []

##ツアーの前後に追加##

#ツアーの最初
text1 = "<gx:Tour>"
text2 = "<open>1</open>"
text3 = "<gx:Playlist>"

#ツアーの最後
text4 = "</gx:Playlist>"
text5 = "</gx:Tour>"

#ツアー部分完成
tour_set.unshift(text3)
tour_set.unshift(text2)
tour_set.unshift(text1)
tour_set.push(text4)
tour_set.push(text5)

##placemarkは@place_setに格納済み


#全体の前につけるやつ
#text1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">"
text1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\">"
text2 = "<Document>" 
text3 = "<name>Test</name>"

#全体の最後につけるやつ
text4 = "</Document>"
text5 = "</kml>"

#全体としては以下のような構成になればＯＫ
#text1＞text2＞text3＞@tour_set＞@place_set＞text4＞text5

result = tour_set + place_set

result.unshift(text3)
result.unshift(text2)
result.unshift(text1)

result.push(text4)
result.push(text5)

#文字コード変更
nr = 0
result.each{|rows|
row = rows.toutf8
result[nr] = row
nr = nr + 1
}



@label9.caption = "<Status> 処理完了"
sleep(0.5)

##################################################

@label9.caption = "<Status> 出力中..."
sleep(1)


   if output_data =~ /.txt$/
   output_data = ouptut_data.sub(/.txt$/, "")
   output_data = output_data + ".kml"
   end
   
   unless output_data =~ /.kml$/
   output_data = output_data + ".kml"
   end


fileout = open(output_data, "w")
ii = 0
final_no = result.size
final_no = final_no - 1

while ii <= final_no
   fileout.puts result[ii]
   ii = ii + 1
end
fileout.close


@label9.caption = "<Status> 完了"
@label9.caption = "<Status> 全処理完了！"	
	
#self.close #処理後にフォームを閉じる

elsif error_flag == 1 #error_flag == 1の場合
@label9.caption = "<ERROR!!> 入力情報に不備があります。\n正しく入力して「開始」をクリックして下さい。"

end #error_flag分岐の終点


end #全体の処理終点

end #module終点

VRLocalScreen.messageloop #メッセージループに入ります
