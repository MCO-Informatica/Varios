#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � fMixGrupo� Autor � Luiz Alberto      � Data �20/09/2016���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Selecionar Equipes de Operadores                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � fMixgrupo()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
User Function fEqpOper(cCodOper)
Local aArea := GetArea()
Local cTitulo:=""
Local aReq := {}
Local MvPar
Local MvParDef:="" 
Local i := 1

Private aReq:={}

cAlias := Alias()               // Salva Alias Anterior
MvPar:=Space(200) //&(Alltrim(ReadVar()))   // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())      // Iguala Nome da Variavel ao Nome variavel de Retorno

If SZ1->(dbSetOrder(1), dbSeek(xFilial("SZ1")+cCodOper)) 
	If SZ1->Z1_TIPO == 'O'  
		M->H6_IDOPERA := cCodOper
		Return Left(SZ1->Z1_DESCOPE,10)
	Else
		aRetorno := U_SelOpe(cCodOper)
	Endif
Else
	Return ''
Endif
RestArea(aArea)    

M->H6_IDOPERA := aRetorno[1]
Return( aRetorno[2] )
