#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR18     º Autor ³ Felipe Valenca     º Data ³  22/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento por Vendedor.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATR18()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "FATURAMENTO POR VENDEDOR"
Local cPict          := ""
Local nLin         := 80
Local imprime      := .T.
Local aOrd := {}

Private titulo       := "FATURAMENTO POR VENDEDOR"
Private Cabec1       := "                             REGIAO         ESTADO       VLR MERC          VLR IPI        VLR ST        VLR TOTAL"
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RFATR18" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("RFATR18",LEN(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFATR18" 

Private cString := "SF2"

ValidPerg()

pergunte(cPerg,.f.)

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _nTotal	:= 0
Local _nValMerc	:= 0
Local _nValIpi	:= 0
Local _nValst	:= 0
Local _nTotGer	:= 0

Local _nTotSt 	:= 0
Local _nTotIpi	:= 0
Local _nTotMerc	:= 0
Local _nTotGer 	:= 0
Local _nDevMerc	:= 0
Local _nDevIpi	:= 0
Local _nDevSt	:= 0
Local _nDevTot	:= 0

Local _cRegiao	:= ""
Local _cEst		:= ""

Private _nTotMercEx	:= 0
Private _nTotIpiEx	:= 0
Private _nTotStEx	:= 0
Private	_nTotGerEx 	:= 0
Private	_nGerMercEx := 0
Private	_nGerIpiEx	:= 0
Private	_nGerStEx	:= 0
Private	_nGerTotEx	:= 0

Private	_nDevMercGerEx := 0
Private	_nDevIpiGerEx  := 0
Private	_nDevStGerEx   := 0
Private	_nDevTotGerEx  := 0

Private	_nDevMercGer:= 0
Private	_nDevIpiGer	:= 0
Private	_nDevStGer	:= 0
Private	_nDevTotGer	:= 0

Private	_nGDevMercEx := 0
Private	_nGDevIpiEx	 := 0
Private	_nGDevStEx	 := 0
Private	_nGDevTotEx	 := 0

Private _cVend	:= ""
Private _cCli	:= ""
Private _cLojCli:= ""
Private dUltCom := ""
Private _cClient:= ""
Private _cLoja	:= ""

Private lPassou := .T.

Private aRet	:= {}
Private aDados1 := {}
Private aDados2 := {}
Private aDados3 := {}
Private aDadosEx:= {}
Private aCabec  := {}
Private _aDev	:= {}
cQuery := "select DISTINCT F2_EMISSAO, F2_VEND1, F2_CLIENTE, F2_LOJA, F2_REGIAO, F2_EST, F2_VALMERC , F2_VALIPI, F2_ICMSRET, F2_TIPO "
cQuery += "from "+RetSqlName("SF2")+" F2 "
cQuery += "INNER JOIN "+RetSqlName("SD2")+" D2 ON D2.D_E_L_E_T_ = ' ' "
cQuery += "AND D2_FILIAL = F2_FILIAL "
cQuery += "AND D2_DOC = F2_DOC "
cQuery += "AND D2_SERIE = F2_SERIE "
cQuery += "AND D2_CLIENTE = F2_CLIENTE "
cQuery += "AND D2_LOJA = F2_LOJA "
cQuery += "INNER JOIN "+RetSqlName("SF4")+" F4 ON F4.D_E_L_E_T_ = ' ' "
cQuery += "AND F4_CODIGO = D2_TES "
cQuery += "AND F4_DUPLIC = 'S' "
cQuery += "WHERE F2.D_E_L_E_T_ = ' ' "
cQuery += "AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += "AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery += "AND F2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND F2_EST BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "AND F2_VEND1 BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "AND F2_REGIAO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += "ORDER BY F2_VEND1,F2_CLIENTE "


MemoWrite("RFATR18.SQL",cQuery)
If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
SetRegua(RecCount())
DbSelectArea("TRB")
dbGoTop()


Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

If MV_PAR11 == 2
	AAdd(aDadosEx, {"","Data de Emissão: ", dDataBase, , "HORARIO:", Time()})		
	AAdd(aDadosEx, {})
	AAdd(aDadosEx, {"CLIENTE","REGIAO","ESTADO","VLR MERC","VLR IPI","VLR ST","VLR TOTAL"})
	AAdd(aDadosEx, {})
Endif

While !TRB->(EOF())

	_cVend := TRB->F2_VEND1
	
	@nLin,0000 pSay Posicione("SA3",1,xFilial("SA3")+TRB->F2_VEND1,"A3_NOME")
	//@nLin,0000 pSay Replicate("_",Len(Alltrim(Posicione("SA3",1,xFilial("SA3")+TRB->F2_VEND1,"A3_NOME")))+1)
	nLin += 2

	If MV_PAR11 == 2
		AAdd(aDados1,{Posicione("SA3",1,xFilial("SA3")+TRB->F2_VEND1,"A3_NOME")})
		lPassou := .T.
	Endif
	
	Do While !TRB->(Eof()) .And. _cVend == TRB->F2_VEND1

		_cClient := TRB->F2_CLIENTE
		_cLoja	 := TRB->F2_LOJA
		Do While !TRB->(Eof()) .And. _cClient == TRB->F2_CLIENTE .And. _cLoja == TRB->F2_LOJA
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
		
			_nValMerc 	+= TRB->F2_VALMERC
			_nValIpi	+= TRB->F2_VALIPI
			_nValst		+= TRB->F2_ICMSRET
			_nTotal		+= TRB->F2_VALMERC + TRB->F2_VALIPI + TRB->F2_ICMSRET
			_cRegiao	:= Posicione("SX5",1,xFilial("SX5")+"61"+Posicione("SA1",1,xFilial("SA1")+TRB->F2_CLIENTE+TRB->F2_LOJA,"A1_REGIAO"),"X5_DESCRI")
			_cEst		:= TRB->F2_EST
			
			TRB->(dbSkip())
		EndDo
		
		fDevolucao()
		For _nA := 1 to Len(_aDev)
			_nDevMerc 	+= _aDev[_nA][1]
			_nDevIpi	+= _aDev[_nA][2]
			_nDevSt		+= _aDev[_nA][3]
			_nDevTot	+= (_aDev[_nA][1] + _aDev[_nA][2] + _aDev[_nA][3])
		Next
		_aDev := {}

		_cCli 		+= "'"+ _cClient +"',"
		_cLojCli    += "'"+ _cLoja + "',"
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,0000 pSay _cClient+"/"+_cLoja+" - "+Substr(Posicione("SA1",1,xFilial("SA1")+_cClient+_cLoja,"A1_NREDUZ"),1,14)
		@nLin,0029 pSay _cRegiao
		@nLin,0047 pSay _cEst
		@nLin,0051 pSay Transform(_nValMerc - _nDevMerc, "@E 999,999,999.99")
		@nLin,0066 pSay Transform(_nValIpi - _nDevIpi, "@E 999,999,999.99")
		@nLin,0081 pSay Transform(_nValst - _nDevSt, "@E 999,999,999.99")
		@nLin,0099 pSay Transform(_nTotal - _nDevTot, "@E 999,999,999.99")
		nLin++			

		If MV_PAR11 == 2
			Aadd(aDados2,{Posicione("SA1",1,xFilial("SA1")+_cClient+_cLoja,"A1_NREDUZ"),_cRegiao,_cEst,_nValMerc - _nDevMerc,_nValIpi - _nDevIpi,_nValst - _nDevSt,_nTotal - _nDevTot})
		Endif
		
		_nTotSt 	+= _nValst
		_nTotIpi	+= _nValIpi
		_nTotMerc	+= _nValMerc
		_nTotGer 	+= _nTotal
		
		_nDevMercGer+= _nDevMerc
		_nDevIpiGer	+= _nValIpi
		_nDevStGer	+= _nDevSt
		_nDevTotGer	+= _nDevTot
		
		_nValst 	:= 0
		_nValIpi 	:= 0
		_nValMerc 	:= 0
		_nTotal 	:= 0
		
		_nDevMerc 	:= 0
		_nDevIpi	:= 0
		_nDevSt		:= 0
		_nDevTot	:= 0
	EndDo
	
	
	@nLin,0050 pSay Transform(_nTotMerc - _nDevMercGer, "@E 999,999,999.99")
	@nLin,0065 pSay Transform(_nTotIpi - _nDevIpiGer, "@E 999,999,999.99")
	@nLin,0080 pSay Transform(_nTotSt - _nDevStGer, "@E 999,999,999.99")
	@nLin,0098 pSay Transform(_nTotGer - _nDevTotGer, "@E 999,999,999.99")
	nLin += 2

    _nTotMercEx	:= _nTotMerc - _nDevMercGer
    _nTotIpiEx	:= _nTotIpi - _nDevIpiGer
    _nTotStEx	:= _nTotSt - _nDevStGer
	_nTotGerEx 	:= _nTotGer - _nDevTotGer

	_nDevMercGerEx	:= _nDevMercGer 
	_nDevIpiGerEx	:= _nDevIpiGer
	_nDevStGerEx	:= _nDevStGer 
	_nDevTotGerEx	:= _nDevTotGer
	
	_nGerMercEx += _nTotMerc
	_nGerIpiEx	+= _nTotIpi
	_nGerStEx	+= _nTotSt
	_nGerTotEx	+= _nTotGerEx
	
	_nGDevMercEx += _nDevMercGerEx
	_nGDevIpiEx	 += _nDevIpiGerEx
	_nGDevStEx	 += _nDevStGerEx
	_nGDevTotEx	 += _nDevTotGerEx 	
	
	_nTotMerc	:= 0
	_nTotIpi	:= 0
	_nTotSt		:= 0
	_nTotGer	:= 0
	
	_nDevMercGer:= 0
	_nDevIpiGer	:= 0
	_nDevStGer	:= 0
	_nDevTotGer	:= 0 
	
	
	fClient()
	
	@nLin,0060 pSay "CLIENTES QUE NÃO COMPRARAM"
	@nLin,0059 Psay Replicate("_",Len("CLIENTES QUE NÃO COMPRARAM")+1)
	nLin += 2
	
	For _nX := 1 to Len(aRet)
		@nLin,0000 pSay aRet[_nX][1]+"/"+aRet[_nX][2]+" - "+Alltrim(Posicione("SA1",1,xFilial("SA1")+aRet[_nX][1]+aRet[_nX][2],"A1_NREDUZ"))
		@nLin,0030 pSay "Ultima Compra: "+aRet[_nX][3]
		nLin++

		Aadd(aDados3,{Posicione("SA1",1,xFilial("SA1")+aRet[_nX][1]+aRet[_nX][2],"A1_NREDUZ"),aRet[_nX][2],aRet[_nX][3]})
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

	Next
	
	fExcel()
	
    _nTotMercEx	:= 0
    _nTotIpiEx	:= 0
    _nTotStEx	:= 0
	_nTotGerEx 	:= 0

	_nDevMercGerEx	:= 0
	_nDevIpiGerEx	:= 0
	_nDevStGerEx	:= 0
	_nDevTotGerEx	:= 0
	
	aRet 		:= {}
	_cCli  		:= ""
	_cLojCli	:= ""

	dbSelectArea("TRB")
	@nLin,00 Psay __PrtThinLine()
	nLin++

EndDo
If MV_PAR11 == 2
	AAdd(aDadosEx,{})
	AAdd(aDadosEx,{"TOTAL GERAL",_nGerMercEx - _nGDevMercEx,_nGerIpiEx - _nGDevIpiEx,_nGerStEx - _nGDevStEx,_nGerTotEx - _nGDevTotEx})
	DlgToExcel({ {"ARRAY","FATURAMENTO POR VENDEDOR", aCabec, aDadosEx} })
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

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
AADD(aRegs,{cperg,"01","Da Emissao"				,"","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cperg,"02","Ate a Emissao:"			,"","","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cperg,"03","Do Cliente:"			,"","","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cperg,"04","Ate o Cliente:"			,"","","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cperg,"05","Do Estado:"				,"","","mv_ch5","C", 2,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cperg,"06","Ate o Estado:"			,"","","mv_ch6","C", 2,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cperg,"07","Do Vendedor"			,"","","mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cperg,"08","Ate o Vendedor:"		,"","","mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cperg,"09","Da Regiao:"				,"","","mv_ch9","C", 4,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","",""})	
AADD(aRegs,{cperg,"10","Ate a Regiao:"			,"","","mv_cha","C", 4,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","",""})	
AADD(aRegs,{cperg,"11","Excel:	"				,"","","mv_chb","N", 1,0,0,"C","","mv_par11","Nao","Nao","Nao","Sim","Sim","Sim","","","","","","","","","","","","","",""})	
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

dBSelectArea(_sAlias)

Return

Static Function fClient()

Local _cA1_COD  := ""
Local _cA1_LOJA := ""

_cQuery := ""
_cQuery += "SELECT A1_COD,A1_LOJA,F2_EMISSAO EMISSAO, "
_cQuery += "(CASE WHEN A1_COD IN ("+_cCli+"'') AND A1_LOJA IN ("+_cLojCli+"'') THEN 'NAO' ELSE 'SIM' END)AS CLIENTES "
_cQuery += "FROM SA1010 A1 "

_cQuery += "INNER JOIN SF2010 F2 ON F2.D_E_L_E_T_ = ' ' "
_cQuery += "AND F2_CLIENTE = A1_COD "
_cQuery += "AND F2_LOJA    = A1_LOJA "
_cQuery += "AND F2_FILIAL = '"+xFilial("SF2")+"' "
_cQuery += "AND F2_EMISSAO < '"+DtoS(MV_PAR01)+"' "
_cQuery += "AND F2_EST BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQuery += "AND F2_VEND1 = '"+_cVend+"' "
_cQuery += "AND F2_REGIAO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cQuery += "WHERE A1.D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY A1_COD,A1_LOJA,F2_EMISSAO DESC"

MemoWrite("CLIENT.SQL",_cQuery)
If Select("TRB2") > 0
	TRB2->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB2",.F.,.T.)

DbSelectArea("TRB2")
dbGoTop()
TcSetField("TRB2","EMISSAO","D") 

_cA1_COD := ""
_cA1_LOJA := ""
Do While !TRB2->(Eof())
	If _cA1_COD <> TRB2->A1_COD .And. _cA1_LOJA <> TRB2->A1_LOJA .And. TRB2->CLIENTES = 'SIM'
		Aadd(aRet,{TRB2->A1_COD,TRB2->A1_LOJA,DtoC(TRB2->EMISSAO)})
		_cA1_COD := TRB2->A1_COD
		_cA1_LOJA := TRB2->A1_LOJA
	Endif
	TRB2->(dbSkip())
EndDo

Return

Static Function fExcel()

	For _nX := 1 to Len(aDados1)
		
		If lPassou
			AAdd(aDadosEx,{})
			AAdd(aDadosEx,{aDados1[_nX][1]})
			lPassou := .F.
		Endif
		
		For _nY := 1 to Len(aDados2)
			AAdd(aDadosEx,{aDados2[_nY][1],aDados2[_nY][2],aDados2[_nY][3],aDados2[_nY][4],aDados2[_nY][5],aDados2[_nY][6],aDados2[_nY][7]})
		Next
		aDados2 := {}
		
		AAdd(aDadosEx,{"TOTAL",,,_nTotMercEx - _nDevMercGerEx,_nTotIpiEx -_nDevIpiGerEx, _nTotStEx - _nDevStGerEx,_nTotGerEx - _nDevTotGerEx})
		AAdd(aDadosEx,{})
		AAdd(aDadosEx,{"CLIENTES QUE NAO COMPRARAM"})
		
		For _nZ := 1 To Len(aDados3)
			AAdd(aDadosEx,{aDados3[_nZ][1],aDados3[_nZ][2],aDados3[_nZ][3]})
		Next
		aDados3 := {}
	Next
	aDados1 := {}
Return

Static Function fDevolucao()

_cQuery3 := "SELECT DISTINCT F1_VALMERC,F1_VALIPI,F1_ICMSRET from SF1010 F1 "
_cQuery3 += "INNER JOIN SD1010 D1 ON D1.D_E_L_E_T_ = ' ' "
_cQuery3 += "AND D1_FILIAL = F1_FILIAL "
_cQuery3 += "AND D1_DOC = F1_DOC "
_cQuery3 += "AND D1_SERIE = F1_SERIE "
_cQuery3 += "AND D1_FORNECE = F1_FORNECE "
_cQuery3 += "AND D1_LOJA = F1_LOJA "
_cQuery3 += "AND D1_CF IN ('1201','1202','2201','2202','1410','1411','2410','2411') "
_cQuery3 += "WHERE F1.D_E_L_E_T_ = ' ' "
_cQuery3 += "AND F1_FORNECE = '"+_cClient+"' "
_cQuery3 += "AND F1_LOJA = '"+_cLoja+"' "
_cQuery3 += "AND F1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "

MemoWrite("DEVOLUCAO.SQL",_cQuery3)
If Select("TRB3") > 0
	TRB3->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery3),"TRB3",.F.,.T.)

DbSelectArea("TRB3")
dbGoTop()

Do While !TRB3->(Eof())
	AAdd(_aDev,{TRB3->F1_VALMERC,TRB3->F1_VALIPI,TRB3->F1_ICMSRET})
	TRB3->(dbSkip())
EndDo

Return
