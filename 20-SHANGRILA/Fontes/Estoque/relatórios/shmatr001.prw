#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SHMATR001  º Autor ³ 	Felipe Valenca	 º Data ³  18/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio dos Itens Inventariados 				          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shangrila                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SHMATR001
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Relatorio dos Itens Inventariados"
Local Cabec1       := "" //"Nome do Cliente                    90-          91-120          121-365           366-730           731+        Total Geral          Percentual"
Local Cabec2       := ""
Local imprime      := .T.

Private nLin        := 0
//Private oPrn    	:= NIL
Private nLastKey 	:= 0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "G"
Private nomeprog    := "Itens Inventariados" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private cPerg       := PadR("SHMATR001",Len(SX1->X1_GRUPO))
Private wnrel       := "SHMATR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private _cTime 		:= Time() 
Private _nPag		:= 1

oFont08	 := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Courier New",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Courier New",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
oFontC12 := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Courier New",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Courier New",06,06,,.T.,,,,.T.,.F.)

ValidPerg()

If !pergunte(cPerg,.T.)
	Return
Endif

oPrn := TMSPrinter():New(Titulo)
oPrn:Setup()

//oPrn:SetPortrait() //Retrato
oPrn:SetLandscape()// Paisagem()
oPrn:StartPage()

Private lEnd := .F.
Private bBloco := { |lEnd| Invent(),Titulo }
MsAguarde(bBloco,"Aguarde...","Gerando "+Titulo,.T.)

oPrn:Preview()
oPrn:EndPage()
oPrn:End()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Invent     ºAutor  ³Felipe Valença      º Data ³  18/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Itens Inventariados 				              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Invent()
                                         

cQuery := "SELECT SB1.R_E_C_N_O_ SB1REC , SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, "
cQuery += "	        SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM, SB1.B1_CODITE, SB2.R_E_C_N_O_ SB2REC, "
cQuery += "			SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_DINVENT, SB7.R_E_C_N_O_ SB7REC, "
cQuery += "         SB7.B7_FILIAL, SB7.B7_COD, SB7.B7_LOCAL, SB7.B7_DATA B7_DATA,SB7.B7_LOCALIZ, "
cQuery += "         SB7.B7_NUMSERI, SB7.B7_LOTECTL, SB7.B7_NUMLOTE, SB7.B7_DOC, SB7.B7_QUANT, "
cQuery += "         SB7.B7_ESCOLHA, SB7.B7_CONTAGE, SB2.B2_QATU "

cQuery += "FROM SB1010 SB1, SB2010 SB2, SB7010 SB7 "

cQuery += "WHERE  SB1.B1_FILIAL =  '"+xFilial("SB1")+"'										AND "
cQuery += "		SB1.B1_COD   >= '"+MV_PAR01+"'  AND SB1.B1_COD   <= '"+MV_PAR02+"'			AND "
cQuery += "		SB1.B1_TIPO  >= '"+MV_PAR04+"'	AND SB1.B1_TIPO  <= '"+MV_PAR05+"'			AND "
cQuery += "		SB1.B1_GRUPO >= '"+MV_PAR08+"'	AND SB1.B1_GRUPO <= '"+MV_PAR09+"'			AND "			
cQuery += "	 	SB1.D_E_L_E_T_ = ' '														AND "
cQuery += "	  	SB2.B2_FILIAL =  '"+xFilial("SB2")+"' AND SB2.B2_COD   =  SB1.B1_COD		AND "
cQuery += "	  	SB2.B2_LOCAL  =  SB7.B7_LOCAL		AND SB2.D_E_L_E_T_ = ' '				AND "
cQuery += "	  	SB7.B7_FILIAL =  '"+xFilial("SB7")+"'	AND SB7.B7_COD   =  SB1.B1_COD		AND "
cQuery += "	  	SB7.B7_LOCAL  >= '"+MV_PAR06+"'	AND SB7.B7_LOCAL <= '"+MV_PAR07+"'		 	AND "
cQuery += "	  	SB7.B7_DATA   =  '"+DtoS(MV_PAR03)+"' AND SB7.D_E_L_E_T_ = ' ' "

cQuery += "ORDER BY SB1.B1_FILIAL, SB1.B1_COD "
                                              
MemoWrite("INVENTARIO.SQL",cQuery)
If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"INV",.F.,.T.)
TcQuery cQuery New Alias "TRB"
DbSelectArea("TRB")
DbGotop()
TcSetField("TRB","B7_DATA","D") 
                         
Cabecalho()
Do While !TRB->(Eof())  

	fVerifLin()
	oPrn:Say(nLin,0050, TRB->B1_COD ,oFont12)
	oPrn:Say(nLin,0250, TRB->B1_DESC ,oFont12)
	oPrn:Say(nLin,0950, TRB->B1_TIPO ,oFont12)
	oPrn:Say(nLin,1150, TRB->B1_GRUPO ,oFont12)
	oPrn:Say(nLin,1250, TRB->B1_UM ,oFont12)
	oPrn:Say(nLin,1400, TRB->B2_LOCAL ,oFont12)
	oPrn:Say(nLin,1650, TRB->B7_LOTECTL ,oFont12)
	oPrn:Say(nLin,1850, Transform(TRB->B7_QUANT, "@E 999,999,999.99") ,oFont12)
	oPrn:Say(nLin,2050, Transform(TRB->B2_QATU, "@E 999,999,999.99") ,oFont12)	
	oPrn:Say(nLin,2250, Iif(TRB->B7_QUANT > TRB->B2_QATU, Transform(TRB->B7_QUANT - TRB->B2_QATU, "@E 999,999,999.99"), Transform(TRB->B2_QATU - TRB->B7_QUANT, "@E 999,999,999.99")) ,oFont12)	
    nLin += 50
	
	TRB->(dbSkip())
EndDo

Return


Static Function UM

_cQuery := "SELECT 	SB1.B1_UM "

_cQuery += "FROM SB1010 SB1, SB2010 SB2, SB7010 SB7 "

_cQuery += "WHERE SB1.B1_FILIAL =  '"+xFilial("SB1")+"'	AND SB1.B1_TIPO  >= '"+MV_PAR04+"'		AND "
_cQuery += "		SB1.B1_COD   >= '"+MV_PAR01+"'  AND SB1.B1_COD   <= '"+MV_PAR02+"'			AND "
_cQuery += "		SB1.B1_TIPO   <= '"+MV_PAR05+"'	AND SB1.B1_GRUPO >= '"+MV_PAR08+"'			AND "
_cQuery += "	 	SB1.B1_GRUPO  <= '"+MV_PAR09+"'	AND SB1.D_E_L_E_T = ' '						AND "
_cQuery += "	  	SB2.B2_FILIAL =  '"+xFilial("SB2")+"' AND SB2.B2_COD   =  SB1.B1_COD		AND "
_cQuery += "	  	SB2.B2_LOCAL  =  SB7.B7_LOCAL		AND SB2.D_E_L_E_T_ = ''					AND "
_cQuery += "	  	SB7.B7_FILIAL =  '"+xFilial("SB7")+"'	AND SB7.B7_COD   =  SB1.B1_COD		AND "
_cQuery += "	  	SB7.B7_LOCAL  >= '"+MV_PAR06+"'	AND SB7.B7_LOCAL <= '"+MV_PAR07+"'		 	AND "
_cQuery += "	  	SB7.B7_DATA   =  '"+DtoS(MV_PAR03)+"' AND SB7.D_E_L_E_T_ = ' ' "

_cQuery += "GROUP BY SB1.B1_UM " 
_cQuery += "ORDER BY SB1.B1_FILIAL, SB1.B1_UM "
                                              
MemoWrite("UM.SQL",_cQuery)
If Select("TRB2") > 0
	TRB2->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB2",.F.,.T.)
DbSelectArea("TRB2")
DbGotop()
TcSetField("TRB2","B7_DATA","D") 

Return

Static Function Cabecalho()

	nLin+= 105
    oPrn:Say(nLin,0050, Replicate("_", 141) ,oFont12N,100)
	nLin+= 50
	oPrn:Say(nLin,1100, "RELATORIO DOS ITENS INVENTARIADOS" ,oFont16N)
	oPrn:Say(nLin,0050, Replicate("_", 141) ,oFont12N)
	nLin+= 100
    
	oPrn:Say(nLin,0050, "CODIGO" ,oFont12N)
	oPrn:Say(nLin,0250, "DESCRICAO" ,oFont12N)
	oPrn:Say(nLin,0950, "TP" ,oFont12N)
	oPrn:Say(nLin,1050, "GRP" ,oFont12N)
	oPrn:Say(nLin,1150, "UM" ,oFont12N)
	oPrn:Say(nLin,1250, "LOCAL" ,oFont12N)
	oPrn:Say(nLin,1400, "DOCUMENTO" ,oFont12N)
	oPrn:Say(nLin,1650, "QTD INVENTARIADA" ,oFont12N)
	oPrn:Say(nLin,1850, "QTD DT INVENTARIO" ,oFont12N)
	oPrn:Say(nLin,2050, "QUANTIDADE" ,oFont12N)
	oPrn:Say(nLin,2250, "VALOR" ,oFont12N)
	oPrn:Say(nLin,2450, "ACURACIDADE" ,oFont12N)
	nLin+= 50 

Return


Static Function fVerifLin()
//SetPortrait
//If nLin > 3400
 
//SetLandscape

If nLin > 2000 //2800 //2300
	oPrn:EndPage()
	oPrn:StartPage()
	_nPag += 1
	nLin:= 0
	CABECALHO()
	nLin := 505 //455
Endif
Return 


*---------------------------------*
Static Function ValidPerg()
*---------------------------------*

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	DBSelectArea("SX1") ; DBSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cperg,"01","Do Produto:"		,"","","mv_ch1","C", 15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cperg,"02","Ate o Produto:"		,"","","mv_ch2","C", 15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cperg,"03","Data de Selecao:"	,"","","mv_ch3","D", 8,0,0,"G","","mv_par03"})
	AADD(aRegs,{cperg,"04","Do Tipo : "			,"","","mv_ch4","C", 2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"05","Ate o Tipo"			,"","","mv_ch5","C", 2,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"06","Do Armazem:"		,"","","mv_ch6","C", 2,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"07","Ate o Armazem:"		,"","","mv_ch7","C", 2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"08","Do Grupo:"			,"","","mv_ch8","C", 4,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(aRegs,{cperg,"09","Ate o Grupo:"		,"","","mv_ch9","C", 4,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])

			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
			

		EndIf 
	Next    
	DBSelectArea(_sAlias)
Return
