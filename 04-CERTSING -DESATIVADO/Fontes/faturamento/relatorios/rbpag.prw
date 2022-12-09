#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  RBPAG  � Autor � Rene Lopes         � Data �  06/04/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio de para - Bpag							          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RBPAG()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "DE PARA - BPAG"
Local cPict          	:= ""
Local titulo       	 	:= "RELATORIO_DE_PARA_BPAG"                  
Local nLin         		:= 80
Local Cabec1       		:= "CODIGO_BPAG        CODIGO_MICROSIGA        PRODUTO           PRE�O VENDA      "
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "RBPAG" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RBPAG" 
Private cString 		:= ""
Private cPerg			:= "RBPAG"

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
Else

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  06/04/2010 ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())  

_cQuery := "SELECT 																										"+Chr(13)+Chr(10)
_cQuery += "PA8_CODBPG 										AS CODIGO_BPAG,												"+Chr(13)+Chr(10)
_cQuery += "PA8.PA8_CODMP8 									AS CODIGO_MICROSIGA,										"+Chr(13)+Chr(10)
_cQuery += "PA8.PA8_DESBPG									AS PRODUTO,													"+Chr(13)+Chr(10)
_cQuery += "SB1.B1_PRV1 									AS PRECO 													"+Chr(13)+Chr(10)
_cQuery += "FROM																										"+Chr(13)+Chr(10)
_cQuery += RetSQLName("PA8")+ " PA8,																					"+Chr(13)+Chr(10)
_cQuery += RetSQLName("SB1")+ " SB1																						"+Chr(13)+Chr(10)
_cQuery += "Where 																										"+Chr(13)+Chr(10)
_cQuery += "PA8.PA8_CODMP8 = SB1.B1_COD							AND														"+Chr(13)+Chr(10)
_cQuery += "PA8.PA8_FILIAL   =  '" + Alltrim(mv_par01) + "'     AND														"+Chr(13)+Chr(10)
_cQuery += "SB1.B1_COD		>=	'" + Alltrim(mv_par02) + "'		AND														"+Chr(13)+Chr(10)
_cQuery += "SB1.B1_COD      <=  '" + Alltrim(mv_par03) + "'    														"+Chr(13)+Chr(10)
//_cQuery += "PA8.PA8_CODBPG   >= '" + AllTrim(mv_par04) + "'		AND														"+Chr(13)+Chr(10)
//_cQuery += "PA8.PA8_CODBPG   <=	'" + AllTrim(mv_par05) + "'     														"+Chr(13)+Chr(10)


If Select("TRC") > 0
	TRC->(DbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRC", .F., .T.)



_cDataBase 	:= dDataBase 
_cTime 		:= Time()
_aCabec 	:= {}
_aDados		:= {}

AAdd(_aDados, {"CODIGO_BPAG","CODIGO_MICROSIGA","PRODUTO","PRECO"})
AAdd(_aDados, {})

DbSelectArea("TRC") 
TRC->(dbGoTop())

While !TRC->(Eof())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   

	
	AAdd(_aDados, 	{SubSTR(TRC->CODIGO_BPAG, 1,24),SubSTR(TRC->CODIGO_MICROSIGA, 1,24),SubSTR(TRC->PRODUTO, 1,50),Transform(TRC->PRECO, "@E 9,999,999.99")})

   nLin++
   TRC->(dbSkip()) 

EndDo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

//If mv_par12 == 1
	DlgToExcel({ {"ARRAY","RELATORIO_DE_PARA_BPAG", _aCabec, _aDados} }) 
//EndIf
                                                                     
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������-���
���Fun��o    � AjustaSX1    �Autor �  Douglas Mello		�    16/12/2009   ���
�������������������������������������������������������������������������-���
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Filial         	  ","Filial		        ","Filial     	      ","mv_ch1","C",02,00,01,"G","","SM0","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Filial Inicial a ser considerada"})
PutSx1(cPerg,"02","Produto De         ","Produto De         ","Produto De         ","mv_ch2","C",15,00,01,"G","","SB1","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto inicial a ser considerado"})
PutSx1(cPerg,"03","Produto Ate        ","Produto Ate        ","Produto Ate        ","mv_ch3","C",15,00,01,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto final a ser considerado"})
//PutSx1(cPerg,"04","Prod. BPAG De      ","Prod. BPAG De      ","Prod. BPAG De      ","mv_ch4","C",15,00,01,"G","","PA8","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto inicial a ser considerado"})
//PutSx1(cPerg,"05","Prod. BPAG Ate     ","Prod. BPAG Ate     ","Prod. BPAG Ate     ","mv_ch5","C",15,00,01,"G","","PA8","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto final a ser considerado"})
//PutSx1(cPerg,"06","Excel			  ","Excel              ","Excel              ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par10","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)

Return   