#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"

//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 
//                        Low Intensity colors 
//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 
//                      High Intensity Colors 
//ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01    ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  19/09/05   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera arquivo de fluxo de caixa                             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico 		                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
user function PFIN003()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"GeraÁ„o de planilha de Fluxo de Caixa"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"PFIN03"
private _cArq	:= 	"PFIN03.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilSE5:= xFilial("SE5")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
private _nSaldoIni 	:= 0
Private _aRegSimul	:= {} // matriz com os recnos do TRB1 e do SZ3, respectivamente
private _cItemConta := mv_par06
private _ItemICIni 

private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"
             
Private _aGrpSint:= {}

ValidPerg()

AADD(aSays,"Este programa gera planilha com os dados para o fluxo de caixa de acordo com os ")
AADD(aSays,"par‚metros fornecidos pelo usu·rio. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"autom·tica pelo Excel.")
AADD(aSays,"Movimentos apÛs a data de referÍncia s„o considerados previstos e anteriores ")
AADD(aSays,"ou iguais a ela, realizados.")
AADD(aSays,"")
AADD(aSays,"")
AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
if nOpcA == 1 
	          
	pergunte(cPerg,.F.)
	
	_dDataIni 	:= mv_par01 // Data inicial
	_dDataFim 	:= mv_par02 // Data Final
	_dDtRef  	:= mv_par03 // Data de referencia
	_lPedCompra	:= mv_par04 == 1 // Considera pedido de compras
	//_lPedVenda	:= mv_par05 == 1 // Considera pedido de vendas
	_lVencRec	:= 3 // Considera Vencidos a receber
	_lVencPag	:= 3 // Considera Vencidos a pagar
	_nDiasPer	:= max(1 , mv_par05) // Quantidade de dias por periodo (minimo de 1 dia)
	//_ItemICIni 	:= mv_par06
	
	//_ItemICFim 	:= mv_par07
	
	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif
	
	dDataBase := _dDtRef // muda a database para a data de referencia, para calculo de saldos
	
	//MSAguarde({||ProcBco(_lSelBancos)},"Processando Bancos") // Calcula saldos bancarios iniciais
	
	//MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
	//MSAguarde({||PFIN01REAL02()},"Fluxo de caixa Realizado")
	
	// Processa titulos em aberto
	MSAguarde({|| PFIN01TIT03()},"TÌtulos Contas a Receber")
	
	MSAguarde({|| PFIN01SE203()},"TÌtulos Conta a Pagar")
	
	//MSAguarde({|| PFIN01BC()},"Saldos Bancarios")
	
		
	if _lPedCompra
		// Processa os pedidos de compras
		MSAguarde({|| PFIN01PC03()},"Ordem de compra")
	endif
	

	MSAguarde({||PFIN01SINT()},"Gerando arquivo sintÈtico.") // *** Funcao de gravacao do arquivo sintetico ***
	
	MontaTela()
	
	dDataBase := _cOldData // restaura a database
	
	TRB1->(dbclosearea())
	TRB11->(dbclosearea())
	TRB2->(dbclosearea())
	
	
endif


return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01TIT ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Processa Titulos em aberto                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function PFIN01TIT03()
Local _cFilSE1 := xFilial("SE1")
Local _cFilSED := xFilial("SED")
local _cQuery := ""
local _nSaldo := 0
local _lNatFluxo := SED->(fieldpos("ED_XFLUXO")) > 0

SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO

// TITULOS A RECEBER EM ABERTO
ChkFile("SE1",.F.,"QUERY") // Alias dos titulos a receber
QUERY->(dbsetorder(7)) // E1_FILIAL + DTOS(E1_VENCREA) + E1_NOMCLI + E1_PREFIXO + E1_NUM + E1_PARCELA
//QUERY->(dbseek(_cFilSE1+dtos(_dDtRef),.T.))
///QUERY->(dbseek(_cFilSE1+iif(_lVencRec,"",dtos(_dDtRef)),.T.))
QUERY->(dbGoTop())
while QUERY->(!eof()) //.and. SE1->E1_FILIAL == _cFilSE1 .and. QUERY->E1_VENCREA <= _dDataFim
	
	if 	substr(QUERY->E1_TIPO,3,1) == "-" .or. ;
		!(QUERY->E1_SALDO > 0 .OR. dtos(QUERY->E1_BAIXA) > dtos(_dDtRef)) .or. ;
		QUERY->E1_EMISSAO > _dDataFim .or. QUERY->E1_TIPO = "RA" .or. ALLTRIM(QUERY->E1_FLUXO) = "N" /////////////////////////////////////////////
		QUERY->(dbskip())
		loop
	endif
	/*
	if QUERY->E1_XXIC <> _ItemICIni
		QUERY->(dbskip())
		loop
	endif
	*/
	/*
	if QUERY->E1_XXIC > _ItemICFim
		QUERY->(dbskip())
		loop
	endif
	*/
	if SED->(dbseek(_cFilSED+QUERY->E1_NATUREZ))
		_cNatureza := SED->ED_DESCRIC
	
	else
		_cNatureza := "NATUREZA NAO DEFINIDA"
		if _lNatFluxo .and. SED->ED_XFLUXO == "N"
			QUERY->(dbskip())
			loop
		endif

	endif
	
	_nSaldo :=_CalcSaldo("SE1", QUERY->(recno()))
	
	if _nSaldo <> 0
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= iif( dtos(QUERY->E1_VENCREA) < dtos(_dDtRef) , _dDtRef , DataValida(QUERY->E1_VENCREA) ) // DataValida(QUERY->E1_VENCREA) //max(DataValida(QUERY->E1_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
		TRB1->NATUREZA	:= QUERY->E1_NATUREZ
		TRB1->DESC_NAT	:= _cNatureza
		TRB1->VALOR		:= _nSaldo
		TRB1->TIPO		:= "P"
		TRB1->RECPAG	:= "R"
		TRB1->ORIGEM	:= "CR"
		TRB1->HISTORICO	:= 	alltrim(QUERY->E1_XXIC + " - " + QUERY->E1_NOMCLI + " Titulo:"  + QUERY->E1_NUM + " Parcela:" + QUERY->E1_PARCELA + " Tipo:" + QUERY->E1_TIPO) + ;
		iif(!empty(QUERY->E1_HIST) , " - " + QUERY->E1_HIST ,"") + " " + ;
		iif( dtos(QUERY->E1_VENCREA) < dtos(_dDtRef) , " - Vencto.Real: " + dtoc(DataValida(QUERY->E1_VENCREA)) , "" )
		TRB1->GRUPONAT 	:= iif( dtos(QUERY->E1_VENCREA) < dtos(_dDtRef) .and. empty(dtos(QUERY->E1_BAIXA)) .and. !empty(QUERY->E1_NATUREZ)  , "0.00.09" , RetGrupo(TRB1->NATUREZA) ) //RetGrupo(TRB1->NATUREZA)
		TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
		TRB1->ITEMCONTA	:= QUERY->E1_XXIC
		TRB1->CLIFOR	:= QUERY->E1_CLIENTE
		TRB1->NCLIFOR	:= QUERY->E1_NOMCLI
		TRB1->LOJA		:= QUERY->E1_LOJA
		TRB1->PREFIXO	:= QUERY->E1_PREFIXO
		TRB1->NTITULO	:= QUERY->E1_NUM
		TRB1->PARCELA	:= QUERY->E1_PARCELA
		TRB1->TIPOD		:= QUERY->E1_TIPO
		TRB1->DATAMOV2	:=  DataValida(QUERY->E1_VENCREA) 
		MsUnlock()
	endif
	
	QUERY->(dbskip())
enddo


QUERY->(dbclosearea())


return

//////////////////////////
static function PFIN01SE203()

Local _cFilSE2 := xFilial("SE2")
Local _cFilSED := xFilial("SED")
local _cQuery := ""
local _nSaldo := 0


SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO

// TITULOS A PAGAR EM ABERTO
ChkFile("SE2",.F.,"QUERY") // Alias dos titulos a pagar
QUERY->(dbsetorder(3)) // E2_FILIAL + DTOS(E2_VENCREA) + E2_NOMFOR + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
//QUERY->(dbseek(_cFilSE2+dtos(_dDtRef),.T.))
QUERY->(dbGoTop())
while QUERY->(!eof()) //.and. SE2->E2_FILIAL == _cFilSE2 .and. QUERY->E2_VENCREA <= _dDataFim
	//msginfo ( "Contas a pagar")
	if 	substr(QUERY->E2_TIPO,3,1) == "-" .or. ;
		!(QUERY->E2_SALDO > 0 .OR. dtos(QUERY->E2_BAIXA) > dtos(_dDtRef)) .or. ; 
		QUERY->E2_EMISSAO > _dDataFim .or. QUERY->E2_TIPO = "PA" 
		QUERY->(dbskip())
		loop
		//!(QUERY->E2_SALDO > 0 .OR. dtos(QUERY->E2_BAIXA) > dtos(_dDtRef)) .or. ; 
	endif
	/*
	if QUERY->E2_XXIC <> _ItemICIni
		QUERY->(dbskip())
		loop
	endif
	*/
	/*
	if QUERY->E2_XXIC > _ItemICFim
		QUERY->(dbskip())
		loop
	endif
	*/
	
	if SED->(dbseek(_cFilSED+QUERY->E2_NATUREZ))
		_cNatureza := SED->ED_DESCRIC
	
	else
		_cNatureza := "NATUREZA NAO DEFINIDA"
			
	endif
	
	
	_nSaldo :=_CalcSaldo("SE2", QUERY->(recno()))
	
	
	if _nSaldo <> 0
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= iif( dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) , _dDtRef , DataValida(QUERY->E2_VENCREA) ) // A data de previsao tem que ser, no minimo, a data de referencia
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DESC_NAT	:= _cNatureza
		TRB1->VALOR		:= _nSaldo // QUERY->E2_SALDO //_nSaldo
		TRB1->TIPO		:= "P"
		TRB1->RECPAG	:= "P"
		TRB1->ORIGEM	:= "CP"
		TRB1->HISTORICO	:=  alltrim(QUERY->E2_XXIC) + " " + alltrim(QUERY->E2_NOMFOR) + " Titulo:" + ;
		QUERY->E2_NUM + " Parcela:" + QUERY->E2_PARCELA + " Tipo:" + alltrim(QUERY->E2_TIPO) + ;
		iif(!empty(QUERY->E2_HIST) , " - " + alltrim(QUERY->E2_HIST) ,"") + " " + ;
		iif( dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) , " - Vencto.Real: " + dtoc(DataValida(QUERY->E2_VENCREA)) , "" )
		TRB1->GRUPONAT 	:= iif( dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) .and. empty(dtos(QUERY->E2_BAIXA)) .and. !empty(QUERY->E2_NATUREZ)  , "0.00.10" , RetGrupo(TRB1->NATUREZA) ) //RetGrupo(TRB1->NATUREZA)
		TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
		TRB1->ITEMCONTA	:= QUERY->E2_XXIC
		TRB1->CLIFOR	:= QUERY->E2_FORNECE
		TRB1->NCLIFOR	:= QUERY->E2_NOMFOR
		TRB1->LOJA		:= QUERY->E2_LOJA
		TRB1->PREFIXO	:= QUERY->E2_PREFIXO
		TRB1->NTITULO	:= QUERY->E2_NUM
		TRB1->PARCELA	:= QUERY->E2_PARCELA
		TRB1->TIPOD		:= QUERY->E2_TIPO
		TRB1->DATAMOV2	:=  DataValida(QUERY->E2_VENCREA) 
		MsUnlock()
	endif
	
	QUERY->(dbskip())
enddo

QUERY->(dbclosearea())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥_CalcSaldo∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Calcula o saldo do titulo na data de referencia            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function _CalcSaldo(_cAlias, _nRecno)

local _nSaldo := 0

if _cAlias == "SE1"
	
	SE1->(dbgoto(_nRecno))
	
	dbselectarea("SE1")
	
	_nSaldo	:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
	SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,;
	_dDtRef,_dDtRef,SE1->E1_LOJA,_cFilSE5)
	
	dbselectarea("SE1")
	
	_nSaldo -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,;
	_dDtRef,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
	
	if SE1->E1_TIPO $ (MV_CRNEG + "/" + MVRECANT) .OR. SE2->E2_TIPO == "RA" // O normal de um titulo a receber e ser positivo
		_nSaldo := -1 * _nSaldo
	endif

else
	
	SE2->(dbgoto(_nRecno))
	
	dbselectarea("SE2")
	
	_nSaldo	:= SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
	SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,;
	_dDtRef,_dDtRef,SE2->E2_LOJA)
	
	dbselectarea("SE2")

	_nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,;
	_dDtRef,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL)

	if !(SE2->E2_TIPO $ (MV_CPNEG + "/" + MVPAGANT)) .OR. SE2->E2_TIPO == "PA"  // O normal de um titulo a pagar e ser negativo
		_nSaldo := -1 * _nSaldo
	endif
	
endif

return(_nSaldo)



/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01PC  ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Processa  Pedidos de compra                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function PFIN01PC03()
local _cQuery 		:= ""
local _aVencimentos	:= {} // Matriz no formato {Data de vencimento, natureza ,valor, numero do pedido de compra}
local _aparcelas	:= {}
local _nValor       := 0
local _nValIPI      := 0
local _nPos			:= 0
local _nConta		:= 0
local _cFilSA2 		:= xFilial("SA2")
local _cFilSB1 		:= xFilial("SB1")
local _cFilSC7 		:= xFilial("SC7")
local _cFilSE4 		:= xFilial("SE4")
local _cFilSED 		:= xFilial("SED")
local _cFilSF4 		:= xFilial("SF4")
local _lNatSC7		:= SC7->(fieldpos("C7_NATUREZ")) > 0

SA2->(dbsetorder(1)) // A2_FILIAL + A2_COD + A2_LOJA
SB1->(dbsetorder(1)) // B1_FILIAL + B1_COD
SC7->(dbsetorder(1)) // C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
SE4->(dbsetorder(1)) // E4_FILIAL + E4_CODIGO
SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
SF4->(dbsetorder(1)) // F4_FILIAL + F4_CODIGO

SC7->(dbseek(_cFilSC7))

while SC7->(!eof()) .and. SC7->C7_FILIAL == _cFilSC7
	
	if 	SC7->C7_QUJE >= SC7->C7_QUANT .or. SC7->C7_RESIDUO == 'S' .or. SC7->C7_FLUXO == 'N' .or. ;
		SB1->(!dbseek(_cFilSB1+SC7->C7_PRODUTO)) .or. SE4->(!dbseek(_cFilSE4+SC7->C7_COND)) .or. ;
		SA2->(!dbseek(_cFilSA2+SC7->C7_FORNECE+SC7->C7_LOJA))
		SC7->(dbskip())
		loop
	endif
	
	// Considera o TES do Pedido de Compras e, se ele estiver vazio, considera o do Produto
	_cTES := iif(!empty(SC7->C7_TES), SC7->C7_TES, SB1->B1_TE)
	
	_lTES := !empty(_cTES)
	
	if _lTES .and. SF4->(dbseek(_cFilSF4+_cTES))
		if SF4->F4_DUPLIC == "N"
			SC7->(dbskip())
			loop
		endif
	endif
	
	_dDtEnt :=  DataValida(SC7->C7_DATPRF) //Iif( SC7->C7_DATPRF < _dDtRef, _dDtRef, DataValida(SC7->C7_DATPRF))
	
	_nValPC := (1+SE4->E4_ACRSFIN/100) * ((SC7->C7_QUANT-SC7->C7_QUJE)) * (SC7->C7_PRECO - SC7->C7_VLDESC)  //(1+SE4->E4_ACRSFIN/100) * ((SC7->C7_QUANT-SC7->C7_QUJE)/SC7->C7_QUANT) * (SC7->C7_TOTAL - SC7->C7_VLDESC)
	
	_nValor := iif(str(SC7->C7_MOEDA,1,0) <> "1",xMoeda(_nValPC,SC7->C7_MOEDA,1,_dDtEnt) ,_nValPC)
	if SC7->C7_IPI > 0 .and. (!_lTES .or. SF4->F4_IPI <> "N")
		_nValIPI := (SC7->C7_IPI/100) * _nValor
		if _lTES .and. SF4->F4_BASEIPI > 0
			_nValIPI *= (SF4->F4_BASEIPI/100)
		elseif SF4->F4_IPI == "R"
			_nValIPI := _nValIPI/2
		endif
	endif
	_nValor += _nValIPI
	
	_aParcelas := Condicao(_nValor,SC7->C7_COND,_nValIpi,_dDtEnt)
	
	_cNatureza := if(_lNatSC7 .and. !empty(SC7->C7_NATUREZ) , SC7->C7_NATUREZ, SA2->A2_NATUREZ)
	
	for _nConta := 1 to len(_aParcelas)
		_nPos := Ascan(_aVencimentos,{|x| x[1]==_aParcelas[_nConta,1] .and. x[2]==_cNatureza .and. x[4]==SC7->C7_NUM})
		if _nPos == 0
			aadd(_aVencimentos, {_aParcelas[_nConta,1],_cNatureza,_aParcelas[_nConta,2],SC7->C7_NUM})
		else
			_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
		endif
		
	next _nConta
	
	SC7->(dbskip())
	_nValor := 0
	_nValIPI:= 0
enddo
/*
TRB1->DATAMOV	:= iif( dtos(DataValida(_aVencimentos[_nConta,1])) < dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(DataValida(_aVencimentos[_nConta,1])) )
	TRB1->GRUPONAT 	:= iif( dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) .and. empty(dtos(QUERY->E2_BAIXA)) .and. !empty(QUERY->E2_NATUREZ)  , "0.00.10" , RetGrupo(TRB1->NATUREZA) ) 
*/
for _nConta := 1 to len(_aVencimentos)
	if _aVencimentos[_nConta,1] <= _dDataFim
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= iif( dtos(_aVencimentos[_nConta,1]) <= dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(_aVencimentos[_nConta,1]) )  //DataValida(_aVencimentos[_nConta,1])
		TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
		TRB1->HISTORICO	:=  "Cond.Pag.: "  +  Posicione("SE4",1,xFilial("SE4") + Posicione("SC7",1,xFilial("SC7") + alltrim(_aVencimentos[_nConta,4]),"SC7->C7_COND") ,"E4_DESCRI") + " " + ;
		iif( dtos(_aVencimentos[_nConta,1]) < dtos(DataValida(_dDtRef)) , " - Vencto.Real: " + dtoc(DataValida(_aVencimentos[_nConta,1])) , "" )  //"OC: " + _aVencimentos[_nConta,4] 
		TRB1->VALOR		:= -_aVencimentos[_nConta,3]
		TRB1->RECPAG	:= "P"
		TRB1->TIPO		:= "P"
		TRB1->ORIGEM	:= "OC"
		TRB1->GRUPONAT 	:= iif( dtos(_aVencimentos[_nConta,1]) <= dtos(_dDtRef) , "0.00.10" , "2.0X.00" )  //"2.0X.00"//RetGrupo(TRB1->NATUREZA)
		TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
		if SED->(dbseek(_cFilSED+_aVencimentos[_nConta,2]))
			TRB1->DESC_NAT := SED->ED_DESCRIC
		else
			TRB1->DESC_NAT := "NATUREZA NAO DEFINIDA"
		endif
		TRB1->NTITULO	:= alltrim(_aVencimentos[_nConta,4]) 
		TRB1->ITEMCONTA	:= Posicione("SC7",1,xFilial("SC7") + alltrim(_aVencimentos[_nConta,4]),"SC7->C7_ITEMCTA")
		TRB1->CLIFOR	:= Posicione("SC7",1,xFilial("SC7") + alltrim(_aVencimentos[_nConta,4]),"SC7->C7_FORNECE")
		XCLIFOR := Posicione("SC7",1,xFilial("SC7") + alltrim(_aVencimentos[_nConta,4]),"SC7->C7_FORNECE")
		TRB1->NCLIFOR	:= ALLTRIM(Posicione("SA2",1,xFilial("SA2") + XCLIFOR,"SA2->A2_NREDUZ"))
		TRB1->PREFIXO	:= ""
		
		TRB1->PARCELA	:= ""
		TRB1->TIPOD		:= ""
		TRB1->DATAMOV2	:= DataValida(_aVencimentos[_nConta,1]) 
		MsUnlock()
	endif
next _nConta
return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PFIN01SINT∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera o Arquivo Sintetico                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function PFIN01SINT03()
local _nPos 	:= 0
local _cQuery	:= ""
local Query 	:= ""
local cFiltra 	:= " ORDEM <> '000001' "
local _nSaldo 	:= 0
local _nSaldoB1 	:= 0
local _nSaldoB2 	:= 0
local _nSaldoB3 	:= 0
local _nSaldoB4 	:= 0
local _nSaldoB5 	:= 0
local _nSaldoB1a 	:= 0
local _nSaldoB2a 	:= 0
local _nSaldoB3a 	:= 0
local _nSaldoB4a 	:= 0

local nX			:= 0

private _cOrdem := "000001"

//ProcRegua(ZZF->(reccount())+TRB1->(reccount())+BANCOS->(reccount()))

//oProcess:SetRegua2( ("TR1")->(RecCount()) ) //Alimenta a segunda barra de progresso

//oProcess:SetRegua2( ("TR1")->(RecCount()) ) //Alimenta a segunda barra de progresso
/*
BANCOS->(dbgotop())
while BANCOS->(!eof()) 
	if BANCOS->A6_OK <> ' ' 
		_nSaldo += BANCOS->A6_SALATU
	endif
	incproc()
	BANCOS->(dbskip())
enddo
*/
// Carga com todos os grupos de naturezas existentes
ZZF->(dbsetorder(1)) // Z2_FILIAL + Z2_GRUPO
ZZF->(dbgotop())
while ZZF->(!eof())
	RecLock("TRB2",.T.)
	
	TRB2->GRUPO 	:= ZZF->ZZF_GRUPO
	TRB2->DESCRICAO	:= ZZF->ZZF_DESCRI
	TRB2->ORDEM		:= _cOrdem
	TRB2->GRUPOSUP 	:= ZZF->ZZF_CODSUP
	MsUnlock()
	if ascan(_aGrpSint,ZZF->ZZF_CODSUP) == 0
		aadd(_aGrpSint,ZZF->ZZF_CODSUP)
	endif
	ZZF->(dbskip())
	_cOrdem := soma1(_cOrdem)
enddo

_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo



_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo

_cOrdem := soma1(_cOrdem)

// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas
RecLock("TRB2",.T.)


TRB2->DESCRICAO := "SEM NATUREZA"
TRB2->ORDEM		:= _cOrdem

MsUnlock()



TRB1->(dbclearfil())
TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
TRB1->(dbgotop())
while TRB1->(!eof())
	_nPos 	:= TRB2->(fieldpos(TRB1->CAMPO))
	if _nPos > 0 .AND. ! TRB2->GRUPO $ "9.ZZ.03/9.ZZ.04/9.ZZ.05/9.ZZ.06/9.ZZ.07"
		GravaVlr(TRB1->GRUPONAT,TRB1->VALOR,_nPos)
	endif
	TRB1->(dbskip())
enddo


_cOrdem := soma1(_cOrdem)


AtuSaldo()

TRB2->(dbclearfil())
TRB2->(dbgotop())


return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GravaVlr  ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Grava valor no arquivo sintetico                           ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function GravaVlr(_cGrupo, _nValor, _nPosCpo)
local _nValAtual := 0

if TRB2->(dbseek(_cGrupo)) .OR. _cGrupo $ "9.ZZ.03/9.ZZ.04/9.ZZ.05/9.ZZ.06/9.ZZ.07"
	
	_nValAtual := TRB2->(FieldGet(_nPosCpo))
	
	RecLock("TRB2",.F.)
	FieldPut(_nPosCpo , _nValor + _nValAtual)
	TRB2->TOTAL += _nValor
	MsUnlock()
	
/*	
else // Se o grupo nao existir
	
	RecLock("TRB2",.T.)
	TRB2->GRUPO 	:= _cGrupo
	TRB2->DESCRICAO	:= "GRUPO INEXISTENTE"
	TRB2->ORDEM		:= _cOrdem
	FieldPut( _nPosCpo , _nValor )
	TRB2->TOTAL += _nValor 
	MsUnlock()
	_cOrdem := soma1(_cOrdem)
*/
endif

if !empty(TRB2->GRUPOSUP)
	GravaVlr(TRB2->GRUPOSUP, _nValor, _nPosCpo)
endif

//AtuSaldo() // Atualiza os saldo iniciais

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AtuSaldo  ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Atualiza o Saldo inicial de todos os dias no TRB2          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function AtuSaldo()
local _nSaldoB1 	:= 0
local _nSaldoB2 	:= 0
local _nSaldoB3 	:= 0
local _nSaldoB4 	:= 0
local _nSaldoB5 	:= 0
local nX			:= 0
local nX1			:= 1
local _aSaldos	:= {}
local _nPos		:= 0

for _ni := 1 to _nCampos
	aAdd(_aSaldos,{_aCpos[_ni] ,0})
next _ni

TRB2->(dbgotop())
while TRB2->(!eof())
	if TRB2->(recno())<>_nRecSaldo .and. !empty(TRB2->GRUPOSUP) .and. ascan(_aGrpSint,TRB2->GRUPO) == 0 ;
	   .or. alltrim(TRB2->DESCRICAO) == "SEM NATUREZA OU GRUPO" //.and. ! TRB2->GRUPO $ "1.0X.01/9.EM.00" 
		for _ni := 1 to _nCampos
			_nPos := Ascan(_aSaldos,{|x| x[1]==_aCpos[_ni]})
			if _nPos > 0
				_aSaldos[_nPos,2] += &("TRB2->" + _aCpos[_ni])
			endif
		next _ni
	endif
	TRB2->(dbskip())
enddo



//TRB2->(DBGoBottom()) // Posiciona no registro de saldo inicial

//TRB2->(dbgotop())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MontaTela ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Monta a tela de visualizacao do Fluxo Sintetico            ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function MontaTela()
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oDlgSint

cCadastro := "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - PerÌodo de " + alltrim(str(_nDiasPer,4,0)) + " dias", " - Di·rio  "  )

// Monta aHeader do TRB2

aadd(aHeader, {"DescriÁ„o","DESCRICAO","",50,0,"","","C","TRB2","R"})

for _ni := 1 to len(_aCpos) // Monta campos com as datas
	aadd(aHeader, {_aLegPer[_ni],_aCpos[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
next _dData
aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Grupo","GRUPO","",10,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - PerÌodo de " + alltrim(str(_nDiasPer,4,0)) + " dias", " - Di·rio  " ) ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

// COR DA FONTE
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

/*
oGroup1:= TGroup():New(0032,0015,0062,0900,'',_oDlgSint,,,.T.)
oGroup2:= TGroup():New(0065,0015,0095,0380,'Venda',_oDlgSint,,,.T.)
oGroup3:= TGroup():New(0065,0385,0095,0800,'Venda Revisado',_oDlgSint,,,.T.)

oGroup4:= TGroup():New(0095,0015,0125,0380,'Custo Vendido',_oDlgSint,,,.T.)
oGroup5:= TGroup():New(0095,0385,0125,0800,'Custo Revisado',_oDlgSint,,,.T.)

oGroup6:= TGroup():New(0065,0810,0125,0900,'Data',_oDlgSint,,,.T.)


@ 0070,0830 Say  "InÌcio " 	COLORS 0, 16777215 PIXEL
@ 0079,0830 MSGET  POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_DTEXIS") COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0830 Say  "Final" 	COLORS 0, 16777215 PIXEL
@ 0109,0830 MSGET  POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_DTEXSF") COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0045,0020 MSGET  _ItemICIni  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0045,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0200 Say  "Cod.C∑liente: " 	 COLORS 0, 16777215 PIXEL
@ 0045,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0045,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0460 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0045,0460 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0520 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0045,0520 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0060 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDCI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0160 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDSI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0260 Say  "s/ Tributos (s/Frete): " 	COLORS 0, 16777215 PIXEL
@ 0079,0260 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XSISFV"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0440 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDCIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0540 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDSIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0640 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0079,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XSISFR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0060 Say  "ProduÁ„o " 	COLORS 0, 16777215 PIXEL
@ 0109,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUSTO"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUTOT"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0440 Say  "ProduÁ„o " 	COLORS 0, 16777215 PIXEL
@ 0109,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUPRR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0540 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUTOR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0640 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0109,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVBAD"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
*/

//aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "SimulaÁ„o" } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE1" , { || zExportExc()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE2" , { || zAtualizar()}, "Atualizar SintÈtico " } )
aadd(aButton , { "BMPTABLE3" , { || ShowAna03()}, "AnalÌtico Geral " } )


_oDlgSint:Refresh()
_oGetDbSint:ForceRefresh()

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

Static Function zExportExc()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cArquivo  := GetTempPath()+'zExportExc.xml'
    Local oExcel	
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcelEx():New()
    //Local oFWMsExcel := YExcel():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   //Local oExcel	:= YExcel():new()
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#000080")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do tÌtulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFE0")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
    
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Fluxo de Caixa") //N„o utilizar n˙mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Fluxo de Caixa","Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim))
        
        aAdd(aColunas, "DescriÁ„o" + SPACE(25))
        for _ni := 1 to len(_aCpos) // Monta campos com as datas
        	aAdd(aColunas,  _aLegPer[_ni])
        next _dData
        
        For nAux := 1 To Len(aColunas)
            oFWMsExcel:AddColumn("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aColunas[nAux],1,2)
            aAdd(aColsMa,  nX1 )
            nX1++
        Next
              
        While  !(TRB2->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB2->DESCRICAO
        	
        	nAux2 := 2
        	For nAux := 1 To Len(aColunas)-1	
        		aLinhaAux[nAux2] := &("TRB2->" + _aCpos[nAux])
            	nAux2++
            next
           
               		
            if alltrim(aLinhaAux[1]) == "SALDO INICIAL" .OR. alltrim(aLinhaAux[1]) == "TOTAL RECEITAS" .OR. ;
            	alltrim(aLinhaAux[1]) == "TOTAL DESPESAS" .OR. alltrim(aLinhaAux[1]) == "SALDO FINAL"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#4169E1")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif alltrim(aLinhaAux[1]) == "SALDO PROVISIONADO" .OR. alltrim(aLinhaAux[1]) == "SALDO BANCOS" .OR. ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO (EMPREST./CHEQUE ESPECIAL)" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#4169E1")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO DISPONIVEL"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "SANTADER (CC 100/104)" .OR. ;
            	alltrim(aLinhaAux[1]) == "BRADESCO (CC 200/202)" .OR. ;
            	alltrim(aLinhaAux[1]) == "CAIXA GERAL (CX1)" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "SALDOS BANCOS" .OR. ;
            	alltrim(aLinhaAux[1]) == "SANTADER (EMPRESTIMO 115" .OR. ;
            	alltrim(aLinhaAux[1]) == "ITAU (CC 500/502)" .OR. ;
            	alltrim(aLinhaAux[1]) == "XP INVESTIMENTOS"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#F0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE DE CREDITO ATUAL" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#F0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO EMPRESTIMO"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#F0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO CHEQUE ESPECIAL" .OR. ;
            	alltrim(aLinhaAux[1]) == "TOTAL CREDITO" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            elseif;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SALDO INICIAL" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "TOTAL RECEITAS" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "TOTAL DESPESAS" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SALDO FINAL" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SALDOS BANCOS" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (CC 100/104)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "BRADESCO (CC 200/202)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "CAIXA GERAL (CX1)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (EMPRESTIMO 115" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "ITAU (CC 500)"
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "LIMITE CREDITO DISPONIVEL"
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)   
            	nCL := 2
            elseif ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SALDO INICIAL" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "TOTAL RECEITAS" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "TOTAL DESPESAS" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SALDOS BANCOS" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SALDO FINAL" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (CC 100/104)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "BRADESCO (CC 200/202)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "CAIXA GERAL (CX1)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (EMPRESTIMO 115" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "ITAU (CC 500)"
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "LIMITE CREDITO DISPONIVEL"
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FAFAD2")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            	nCL := 1
            
            else
            	oFWMsExcel:AddRow("Fluxo de Caixa", "Fluxo de caixa - SintÈtico - de " + dtoc(_dDataIni) + " atÈ " + dtoc(_dDataFim), aLinhaAux,aColsMa)
            endif

            TRB2->(DbSkip())

        EndDo
        
    TRB2->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
  
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex„o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
    
Return


Static Function SFMudaCor(nIOpcao)
    Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.01"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.XX.03"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.10"; _cCor := CLR_LIGHTGRAY ; endif
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.08"; _cCor := CLR_LIGHTGRAY ; endif
   	  ///if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.13"; _cCor := CLR_LIGHTGRAY ; endif
   	  /*
   	  for _ni := 1 to _nCampos-1
				if &("TRB2->" + _aCpos[_ni] ) > 0 .AND. ALLTRIM(TRB2->GRUPO) == "1.0X.01";_cCor := CLR_WHITE ; endif    // Grava o saldo inicial do dia seguinte
	  next _ni
   	  */  
    endif
   
   if nIOpcao == 2 // Cor da Fonte
   	  if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.01"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.XX.03"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.10"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.08"; _cCor := CLR_HGREEN  ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.13"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "0.XX.00"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "1.99.99"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.01"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.11"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.12"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.02"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.09"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.11"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.12"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.18"; _cCor := CLR_HCYAN ; endif
      //if ALLTRIM(TRB2->GRUPO) ==  "9.XX.04"; _cCor := CLR_YELLOW ; endif
      //if ALLTRIM(TRB2->GRUPO) ==  "9.XX.05"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.06"; _cCor := CLR_HGREEN ; endif
      
      //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.18"; _cCor := CLR_HGREEN ; endif
      
      /*
      for _ni := 1 to _nCampos-1
				if &("TRB2->" + _aCpos[_ni] ) > 0 .AND. ALLTRIM(TRB2->GRUPO) == "1.0X.01";_cCor := CLR_HMAGENTA ; endif    // Grava o saldo inicial do dia seguinte
	  next _ni
	  
	  for _ni := 1 to _nCampos-1
				if &("TRB2->" + _aCpos[_ni] ) > 0 .AND. ALLTRIM(TRB2->GRUPO) == "1.0X.02";_cCor := CLR_HMAGENTA ; endif    // Grava o saldo inicial do dia seguinte
	  next _ni
	  */
	 	  
    endif
Return _cCor

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ShowAnalit∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Abre os arquivos necessarios                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function ShowAnalit(_cCampo,_cPeriodo)
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(GRUPONAT) == '" + alltrim(TRB2->GRUPO) + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB1
aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Banco"		,"BANCO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Prefixo"	,"PREFIXO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"No.Titulo/OC","NTITULO"	,"",09,0,"","","C","TRB1","R"})
aadd(aHeader, {"Parcela"	,"PARCELA"	,"",01,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPOD"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"DescriÁ„o"	,"DESC_NAT"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Cli/For","CLIFOR"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cli/For"	,"NCLIFOR"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Loja"		,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"HistÛrico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

cCadastro :=  "Fluxo de caixa - AnalÌtico - " + _cPeriodo + " " 

DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - AnalÌtico - " + _cPeriodo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

_oGetDbAnalit:oBrowse:BlDblClick := {|| EditReg() }

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA ORIGEM: MB - Movimento Banc·rio / CR - Contas a Receber / CP - Contas a Pagar / OC - Ordem de Compras / PV - Pedido de Vendas "  COLORS 0, 16777215 PIXEL
/*
oGroup1a:= TGroup():New(0032,0015,0062,0900,'',_oDlgAnalit,,,.T.)
oGroup2a:= TGroup():New(0065,0015,0095,0380,'Venda',_oDlgAnalit,,,.T.)
oGroup3a:= TGroup():New(0065,0385,0095,0800,'Venda Revisado',_oDlgAnalit,,,.T.)

oGroup4a:= TGroup():New(0095,0015,0125,0380,'Custo Vendido',_oDlgAnalit,,,.T.)
oGroup5a:= TGroup():New(0095,0385,0125,0800,'Custo Revisado',_oDlgAnalit,,,.T.)

oGroup6a:= TGroup():New(0065,0810,0125,0900,'Data',_oDlgAnalit,,,.T.)


@ 0070,0830 Say  "InÌcio " 	COLORS 0, 16777215 PIXEL
@ 0079,0830 MSGET  POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_DTEXIS") COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0830 Say  "Final" 	COLORS 0, 16777215 PIXEL
@ 0109,0830 MSGET  POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_DTEXSF") COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0045,0020 MSGET  _ItemICIni  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0045,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0200 Say  "Cod.C∑liente: " 	 COLORS 0, 16777215 PIXEL
@ 0045,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0045,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0460 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0045,0460 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0520 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0045,0520 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0060 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDCI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0160 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDSI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0260 Say  "s/ Tributos (s/Frete): " 	COLORS 0, 16777215 PIXEL
@ 0079,0260 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XSISFV"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0440 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDCIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0540 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDSIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0640 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0079,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XSISFR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0060 Say  "ProduÁ„o " 	COLORS 0, 16777215 PIXEL
@ 0109,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUSTO"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUTOT"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0440 Say  "ProduÁ„o " 	COLORS 0, 16777215 PIXEL
@ 0109,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUPRR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0540 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUTOR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0640 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0109,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVBAD"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
*/
//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "SimulaÁ„o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir SimulaÁ„o" } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE3" , { || zExpAnalitico()}, "Gerar Plan. Excel " } )


ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ShowAnalit∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Abre os arquivos necessarios                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function ShowAna03()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
/*
cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(GRUPONAT) == '" + alltrim(TRB2->GRUPO) + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
*/

// Monta aHeader do TRB1
aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Banco"		,"BANCO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Prefixo"	,"PREFIXO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"No.Titulo/OC","NTITULO"	,"",09,0,"","","C","TRB1","R"})
aadd(aHeader, {"Parcela"	,"PARCELA"	,"",01,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPOD"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"DescriÁ„o"	,"DESC_NAT"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Cli/For","CLIFOR"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cli/For"	,"NCLIFOR"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Loja"		,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"HistÛrico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

cCadastro :=  "Fluxo de caixa - AnalÌtico " 

DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - AnalÌtico  "  From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

_oGetDbAnalit:oBrowse:BlDblClick := {|| EditReg() }

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA ORIGEM: MB - Movimento Banc·rio / CR - Contas a Receber / CP - Contas a Pagar / OC - Ordem de Compras / PV - Pedido de Vendas "  COLORS 0, 16777215 PIXEL
/*
oGroup1a:= TGroup():New(0032,0015,0062,0900,'',_oDlgAnalit,,,.T.)
oGroup2a:= TGroup():New(0065,0015,0095,0380,'Venda',_oDlgAnalit,,,.T.)
oGroup3a:= TGroup():New(0065,0385,0095,0800,'Venda Revisado',_oDlgAnalit,,,.T.)

oGroup4a:= TGroup():New(0095,0015,0125,0380,'Custo Vendido',_oDlgAnalit,,,.T.)
oGroup5a:= TGroup():New(0095,0385,0125,0800,'Custo Revisado',_oDlgAnalit,,,.T.)

oGroup6a:= TGroup():New(0065,0810,0125,0900,'Data',_oDlgAnalit,,,.T.)


@ 0070,0830 Say  "InÌcio " 	COLORS 0, 16777215 PIXEL
@ 0079,0830 MSGET  POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_DTEXIS") COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0830 Say  "Final" 	COLORS 0, 16777215 PIXEL
@ 0109,0830 MSGET  POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_DTEXSF") COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0045,0020 MSGET  _ItemICIni  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0045,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0200 Say  "Cod.C∑liente: " 	 COLORS 0, 16777215 PIXEL
@ 0045,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0045,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0460 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0045,0460 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0520 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0045,0520 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0060 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDCI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0160 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDSI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0260 Say  "s/ Tributos (s/Frete): " 	COLORS 0, 16777215 PIXEL
@ 0079,0260 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XSISFV"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0440 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDCIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0540 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVDSIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0640 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0079,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XSISFR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0060 Say  "ProduÁ„o " 	COLORS 0, 16777215 PIXEL
@ 0109,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUSTO"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUTOT"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0440 Say  "ProduÁ„o " 	COLORS 0, 16777215 PIXEL
@ 0109,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUPRR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0540 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XCUTOR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0640 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0109,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_ItemICIni,"CTD_XVBAD"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
*/
//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "SimulaÁ„o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir SimulaÁ„o" } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE3" , { || zExpAnalitico()}, "Gerar Plan. Excel " } )


ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GerSimul ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Inclui Simulacao no Fluxo de Caixa                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function GerSimul(_cCampo, _cPeriodo)
local _nOpca := 0

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0
	return
endif

private _nOpcoes 	:= 1
private _aOpcoes 	:= {"SimulaÁ„o a Pagar ","SimulaÁ„o a Receber"}
private _cGrupo	 	:= TRB2->DESCRICAO
private _cLegPer 	:= _aLegPer[ascan(_aCpos,_cCampo)]
private _nValor	 	:= 0
private _cHistorico	:= space(130)

@ 000,000 To 280,350 Dialog _oDlgSimul Title "SimulaÁ„o"

@ 010,005 Say "Grupo"
@ 010,035 Get _cGrupo Size 125,10 When .F.

@ 025,005 Say "PerÌodo"
@ 025,035 Get _cLegPer Size 55,10 When .F.

@ 045,005 Radio _aOpcoes Var _nOpcoes

@ 070,005 Say "Valor"
@ 070,035 Get _nValor Picture "@E 999,999,999.99" Valid positivo() Size 55,10

@ 085,005 Say "HistÛrico"
@ 085,035 Get _cHistorico Picture "@!" Size 125,10

@ 110,110 BmpButton Type 1 Action iif(_nValor > 0, (_nOpca:=1,_oDlgSimul:End()) , _oDlgSimul:End())
@ 110,140 BmpButton Type 2 Action (_oDlgSimul:End())

Activate Dialog _oDlgSimul centered

if _nOpca == 1 // Se confirmada a inclusao da simulacao
	
	RecLock("TRB1",.T.)
	TRB1->DATAMOV	:= _aDatas[Ascan(_aDatas , { |x| x[2] == _cCampo }),1] // Pega a primeira data do periodo como data da simulacao
	TRB1->DESC_NAT	:= "SIMULACAO"
	TRB1->HISTORICO	:= _cHistorico
	TRB1->VALOR		:= iif(_nOpcoes == 1 , -(_nValor) , _nValor)
	TRB1->RECPAG	:= iif(_nOpcoes == 1 , "P", "R")
	TRB1->GRUPONAT 	:= TRB2->GRUPO
	TRB1->CAMPO		:= _cCampo
	TRB1->SIMULADO	:= "S"
	MsUnlock()
	
	if msgyesno("Deseja guardar essa simulaÁ„o para consultas futuras?")
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL 	:= xFilial("SZS")
		SZS->ZS_GRUPO 	:= TRB1->GRUPONAT
		SZS->ZS_DATA 	:= TRB1->DATAMOV
		SZS->ZS_HIST 	:= TRB1->HISTORICO
		SZS->ZS_VALOR	:= abs(TRB1->VALOR)
		SZS->ZS_RECPAG	:= TRB1->RECPAG
		MsUnlock()
		
		aadd(_aRegSimul, {TRB1->(recno()), SZ3->(recno())} )
		
	endif
	
	// Limpa e recria o Arquivo sintetico - TRB2
	DbSelectArea("TRB2")
	zap

	MSAguarde({||PFIN01SINT()},"Gerando arquivo sintÈtico.")
	
endif

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ DelSimul ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Excluir Simulacao no Fluxo de Caixa                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function DelSimul()
local _nOpca := 0
local _nPos
local _nRecTRB1

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
if TRB1->SIMULADO <> "S"
	
	MsgStop("Apenas movimentos de simulaÁ„o podem ser excluÌdos.")
	
elseif msgyesno("Confirma exclus„o do movimento de simulaÁ„o?")
	
	_nRecTRB1 := TRB1->(recno())
	RecLock("TRB1",.F.)
	dbdelete()
	MsUnlock()
	
	if msgyesno("Deseja excluir essa simulaÁ„o de consultas futuras?")
		_nPos := Ascan(_aRegSimul,{|x| x[1] == _nRecTRB1})
		if _nPos > 0
			SZ3->(dbgoto(_aRegSimul[_nPos,2]))
			RecLock("SZ3",.F.)
			dbdelete()
			MsUnlock()
		endif
	endif
	
	// Limpa e recria o Arquivo sintetico - TRB2
	DbSelectArea("TRB2")
	zap
	MSAguarde({||PFIN01SINT()},"Gerando arquivo sintÈtico.")
	
	//_oDlgAnalit:End()
	TRB1->(dbgotop())
	TRB2->(dbgotop())
	
endif

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GeraExcel ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera Arquivo em Excel e abre                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function GeraExcel(_cAlias,_cFiltro,aHeader)

MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

/*
_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	copy to &(_cArq) VIA "DBFCDXADS" for &(_cFiltro)
else
	copy to &(_cArq) VIA "DBFCDXADS"
endif

MsAguarde({||AbreDoc( _cArq ) },"Aguarde","Abrindo Arquivo",.F.)
*/

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GeraCSV   ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera Arquivo em Excel e abre                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)

local cDirDocs  := MsDocPath() 
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX

local _cArq		:= ""

_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	(_cAlias)->(dbgotop())
	while (_cAlias)->(!eof())
	
		for _ni := 1 to len(aHeader)
		
			_uValor := ""
			
			if aHeader[_ni,8] == "D" // Trata campos data
				_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
			elseif aHeader[_ni,8] == "N" // Trata campos numericos
				_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
			elseif aHeader[_ni,8] == "C" // Trata campos caracter
				_uValor := &(_cAlias + "->" + aHeader[_ni,2])
			endif

			if _ni <> len(aHeader)
				fWrite(nHandle, _uValor + ";" )
			endif
			
		next _ni

		fWrite(nHandle, cCrLf )
		
		(_cAlias)->(dbskip())
		
	enddo
	
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert("Falha na criaÁ„o do arquivo") 
Endif	

(_cAlias)->(dbclearfil())

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AbreArq   ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Abre os arquivos necessarios                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function AbreArq()
local aStru 	:= {}
local _dData
local _nDias	:= 1
local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("N„o foi possÌvel abrir o arquivo PFIN01.XLS pois ele pode estar aberto por outro usu·rio.")
	return(.F.)
endif

_cCpoAtu := "D" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","") // Primeiro campo que sera criado
//msginfo( _cCpoAtu )
if _nDiasPer == 1 // Se for diario, grava a data
	aadd(_aLegPer , dtoc(DataValida(_dDataIni),"dd/mm/yy"))
else // Senao grava dd/mm a dd/mm
	aadd(_aLegPer , left(dtoc(DataValida(_dDataIni),"dd/mm/yy"),5) + " a ")
endif
for _dData := _dDataIni to _dDataFim step 1 // Monta campos com as datas
	
	if _dData == (_dData) // Apenas dias uteis
		
		if _nDias > _nDiasPer // Se ja acumulou mais que o necessario
			if _nDiasPer == 1 // Se for diario, grava a data
				aadd(_aLegPer , dtoc(_dData,"dd/mm/yy")) // Grava o dia como label do campo
			else // Grava a data inicial no campo
				_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),5)
				aadd(_aLegPer , left(dtoc(_dData,"dd/mm/yy"),5) + " a ")
			endif
			
			_cCpoAtu 	:= "D" +	strtran(dtoc(_dData,"dd/mm/yy"),"/","") // gera o nome do campo
			_nDias 		:= 1 // reinicia o contador
		endif
		
		_nDias++
		
		aadd(_aDatas , {_dData, _cCpoAtu})
		
		if ascan(_aCpos , _cCpoAtu) == 0
			aadd(_aCpos , _cCpoAtu)
		endif
		
	endif
	
next _dData

_nCampos := len(_aCpos)

if _nDiasPer <> 1
	_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),5)
endif

// monta arquivo analitico
aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"BANCO"		,"C",03,0}) // Banco
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Item Conta
aAdd(aStru,{"CLIFOR"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"NCLIFOR"	,"C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"LOJA"		,"C",02,0}) // Loja
aAdd(aStru,{"PREFIXO"	,"C",03,0}) // Prefixo
aAdd(aStru,{"NTITULO"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"PARCELA"	,"C",01,0}) // Parcela
aAdd(aStru,{"TIPOD"		,"C",03,0}) // Tipo
aAdd(aStru,{"HISTORICO"	,"C",100,0}) // Historico
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RECPAG"	,"C",01,0}) // (R)eceber ou (P)agar
aAdd(aStru,{"TIPO"		,"C",01,0}) // Tipo - (P)revisto ou (R)ealizado
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"NATUREZA"	,"C",10,0}) // Codigo da Natureza
aAdd(aStru,{"DESC_NAT"	,"C",30,0}) // Descricao da Natureza
aAdd(aStru,{"GRUPONAT"	,"C",10,0}) // Grupos de Natureza
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"DATAMOV2"	,"D",08,0}) // Data de movimentacao

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)

aStru := {}
aAdd(aStru,{"GRUPO"		,"C",10,0}) // Codigo da Natureza
aAdd(aStru,{"DESCRICAO"	,"C",30,0}) // Descricao da Natureza
for _ni := 1 to len(_aCpos) // Monta campos com as datas
	aAdd(aStru,{_aCpos[_ni] ,"N",15,2}) // Valor do movimento no dia
next _dData
aAdd(aStru,{"TOTAL"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao
aAdd(aStru,{"GRUPOSUP"	,"C",10,0}) // Codigo do grupo superior

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on ORDEM to &(cArqTrb2+"2")
index on GRUPO+DESCRICAO to &(cArqTrb2+"1")
set index to &(cArqTrb2+"1")

return(.T.)

//**********************************************************************

Static Function zExpAnalitico()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpAnalitico.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do tÌtulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Fluxo de caixa - AnalÌtico") 
        //Criando a Tabela
        oFWMsExcel:AddTable("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico")
        
        aAdd(aColunas, "Data")									// 1 Data
        aAdd(aColunas, "Banco")									// 2 Banco
        aAdd(aColunas, "Item Conta")							// 3 Item Conta
        aAdd(aColunas, "Prefixo")								// 4 Prefixo
        aAdd(aColunas, "No.TÌtulo/OC")							// 5 No.Titulo/OC
        aAdd(aColunas, "Parcela")								// 6 Parcela
        aAdd(aColunas, "Tipo")									// 7 Tipo
        aAdd(aColunas, "Natureza")								// 8 Natureza
        aAdd(aColunas, "DescriÁ„o")								// 9 DescriÁ„o Natureza
        aAdd(aColunas, "Cod.Cli./For.")							// 10 Codigo Cliente / Fornecedor
        aAdd(aColunas, "Cliente/Fornecedor")					// 11 Cliente / Fornecedor
        aAdd(aColunas, "Loja")									// 12 Loja
        aAdd(aColunas, "Valor")									// 13 Valor
        aAdd(aColunas, "HistÛrico")								// 13 HistÛrico
        aAdd(aColunas, "Origem")								// 14 Origem
                
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Data",2,4)					// 1 Data
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Banco",1,2)					// 2 Banco
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Item Conta",1,2)			// 3 Item Conta
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Prefixo",1,2)				// 4 Prefixo
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "No.TÌtulo/OC",1,2)			// 5 No.Titulo/OC
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Parcela",1,2)				// 6 Parcela
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Tipo",1,2)					// 7 Tipo
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Natureza",1,2)				// 8 Natureza
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "DescriÁ„o",1,2)				// 9 DescriÁ„o
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Cod.Cli./For.",1,2)			// 10 Codigo Cliente / Fornecedor
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Cliente/Fornecedor",1,2)	// 11 Cliente / Fornecedor
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Loja",1,2)					// 12 Loja
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Valor",1,2)					// 13 Valor
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "HistÛrico",1,2)					// 13 Valor
        oFWMsExcel:AddColumn("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , "Origem",1,2)				// 14 Origem
           
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->DATAMOV
        	aLinhaAux[2] := TRB1->BANCO
        	aLinhaAux[3] := TRB1->ITEMCONTA
        	aLinhaAux[4] := TRB1->PREFIXO
        	aLinhaAux[5] := TRB1->NTITULO
        	aLinhaAux[6] := TRB1->PARCELA
        	aLinhaAux[7] := TRB1->TIPOD
        	aLinhaAux[8] := TRB1->NATUREZA
        	aLinhaAux[9] := TRB1->DESC_NAT
        	aLinhaAux[10] := TRB1->CLIFOR
        	aLinhaAux[11] := TRB1->NCLIFOR
        	aLinhaAux[12] := TRB1->LOJA
        	aLinhaAux[13] := TRB1->VALOR
        	aLinhaAux[14] := TRB1->HISTORICO
        	aLinhaAux[15] := TRB1->ORIGEM
           	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        		
        		oFWMsExcel:AddRow("Fluxo de caixa - AnalÌtico","Fluxo de caixa - AnalÌtico" , aLinhaAux)
        	//endif
            TRB1->(DbSkip())

        EndDo

        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             	//Abre uma nova conex„o com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)                 	//Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

//**********************************************************************

//**********************************************************************
Static Function EditReg()
    Local aArea       := GetArea()
    Local aAreaC7     := SC7->(GetArea())
    Local aAreaE2     := SE2->(GetArea())
    Local aAreaE1     := SE1->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := alltrim(TRB1->NTITULO)
    Local cClifor	  := alltrim(TRB1->CLIFOR)
    Local cLoja		  := alltrim(TRB1->LOJA)
    Local cParcela	  := alltrim(TRB1->PARCELA)
    Local dData		  := DTOS(TRB1->DATAMOV)
    Local cConsSE2	  := cClifor+cTitulo+cParcela
    Local cConsSE1	  := cClifor+cTitulo+cParcela
    Local cOrigem	  := alltrim(TRB1->ORIGEM)
   
    Private cCadastro 
    
    if alltrim(TRB1->GRUPONAT) == "0.00.09" .OR. alltrim(TRB1->GRUPONAT) == "0.00.10"
    	dData		  := DTOS(TRB1->DATAMOV2)
    endif
    
    IF cOrigem == "OC"  
    	
    	cCadastro := "AlteraÁ„o Ordem de Compra"
    
	    DbSelectArea("SC7")
	    SC7->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	    SC7->(DbGoTop())
	     
	    //Se conseguir posicionar no produto
	    If SC7->(DbSeek(xFilial('SC7')+cTitulo))
	    	
	        nOpcao := fAltRegSC7()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "AtenÁ„o")
	        EndIf
	       
	    EndIf
	ENDIF
	
	IF cOrigem == "CP"  
		cCadastro := "AlteraÁ„o Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB1->NTITULO+TRB1->CLIFOR+dData+TRB1->LOJA) )
			//nOpcao := AxAltera("SE2", SE2->(RecNo()), 4)
	        nOpcao := zAltRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "AtenÁ„o")
	            MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	       
	        EndIf
	    endif
	ENDIF
		
	IF cOrigem == "CR"  

		cCadastro := "AlteraÁ„o Contas a Receber"
	
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
	    SE1->(DbGoTop())
	    
	    //Se conseguir posicionar no produto
	    If SE1->(DbSeek(xFilial("SE1")+TRB1->NTITULO+TRB1->CLIFOR+dData+TRB1->LOJA ))
	       nOpcao := fAltRegSE1()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "AtenÁ„o")
	            MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	        EndIf
	    EndIf
	    
	ENDIF
	
	IF cOrigem $ "MB/SB"  
		 MsgInfo("Registro n„o pode ser alterado...", "AtenÁ„o")
	ENDIF
     
   
    RestArea(aAreaC7)
    RestArea(aAreaE2)
    RestArea(aAreaE1)
    RestArea(aArea)
Return

//**********************************************************************
// AlteraÁ„o Ordem de Compra


static Function fAltRegSC7()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SC7->C7_NUM
Local oGet2
Local cGet2 := Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA, "A2_NREDUZ")
Local oGet3
Local dVencto := SC7->C7_DATPRF
Local oGet4
Local oGet5	
Local oGet6	

Local nValor := 0
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

If SC7->( dbSeek(xFilial("SC7")+cGet1) )
	While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cGet1
		nValor += SC7->C7_TOTAL + ((SC7->C7_IPI/100) * SC7->C7_TOTAL)
		SC7->( dbSkip() )
	enddo
EndIf


  DEFINE MSDIALOG _oDlg TITLE "Altera Ordem de Compra" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 179, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Numero OC" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Data Entrega" SIZE 050, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 063 SAY oSay4 PROMPT "Total OC " SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
   	@ 049, 061 MSGET oGet2 VAR  Transform(nValor,"@E 99,999,999.99") When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 073, 049 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 097 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	
  	//SE1->E1_VENCTO 	:= dVencto
  	If SC7->( dbSeek(xFilial("SC7")+cGet1) )
  		
  		While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cGet1
  			Reclock("SC7",.F.)
		  	SC7->C7_DATPRF := DataValida(dVencto,.T.) //Proximo dia ˙til
		  	MsUnlock()
		  	SC7->( dbSkip() )
		  	
		enddo
		
	EndIf
  	
  Endif

   
  
Return _nOpc

// AlteraÁ„o registro Contas a Receber
static Function fAltRegSE1()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SE1->E1_NUM
Local oGet2
Local cGet2 := Posicione("SA1",1,xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_NREDUZ")
Local oGet3
Local dVencto := SE1->E1_VENCREA
Local oGet4
Local oGet5	:=  SE1->E1_TIPO
Local oGet6	:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE1->E1_NATUREZ), "ED_XGRUPO")
Local nValor := SE1->E1_VALOR
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Altera TÌtulo" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 179, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Titulo" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Cliente" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Vencimento" SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 063 SAY oSay4 PROMPT "Valor" SIZE 018, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    if alltrim(oGet5) <> "PR"
    	@ 049, 061 MSGET oGet2 VAR  Transform(nValor,"@E 99,999,999.99") When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    else
    	@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE1","E1_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    endif
    @ 073, 049 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 097 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE1",.F.)
  	//SE1->E1_VENCTO 	:= dVencto
  	SE1->E1_VENCREA := DataValida(dVencto,.T.) //Proximo dia ˙til
  	SE1->E1_VALOR	:= nValor
  	SE1->E1_SALDO	:= nValor
  	MsUnlock()
  Endif
  
	Reclock("TRB1",.F.)
	if alltrim(oGet5) <> "PR"
		TRB1->DATAMOV := dVencto
		TRB1->DATAMOV2 := dVencto
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
	else
		TRB1->DATAMOV := dVencto
		TRB1->DATAMOV2 := dVencto
		TRB1->VALOR := -nValor
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
	endif
  MsUnlock()
  
Return _nOpc

Static function zAtualizar()

	DbSelectArea("TRB1")
	
	
	cFiltra := " alltrim(ORIGEM) == 'OC'" 
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB1->(dbgotop())
	while TRB1->( ! EOF() )
		if TRB1->ORIGEM == "OC"
			RecLock("TRB1",.F.)
			dbdelete()
			MsUnlock()
		endif
		TRB1->( dbSkip() )
	enddo
	
	MSAguarde({|| PFIN01PC02()},"Ordem de compra")
	
	DbSelectArea("TRB2")
	zap
	MSAguarde({||PFIN01SINT()},"Atualizando arquivo sintÈtico.")
	//MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	
	TRB2->(dbgotop())
	
	
	
	
Return nil

/*
// AlteraÁ„o registro Contas a Pagar

*/

static function zAltRegSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SE2->E2_NUM
Local oGet2
Local cGet2 := Posicione("SA2",1,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NREDUZ")
Local oGet3
Local oFornece := SE2->E2_FORNECE
Local oGet7 
Local oGet8 := SE2->E2_LOJA
Local dVencto := SE2->E2_VENCREA
Local oGet4
Local oGet5	:=  SE2->E2_TIPO
Local oGet6	:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE2->E2_NATUREZ), "ED_XGRUPO")
Local nValor := SE2->E2_VALOR
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Altera TÌtulo" FROM 000, 000  TO 220, 400 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 184, 098 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 179, 096 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 003, 006 SAY oSay1 PROMPT "Titulo" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 012, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    
    if alltrim(oGet5) <> "PR"
	    @ 027, 006 SAY oSay7 PROMPT "Codigo" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
	    @ 036, 004 MSGET oGet7 VAR oFornece When .F. SIZE 048, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
	else
		@ 027, 006 SAY oSay7 PROMPT "Codigo" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
	    @ 036, 004 MSGET oGet7 VAR oFornece Picture "@!" Pixel F3 "SA2" SIZE 048, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
	   
	endif
    
    @ 027, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 036, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    
    @ 053, 006 SAY oSay3 PROMPT "Vencimento" SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 062, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
       
    @ 053, 063 SAY oSay4 PROMPT "Valor" SIZE 018, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    if alltrim(oGet5) <> "PR"
    	@ 062, 061 MSGET oGet2 VAR Transform(nValor,"@E 99,999,999.99") When .F. SIZE 113, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    else
    	@ 062, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    endif
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 082, 049 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 082, 097 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE2",.F.)
  	//SE2->E2_VENCTO 	:= dVencto
  	SE2->E2_VENCREA := DataValida(dVencto,.T.) //Proximo dia ˙til
  	SE2->E2_VALOR	:= nValor
  	SE2->E2_VLCRUZ	:= nValor
  	SE2->E2_SALDO	:= nValor
  	if alltrim(oGet5) = "PR"
  		SE2->E2_FORNECE	:= oFornece
  		SE2->E2_NOMFOR	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_NREDUZ")
  		SE2->E2_LOJA	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_LOJA")
  	endif	
  	MsUnlock()
  Endif
  
	Reclock("TRB1",.F.)
	if alltrim(oGet5) <> "PR"
		TRB1->DATAMOV 	:= dVencto
		TRB1->DATAMOV2 	:= dVencto
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
		
	else
		TRB1->DATAMOV 	:= dVencto
		TRB1->DATAMOV2 	:= dVencto
		TRB1->VALOR 	:= -nValor
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
		TRB1->CLIFOR	:= oFornece
		TRB1->NCLIFOR	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_NREDUZ")
		TRB1->LOJA		:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_LOJA")
		
	endif
	MsUnlock()
  
  
Return _nOpc

//**********************************************************************


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ RETGRUPO ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Retorna o grupo de uma determinada natureza                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function RetGrupo(_cNaturez)
local _cRet := ""

if empty(_cNaturez)
	_cRet := space(10)
else
	SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
	if SED->(dbseek(xFilial("SED")+_cNaturez))
		_cRet := SED->ED_XGRUPO
	endif
	
endif

return(_cRet)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ RETCAMPO ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Retorna o grupo de uma determinada natureza                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function RetCampo(_dData)
local _cRet := ""

_nPos := Ascan(_aDatas , { |x| x[1] == _dData })

if _nPos > 0
	_cRet := _aDatas[_nPos,2]
endif

return(_cRet)
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥VLDPARAM  ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Valida os parametros digitados                             ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function VldParam()

if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos par‚metros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de inÌcio do processamento deve ser menor ou igual a data de referÍncia.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de referÍncia.")
	return(.F.)
endif
/*
if Empty(_ItemICIni) // Item Conta
	msgstop("Informe Item Conta para processamento.")
	return(.F.)
endif
*/
return(.T.)
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ABREDOC   ∫Autor  ≥Marcos Zanetti G&Z  ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Abre o XLS com os dados do fluxo de caixa                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function AbreDoc( _cFile )
LOCAL cDrive     := ""
LOCAL cDir       := ""

cTempPath := "C:\"
cPathTerm := cTempPath + _cFile

ferase(cTempPath + _cFile)

If CpyS2T( "\SIGAADV\"+_cFile, cTempPath, .T. )
	SplitPath(cPathTerm, @cDrive, @cDir )
	cDir := Alltrim(cDrive) + Alltrim(cDir)
	nRet := ShellExecute( "Open" , cPathTerm ,"", cDir , 3 )
else
	MsgStop("Ocorreram problemas na cÛpia do arquivo.")
endif

return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥VALIDPERG ∫Autor  ≥Marcos Zanetti GZ   ∫ Data ≥  01/11/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Cria as perguntas do SX1                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static function VALIDPERG()
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Data Inicial"			,"Data Inicial"			,"Data Inicial"			,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","",{"Data de inicio do processamento"})
PutSX1(cPerg,"02","Data Final"				,"Data Final"			,"Data Final"			,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","",{"Data final do processamento"})
PutSX1(cPerg,"03","Data de Referencia"		,"Data de Referencia"	,"Data de Referencia"	,"mv_ch3","D",08,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","",{"Data de referencia do processamento","movimentos apos essa data sao","previstos e o restante, realizados"})
PutSX1(cPerg,"04","Considera Ped. Compra" 	,"Considera Ped. Compra","Considera Ped. Compra","mv_ch4","N",01,0,0,"C","",""		,"",,"mv_par04","Sim","","","","Nao","","","","","","","","","","","")
//PutSX1(cPerg,"05","Considera Ped. Venda" 	,"Considera Ped. Venda"	,"Considera Ped. Venda"	,"mv_ch5","N",01,0,0,"C","",""		,"",,"mv_par05","Sim","","","","Nao","","","","","","","","","","","")
//PutSX1(cPerg,"06","Considera Vencidos"		,"Considera Vencidos"	,"Considera Vencidos"	,"mv_ch6","N",01,0,0,"C","",""		,"",,"mv_par06","A Receber","","","","A Pagar","","","Ambos","","","Nenhum","","","","","")
PutSX1(cPerg,"05","Dias por periodo"		,"Dias por periodo"		,"Dias por periodo"		,"mv_ch5","N",02,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","",{"Indica quantos dias ser„o considerados","por perÌodo (coluna) do relatÛrio"})
//PutSX1(cPerg,"08","Seleciona Bancos"		,"Seleciona Bancos"		,"Seleciona Bancos"		,"mv_ch8","N",01,0,0,"C","",""		,"",,"mv_par08","Sim","","","","Nao","","","","","","","","","","","")
//PutSX1(cPerg,"09","Considera Previsoes"	    ,"Considera Previsoes"	,"Considera Previsoes"	,"mv_ch9","N",01,0,0,"C","",""		,"",,"mv_par09","Sim","","","","Nao","","","","","","","","","","","")
//putSx1(cPerg, "06", "Item Conta de ?"	  , "", "", "mv_ch6", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par06")
//putSx1(cPerg, "07", "Item Conta atÈ?"	  , "", "", "mv_ch7", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par07")
return