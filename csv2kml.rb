#! ruby -Ks
#��ruby1.8�R�[�h�̎w��

# Copyright (C) 2011  Hiroaki Sengoku.


require 'vr/vruby'
require 'vr/vrcontrol' #�W���R���g���[��(�{�^����e�L�X�g�Ȃ�)�̃��C�u����

#�����R�[�h�ϊ��ɕK�v
require 'kconv'


module MyForm

    def construct      #�E�C���h�E���쐬���ꂽ���ɌĂяo����郁�\�b�h�i����������1�j
    
       move 10,10,600,380 #�ʒux,�ʒuy,�T�C�Yx,�T�C�Yy
       
       ##�t�H�[���̒��g##
       
       #�擪
       addControl(VRStatic,  "label1","��kml�t�@�C���쐬�V�X�e��(Ver1.0)��",10,10,550,40)
       addControl(VRStatic,  "label2"," Copyright (C) E-design",10,40,550,40)
       addControl(VRStatic,  "label3","-----------------------------------------------------",10,60,550,40)       
       
       #�t�@�C���I��
       addControl(VRStatic,  "label4","���̓t�@�C�����w�肵�ĉ������B",10,80,450,40)
       addControl(VRButton,'button1',"�t�@�C����I��",330,100,148,25)
       addControl(VREdit,'edit1',"",10,100,310,25)

       #�o�̓t�@�C�����w��
       addControl(VRStatic,  "label5","�o�̓t�@�C�����w�肵�ĉ������B",10,140,450,40)
       addControl(VRButton,'button2',"�t�@�C����I��",330,160,148,25)
       addControl(VREdit,'edit2',"",10,160,310,25)
                    
       #�N��
       addControl(VRStatic,  "label6","���́E�o�̓t�@�C�������w�肵����A�J�n���N���b�N���ĉ������B",10,200,500,40)
       addControl(VRStatic,  "label7","�i��kml�t�@�C���͓��̓t�@�C���Ɠ����t�H���_�ɏo�͂���܂��B�j",10,220,550,40)
       addControl(VRButton,'button3',"�J�n",10,245,100,30,0x0300) #�����J�n�{�^��
       
       
       addControl(VRStatic,  "label8","-----------------------------------------------------",10,280,550,40)       
       
       #�����J�n�錾
       addControl(VRStatic,  "label9","<Status> �����J�n�ҋ@��...",10,300,600,40)
       

    end #construct�I�_



##�^�C�g��##
def self_created   #construct�̌�ɌĂяo����郁�\�b�h�i����������2�j
    self.caption = "kml�t�@�C���쐬�V�X�e���iVer1.0�j" #�\��
end


#�t�@�C���I���@�\�ǉ�
def button1_clicked
    file = openFilenameDialog([["���ׂ�","*.*"],["Ruby Script","*.rb"]])
    @edit1.text = file if file
end

def button2_clicked
    file = saveFilenameDialog([["���ׂ�","*.*"],["Ruby Script","*.rb"]])
    @edit2.text = file if file
end


#�����{�^�����N���b�N����ƁE�E�E
def button3_clicked
    input_data = @edit1.text
    output_data = @edit2.text  

   #���ʎ擾
   self.do_matching(input_data, output_data)
   
end


frm=VRLocalScreen.newform #�V�����E�C���h�E�i�t�H�[���j���J�����������܂��B
frm.extend MyForm        #MyForm���W���[���ŋ@�\�g�����܂��B
frm.create.show #create�Ŏ��ۂɃt�H�[�����쐬���Ashow�Ńt�H�[����\�����܂��B


#�����J�n
def frm.do_matching(input_data, output_data)
	text1 = input_data
	text2 = output_data
	
	#�����J�n�錾
        @label9.caption = "<Status> �ϊ��������J�n���܂�..."
	sleep(2)
	

##�������ݒ�##
input_data = text1
output_data = text2


#�G���[�t���O
error_flag = 0

#���̓t�@�C�����o�̓t�@�C�����󔒂Ȃ疳��
if input_data == "" || output_data == ""
error_flag = 1
end



##����ȍ~��error_flag = 0�̏ꍇ�̂ݏ���
if error_flag == 0


##�f�[�^���[�h##

@label9.caption = "<Status> ���̓f�[�^���[�h��..."

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
cp_text = "<Status> ���[�h�����i" + size + "�����́j"

@label9.caption = cp_text
	

#############################################################
	
#kml��������

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


#�c�A�[�쐬

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



#�t�B�[���h�̏���
field = array[0]
array.delete_at(0)

#placemark�̊i�[
place_set = []

#tour�̊i�[
tour_set = []


@label9.caption = "<Status> ������..."

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

   #�c�A�[�̕W���ݒ�
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

#���ʊi�[
place_set[na] = kml_text
tour_set[na] = tour_text


na = na + 1
}


###���ʍ쐬###
result = []

##�c�A�[�̑O��ɒǉ�##

#�c�A�[�̍ŏ�
text1 = "<gx:Tour>"
text2 = "<open>1</open>"
text3 = "<gx:Playlist>"

#�c�A�[�̍Ō�
text4 = "</gx:Playlist>"
text5 = "</gx:Tour>"

#�c�A�[��������
tour_set.unshift(text3)
tour_set.unshift(text2)
tour_set.unshift(text1)
tour_set.push(text4)
tour_set.push(text5)

##placemark��@place_set�Ɋi�[�ς�


#�S�̂̑O�ɂ�����
#text1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">"
text1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\">"
text2 = "<Document>" 
text3 = "<name>Test</name>"

#�S�̂̍Ō�ɂ�����
text4 = "</Document>"
text5 = "</kml>"

#�S�̂Ƃ��Ă͈ȉ��̂悤�ȍ\���ɂȂ�΂n�j
#text1��text2��text3��@tour_set��@place_set��text4��text5

result = tour_set + place_set

result.unshift(text3)
result.unshift(text2)
result.unshift(text1)

result.push(text4)
result.push(text5)

#�����R�[�h�ύX
nr = 0
result.each{|rows|
row = rows.toutf8
result[nr] = row
nr = nr + 1
}



@label9.caption = "<Status> ��������"
sleep(0.5)

##################################################

@label9.caption = "<Status> �o�͒�..."
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


@label9.caption = "<Status> ����"
@label9.caption = "<Status> �S���������I"	
	
#self.close #������Ƀt�H�[�������

elsif error_flag == 1 #error_flag == 1�̏ꍇ
@label9.caption = "<ERROR!!> ���͏��ɕs��������܂��B\n���������͂��āu�J�n�v���N���b�N���ĉ������B"

end #error_flag����̏I�_


end #�S�̂̏����I�_

end #module�I�_

VRLocalScreen.messageloop #���b�Z�[�W���[�v�ɓ���܂�
