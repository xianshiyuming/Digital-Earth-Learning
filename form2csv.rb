#! ruby -Ks
#��ruby1.8�R�[�h�̎w��

# Copyright (C) 2011  Hiroaki Sengoku.


require 'vr/vruby'
require 'vr/vrcontrol' #�W���R���g���[��(�{�^����e�L�X�g�Ȃ�)�̃��C�u����
require 'vr/vrhandler'

#�����R�[�h�ϊ��ɕK�v
require 'kconv'


module MyForm

    def construct      #�E�C���h�E���쐬���ꂽ���ɌĂяo����郁�\�b�h�i����������1�j
    
       move 10,10,600,700 #�ʒux,�ʒuy,�T�C�Yx,�T�C�Yy
       
       ##�t�H�[���̒��g##
       
       #�擪
       addControl(VRStatic,  "label1","���d�q����v���W�F�N�g�`csv�쐬�x���c�[��(Ver1.0)��",10,10,550,40)
       addControl(VRStatic,  "label2","Copyright (C) 2011, E-design",10,40,550,40)       
       addControl(VRStatic,  "label3","-----------------------------------------------------",10,60,550,40)       
       
       #�^�C�g������
       addControl(VRStatic,  "label4","�^�C�g������͂��ĉ������B",10,100,450,40)
       addControl(VREdit,'edit1',"",10,120,310,25)

       #�ꏊ����
       addControl(VRStatic,  "label5","�ꏊ�E�Z��������͂��ĉ������B",10,150,450,40)
       addControl(VREdit,'edit2',"",10,170,310,25)
       
       #�o�ܓx����
       addControl(VRStatic,  "label6","�ܓx�ƌo�x����͂��ĉ������B",10,210,450,40)
       addControl(VRStatic,  "label7","�ܓx�F",10,230,50,40)
       addControl(VRStatic,  "label8","�o�x�F",170,230,50,40)
       addControl(VREdit,'edit3',"",60,230,100,25)   #�ܓx
       addControl(VREdit,'edit4',"",230,230,100,25)  #�o�x
       
       
       #URL����
       addControl(VRStatic,  "label9","URL�E�t�@�C���̏ꏊ���w�肵�ĉ������B",10,270,450,40)
       addControl(VREdit,'edit5',"",10,290,310,25)
       addControl(VRButton,'button1',"�t�@�C����I��",330,290,148,25)
       
       #�X�P�[���w��
       addControl(VRStatic,  "label10","�X�P�[�����w�肵�ĉ������i1�`10�j",10,330,450,40)
       addControl(VREdit,'edit6',"",10,350,100,25)
                    
       #�N��
       addControl(VRStatic,  "label11","�o�͐���w�肵csv�����o���{�^����������csv��������쐬���܂��B",10,390,500,40)
       addControl(VRStatic,  "label12","�N���A�{�^���������Əo�͐�ȊO�������o���܂��B",10,410,500,40)
       addControl(VRStatic,  "label13","�o�͐�N���A�{�^���������Əo�͐�������o���܂��B",10,430,500,40)
       addControl(VREdit,'edit7',"",10,450,310,25)
       addControl(VRButton,'button2',"�o�͐�w��",330,450,148,25)       
       
       addControl(VRButton,'button3',"csv�����o��",10,480,100,30,0x0300) #�����o���J�n�{�^��
       
       #�N���A�{�^��
       addControl(VRButton,'button4',"�N���A",120,480,100,30,0x0300) 

       #�o�͐�N���A�{�^��
       addControl(VRButton,'button6',"�o�͐�N���A",230,480,110,30,0x0300) 
       
       #��Ɗ���
       addControl(VRStatic,  "label14","-----------------------------------------------------",10,510,550,40)       
       addControl(VRStatic,  "label15","��Ƃ���������ꍇ��csv�쐬�{�^���������ĉ������B�B",10,530,500,40)
       addControl(VRButton,'button5',"csv�쐬",10,550,100,30,0x0300) 
       
       
       
       addControl(VRStatic,  "label16","-----------------------------------------------------",10,580,550,40)       
       
       #�����J�n�錾
       addControl(VRStatic,  "label17","<Status> �����J�n�ҋ@��...",10,600,580,80)
       

    end #construct�I�_


##�^�C�g��##
def self_created   #construct�̌�ɌĂяo����郁�\�b�h�i����������2�j
    self.caption = "�d�q����v���W�F�N�g�`csv�쐬�x���c�[���iVer1.0�j" #�\��
end


#�t�@�C���I���@�\�ǉ�
def button1_clicked
    file = openFilenameDialog([["���ׂ�","*.*"],["Ruby Script","*.rb"]])
    @edit5.text = file if file
end

def button2_clicked
    file = saveFilenameDialog([["���ׂ�","*.*"],["Ruby Script","*.rb"]])
    @edit7.text = file if file
end


#csv�����o���{�^�����N���b�N����ƁE�E�E
def button3_clicked
    input1 = @edit1.text   #�^�C�g��
    input2 = @edit2.text   #�Z����
    input3 = @edit3.text   #�ܓx
    input4 = @edit4.text   #�o�x
    input5 = @edit5.text   #URL
    input6 = @edit6.text   #�X�P�[��
    input7 = @edit7.text   #�o�͐�

   #���ʎ擾
   self.do_matching(input1, input2, input3, input4, input5, input6, input7)
   
end


#�N���A�{�^��
def button4_clicked
    @edit1.text = ""
    @edit2.text = ""
    @edit3.text = ""
    @edit4.text = ""
    @edit5.text = ""
    @edit6.text = ""

@label17.caption = "<Status> �o�͐�ȊO���N���A���܂����B"
   
end

#�o�͐�N���A�{�^��
def button6_clicked
    @edit7.text = ""

@label17.caption = "<Status> �o�͐���N���A���܂����B"
   
end


frm=VRLocalScreen.newform #�V�����E�C���h�E�i�t�H�[���j���J�����������܂��B
frm.extend MyForm        #MyForm���W���[���ŋ@�\�g�����܂��B
frm.create.show #create�Ŏ��ۂɃt�H�[�����쐬���Ashow�Ńt�H�[����\�����܂��B



#�����J�n
def frm.do_matching(input1, input2, input3, input4, input5, input6, input7)

    #�����l�擾
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

#�G���[�t���O
error_flag = 0

#���̓t�@�C�����o�̓t�@�C�����󔒂Ȃ疳��
if title == "" || address == "" || ido == "" || keido == "" || url == "" || scale == "" || output_data == ""
error_flag = 1
end



##����ȍ~��error_flag = 0�̏ꍇ�̂ݏ���
if error_flag == 0

output_row = "x," + title + "," + address + "," + ido + "," + keido + "," + url + "," + scale
output_row = output_row.to_s

fileout = open(output_data, "a")
fileout.puts output_row
fileout.close

output_kekka = "<Status>\n" + output_row + "\n���o�͂��܂����B"
@label17.caption = output_kekka


elsif error_flag == 1 #error_flag == 1�̏ꍇ
@label17.caption = "<ERROR!!> ���͏��ɕs��������܂��B\n�ēx���������͂��āucsv�����o���v���N���b�N���ĉ������B"

end #error_flag����̏I�_


end #button3�̏����I�_



#csv�쐬�{�^��
def button5_clicked
    output_data = @edit7.text   #�o�͐�

   unless output_data =~ /.csv$/
   output_data = output_data + ".csv"
   end

#output_data�����[�h
@label17.caption = "<Status> csv�t�@�C���쐬��..."

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

#�t�B�[���h�L���`�F�b�N
field = "ID,title,address,lat,lon,url,scale"
   unless array[0] == field
   array.unshift(field)
   end

nr = 0
array.each{|rows|
row = rows.to_s

   if nr >= 1 #�ŏ��̓t�B�[���h�����珈���s�v
   tmp = []
   tmp = row.split(',')
   tmp[0] = nr
   new_row = tmp.join(',')
   array[nr] = new_row
   end

nr = nr + 1
}

#@array���o��
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
label_text = "<Status> �����i" + nr_s + "���j\n" + output_data + "\n�ɏo�͂��܂����B"
@label17.caption = label_text

   
end  #button5�I�_




end #module�I�_

VRLocalScreen.messageloop #���b�Z�[�W���[�v�ɓ���܂�
