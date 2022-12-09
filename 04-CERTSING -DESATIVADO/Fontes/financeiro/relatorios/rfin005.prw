#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  RFIN005  � Autor � Rene Lopes        � Data �  25/02/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Relat tit de valida��o uso financeiro		              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFIN005()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Relatorio de Valida��o"
Local cPict          	:= ""
Local titulo       	 	:= "Relatorio de Valida��o"                  
Local nLin         		:= 80
Local Cabec1       		:= "CLIENTE          NOME                                    PREFIXO           NUMERO     TIPO         NATUREZA       EMISSAO        VENCREAL       BANCO            VALOROGI               VALORFIN               DATABAIXA          MOTIVO"
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "RFIN005" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RFIN005" 
Private cString 		:= ""
Private cPerg			:= "RFIN005"

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
Else

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/12/2009 ���
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

cQuery :="SELECT DISTINCT                                                                                              				 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_CLIENTE			AS CLIENTE,																							 "+Chr(13)+Chr(10) 
cQuery +="A1.A1_NOME			AS NOME,																							 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_PREFIXO			AS PREFIXO,																							 "+Chr(13)+Chr(10)  
cQuery +="E1.E1_NUM				AS NUMERO,																							 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_TIPO			AS TIPO,																							 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_NATUREZ			AS NATUREZA,																						 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_EMISSAO			AS EMISSAO,																					     	 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_VENCREA			AS VENCREAL,																						 "+Chr(13)+Chr(10) 
cQuery +="E5.E5_BANCO			AS BANCO,																							 "+Chr(13)+Chr(10) 
cQuery +="E1.E1_VALOR			AS VALOROGI,																						 "+Chr(13)+Chr(10) 
cQuery +="E5.E5_VLMOED2			AS VALORFIN,																						 "+Chr(13)+Chr(10) 
cQuery +="E5.E5_DATA			AS DATABAIXA,																						 "+Chr(13)+Chr(10) 
cQuery +="E5.E5_MOTBX			AS MOTIVO																							 "+Chr(13)+Chr(10) 
cQuery +="FROM 																														 "+Chr(13)+Chr(10) 
cQuery +=RetSQLName("SE1") + " E1 INNER JOIN 														 							  	 "+Chr(13)+Chr(10)  
cQuery +=RetSQLName("SE5") + " E5 ON E5.E5_PREFIXO = E1.E1_PREFIXO AND E5.E5_NUMERO = E1.E1_NUM										"+Chr(13)+Chr(10)
cQuery +="AND E1.E1_CLIENTE = E5.E5_CLIENTE LEFT JOIN " + RetSQLName("SA1") + " A1 ON E1.E1_CLIENTE = A1.A1_COD 					  "+Chr(13)+Chr(10) 
cQuery +="WHERE																														  "+Chr(13)+Chr(10) 
cQuery +="E1.E1_ORIGPV = '3'																	 									  "+Chr(13)+Chr(10) 
cQuery +="AND E1.E1_EMISSAO >= '" + DtoS(mv_par01) + "'																				  "+Chr(13)+Chr(10) 
cQuery +="AND E1.E1_EMISSAO <= '" + DtoS(mv_par02) +  "'																			  "+Chr(13)+Chr(10) 
cQuery +="AND E1.E1_NATUREZ IN ('FT030001', 'FT010010','FT010001')																			      "+Chr(13)+Chr(10) 
IF MV_PAR03 = 1
cQuery +="AND E1.E1_SALDO = '0'"+Chr(13)+Chr(10)
Endif																										 
IF MV_PAR03 = 2 
cQuery +="AND E1.E1_SALDO <> '0'"+Chr(13)+Chr(10)
Endif																										 
cQuery +="ORDER BY E1.E1_FILIAL, E5.E5_DATA																							  "+Chr(13)+Chr(10) 
                                                                                                     
If Select("TRC") > 0
	TRC->(DbCloseArea())            
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRC", .F., .T.)

_cDataBase 	:= dDataBase 
_cTime 		:= Time()
_aCabec 	:= {}
_aDados		:= {}

AAdd(_aDados, {"CLIENTE","NOME","PREFIXO","NUMERO","TIPO","NATUREZA","EMISSAO","VENCREAL","BANCO","VALOROGI","VALORFIN","DATABAIXA","MOTIVO"})
//"UF","MUNICIPIO_CLIENTE","COD_PRODUTO","DESC_PRODUTO","DATA_PEDIDO","PED_GAR","COD_POSTO_VALIDACAO","DESC_POSTO","COD_AR","DESC_AR","GRUPO","DESC_GRUPO","VALOR","NOME_CLIENTE","CGC_CPF","MUNICIPIO","CEP","UF","DATA_EMISSAO","DATA_RENOVACAO","DATA_VALIDACAO","HORA_VALIDACAO","DATA_PAGAMENTO"})
//AAdd(_aDados, {})

DbSelectArea("TRC") 
TRC->(dbGoTop())

While !TRC->(Eof())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
/*  "UF","MUNICIPIO_CLIENTE","COD_PRODUTO","DESC_PRODUTO","DATA_PEDIDO","PED_GAR","COD_POSTO_VALIDACAO","DESC_POSTO","COD_AR","DESC_AR","GRUPO","DESC_GRUPO",
  "VALOR","NOME_CLIENTE","CGC_CPF","MUNICIPIO","CEP","UF","DATA_EMISSAO","DATA_RENOVACAO","DATA_VALIDACAO",
  "HORA_VALIDACAO","DATA_PAGAMENTO"    */   
        aAdd(_aDados, 	{	TRC->CLIENTE,;
        					TRC->NOME,;
        					TRC->PREFIXO,;
        					TRC->NUMERO,;
        					TRC->TIPO,;
        					TRC->NATUREZA,;
        					TRC->EMISSAO,;
        					TRC->VENCREAL,;
        					TRC->BANCO,;
        					TRC->VALOROGI,;
        					TRC->VALORFIN,;
        					TRC->DATABAIXA,;
        					TRC->MOTIVO}) 
   nLin++
   TRC->(dbSkip())    
   

EndDo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

If mv_par04 == 1
	DlgToExcel({ {"ARRAY","Relatorio Valida��o", _aCabec, _aDados} }) 
EndIf
                                                                     
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

PutSx1(cPerg,"01","Emissao De         ","Emissao De         ","Emissao De         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Emissao Ate        ","Emissao Ate        ","Emissao Ate        ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Status Titulo	  ","Status Titulo      ","Status Titulo      ","mv_chA3","N",01,00,01,"C","",""   ,"","","mv_par03","Baixado","Baixado","Baixado","Em Aberto","Em Aberto","Em Aberto","Em Aberto","Ambos","Ambos","Ambos","","","","","","","","","","",{"Status Tit."})
PutSx1(cPerg,"04","Excel			  ","Excel              ","Excel              ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par04","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)

Return   