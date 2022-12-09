#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMR001     º Autor ³ VANILSON SOUZA   º Data ³  12/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Este programa tem como objetivo gerar o relatório de       º±±
±±º          ³ Controle de Encalhe.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function COMR001()
///////////////////////

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "CONTROLE DE ENCALHE"
Local cPict         := ""
Local titulo       	:= "CONTROLE DE ENCALHE"
Local nLin         	:= 80
//					   xxxxxxxxx      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     xxxx       xxxx         xxxxxxxxxx    xxxxxxxx      xxxxxxxx
Local Cabec1       	:= "Codigo         Descricao                                          Estoque  Pr. Venda  Quantidade Lancamento 1a.Entrada Encalhe"
Local Cabec2       	:= "                                                                                                 (Dt Cad.)  na filial         "
Local imprime      	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "COMR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := padr("COMR01",len(SX1->X1_GRUPO),' ')
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "COMR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private Caracter  	:= 15
Private cString 	:= "SB1"


dbSelectArea("SB1")
dbSetOrder(1)

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
////////////////////////////////////////////////////

Local nOrdem
Local _cFilial := ""
Local cFornec  := ""
Local _cNFil   := ""

_cQuery := " SELECT SB2.B2_FILIAL,SD1.D1_COD, SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_PROC, SB2.B2_QATU, B1_DTCAD, B1_ENCALHE, MIN(D1_DTDIGIT) D1_DTDIGIT "
_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)
_cQuery += _cEnter + " ON SD1.D1_COD = SB1.B1_COD "
_cQuery += _cEnter + " AND SD1.D1_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = '' "

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB2') + " SB2 (NOLOCK) "
_cQuery += _cEnter + " ON SB2.D_E_L_E_T_ = ''
_cQuery += _cEnter + " AND B2_FILIAL = D1_FILIAL"
_cQuery += _cEnter + " AND B2_COD = B1_COD "

_cQuery += _cEnter + " WHERE B1_ENCALHE BETWEEN '" + dtos(MV_PAR03) + "' AND '" + dtos(MV_PAR04) + "'"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = ''"

If !Empty(MV_PAR05)
	_cQuery +=   _cEnter + "AND B1_GRUPO = '" + MV_PAR05 + "'"
EndIf

If !Empty(MV_PAR06)
	_cQuery += _cEnter + " AND D1_FORNECE = '" + MV_PAR06 + "'"
EndIf

_cQuery += _cEnter + " GROUP BY SB2.B2_FILIAL,SD1.D1_COD, SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_PROC, SB2.B2_QATU, B1_DTCAD, B1_ENCALHE"
_cQuery += _cEnter + " ORDER BY B2_FILIAL,B1_PROC,D1_COD"

MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQRY(,,_cQuery ),"TQRY",.T.,.T.)},'Selecionando informações...')
TcSetField("TQRY","B1_DTCAD","D",8,0)
TcSetField("TQRY","B1_ENCALHE","D",8,0)
TcSetField("TQRY","D1_DTDIGIT","D",8,0)

U_GravaQuery('COMR001.SQL',_cQuery)

Count to _nLastRec
DbGoTop()
SetRegua(_nLastRec)

TQRY->(dbGoTop())
_cFilial  := TQRY->B2_FILIAL
_cNFil	  := GetAdvFval("SM0",Alltrim("M0_FILIAL"),"01"+Alltrim(_cFilial))
cFornec   := TQRY->B1_PROC

Do While !TQRY->(EOF())
	
	IncRegua()
		
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 66
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		
		@nLin,00 PSAY "Filial: " + cValToChar(_cFilial) + "  " + cValToChar(_cNFil)		
		@nLin+=2,00 PSAY "Fornecedor: "  + cFornec + ' - ' + Posicione('SA2',1,xFilial('SA2') + cFornec ,'A2_NOME')
		
		nLin++
		
	Endif
	
	If _cFilial <> TQRY->B2_FILIAL
		
		_cFilial := TQRY->B2_FILIAL
		
		_cNFil	  := GetAdvFval("SM0",Alltrim("M0_FILIAL"),"01"+Alltrim(_cFilial))
		@nLin+=2,00 PSAY "Filial: " + cValToChar(_cFilial) + "  " + cValToChar(_cNFil)
		
	End
	
	If cFornec <> TQRY->B1_PROC
		
		cFornec := TQRY->B1_PROC
		@nLin+=2,00 PSAY "Fornecedor: "  + cFornec + ' - ' + Posicione('SA2',1,xFilial('SA2') + cFornec ,'A2_NOME')
		nLin++
		
	Endif
	
	_cLinha := TQRY->D1_COD + ' '  // Codigo
	_cLinha += Substr( TQRY->B1_DESC, 1, 50 ) + ' '  // Descrição
	_cLinha += str(TQRY->B2_QATU,4) + ' '
	_cLinha += "R$ " + transform(TQRY->B1_PRV1,"@E 999,999.99") + ' '
	_cLinha += "___________ "
	_cLinha += dtoc(TQRY->B1_DTCAD) + ' '		// data do lançamento (cadastro) do produto
	_cLinha += dtoc(TQRY->D1_DTDIGIT) + ' '   // data da primeira entrada na loja
	_cLinha += dtoc(TQRY->B1_ENCALHE)
	
	@ ++nlin,00 pSay _cLinha
	
	TQRY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
EndDo

dbCloseArea("TQRY")

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

