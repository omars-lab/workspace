FasdUAS 1.101.10   ��   ��    k             l    � ����  O     �  	  k    � 
 
     O    �    k    �       Z    X  ����  I   "�� ��
�� .coredoexnull���     ****  l    ����  6       n        4   �� 
�� 
uiel  m    ����   4    �� 
�� 
mbar  m    ����   E        n        1    ��
�� 
valL  4    ��  
�� 
attr   m     ! ! � " "  A X I d e n t i f i e r  m     # # � $ $  b l u e t o o t h��  ��  ��    k   % T % %  & ' & I  % <�� (��
�� .prcsclicnull��� ��� uiel ( l  % 8 )���� ) 6  % 8 * + * n   % , , - , 4  ) ,�� .
�� 
uiel . m   * +����  - 4   % )�� /
�� 
mbar / m   ' (����  + E   - 7 0 1 0 n   . 3 2 3 2 1   1 3��
�� 
valL 3 4   . 1�� 4
�� 
attr 4 m   / 0 5 5 � 6 6  A X I d e n t i f i e r 1 m   4 6 7 7 � 8 8  b l u e t o o t h��  ��  ��   '  9 : 9 I  = B�� ;��
�� .sysodelanull��� ��� nmbr ; m   = >���� ��   :  < = < r   C R > ? > c   C N @ A @ n   C J B C B 1   F J��
�� 
titl C n  C F D E D m   D F��
�� 
cwin E  g   C D A m   J M��
�� 
TEXT ? o      ���� *0 bluetoothmenuwindow bluetoothMenuWindow =  F�� F l  S S�� G H��   G 8 2 click on the Control Center drop down on menu bar    H � I I d   c l i c k   o n   t h e   C o n t r o l   C e n t e r   d r o p   d o w n   o n   m e n u   b a r��  ��  ��     J�� J O   Y � K L K k   b � M M  N O N e   b o P P n   b o Q R Q 1   j n��
�� 
pALL R n   b j S T S 2   h j��
�� 
uiel T 4   b h�� U
�� 
sgrp U m   f g����  O  V W V I  p �� X��
�� .prcsclicnull��� ��� uiel X n   p { Y Z Y 4  v {�� [
�� 
chbx [ m   y z����  Z 4   p v�� \
�� 
sgrp \ m   t u���� ��   W  ] ^ ] l  � ��� _ `��   _ C = 		set bluetoothWarningPopup to title of its window as string    ` � a a z   	 	 s e t   b l u e t o o t h W a r n i n g P o p u p   t o   t i t l e   o f   i t s   w i n d o w   a s   s t r i n g ^  b c b l  � ��� d e��   d : 4 set controlCenterElements to UI elements of group 1    e � f f h   s e t   c o n t r o l C e n t e r E l e m e n t s   t o   U I   e l e m e n t s   o f   g r o u p   1 c  g h g l  � ��� i j��   i * $ 		set myattribute to "AXIdentifier"    j � k k H   	 	 s e t   m y a t t r i b u t e   t o   " A X I d e n t i f i e r " h  l m l l  � ��� n o��   n   		set myaction to 1    o � p p (   	 	 s e t   m y a c t i o n   t o   1 m  q r q l  � ��� s t��   s 4 . 		repeat with anItem in controlCenterElements    t � u u \   	 	 r e p e a t   w i t h   a n I t e m   i n   c o n t r o l C e n t e r E l e m e n t s r  v w v l  � ��� x y��   x   			try    y � z z    	 	 	 t r y w  { | { l  � ��� } ~��   } 8 2 			if exists attribute myattribute of anItem then    ~ �   d   	 	 	 i f   e x i s t s   a t t r i b u t e   m y a t t r i b u t e   o f   a n I t e m   t h e n |  � � � l  � ��� � ���   � � � 				if value of attribute myattribute of anItem contains "screen-mirroring" or value of attribute myattribute of anItem contains "Screen Mirroring" then    � � � �2   	 	 	 	 i f   v a l u e   o f   a t t r i b u t e   m y a t t r i b u t e   o f   a n I t e m   c o n t a i n s   " s c r e e n - m i r r o r i n g "   o r   v a l u e   o f   a t t r i b u t e   m y a t t r i b u t e   o f   a n I t e m   c o n t a i n s   " S c r e e n   M i r r o r i n g "   t h e n �  � � � l  � ��� � ���   � , & 				perform action myaction of anItem    � � � � L   	 	 	 	 p e r f o r m   a c t i o n   m y a c t i o n   o f   a n I t e m �  � � � l  � ��� � ���   �   					exit repeat    � � � � "   	 	 	 	 	 e x i t   r e p e a t �  � � � l  � ��� � ���   �  
 			end if    � � � �    	 	 	 e n d   i f �  � � � l  � ��� � ���   �  	 		end if    � � � �    	 	 e n d   i f �  � � � l  � ��� � ���   �   		on error    � � � �    	 	 o n   e r r o r �  � � � l  � ��� � ���   � . ( 		log "error clicking screen mirroring"    � � � � P   	 	 l o g   " e r r o r   c l i c k i n g   s c r e e n   m i r r o r i n g " �  � � � l  � ��� � ���   �   			return "failed"    � � � � &   	 	 	 r e t u r n   " f a i l e d " �  � � � l  � ��� � ���   �  
 		end try    � � � �    	 	 e n d   t r y �  ��� � l  � ��� � ���   �   	end repeat    � � � �    	 e n d   r e p e a t��   L 4   Y _�� �
�� 
cwin � o   [ ^���� *0 bluetoothmenuwindow bluetoothMenuWindow��    4    �� �
�� 
prcs � m     � � � � �  C o n t r o l C e n t e r   � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � M G	click (menu bar item 1 of menu bar 1 whose description is "Bluetooth")    � � � � � 	 c l i c k   ( m e n u   b a r   i t e m   1   o f   m e n u   b a r   1   w h o s e   d e s c r i p t i o n   i s   " B l u e t o o t h " ) �  � � � l  � ��� � ���   �  	delay 1    � � � �  	 d e l a y   1 �  � � � l  � ��� � ���   � 3 -	set window_ to title of its window as string    � � � � Z 	 s e t   w i n d o w _   t o   t i t l e   o f   i t s   w i n d o w   a s   s t r i n g �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � < 6 click checkbox "Mac Pro" of scroll area 1 of window 1    � � � � l   c l i c k   c h e c k b o x   " M a c   P r o "   o f   s c r o l l   a r e a   1   o f   w i n d o w   1 �  ��� � l  � ��� � ���   � &   key code 53 -- Press escape key    � � � � @   k e y   c o d e   5 3   - -   P r e s s   e s c a p e   k e y��   	 m      � ��                                                                                  sevs  alis    T  Untitled                   �ǣ/BD ����System Events.app                                              �����ǣ/        ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    U n t i t l e d  -System/Library/CoreServices/System Events.app   / ��  ��  ��     � � � l     ��������  ��  ��   �  � � � l  � � ����� � I  � ��� ���
�� .sysodelanull��� ��� nmbr � m   � ����� ��  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � ' ! tell application "System Events"    � � � � B   t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s " �  � � � l     �� � ���   � ) # 	get every window of every process    � � � � F   	 g e t   e v e r y   w i n d o w   o f   e v e r y   p r o c e s s �  � � � l     �� � ���   � 5 / 	get every window of every application process    � � � � ^   	 g e t   e v e r y   w i n d o w   o f   e v e r y   a p p l i c a t i o n   p r o c e s s �  � � � l     �� � ���   � - ' 	get every window of every application    � � � � N   	 g e t   e v e r y   w i n d o w   o f   e v e r y   a p p l i c a t i o n �  � � � l     �� � ���   �  	 end tell    � � � �    e n d   t e l l �  ��� � l  � � ����� � Q   � � � � � � O   � � � � � O   � � � � � k   � � � �  �  � e   � � 2   � ���
�� 
cwin  �� O   � � k   � �  e   � � 1   � ���
�� 
pALL 	
	 e   � � 1   � ���
�� 
ects
  e   � � n   � � 1   � ���
�� 
pALL 4   � ���
�� 
butT m   � � � $ T u r n   B l u e t o o t h   O f f  l  � �����     			get every group    � &   	 	 	 g e t   e v e r y   g r o u p  l  � �����   , & 		get every UI element of every group    � L   	 	 g e t   e v e r y   U I   e l e m e n t   o f   e v e r y   g r o u p �� Z   � � ���� I  � ���!��
�� .coredoexnull���     ****! 4   � ���"
�� 
butT" m   � �## �$$ $ T u r n   B l u e t o o t h   O f f��    I  � ���%��
�� .prcsclicnull��� ��� uiel% 4   � ���&
�� 
butT& m   � �'' �(( $ T u r n   B l u e t o o t h   O f f��  ��  ��  ��   4  � ���)
�� 
cwin) m   � ����� ��   � 4   � ���*
�� 
pcap* m   � �++ �,, & C o n t r o l C e n t e r H e l p e r � m   � �--�                                                                                  sevs  alis    T  Untitled                   �ǣ/BD ����System Events.app                                              �����ǣ/        ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    U n t i t l e d  -System/Library/CoreServices/System Events.app   / ��   � R      ��.��
�� .ascrerr ****      � ****. o      ���� 0 errmsg errMsg��   � k   � �// 010 l  � ���23��  2 ? 9 	display dialog "Couldnt bypass conrifmation: " & errMsg   3 �44 r   	 d i s p l a y   d i a l o g   " C o u l d n t   b y p a s s   c o n r i f m a t i o n :   "   &   e r r M s g1 5��5 l  � ���67��  6 l f We should be good if we got an error turning on since the popup only shows up in certain scenarios ..   7 �88 �   W e   s h o u l d   b e   g o o d   i f   w e   g o t   a n   e r r o r   t u r n i n g   o n   s i n c e   t h e   p o p u p   o n l y   s h o w s   u p   i n   c e r t a i n   s c e n a r i o s   . .��  ��  ��  ��       ��9:;��  9 ���
�� .aevtoappnull  �   � ****� *0 bluetoothmenuwindow bluetoothMenuWindow: �~<�}�|=>�{
�~ .aevtoappnull  �   � ****< k     �??  @@  �AA  ��z�z  �}  �|  = �y�y 0 errmsg errMsg>  ��x ��w�vB�u !�t #�s 5 7�r�q�p�o�n�m�l�k�j�i+�h�g#'�f�e
�x 
prcs
�w 
mbar
�v 
uielB  
�u 
attr
�t 
valL
�s .coredoexnull���     ****
�r .prcsclicnull��� ��� uiel
�q .sysodelanull��� ��� nmbr
�p 
cwin
�o 
titl
�n 
TEXT�m *0 bluetoothmenuwindow bluetoothMenuWindow
�l 
sgrp
�k 
pALL
�j 
chbx
�i 
pcap
�h 
ects
�g 
butT�f 0 errmsg errMsg�e  �{ �� �*��/ y*�k/�k/�[��/�,\Z�@1j 
 4*�k/�k/�[��/�,\Z�@1j Okj O*�,a ,a &E` OPY hO*�_ / !*a k/�-a ,EO*a k/a k/j OPUUOPUOkj O ^� V*a a / J*�-EO*�k/ =*a ,EO*a ,EO*a a /a ,EO*a a /j 
 *a a /j Y hUUUW X  h; �CC  C o n t r o l   C e n t e rascr  ��ޭ