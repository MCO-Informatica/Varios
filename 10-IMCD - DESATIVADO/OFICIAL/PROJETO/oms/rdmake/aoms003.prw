#INCLUDE "topconn.ch"  
#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AOMS003   � Autor � Giane              � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Descrica  � Cadastro do tipo de veiculo                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � no OMS pois eh do modulo SIGAVEI                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AOMS003              

	Local aArea := GetArea()  
	Local aCores  	:= {}   

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "AOMS003" , __cUserID )

	Private aRotina    := MenuDef()
	Private cCadastro  := "Tipo de Ve�culo"
	Private cAlias     := "DUT"     

	mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Giane               � Data �  XX/XX/XX   ���
�������������������������������������������������������������������������͹��
���Desc.     �Menu principal da rotina                                    ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()          

	Local aRotina    := {}

	Aadd(aRotina,{"Pesquisar" 		,"AxPesqui"	  ,0,1 })
	Aadd(aRotina,{"Visualizar"  	,"AxVisual"   ,0,2 })
	Aadd(aRotina,{"Incluir"  	    ,"AxInclui"   ,0,3 })
	Aadd(aRotina,{"Alterar"  		,"AxAltera"   ,0,4 }) 
	Aadd(aRotina,{"Excluir"         ,"TA530DELOK()"   ,0,5 })   

Return aClone(aRotina)   
