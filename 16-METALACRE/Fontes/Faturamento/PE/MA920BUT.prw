#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'MSOle.CH' 
#INCLUDE "FILEIO.CH"         

#DEFINE CRLF Chr(13)+Chr(10)
#DEFINE TIPO	001
#DEFINE PREFIXO	002
#DEFINE NUMERO	003
#DEFINE PARCELA	004
#DEFINE EMISSAO	005
#DEFINE VENCTO	006
#DEFINE VLRORI	007
#DEFINE VLRSLD	008
#DEFINE REGISTRO 009
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออหออออออัอออออออออปฑฑ
ฑฑบPrograma  ณ MA920BUT บ Autor ณ Luiz Alberto         บ Data ณ 13/08/16บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออสออออออฯอออออออออนฑฑ
ฑฑบDescri…o ณ Botใo Duplicatas RAบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ P.E. na criacao da Tela de Ordem de Servico.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MA920BUT()

Local aBtn := {}

Aadd(aBtn,{"S4WB014B",&("{|| Processa( {|| U_VERRAS() } ) }"),"Consulta Titulos"})

Return(aBtn)


User Function VerRas()
Local aArea := GetArea()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery Principalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT   E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA						   	   		" + CRLF
cQuery += " 		,E1_EMISSAO                    	   		" + CRLF
cQuery += " 		,E1_VENCORI                    	   		" + CRLF
cQuery += " 		,E1_VENCREA                 	   		" + CRLF
cQuery += " 		,E1_VALOR	                 	   		" + CRLF
cQuery += " 		,E1_SALDO	                 	   		" + CRLF
cQuery += " 		,SE1.R_E_C_N_O_ REGSE1         	   		" + CRLF
	
cQuery += " FROM "+RetSqlName("SE1")+" SE1			   		" + CRLF
		
cQuery += " WHERE                                  			" + CRLF
cQuery += "  SE1.D_E_L_E_T_ <> '*'          	   		" + CRLF
cQuery += "  AND SE1.E1_PREFIXO = '"+ SF2->F2_SERIE +"'       		" + CRLF
cQuery += "  AND SE1.E1_NUM = '"+ SF2->F2_DOC +"'       		" + CRLF
cQuery += "  AND SE1.E1_CLIENTE = '"+ SF2->F2_CLIENTE +"'      		" + CRLF 
cQuery += "  AND SE1.E1_LOJA = '"+ SF2->F2_LOJA +"'      		" + CRLF 
		 	
cQuery += " ORDER BY E1_NUM							   		" + CRLF
	
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"KAD1",.F.,.T.)

TcSetField('KAD1','E1_EMISSAO','D')
TcSetField('KAD1','E1_VENCREA','D')
		
Count To nReg
		
aTitulos := {}
nVlrTotal := 0.00
nVlrSaldo := 0.00

dbSelectArea("KAD1")
dbGoTop()
ProcRegua(nReg)
		
While KAD1->(!Eof())
		
	IncProc("Aguarde Processando Filtro de Titulos...")
			
	AAdd(aTitulos,{	KAD1->E1_TIPO, KAD1->E1_PREFIXO,;
	KAD1->E1_NUM,;
	KAD1->E1_PARCELA,;
	KAD1->E1_EMISSAO,;
	KAD1->E1_VENCREA,;
	TransForm(KAD1->E1_VALOR,'@E 9,999,999.99'),;          
	TransForm(KAD1->E1_SALDO,'@E 9,999,999.99'),;          
	0})
			
	nVlrTotal += KAD1->E1_VALOR
	nVlrSaldo += KAD1->E1_SALDO

	KAD1->(dbSkip(1))
Enddo
KAD1->(dbCloseArea())



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCompensacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT  SUM(E5_VALOR) VLRADT " + CRLF
	
cQuery += " FROM "+RetSqlName("SE5")+" SE5			   		" + CRLF
		
cQuery += " WHERE                                  			" + CRLF
cQuery += "  SE5.D_E_L_E_T_ <> '*'          	   		" + CRLF
cQuery += "  AND SE5.E5_TIPO = 'RA' " + CRLF
cQuery += "  AND SE5.E5_MOTBX = 'CMP' " + CRLF
cQuery += "  AND LEFT(SE5.E5_DOCUMEN,12) = '" + SF2->F2_SERIE + SF2->F2_DOC + "' "+ CRLF
cQuery += "  AND SE5.E5_CLIENTE = '"+ SF2->F2_CLIENTE +"'      		" + CRLF 
cQuery += "  AND SE5.E5_LOJA = '"+ SF2->F2_LOJA +"'      		" + CRLF 
		 	
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"KAD1",.F.,.T.)

dbSelectArea("KAD1")
dbGoTop()
ProcRegua(nReg)
		
If KAD1->VLRADT > 0.00
	AAdd(aTitulos,{	'ADT', '',;
	'',;
	'',;
	SF2->F2_EMISSAO,;
	SF2->F2_EMISSAO,;
	TransForm(KAD1->VLRADT,'@E 9,999,999.99'),;          
	TransForm(0.00,'@E 9,999,999.99'),;          
	0})          
	
Endif
KAD1->(dbCloseArea())
RestArea(aArea)
		
If Empty(Len(aTitulos))
	MsgStop("Aten็ใo Nenhuma Titulo Localizado !")
	Return .f.
Endif

lOk:=.f.
		
DEFINE MSDIALOG oTelNfe TITLE "Titulos Financeiros - Nota Fiscal: " + SF2->F2_DOC  FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL //Style DS_MODALFRAME
oTelNfe:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC
		
@ 010, 005 LISTBOX oTitulos Fields HEADER 'Tipo','Prefixo',"Numero","Parcela","Emissใo",'Vencimento',;
'Valor Original','Saldo Atual' SIZE 490, 210 OF oTelNfe PIXEL ColSizes 50,50	//?FONT Dados 
		
oTitulos:SetArray(aTitulos)
oTitulos:bLine := {|| {	aTitulos[oTitulos:nAt,TIPO],;
						aTitulos[oTitulos:nAt,PREFIXO],;
											aTitulos[oTitulos:nAt,NUMERO],;
											aTitulos[oTitulos:nAt,PARCELA],;
											aTitulos[oTitulos:nAt,EMISSAO],;
											aTitulos[oTitulos:nAt,VENCTO],;
											aTitulos[oTitulos:nAt,VLRORI],;
											aTitulos[oTitulos:nAt,VLRSLD]}}
	

@ 230, 005 BUTTON oBotaoSai PROMPT "&Sair" 						ACTION (lOk:=.f.,Close(oTelNfe)) 	SIZE 080, 010 OF oTelNfe PIXEL
		
@ 230, 150 SAY oSldIni PROMPT "Total Nota: " + TransForm(nVlrTotal,"@E 999,999,999,999.99") SIZE 100, 008 COLOR CLR_BLUE,CLR_WHITE  OF oTelNfe PIXEL
oSldIni:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 230, 350 SAY oSldFim PROMPT "Saldo Atual: " + TransForm(nVlrSaldo,"@E 999,999,999,999.99") SIZE 100, 008 COLOR CLR_RED,CLR_WHITE  OF oTelNfe PIXEL
oSldFim:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

ACTIVATE MSDIALOG oTelNfe CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
RestArea(aArea)
Return
	


