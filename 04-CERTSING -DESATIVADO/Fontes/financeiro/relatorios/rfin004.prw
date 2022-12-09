#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  RFIN004  � Autor � Douglas Mello     � Data �  16/02/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Titulos a Receber - Analitico 			                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFIN004()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Titulos a Receber Analitico."
Local cPict          	:= ""
Local titulo       	 	:= "Titulos a Receber Analitico."             
Local nLin         		:= 80
Local Cabec1       		:= "MES        CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG    AR                VALOR    EMISSAO "
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 132 
Private tamanho         := "G"
Private nomeprog        := "RFIN004" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RFIN004" 
Private cString 		:= "SE1"
Private cPerg			:= "RFIN004"
aOrd :={	"Por Cliente",;	   //E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	"Por Prefixo/Numero",;	//E1_FILIAL+E1_PREFIXO+E1_NUM
	"Por Banco",; //E1_PORTADO
	"Por Venc/Cli",;	//E1_VENCREA
	"Por Natureza",;	  //E1_NATUREZ
	"Por Emissao",; //E1_EMISSAO
	"Por Ven\Bco",;	  //E1_FILIAL+DTOS(E1_VENCREA)+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	"Por Cod.Cli.",; // E1_CLIENTE
	"Banco/Situacao",;  //E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	"Por Numero/Tipo/Prefixo" } //E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA                                                                        


//���������������������������������������������������������������������Ŀ
//� Chamada dos parametros do relatorio									�
//�����������������������������������������������������������������������
                     
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


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
Local _cQuery
Private nOrdem	:= 0
                    
nOrdem:=aReturn[8]

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())  

_cQuery := " SELECT "+Chr(13)+Chr(10)
_cQuery += " E1_CLIENTE AS COD_CLIENTE, "+Chr(13)+Chr(10)
_cQuery += " E1_NOMCLI AS NOME_CLIENTE,"+Chr(13)+Chr(10)
_cQuery += " E1_PREFIXO AS PREFIXO,"+Chr(13)+Chr(10)
_cQuery += " E1_NUM AS NUMERO,"+Chr(13)+Chr(10)
_cQuery += " E1_PARCELA AS PARCELA,"+Chr(13)+Chr(10)
_cQuery += " E1_TIPO AS TIPO,"+Chr(13)+Chr(10)
_cQuery += " E1_NATUREZ AS NATUREZA,"+Chr(13)+Chr(10)
_cQuery += " E1_EMISSAO AS EMISSAO,"+Chr(13)+Chr(10)
_cQuery += " E1_VENCREA AS VENCTO_REAL,"+Chr(13)+Chr(10)
_cQuery += " E1_PORTADO AS BANCO,"+Chr(13)+Chr(10)
_cQuery += " E1_VALOR AS VALOR,"+Chr(13)+Chr(10)
_cQuery += " E1_VALLIQ AS VALOR_LIQ,"+Chr(13)+Chr(10)
_cQuery += " E1_SALDO AS SALDO,"+Chr(13)+Chr(10)
_cQuery += " E1_HIST AS HISTORICO,"+Chr(13)+Chr(10)
_cQuery += " E1_BAIXA AS BAIXA,"+Chr(13)+Chr(10)
_cQuery += " E1_SALDO AS SALDO,"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT SZ2.Z2_CANAL FROM " + RetSQLName("SZ2") + " SZ2 WHERE (SELECT A3_XCANAL FROM SA3010 SA3 WHERE SA3.A3_COD = SE1.E1_VEND1 AND SA3.D_E_L_E_T_ = ' ' ) = SZ2.Z2_CODIGO  AND SZ2.D_E_L_E_T_ = ' '), '') As Canal_Vendas,"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT C5_TIPMOV FROM " + RetSQLName("SC5") +" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2') AND E1_TIPO = 'NF' ), '')  AS TIPO_PAGTO,"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT C5_XBANDEI FROM " + RetSQLName("SC5")+" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2')AND E1_TIPO = 'NF' ), '') AS BADEIRA_CARTAO,"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT C5_CONDPAG FROM " + RetSQLName("SC5")+" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2')AND E1_TIPO = 'NF' ), '') AS CONDICAO_PAGTO,"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT E4_DESCRI FROM "+ RetSQLName("SE4") +" SE4 WHERE SE4.E4_CODIGO = (SELECT C5_CONDPAG FROM SC5010 WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2')AND E1_TIPO = 'NF' )), '') AS DESCRICAO_PAGTO,"+Chr(13)+Chr(10)
_cQuery += " NVL((SELECT C5_MENNOTA FROM "+ RetSQLName("SC5") +" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2')AND E1_TIPO = 'NF' ), '') AS MENSAGEM_NOTA"+Chr(13)+Chr(10)
_cQuery += " FROM "+Chr(13)+Chr(10)
_cQuery += " "+ RetSQLNAME("SE1") +" SE1, "+ RetSQLNAME("SA1") +" SA1 " +Chr(13)+Chr(10)
_cQuery += " WHERE"+Chr(13)+Chr(10)
_cQuery += " E1_CLIENTE Between '" + mv_par01 + "' AND '" + mv_par02 + "'"+Chr(13)+Chr(10)
_cQuery += " AND E1_LOJA Between '" + mv_par03 + "' AND '" + mv_par04 + "'"+Chr(13)+Chr(10)
_cQuery += " AND E1_PREFIXO Between '" + mv_par05 + "' AND '" + mv_par06 + "'"+Chr(13)+Chr(10)
_cQuery += " AND E1_NUM Between '" + mv_par07 + "' AND '" + mv_par08 + "'"+Chr(13)+Chr(10)
//_cQuery += " AND E1_VENCREA Between '" + DtoS(mv_par09) + "' AND '" + DtoS(mv_par10) + "'"+Chr(13)+Chr(10)
_cQuery += " AND E1_NATUREZ Between '" + mv_par11 + "' AND '" + mv_par12 + "'"+Chr(13)+Chr(10) 
//_cQuery += " AND E1_EMISSAO Between '" + DtoS(mv_par13) + "' AND '" + DtoS(mv_par14) + "'"+Chr(13)+Chr(10)
_cQuery += " AND E1_PORTADO Between '" + mv_par16 + "' AND '" + mv_par17 + "'"+Chr(13)+Chr(10)
_cQuery += " AND (SELECT SZ2.Z2_CANAL FROM "+ RetSQLNAME("SZ2")+" SZ2 WHERE (SELECT A3_XCANAL FROM SA3010 SA3 WHERE SA3.A3_COD = SE1.E1_VEND1 AND SA3.D_E_L_E_T_ = ' ' ) = SZ2.Z2_CODIGO  AND SZ2.D_E_L_E_T_ = ' ') >= '" + mv_par24 + "'"+Chr(13)+Chr(10)
_cQuery += " AND (SELECT SZ2.Z2_CANAL FROM "+ RetSQLNAME("SZ2")+" SZ2 WHERE (SELECT A3_XCANAL FROM SA3010 SA3 WHERE SA3.A3_COD = SE1.E1_VEND1 AND SA3.D_E_L_E_T_ = ' ' ) = SZ2.Z2_CODIGO  AND SZ2.D_E_L_E_T_ = ' ') <= '" + mv_par25 + "'"+Chr(13)+Chr(10)
_cQuery += " AND (SELECT C5_CONDPAG FROM "+ RetSQLNAME("SC5")+" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2','FIN')AND E1_TIPO = 'NF' ) >= '" + mv_par20 + "'"+Chr(13)+Chr(10)
_cQuery += " AND (SELECT C5_CONDPAG FROM "+RetSQLNAME("SC5")+" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2','FIN')AND E1_TIPO = 'NF' ) <= '" + mv_par21 + "'"+Chr(13)+Chr(10)
_cQuery += " AND (SELECT C5_XBANDEI FROM "+RetSQLNAME("SC5") +" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2','FIN')AND E1_TIPO = 'NF' ) >= '" + mv_par22 + "'"+Chr(13)+Chr(10)
_cQuery += " AND (SELECT C5_XBANDEI FROM "+RetSQLNAME("SC5") +" WHERE C5_NOTA = E1_NUM AND C5_SERIE IN ('SP2','RP2','FIN')AND E1_TIPO = 'NF' ) <= '" + mv_par23 + "'"+Chr(13)+Chr(10)
_cQuery += " AND E1_FILIAL	= A1_FILIAL"+Chr(13)+Chr(10)
_cQuery += " AND E1_CLIENTE	= A1_COD "+Chr(13)+Chr(10)
_cQuery += " AND E1_LOJA	= A1_LOJA  "+Chr(13)+Chr(10)
_cQuery += " AND E1_EMISSAO	>= "+DtoS(mv_par13)+" AND E1_EMISSAO <= "+DtoS(mv_par14)+" "+Chr(13)+Chr(10)
_cQuery += " AND E1_VENCREA	>= "+DtoS(mv_par09)+" AND E1_VENCREA <= "+DtoS(mv_par10)+" "+Chr(13)+Chr(10) 
_cQuery += " AND (E1_SALDO	>0 OR E1_BAIXA>="+DtoS(mv_par15)+") "+Chr(13)+Chr(10)
_cQuery += " AND E1_TIPO NOT IN ('CF-','PI-','IR-','CS-','AB-','FU-','IN-','IS-')"+Chr(13)+Chr(10) 
_cQuery += " AND SE1.D_E_L_E_T_=' '"+Chr(13)+Chr(10)
_cQuery += " AND SA1.D_E_L_E_T_=' '"+Chr(13)+Chr(10)

If nOrdem = 1
	_cQuery += " ORDER BY E1_FILIAL,E1_NOMCLI,E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
ElseIf nOrdem = 2
	_cQuery += " ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM"
ElseIf nOrdem = 3
	_cQuery += " ORDER BY E1_PORTADO"
ElseIf nOrdem = 4
	_cQuery += " ORDER BY E1_VENCREA"
ElseIf nOrdem = 5
	_cQuery += " ORDER BY E1_NATUREZ"
ElseIf nOrdem = 6
	_cQuery += " ORDER BY E1_EMISSAO"
ElseIf nOrdem = 7
	_cQuery += " ORDER BY E1_FILIAL,DTOS(E1_VENCREA),E1_PORTADO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
ElseIf nOrdem = 8
	_cQuery += " ORDER BY E1_CLIENTE"
ElseIf nOrdem = 9
	_cQuery += " ORDER BY E1_FILIAL,E1_PORTADO,E1_SITUACA,E1_NOMCLI,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
ElseIf nOrdem = 10
  	_cQuery += " ORDER BY E1_FILIAL,E1_NUM,E1_TIPO,E1_PREFIXO,E1_PARCELA "
EndIf


If Select("TRR") > 0
	TRR->(DbCloseArea())            
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRR", .F., .T.)

_aCabec 	:= {}
_aDados		:= {}

AAdd(_aDados, {"Codigo do Cliente",	"Nome do Cliente",	"Prefixo"	,"Numero","Parcela",	"Tipo",	"Natureza",	"Emiss�o"	,"Vencimento",	"Banco"	,"Valor Original"	,"Valor Baixado","Valor Vencido"	,"Valor a Vencer","Hist�rico","Canal de Vendas","Tipo de Pagamento",	"Bandeira","Condi��o de Pagamento","Descri��o","Mensagem da Nota"})
AAdd(_aDados, {})

DbSelectArea("TRR") 
TRR->(dbGoTop())

While !TRR->(Eof())

	If lAbortPrint
    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
 		Exit
 	Endif   
                
//	If STOD(TRR->BAIXA) < mv_par14 // Valida se a data de baixa do titulo eh menor que a data base.
	
//		If TRR->SALDO <> 0 
		
			AAdd(_aDados, 	{TRR->COD_CLIENTE	,;
			TRR->NOME_CLIENTE	,;
			TRR->PREFIXO	,;
			TRR->NUMERO	,;
			TRR->PARCELA	,;
			TRR->TIPO	,;
			TRR->NATUREZA	,;
			STOD(TRR->EMISSAO)	,;
			STOD(TRR->VENCTO_REAL)	,;
			TRR->BANCO	,;
			Transform(TRR->VALOR,'@E 999,999,999.99')	,;
			Transform(TRR->VALOR_LIQ,'@E 999,999,999.99')	,;
			IIF(mv_par14< STOD(TRR->EMISSAO),Transform(TRR->SALDO,'@E 999,999,999.99'),0)	,;
			IIF(mv_par14>=STOD(TRR->EMISSAO),Transform(TRR->SALDO,'@E 999,999,999.99'),0)	,;
			TRR->HISTORICO	,;
			TRR->Canal_Vendas	,;
			IIF(TRR->TIPO_PAGTO=="1","BOLETO",IIF(TRR->TIPO_PAGTO=="2","CARTAO",""))	,;
			TRR->BADEIRA_CARTAO	,;
			TRR->CONDICAO_PAGTO	,;
			TRR->DESCRICAO_PAGTO,;
			TRR->MENSAGEM_NOTA})
	
			nLin++
		  	TRR->(dbSkip())    
//		Else
			//nLin++
	  		//TRR->(dbSkip())    
		//EndIf
	//Else
	//	nLin++
	//  	TRR->(dbSkip()) 	
	//EndIf   

EndDo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

//If mv_par12 == 1
	DlgToExcel({ {"ARRAY","Titulos a Receber", _aCabec, _aDados} }) 
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

Return()