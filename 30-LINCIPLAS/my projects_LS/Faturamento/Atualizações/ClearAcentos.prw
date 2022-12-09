#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  | ClearAcentos   � Autor � Fabiano Pereira    � Data �  05/03/08   ���
�������������������������������������������������������������������������������͹��
���Descricao � Limpa Acentos                                                    ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Uso       � Frigorifico MercoSul - AP8                               	     ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
/*/

**************************************************************************
User Function ClearAcentos( cTexto, cPar1, cPar2 )
**************************************************************************

If cPar1 == 'S'
	cTexto:=Strtran(cTexto,Char(9)," ")	//	<- TAB
	cTexto:=Strtran(cTexto,"|","")
	cTexto:=Strtran(cTexto,"�"," ")
	cTexto:=Strtran(cTexto,"'"," ")
	cTexto:=Strtran(cTexto,"�","C")
	cTexto:=Strtran(cTexto,"�","c")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","E")
	cTexto:=Strtran(cTexto,"�","e")
	cTexto:=Strtran(cTexto,"�","e")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","u")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","N")
	cTexto:=Strtran(cTexto,"�","n")
	cTexto:=Strtran(cTexto,"%","P")
	cTexto:=Strtran(cTexto,"$","S")
	cTexto:=Strtran(cTexto,"�","c")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","q")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","A")
	
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","O")
	cTexto:=Strtran(cTexto,"�","c")
	cTexto:=Strtran(cTexto,"�","C")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","e")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","u")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","e")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","u")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","e")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","u")
	cTexto:=Strtran(cTexto,"�","a")
	cTexto:=Strtran(cTexto,"�","e")
	cTexto:=Strtran(cTexto,"�","i")
	cTexto:=Strtran(cTexto,"�","o")
	cTexto:=Strtran(cTexto,"�","u")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","E")
	cTexto:=Strtran(cTexto,"�","I")
	cTexto:=Strtran(cTexto,"�","O")
	cTexto:=Strtran(cTexto,"�","U")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","E")
	cTexto:=Strtran(cTexto,"�","I")
	cTexto:=Strtran(cTexto,"�","O")
	cTexto:=Strtran(cTexto,"�","U")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","E")
	cTexto:=Strtran(cTexto,"�","I")
	cTexto:=Strtran(cTexto,"�","O")
	cTexto:=Strtran(cTexto,"�","U")
	cTexto:=Strtran(cTexto,"�","A")
	cTexto:=Strtran(cTexto,"�","E")
	cTexto:=Strtran(cTexto,"�","I")
	cTexto:=Strtran(cTexto,"�","O")
	cTexto:=Strtran(cTexto,"�","U")
	cTexto:=Strtran(cTexto,"�","-")
	If FunName() <> 'SPEDNFE'
		cTexto:=Strtran(cTexto,"&","E")
	Else
		cTexto:=Strtran(cTexto,"& ","&amp; ")
	EndIf
	cTexto:=Strtran(cTexto,"<","&gt;")
	cTexto:=Strtran(cTexto,">","&amp;")
	cTexto:=Strtran(cTexto,'"',"&quot;")
	cTexto:=Strtran(cTexto,"'","&#39;")
	
	/*
	cTexto:=Strtran(cTexto,"+"," ")
	cTexto:=Strtran(cTexto,"."," ")
	cTexto:=Strtran(cTexto,")"," ")
	cTexto:=Strtran(cTexto,"("," ")
	*/
Endif

If !Empty(cPar2)
	If "*" $ cPar2
		cTexto := Strtran(cTexto,"*","")
	Endif
	If "." $ cPar2
		cTexto := Strtran(cTexto,"."," ")
	Endif
	If "-" $ cPar2
		cTexto := Strtran(cTexto,"-"," ")
	Endif
	If "B" $ cPar2
		cTexto := Strtran(cTexto," ","")
	Endif
	
	If "D" $ cPar2
		//Retira os espacos em brancos duplos/triplos etc...
		For n:=1 To Len(AllTrim(cTexto))
			If SubStr(cTexto,n,1) == Space(1)
				y:=n ;	n++
				If SubStr(cTexto,n,1) == Space(1)
					cTexto	:= SubStr(cTexto,1,y)+SubStr(cTexto,n+1,Len(cTexto))
					n:=y-1
				Endif
			EndIf
		Next
	Endif
	
Endif


cTexto 		:= AllTrim( cTexto )

Return(cTexto)


