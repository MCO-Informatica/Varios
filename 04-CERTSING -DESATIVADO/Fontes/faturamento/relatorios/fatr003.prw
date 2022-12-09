#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  FATR003  � Autor � Rene Lopes        � Data �  16/02/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Relat de valida��o para uso do SAV			              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR003()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Relatorio de Valida��o"
Local cPict          	:= ""
Local titulo       	 	:= "Relatorio de Valida��o"                  
Local nLin         		:= 80
Local Cabec1       		:= "UF   MUNICIPIO_CLIENTE    COD_PRODUTO     DESC_PRODUTO    DATA_PEDIDO    PED_GAR    COD_POSTO_VALIDACAO   DESC_POSTO    COD_AR     DESC_AR    GRUPO      DESC_GRUPO    VALOR    NOME_CLIENTE    CGC_CPF    MUNICIPIO    CEP    UF   DATA_EMISSAO   DATA_RENOVACAO    DATA_REVOGACAO   DATA_VALIDACAO    HORA_VALIDACAO     DATA_PAGAMENTO"
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "FATR003" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "FATR003" 
Private cString 		:= ""
Private cPerg			:= "FATR003"

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

cQuery :="SELECT                                                                                                    				 "+Chr(13)+Chr(10)
cQuery +="      A1.A1_EST AS UF,                                                                                				     "+Chr(13)+Chr(10)
cQuery +="	    A1.A1_MUN AS MUNICIPIO_CLIENTE,                                                                     				 "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_PRODUTO AS COD_PRODUTO,                                                                    					 "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_DESPRO  AS DESC_PRODUTO,                                                                      					 "+Chr(13)+Chr(10)
cQuery +="      SUBSTR(Z5.Z5_DATPED,7,2) || '/' || SUBSTR(Z5.Z5_DATPED,5,2) || '/' || SUBSTR(Z5.Z5_DATPED,1,4) AS DATA_PEDIDO,  "+Chr(13)+Chr(10)
cQuery +="      C5.C5_CHVBPAG AS PED_GAR,                                                                                            "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_CODPOS  AS COD_POSTO_VALIDACAO,                                                                                 "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_DESPOS  AS DESC_POSTO,                                                                                          "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_CODAR   AS COD_AR,                                                                                               "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_DESCAR  AS DESC_AR,                                                                                             "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_GRUPO   AS GRUPO,                                                                                                "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_DESGRU  AS DESC_GRUPO,                                                                                          "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_VALOR   AS VALOR,                                                                                                "+Chr(13)+Chr(10)
cQuery +="      A1.A1_NOME AS NOME_CLIENTE,                                                                                          "+Chr(13)+Chr(10)
cQuery +="      A1.A1_CGC AS CGC_CPF,                                                                                                "+Chr(13)+Chr(10)
cQuery +="      A1.A1_MUN AS MUNICIPIO,                                                                                              "+Chr(13)+Chr(10)
cQuery +="      A1.A1_CEP AS CEP, A1.A1_EST AS UF,                                                                                   "+Chr(13)+Chr(10)
cQuery +="      A1.A1_PESSOA AS TIPO,		                                                                                   "+Chr(13)+Chr(10)
cQuery +="      SUBSTR(Z5.Z5_EMISSAO,7,2) || '/' || SUBSTR(Z5.Z5_EMISSAO,5,2) || '/' || SUBSTR(Z5.Z5_EMISSAO,1,4) AS DATA_EMISSAO,"+Chr(13)+Chr(10)
cQuery +="      SUBSTR(Z5.Z5_RENOVA,7,2) || '/' || SUBSTR(Z5.Z5_RENOVA,5,2) || '/' || SUBSTR(Z5.Z5_RENOVA,1,4) AS DATA_RENOVACAO, "+Chr(13)+Chr(10)
cQuery +="      SUBSTR(Z5.Z5_REVOGA,7,2) || '/' || SUBSTR(Z5.Z5_REVOGA,5,2) || '/' || SUBSTR(Z5.Z5_REVOGA,1,4) AS DATA_REVOGACAO, "+Chr(13)+Chr(10)
cQuery +="      SUBSTR(Z5.Z5_DATVAL,7,2) || '/' || SUBSTR(Z5.Z5_DATVAL,5,2) || '/' || SUBSTR(Z5.Z5_DATVAL,1,4) AS DATA_VALIDACAO, "+Chr(13)+Chr(10)
cQuery +="      Z5.Z5_HORVAL AS HORA_VALIDACAO,                                                                                        "+Chr(13)+Chr(10)
cQuery +="      SUBSTR(Z5.Z5_DATPAG,7,2) || '/' || SUBSTR(Z5.Z5_DATPAG,5,2) || '/' || SUBSTR(Z5.Z5_DATPAG,1,4) AS DATA_PAGAMENTO  "+Chr(13)+Chr(10)
cQuery +="FROM                                                                                                                         "+Chr(13)+Chr(10)
cQuery +=RetSQLName("SC5") + " C5,                                                                                                     "+Chr(13)+Chr(10)
cQuery +=RetSQLName("SZ5") + " Z5,                                                                                                     "+Chr(13)+Chr(10)
cQuery +=RetSQLName("SA1") + " A1                                                                                                      "+Chr(13)+Chr(10)
cQuery +="WHERE                                                                                                                        "+Chr(13)+Chr(10)
cQuery +="      C5.C5_CHVBPAG = Z5.Z5_PEDGAR                                                                                           "+Chr(13)+Chr(10)
cQuery +="      AND A1.A1_COD = C5.C5_CLIENT                                                                                           "+Chr(13)+Chr(10)
cQuery +="      AND Z5.Z5_DATVAL between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "'                                                                     "+Chr(13)+Chr(10)
cQuery +="      AND C5.D_E_L_E_T_ = ' '                                                                                               "+Chr(13)+Chr(10)
cQuery +="      AND C5.C5_FILIAL = '"+xFilial("SC5")+"'                                                                                                "+Chr(13)+Chr(10)
cQuery +="      AND Z5.D_E_L_E_T_ = ' '                                                                                               "+Chr(13)+Chr(10)
cQuery +="      AND A1.A1_EST = 'SP'                                                                                                   "+Chr(13)+Chr(10)
cQuery +="      ORDER BY A1.A1_EST, A1.A1_MUN, Z5.Z5_PRODUTO                                                                           "+Chr(13)+Chr(10)
                                                                                                    
If Select("TRC") > 0
	TRC->(DbCloseArea())            
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRC", .F., .T.)

_cDataBase 	:= dDataBase 
_cTime 		:= Time()
_aCabec 	:= {}
_aDados		:= {}

AAdd(_aDados, {"UF","MUNICIPIO_CLIENTE","COD_PRODUTO","DESC_PRODUTO","DATA_PEDIDO","PED_GAR","COD_POSTO_VALIDACAO","DESC_POSTO","COD_AR","DESC_AR","GRUPO","DESC_GRUPO","VALOR","NOME_CLIENTE","CGC_CPF","MUNICIPIO","CEP","UF","DATA_EMISSAO","DATA_RENOVACAO","DATA_REVOGACAO","DATA_VALIDACAO","HORA_VALIDACAO","DATA_PAGAMENTO"})
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
        aAdd(_aDados, 	{	TRC->UF,;
      						TRC->MUNICIPIO_CLIENTE,;
      						TRC->COD_PRODUTO,;
      						TRC->DESC_PRODUTO,;
      						TRC->DATA_PEDIDO,;
      						TRC->PED_GAR,;
      						TRC->COD_POSTO_VALIDACAO,;
      						TRC->DESC_POSTO,;
      						TRC->COD_AR,;
      						TRC->DESC_AR,;
      						TRC->GRUPO,;
      						TRC->DESC_GRUPO,;
      						TRC->VALOR,;
      						TRC->NOME_CLIENTE,;
      						IIF(TRC->TIPO="J",Transform(TRC->CGC_CPF,'@R 99.999.999/9999-99'),Transform(TRC->CGC_CPF,'@R 999.999.999-99')),;
      						TRC->MUNICIPIO,;
      						TRC->CEP,;
      						TRC->UF,;
      						TRC->DATA_EMISSAO,;
      						TRC->DATA_RENOVACAO,;
      						TRC->DATA_REVOGACAO,;
      						TRC->DATA_VALIDACAO,;
      						TRC->HORA_VALIDACAO,;
      						TRC->DATA_PAGAMENTO}) 
   nLin++
   TRC->(dbSkip())    
   

EndDo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

If mv_par03 == 1
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
PutSx1(cPerg,"03","Excel			  ","Excel              ","Excel              ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par03","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)

Return   