 #include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"

//����������������������������������������������������������������������������// 
//                        Low Intensity colors 
//����������������������������������������������������������������������������// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//����������������������������������������������������������������������������// 
//                      High Intensity Colors 
//����������������������������������������������������������������������������// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01    �Autor  �Marcos Zanetti GZ   � Data �  19/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera arquivo de fluxo de caixa                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico 		                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function PFIN01()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Gera��o de planilha de Fluxo de Caixa"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"PFIN01"
private _cArq	:= 	"PFIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilSE5:= xFilial("SE5")

private _aDatas	:= {} // Matriz no formato [ data , campo ]
private _aLegPer:= {} // legenda dos periodos
private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
private _nSaldoIni 	:= 0
Private _aRegSimul	:= {} // matriz com os recnos do TRB1 e do SZ3, respectivamente

private cArqTrb1 := CriaTrab(NIL,.F.) //"PFIN011"
private cArqTrb2 := CriaTrab(NIL,.F.) //"PFIN012"
private cArqTrb3 := CriaTrab(NIL,.F.) //"PFIN013"
             
Private _aGrpSint:= {}

ValidPerg()

AADD(aSays,"Este programa gera planilha com os dados para o fluxo de caixa de acordo com os ")
AADD(aSays,"par�metros fornecidos pelo usu�rio. O arquivo gerado pode ser aberto de forma ")
AADD(aSays,"autom�tica pelo Excel.")
AADD(aSays,"Movimentos ap�s a data de refer�ncia s�o considerados previstos e anteriores ")
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
	//_lVencRec	:= mv_par06 == 1 .or. mv_par06 == 3 // Considera Vencidos a receber
	//_lVencPag	:= mv_par06 == 2 .or. mv_par06 == 3 // Considera Vencidos a pagar
	_nDiasPer	:= max(1 , mv_par05) // Quantidade de dias por periodo (minimo de 1 dia)
	_lSelBancos	:=  1 // Seleciona Bancos
	
	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif
	
	dDataBase := _dDtRef // muda a database para a data de referencia, para calculo de saldos
	
	MSAguarde({||ProcBco(_lSelBancos)},"Processando Bancos") // Calcula saldos bancarios iniciais
	
	//MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
	MSAguarde({||PFIN01REAL()},"Fluxo de caixa Realizado")
	
	// Processa titulos em aberto
	MSAguarde({|| PFIN01TIT()},"T�tulos Contas a Receber")
	
	MSAguarde({|| PFIN01SE2()},"T�tulos Conta a Pagar")
	
	MSAguarde({|| PFIN01BC()},"Saldos Bancarios")
	
	if _lPedCompra
		// Processa os pedidos de compras
		MSAguarde({|| PFIN01PC()},"Ordem de compra")
	endif
	

	MSAguarde({||PFIN01SINT()},"Gerando arquivo sint�tico.") // *** Funcao de gravacao do arquivo sintetico ***
	
	MontaTela()
	
	dDataBase := _cOldData // restaura a database
	
	TRB1->(dbclosearea())
	TRB11->(dbclosearea())
	TRB2->(dbclosearea())
	BANCOS->(dbclosearea())
	
endif


return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PROCBCO   �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o saldo inicial dos bancos e define bancos usados ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function ProcBco(_lSelBco)
Local cMarca	 := GetMark()
Local aCampos	:= {	 {"A6_OK"        ,"C",02,0 },;
{"A6_COD"     ,"C",03,0 },;
{"A6_AGENCIA" ,"C",05,0 },;
{"A6_NUMCON"  ,"C",10,0 },;
{"A6_NREDUZ"  ,"C",15,0 },;
{"A6_SALATU"  ,"N",17,2 },;
{"A6_SALATU2" ,"N",17,2 },;
{"A6_OK2"  	,"C",02,0 } }

Local aCampos2 := {	 {"A6_OK",,"  ",""},;
{"A6_COD"     ,,"Banco",""}   ,;
{"A6_AGENCIA" ,,"Agencia",""} ,;
{"A6_NUMCON"  ,,"Conta",""}   ,;
{"A6_NREDUZ"  ,,"Nome",""}    ,;
{"A6_SALATU"  ,,"Saldo Anterior","@E 9,999,999,999.99"},;
{"A6_SALATU2"  ,,"Saldo Dia","@E 9,999,999,999.99"},;
{"A6_OK2",,"",""}}

Local oDlg
Local _cQuery	:= ""
local lInverte	:= .F.
local dDtini

Local _lE8SalReco := SE8->(fieldpos("E8_SALRECO")) > 0

Local _nSaldo := 0
Local _nSaldo2 := 0
Local x := 1

SA6->(dbsetorder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

dbcreate(cArqTrb3,aCampos)
dbUseArea(.T.,,cArqTrb3,"BANCOS",.F.,.F.)
IndRegua("BANCOS",CriaTrab(NIL,.F.),"A6_COD+A6_AGENCIA+A6_NUMCON",,,"Indexando Bancos")

SA6->(dbgotop())
while SA6->(!eof())
	
	if SA6->A6_COD $ '115/117/502' //if SA6->A6_COD $ '115/117'
		SA6->(dbSkip())
	end if
	
	//******************************** SALDO ANTERIOR
	SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))
	_nSaldo := SE8->E8_SALATUA
	dDtini 	:= Dtos(SE8->E8_DTSALAT)
	
		//while SE8->E8_SALATUA == 0
		if dDtini <> Dtos(_dDataIni)
			SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))	
			SE8->(dbSkip(-1))	
		else
			SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))	
			//SE8->(dbSkip(-1))	
		end if
	SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))
	SE8->(dbSkip(-1))
	
	
	if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
		SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == SA6->(A6_COD + A6_AGENCIA + A6_NUMCON)
		_nSaldo := SE8->E8_SALATUA 
	else
		_nSaldo := 0
	endif

	//******************************** SALDO ATUAL
	SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))
	_nSaldo2 := SE8->E8_SALATUA
	dDtini 	:= Dtos(SE8->E8_DTSALAT)
	
		//while SE8->E8_SALATUA == 0
		if dDtini <> Dtos(_dDataIni)
			SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))	
			SE8->(dbSkip(-1))
		else
			SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))	
			SE8->(dbSkip(-1))	
		end if
	SE8->(dbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + Dtos(_dDataIni),.T.))
	//SE8->(dbSkip(-1))
	
	

	if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
		SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == SA6->(A6_COD + A6_AGENCIA + A6_NUMCON)
		_nSaldo2 := SE8->E8_SALATUA 
	else
		_nSaldo2 := _nSaldo
	endif
	//***************************************
	
	RecLock("BANCOS",.T.)
	BANCOS->A6_COD 		:= SA6->A6_COD
	BANCOS->A6_AGENCIA 	:= SA6->A6_AGENCIA
	BANCOS->A6_NUMCON 	:= SA6->A6_NUMCON
	BANCOS->A6_NREDUZ 	:= SA6->A6_NREDUZ
	BANCOS->A6_SALATU 	:= _nSaldo
	BANCOS->A6_SALATU2 	:= _nSaldo2
	if SA6->A6_FLUXCAI <> 'N'
		BANCOS->A6_OK := cMarca
	endif
	BANCOS->A6_OK2 		:= cMarca
	MsUnlock()
	SA6->(dbskip())
enddo


if _lSelBco
	
	BANCOS->( dbGotop() )
	DEFINE MSDIALOG oDlg TITLE "Selecione os Bancos que dever�o ser considerados" From 009,000 To 030,063 OF oMainWnd
	oMark := MsSelect():New("BANCOS","A6_OK","",aCampos2,@lInverte,@cMarca,{20,2,140,248})
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2}) CENTERED
	
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o fluxo de caixa realizado                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01REAL()
	local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local _cFilSE5 := xFilial("SE5")
Local _cFilSED := xFilial("SED")
Local _cFilSEF := xFilial("SEF")
local _cNatureza

local cGrpFluxo := ""

SE2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
SEF->(dbsetorder(1)) // EF_FILIAL + EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM
SE5->(dbsetorder(1))



ChkFile("SE5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"DTOS(E5_DTDISPO)+E5_NATUREZ",,,"Selecionando Registros...")

ChkFile("SE5",.F.,"SE5_EC") // Alias para estorno de cheques
IndRegua("SE5_EC",CriaTrab(NIL,.F.),"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

SE5->(dbgotop())
QUERY->(dbseek(dtos(_dDataIni),.T.))
while QUERY->(!eof()) .and. dtos(QUERY->E5_DATA) <= dtos(_dDtRef) .and. QUERY->E5_FILIAL == _cFilSE5
	
	if BANCOS->(!dbseek(QUERY->(E5_BANCO + E5_AGENCIA + E5_CONTA))) .or. empty(BANCOS->A6_OK)
		QUERY->(dbskip())
		Loop
	endif

	
	if  (QUERY->E5_BANCO $ '117') .or. ;
		(QUERY->E5_VENCTO > QUERY->E5_DTDISPO) .or. ;
		(right(alltrim(QUERY->E5_NUMCHEQ),1) == '*') .or. ;
		(QUERY->E5_SITUACA == 'C') .or. ;
		(QUERY->E5_VALOR == 0) .or. ;
		(QUERY->E5_TIPODOC $ 'DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA') .or. ;
		(QUERY->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. Empty(QUERY->E5_NUMCHEQ) .and. !(QUERY->E5_TIPODOC $ "TR#TE")) 	.or. ;
		(QUERY->E5_TIPODOC $ "TR/TE" .and. Empty(QUERY->E5_NUMERO) .and. !(QUERY->E5_MOEDA $ "R$/DO/TB/TC/CH/EM/PE")) 	.or. ;
		(QUERY->E5_TIPODOC $ "TR/TE" .and. (Substr(QUERY->E5_NUMCHEQ,1,1)=="*" .or. Substr(QUERY->E5_DOCUMEN,1,1) == "*" )) .or. ;
		(QUERY->E5_MOEDA == "CH" .and. IsCaixaLoja(QUERY->E5_BANCO)) 	.or. ;
		(!Empty( QUERY->E5_MOTBX ) .and. !MovBcoBx( QUERY->E5_MOTBX ))	.or. ;
		(left(QUERY->E5_NUMCHEQ,1) == "*"  .or. left(QUERY->E5_DOCUMEN,1) == "*") .or. ;
		QUERY->E5_TIPODOC == "EC"
		QUERY->(dbskip())
		Loop
		
	endif

	
	if SED->(dbseek(_cFilSED+QUERY->E5_NATUREZ))
		_cNatureza := SED->ED_DESCRIC
	else
		_cNatureza := "NATUREZA NAO DEFINIDA"
	endif
	/*
	if  ALLTRIM(QUERY->E5_NATUREZ) == '1.25.00' .and. ALLTRIM(QUERY->E5_TIPODOC) == 'TR' .or.  ;
		ALLTRIM(QUERY->E5_NATUREZ) == '2.24.00' .or. // alltrim(QUERY->E5_TIPODOC) <> "CH" .or.
		(QUERY->E5_VENCTO > QUERY->E5_DATA)
	*/
	
	if alltrim(QUERY->E5_TIPODOC) <> "CH"	
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= DataValida(QUERY->E5_DTDISPO)
		TRB1->VENCTO	:= DataValida(QUERY->E5_DTDISPO)
		TRB1->EMISSAO	:= DataValida(QUERY->E5_DTDISPO)
		TRB1->NATUREZA	:= QUERY->E5_NATUREZ
		TRB1->DESC_NAT	:= _cNatureza
		TRB1->HISTORICO	:= QUERY->E5_HISTOR // alltrim(QUERY->E5_XXIC) + " " + alltrim(QUERY->E5_BENEF) + " " + 
		TRB1->VALOR		:= iif(QUERY->E5_RECPAG == "R" , QUERY->E5_VALOR , -QUERY->E5_VALOR)
		TRB1->RECPAG	:= QUERY->E5_RECPAG
		TRB1->TIPO		:= "R"
		TRB1->ORIGEM	:= "MB"
		TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
		TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
		TRB1->BANCO		:= QUERY->E5_BANCO
		TRB1->ITEMCONTA	:= QUERY->E5_XXIC
		TRB1->CLIFOR	:= QUERY->E5_CLIFOR
		TRB1->NCLIFOR	:= QUERY->E5_BENEF
		TRB1->PREFIXO	:= alltrim(QUERY->E5_BENEF)
		TRB1->NTITULO	:= QUERY->E5_NUMERO
		TRB1->PARCELA	:= ""
		TRB1->TIPOD		:= ""
		MsUnlock()
		
	else // Se for um cheque aglutinado - pesquisa pelos titulos pagos no cheque
		
		
		_nRegQry := 0
		
		if SE5_EC->(dbseek(QUERY->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))
			while SE5_EC->(!eof()) .and. QUERY->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ) == SE5_EC->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
				if SE5_EC->E5_SEQ == QUERY->E5_SEQ .and. SE5_EC->E5_TIPODOC = 'EC' .and. SE5_EC->(recno()) > QUERY->(recno())
					_nRegQry++
				endif
				SE5_EC->(dbskip())
			enddo
		endif
		
		if _nRegQry > 0
			QUERY->(dbskip())
			Loop
		endif
		
		_cChave := _cFilSEF+QUERY->E5_BANCO+QUERY->E5_AGENCIA+QUERY->E5_CONTA+QUERY->E5_NUMCHEQ
		
		if SEF->(dbseek(_cChave))
			
			while SEF->(!eof()) .and. SEF->EF_FILIAL + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM == _cChave
				
				if !empty(SEF->EF_TITULO) .and. SE2->(dbseek(_cFilSE2+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
					
					if SED->(dbseek(_cFilSED+SE2->E2_NATUREZ))
						_cNatureza := SED->ED_DESCRIC
					else
						_cNatureza := "NATUREZA NAO DEFINIDA"
					endif
					
					RecLock("TRB1",.T.)
					TRB1->DATAMOV	:= DataValida(QUERY->E5_DTDISPO)
					TRB1->VENCTO	:= DataValida(QUERY->E5_DTDISPO)
					TRB1->EMISSAO	:= DataValida(QUERY->E5_DTDISPO)
					TRB1->NATUREZA	:= SE2->E2_NATUREZ
					TRB1->DESC_NAT	:= _cNatureza //GetAdvFVal("SED","ED_DESCRIC",_cFilSED+SE2->E2_NATUREZ,1,"NATUREZA NAO DEFINIDA")
					TRB1->HISTORICO	:= QUERY->E5_HISTOR
					TRB1->VALOR		:= iif(QUERY->E5_RECPAG == "R" , SEF->EF_VALOR , -SEF->EF_VALOR)
					TRB1->RECPAG	:= QUERY->E5_RECPAG
					TRB1->TIPO		:= "R"
					TRB1->ORIGEM	:= "MB"
					
					if ! alltrim(QUERY->E2_XXIC) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES") .OR. alltrim(QUERY->E2_XXIC) <> "" 
						cGrpFluxo := "2.0X.00"
					elseif alltrim(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00"
						cGrpFluxo := "6.2X.00"
					else
						cGrpFluxo := RetGrupo(TRB1->NATUREZA)
					endif
					
					TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
					TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
					TRB1->BANCO		:= QUERY->E5_BANCO
					TRB1->ITEMCONTA	:= QUERY->E5_XXIC
					TRB1->CLIFOR	:= QUERY->E5_CLIFOR
					TRB1->NCLIFOR	:= QUERY->E5_BENEF
					TRB1->PREFIXO	:= alltrim(QUERY->E5_BENEF)
					TRB1->NTITULO	:= QUERY->E5_NUMERO
					TRB1->PARCELA	:= SE2->E2_PARCELA
					TRB1->TIPOD		:= SE2->E2_TIPO
					MsUnlock()
					
				endif
				SEF->(dbskip())
				
			enddo
			
		endif
	
	endif
	
	QUERY->(dbskip())
	
enddo

QUERY->(dbclosearea())
SE5_EC->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01TIT �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa Titulos em aberto                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01TIT()
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


//oProcess:SetRegua2( ("QUERY")->(RecCount()) ) //Alimenta a segunda barra de progresso

///QUERY->(dbseek(_cFilSE1+iif(_lVencRec,"",dtos(_dDtRef)),.T.))
while QUERY->(!eof()) //.and. SE1->E1_FILIAL == _cFilSE1 .and. QUERY->E1_VENCREA <= _dDataFim

	//oProcess:IncRegua2("Processando Titulos")
	//oProcess:SetRegua2( ("QUERY")->(RecCount()) ) //Alimenta a segunda barra de progresso
	
	if 	substr(QUERY->E1_TIPO,3,1) == "-" .or. ;
		!(QUERY->E1_SALDO > 0 .OR. dtos(QUERY->E1_BAIXA) > dtos(_dDtRef)) .or. ;
		dtos(QUERY->E1_EMISSAO) > dtos(_dDataFim) .or. QUERY->E1_TIPO = "RA" .or. ALLTRIM(QUERY->E1_FLUXO) = "N"/////////////////////////////////////////////
		QUERY->(dbskip())
		loop
	endif
	
		
	
	if SED->(dbseek(_cFilSED+QUERY->E1_NATUREZ))
		_cNatureza := SED->ED_DESCRIC
	/*
	else
		_cNatureza := "NATUREZA NAO DEFINIDA"
		if _lNatFluxo .and. SED->ED_XFLUXO == "N"
			QUERY->(dbskip())
			loop
		endif
	*/
	endif
	
	_nSaldo :=_CalcSaldo("SE1", QUERY->(recno()))
	
	if _nSaldo <> 0
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= iif( dtos(QUERY->E1_VENCREA) < dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(QUERY->E1_VENCREA) ) //max(DataValida(QUERY->E1_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
		TRB1->VENCTO	:= QUERY->E1_VENCTO
		TRB1->EMISSAO	:= QUERY->E1_EMISSAO
		TRB1->NATUREZA	:= QUERY->E1_NATUREZ
		TRB1->DESC_NAT	:= _cNatureza
		TRB1->VALOR		:= _nSaldo
		TRB1->TIPO		:= "P"
		TRB1->RECPAG	:= "R"
		TRB1->ORIGEM	:= "CR"
		TRB1->HISTORICO	:= 	iif(!empty(QUERY->E1_HIST) , alltrim(QUERY->E1_HIST) ,"") + " " + ;
		iif( dtos(QUERY->E1_VENCREA) < dtos(DataValida(_dDtRef)) , " - Vencto.Real: " + dtoc(DataValida(QUERY->E1_VENCREA)) , "" )//QUERY->E1_HIST //alltrim(QUERY->E1_XXIC + " - " + QUERY->E1_NOMCLI + " Titulo:"  + QUERY->E1_NUM + " Parcela:" + QUERY->E1_PARCELA + " Tipo:" + QUERY->E1_TIPO) + ;
		//iif(!empty(QUERY->E1_HIST) , " - " + QUERY->E1_HIST ,"")
		TRB1->GRUPONAT 	:= iif( dtos(QUERY->E1_VENCREA) < dtos(_dDtRef) .and. empty(dtos(QUERY->E1_BAIXA)) .and. !empty(QUERY->E1_NATUREZ)  , "0.00.09" , RetGrupo(TRB1->NATUREZA) )//RetGrupo(TRB1->NATUREZA)
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
static function PFIN01SE2()

Local _cFilSE2 	:= xFilial("SE2")
Local _cFilSED 	:= xFilial("SED")
local _cQuery 	:= ""
local _nSaldo 	:= 0
local cGrpFluxo := ""


SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO

// TITULOS A PAGAR EM ABERTO
ChkFile("SE2",.F.,"QUERY") // Alias dos titulos a pagar
QUERY->(dbsetorder(3)) // E2_FILIAL + DTOS(E2_VENCREA) + E2_NOMFOR + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
//QUERY->(dbseek(_cFilSE2+dtos(_dDtRef),.T.))
QUERY->(dbGoTop())

//oProcess:SetRegua2( ("QUERY")->(RecCount()) ) //Alimenta a segunda barra de progresso
//oProcess:SetRegua2( ("QUERY")->(RecCount()) ) //Alimenta a segunda barra de progresso

while QUERY->(!eof()) //.and. SE2->E2_FILIAL == _cFilSE2 .and. QUERY->E2_VENCREA <= _dDataFim

	
	//oProcess:IncRegua2("Processando Titulos")

	//msginfo ( "Contas a pagar")
	if 	substr(QUERY->E2_TIPO,3,1) == "-" .or. ;
		!(QUERY->E2_SALDO > 0 .OR. dtos(QUERY->E2_BAIXA) > dtos(_dDtRef)) .or. ; 
		dtos(QUERY->E2_EMISSAO) > dtos(_dDataFim) .or. QUERY->E2_TIPO = "PA" 
		QUERY->(dbskip())
		loop
		//!(QUERY->E2_SALDO > 0 .OR. dtos(QUERY->E2_BAIXA) > dtos(_dDtRef)) .or. ; 
	endif
	
	
	if SED->(dbseek(_cFilSED+QUERY->E2_NATUREZ))
		_cNatureza := SED->ED_DESCRIC
	/*
	else
		_cNatureza := "NATUREZA NAO DEFINIDA"
		if _lNatFluxo .and. SED->ED_XFLUXO == "N"
			QUERY->(dbskip())
			loop
		endif
	*/
	endif

	_nSaldo :=_CalcSaldo("SE2", QUERY->(recno()))
	
	
	if _nSaldo <> 0
		RecLock("TRB1",.T.)
		
		TRB1->DATAMOV	:= iif( dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(QUERY->E2_VENCREA) ) // A data de previsao tem que ser, no minimo, a data de referencia
		TRB1->VENCTO	:= QUERY->E2_VENCTO
		TRB1->EMISSAO	:= QUERY->E2_EMISSAO
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		cGrpFluxo := RetGrupo(TRB1->NATUREZA)
		TRB1->DESC_NAT	:= POSICIONE("SED",1,XFILIAL("SED")+alltrim(QUERY->E2_NATUREZ),"ED_DESCRIC")//_cNatureza
		TRB1->VALOR		:= _nSaldo // QUERY->E2_SALDO //_nSaldo
		TRB1->TIPO		:= "P"
		TRB1->RECPAG	:= "P"
		TRB1->ORIGEM	:= "CP"
		TRB1->HISTORICO	:=  iif(!empty(QUERY->E2_HIST) , alltrim(QUERY->E2_HIST) ,"") + " " + ;
		iif( dtos(QUERY->E2_VENCREA) < dtos(DataValida(_dDtRef)) , " - Vencto.Real: " + dtoc(DataValida(QUERY->E2_VENCREA)) , "" )
		
		if dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) .and. empty(dtos(QUERY->E2_BAIXA)) .and. !empty(QUERY->E2_NATUREZ) .OR. ;
			QUERY->E2_SALDO > 0 .AND.  dtos(QUERY->E2_VENCREA) < dtos(_dDtRef)
			cGrpFluxo := "0.00.10"
		elseif ! alltrim(QUERY->E2_XXIC) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES") .AND. ;
				! empty(alltrim(QUERY->E2_XXIC)) .AND. ;
				 ! alltrim(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00" 
			cGrpFluxo := "2.0X.00"
		//elseif alltrim(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00"
			//cGrpFluxo := "6.2X.00"
		
		
		//else
			//cGrpFluxo := RetGrupo(TRB1->NATUREZA)
		endif 
		TRB1->GRUPONAT 	:= cGrpFluxo
		//TRB1->GRUPONAT 	:= iif( dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) .and. empty(dtos(QUERY->E2_BAIXA)) .and. !empty(QUERY->E2_NATUREZ) .OR. QUERY->E2_SALDO > 0 .AND.  dtos(QUERY->E2_VENCREA) < dtos(_dDtRef) , "0.00.10" , RetGrupo(TRB1->NATUREZA) ) //RetGrupo(TRB1->NATUREZA)
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01PREV�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa Previsoes do fluxo de caixa                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01PREV()
local _cQuery := ""
local _nSaldo := 0

SZS->(dbsetorder(2)) // Z3_FILIAL + dtos(Z3_DATA) + Z3_GRUPO

SZS->(dbseek(xFilial("SZS")+dtos(_dDtRef),.T.))
while SZS->(!eof()) .and. dtos(SZS->ZS_DATA) <= dtos(_dDataFim)
	
	RecLock("TRB1",.T.)
	TRB1->DATAMOV	:= SZS->ZS_DATA
	TRB1->DESC_NAT	:= "SIMULACAO"
	TRB1->HISTORICO	:= SZS->ZS_HIST
	TRB1->VALOR		:= iif(SZS->ZS_RECPAG == "P" , -(SZS->ZS_VALOR) , SZS->ZS_VALOR)
	TRB1->RECPAG	:= SZS->ZS_RECPAG
	TRB1->GRUPONAT 	:= SZS->ZS_GRUPO
	TRB1->CAMPO		:= RetCampo(SZS->ZS_DATA)
	TRB1->SIMULADO	:= "S"
	MsUnlock()
	
	aadd(_aRegSimul, {TRB1->(recno()), SZS->(recno())})
	
	SZS->(dbskip())
enddo

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_CalcSaldo�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula o saldo do titulo na data de referencia            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	dDatabase-1,,SE2->E2_LOJA)//_dDtRef,_dDtRef,SE2->E2_LOJA)
	
	dbselectarea("SE2")

	_nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,;
	dDatabase-1,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL) //_dDtRef,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL)

	if !(SE2->E2_TIPO $ (MV_CPNEG + "/" + MVPAGANT)) .OR. SE2->E2_TIPO == "PA"  // O normal de um titulo a pagar e ser negativo
		_nSaldo := -1 * _nSaldo
	endif
	
endif

return(_nSaldo)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01PC  �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa  Pedidos de compra                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01PC()
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
	
	_nValPC :=  (1+SE4->E4_ACRSFIN/100) * ((SC7->C7_QUANT-SC7->C7_QUJE)) * (SC7->C7_PRECO - SC7->C7_VLDESC) // (1+SE4->E4_ACRSFIN/100) * ((SC7->C7_QUANT-SC7->C7_QUJE)/SC7->C7_QUANT)
	
	_nValor := iif(str(SC7->C7_MOEDA,1,0) <> "1",xMoeda(_nValPC,SC7->C7_MOEDA,1,_dDtEnt) ,_nValPC)
	
	if SC7->C7_IPI > 0 .and. (!_lTES .or. SF4->F4_IPI <> "N")
		_nValIPI := (SC7->C7_IPI/100) * _nValor
		if _lTES .and. SF4->F4_BASEIPI > 0
			_nValIPI := (SF4->F4_BASEIPI/100)
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
			//_aVencimentos[_nPos,3] += _nValPC
			_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
		endif
		//msginfo( "2.." + cValToChar(_aParcelas[_nConta,2]) + " OC. " + alltrim(_aVencimentos[_nConta,4])  )
		//msginfo( "2.." + cValToChar(_aVencimentos[_nPos,3]) + " OC. " + alltrim(_aVencimentos[_nConta,4])  )
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
		TRB1->DATAMOV	:= iif( dtos(_aVencimentos[_nConta,1]) <= dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(_aVencimentos[_nConta,1]) ) //DataValida(_aVencimentos[_nConta,1])
		TRB1->VENCTO	:= iif( dtos(_aVencimentos[_nConta,1]) <= dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(_aVencimentos[_nConta,1]) ) //DataValida(_aVencimentos[_nConta,1])
		TRB1->EMISSAO	:= iif( dtos(_aVencimentos[_nConta,1]) <= dtos(_dDtRef) , DataValida(_dDtRef) , DataValida(_aVencimentos[_nConta,1]) ) //DataValida(_aVencimentos[_nConta,1])
		TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
		
		//cTipoCD := Posicione("SE4",1,xFilial("SE4") + Posicione("SC7",1,xFilial("SC7") + alltrim(_aVencimentos[_nConta,4]),"SC7->C7_COND")
		
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01PV  �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa  Pedidos de venda                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01PV()
local _cQuery 		:= ""
local _aVencimentos	:= {} // Matriz no formato {Data de vencimento, natureza ,valor, numero do pedido de compra}
local _aparcelas	:= {}
local _nValor       := 0
local _nValIPI      := 0
local _nPos			:= 0
local _nConta		:= 0
local _cFilSA1		:= xFilial("SA1")
local _cFilSB1		:= xFilial("SB1")
local _cFilSC5		:= xFilial("SC5")
local _cFilSC6		:= xFilial("SC6")
local _cFilSE4		:= xFilial("SE4")
local _cFilSED		:= xFilial("SED")
local _cFilSF4		:= xFilial("SF4")

SA1->(dbsetorder(1)) // A1_FILIAL + A1_COD + A1_LOJA
SB1->(dbsetorder(1)) // B1_FILIAL + B1_COD
SC5->(dbsetorder(1)) // C5_FILIAL + C5_NUM
SC6->(dbsetorder(1)) // C6_FILIAL + C6_NUM + C6_ITEM
SE4->(dbsetorder(1)) // E4_FILIAL + E4_CODIGO
SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
SF4->(dbsetorder(1)) // F4_FILIAL + F4_CODIGO

SC6->(dbseek(_cFilSC6))
while SC6->(!eof()) .and. SC6->C6_FILIAL == _cFilSC6
	
	if 	SC5->(!dbseek(SC6->C6_FILIAL + SC6->C6_NUM)) .or. SE4->(!dbseek(_cFilSE4+SC5->C5_CONDPAG)) .or. !SC5->C5_TIPO$"NCP" .or. ;
		SA1->(!dbseek(_cFilSA1+SC6->C6_CLI+SC6->C6_LOJA)) .or. SB1->(!dbseek(_cFilSB1+SC6->C6_PRODUTO)) .or. SF4->(!dbseek(_cFilSF4+SC6->C6_TES))
		SC6->(dbskip())
		loop
	endif
	
	_dDtEnt := max( _dDtRef, (DataValida(SC6->C6_ENTREG)) )
	
	_nValPV := (1+SE4->E4_ACRSFIN/100) * ((SC6->C6_QTDVEN-SC6->C6_QTDENT)/SC6->C6_QTDVEN) * SC6->C6_VALOR
	
	_nValor := iif(str(SC5->C5_MOEDA,1,0) <> "1",xMoeda(_nValPV,SC5->C5_MOEDA,1,_dDtEnt) ,_nValPV)
	
	if SB1->B1_IPI > 0 .and. SF4->F4_IPI <> "N"
		_nValIPI := (SB1->B1_IPI/100) * _nValor
		if SF4->F4_BASEIPI > 0
			_nValIPI *= (SF4->F4_BASEIPI/100)
		endif
	endif
	
	_nValor += _nValIPI
	
	_aParcelas := Condicao(_nValor,SC5->C5_CONDPAG,_nValIpi,_dDtEnt)
	
	for _nConta := 1 to len(_aParcelas)
		_nPos := Ascan(_aVencimentos,{|x| x[1]==_aParcelas[_nConta,1] .and. x[2]==SA1->A1_NATUREZ .and. x[4]==SC6->C6_NUM})
		if _nPos == 0
			aadd(_aVencimentos, {_aParcelas[_nConta,1],SA1->A1_NATUREZ,_aParcelas[_nConta,2],SC6->C6_NUM})
		else
			_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
		endif
		
	next _nConta
	
	SC6->(dbskip())
	
enddo

for _nConta := 1 to len(_aVencimentos)
	if _aVencimentos[_nConta,1] <= _dDataFim
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= DataValida(_aVencimentos[_nConta,1])
		TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
		//TRB1->DESC_NAT	:= GetAdvFVal("SED","ED_DESCRIC",xFilial("SED")+_aVencimentos[_nConta,2],1,"SEM NATUREZA")
		TRB1->HISTORICO	:= "PEDIDO DE VENDA " + _aVencimentos[_nConta,4]
		TRB1->VALOR		:= _aVencimentos[_nConta,3]
		TRB1->RECPAG	:= "R"
		TRB1->TIPO		:= "P"
		TRB1->ORIGEM	:= "PV"
		TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
		TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
		if SED->(dbseek(_cFilSED+_aVencimentos[_nConta,2]))
			TRB1->DESC_NAT := SED->ED_DESCRIC
		else
			TRB1->DESC_NAT := "NATUREZA NAO DEFINIDA"
		endif
		MsUnlock()
	endif
next _nConta

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01PV  �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa  Pedidos de venda                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01BC()
local _nPos 	:= 0
local _cQuerySB	:= ""
local QuerySB 	:= ""
local cNatuFl
local cDescFl
local _cFilSE8 		:= xFilial("SE8")


SE8->(dbsetorder(1)) // F4_FILIAL + F4_CODIGO

SE8->(dbseek(_cFilSE8))

//oProcess:SetRegua2( ("SE8")->(RecCount()) ) //Alimenta a segunda barra de progresso


while SE8->(!eof()) .and. SE8->E8_FILIAL == _cFilSE8
	
		//oProcess:IncRegua2("Processando Bancos")
		//oProcess:SetRegua2( ("SE8")->(RecCount()) ) //Alimenta a segunda barra de progresso
//******************************************
		IF !alltrim(SE8->E8_BANCO) $ "115/202/502"
			cNatuFl := "9.ZZ.04"
			cDescFl := "BANCO"
		endif
		/*
		IF alltrim(SE8->E8_BANCO) $ "100"
			cNatuFl := "9.ZZ.03"
			cDescFl := "SANTANDER"
		ELSEIF alltrim(SE8->E8_BANCO) $ "104"
			cNatuFl := "9.ZZ.04"
			cDescFl := "SANTANDER"
		ELSEIF alltrim(SE8->E8_BANCO) == "115"
			cNatuFl := "9.ZZ.02"
			cDescFl := "SANTANDER EMPRESTIMO"
		ELSEIF alltrim(SE8->E8_BANCO) $ "200"
			cNatuFl := "9.ZZ.05"
			cDescFl := "BRADESCO"
		ELSEIF alltrim(SE8->E8_BANCO) $ "202"
			cNatuFl := "9.ZZ.06"
			cDescFl := "BRADESCO"
		ELSEIF alltrim(SE8->E8_BANCO) $ "500"
			cNatuFl := "9.ZZ.07"
			cDescFl := "ITAU"
		ELSEIF alltrim(SE8->E8_BANCO) $ "502"
			cNatuFl := "9.ZZ.08"
			cDescFl := "ITAU"
		ELSEIF alltrim(SE8->E8_BANCO) $ "400"
			cNatuFl := "9.ZZ.09"
			if mv_par07 = 1
				cDescFl := "XP INVESTIMENTOS"
			else
				cDescFl := "INVESTMENTS XP"
			endif
		ELSEIF alltrim(SE8->E8_BANCO) $ "CX1"
			cNatuFl := "9.ZZ.10"
			if mv_par07 = 1
				cDescFl := "CAIXA GERAL"
			else
				cDescFl := "GENERAL BOX"
			endif
		ENDIF
		*/
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= SE8->E8_DTSALAT
		TRB1->VENCTO	:= SE8->E8_DTSALAT
		TRB1->NATUREZA	:= alltrim(cNatuFl) 
		TRB1->BANCO		:= alltrim(SE8->E8_BANCO)
		TRB1->DESC_NAT	:= POSICIONE("SA6",1,XFILIAL("SA6")+alltrim(SE8->E8_BANCO),"A6_NOME")
		TRB1->HISTORICO	:= "Agencia: " + alltrim(SE8->E8_AGENCIA) + " - " + "Conta: " + SE8->E8_CONTA
		TRB1->VALOR		:= SE8->E8_SALATUA
		TRB1->RECPAG	:= "M"
		TRB1->TIPO		:= "M"
		TRB1->ORIGEM	:= "SB"
		TRB1->GRUPONAT 	:= cNatuFl //RetGrupo(TRB1->NATUREZA)
		TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
		MsUnlock()
	
		SE8->(dbskip())
	enddo
	
SE8->(dbclosearea())


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01SINT�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o Arquivo Sintetico                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PFIN01SINT()
local _nPos 	:= 0
local _cQuery 	:= ""
local cFiltra 	:= " ORDEM <> '000001' "
local _nSaldo 	:= 0
local _nSaldo2 	:= 0

local nX 		:= 0
local nX1 		:= 0
local nX2 		:= 0
local nX3		:= 0
local nX4		:= 0
local nX5 		:= 0


local _nSaldoB1 	:= 0
local _nSaldoB2 	:= 0
local _nSaldoB3 	:= 0
local _nSaldoB4 	:= 0
local _nSaldoB5 	:= 0
local _nSaldoB6 	:= 0
local _nSaldoB10 	:= 0
local _nSaldoB1a 	:= 0
local _nSaldoB2a 	:= 0
local _nSaldoB3a 	:= 0
local _nSaldoB4a 	:= 0
local nLimite1	 	:= 0
local nLimite2	 	:= 0
local nLimite3	 	:= 0
local nLimite4	 	:= 0
local nLimite5	 	:= 0
local nLimite6	 	:= 0
local nLimite7	 	:= 0
local _nSaldoBXP 	:= 0
local cField2		:= ""
local cField2b		:= ""

local cBanco		:= ""
local cAgencia		:= ""
local cConta		:= ""

local cBanco2		:= ""
local cAgencia2		:= ""
local cConta2		:= ""

local _cFilSE8 		:= xFilial("SE8")
local _cFilSA6 		:= xFilial("SA6")
local _ni

private _cOrdem := "000001"

ProcRegua(SZR->(reccount())+TRB1->(reccount())+BANCOS->(reccount()))

BANCOS->(dbgotop())
while BANCOS->(!eof()) 
	if BANCOS->A6_OK <> ' '
		_nSaldo += BANCOS->A6_SALATU
		_nSaldo2 += BANCOS->A6_SALATU2
	endif
	incproc()
	BANCOS->(dbskip())
enddo

// Carga com todos os grupos de naturezas existentes
SZR->(dbsetorder(1)) // Z2_FILIAL + Z2_GRUPO
SZR->(dbgotop())
while SZR->(!eof())
	RecLock("TRB2",.T.)
	
	TRB2->GRUPO 	:= SZR->ZR_GRUPO
	if mv_par07 = 1
		TRB2->DESCRICAO	:= SZR->ZR_DESCRI
	else
		TRB2->DESCRICAO	:= SZR->ZR_DESENG
	endif
	TRB2->ORDEM		:= _cOrdem
	TRB2->GRUPOSUP 	:= SZR->ZR_CODSUP
	MsUnlock()
	if ascan(_aGrpSint,SZR->ZR_CODSUP) == 0
		aadd(_aGrpSint,SZR->ZR_CODSUP)
	endif
	SZR->(dbskip())
	_cOrdem := soma1(_cOrdem)
enddo


RecLock("TRB2",.T.)
TRB2->GRUPO		:= "0.XX.00"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "SALDO INICIAL"
else
	TRB2->DESCRICAO	:= "BEGINNING BALANCE"
endif
TRB2->ORDEM		:= _cOrdem
TRB2->TOTAL 	:= _nSaldo
FieldPut(TRB2->(fieldpos(_aCpos[1])) , _nSaldo) // Campo do primeiro dia de movimento
MsUnlock()

_nSaldoIni	:= _nSaldo

_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo

_cOrdem := soma1(_cOrdem)

// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas
RecLock("TRB2",.T.)
if mv_par07 = 1
	TRB2->DESCRICAO := "SEM NATUREZA"
else
	TRB2->DESCRICAO := "NO NATURE"
endif
TRB2->ORDEM		:= _cOrdem

MsUnlock()

_cOrdem := soma1(_cOrdem)

//_cFilTRB1 := TRB1->(dbfilter())
TRB1->(dbclearfil())

TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))

TRB1->(dbgotop())
while TRB1->(!eof())
	_nPos 	:= TRB2->(fieldpos(TRB1->CAMPO)) 
	if _nPos > 0 .AND. ! TRB2->GRUPO $ "9.ZZ.02/9.ZZ.03/9.ZZ.04/9.ZZ.05/9.ZZ.06/9.ZZ.07/9.ZZ.08/9.ZZ.09/9.ZZ.10/9.ZZ.11/9.ZZ.12/9.ZZ.13/9.ZZ.14/9.ZZ.15"
		GravaVlr(TRB1->GRUPONAT,TRB1->VALOR,_nPos)
	endif
	TRB1->(dbskip())
enddo

AtuSaldo()



//***********************************************************************
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.XX.02"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "SALDO FINAL"
else
	TRB2->DESCRICAO	:= "CLOSING BALANCE"
endif
TRB2->ORDEM		:= _cOrdem

for _ni := 1 to _nCampos

	TRB2->(dbskip(-14))
	nSIni := TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(14))
	
	
	TRB2->(dbskip(-9))
	nTRec := TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(9))
	
	TRB2->(dbskip(-1))
	nTDes := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(1))

	FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , (nSIni + nTRec) - nTDes )

	nSIni := 0
	nTRec := 0
	nTDes := 0
	
next _ni

MsUnlock()

RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.XX.03"
TRB2->DESCRICAO	:= ""
TRB2->ORDEM		:= _cOrdem
MsUnlock()

//***********************************************************************
/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.XX.04"
TRB2->DESCRICAO	:= "PROVISAO VENDAS-RECEITA"
TRB2->ORDEM		:= _cOrdem
MsUnlock()
//***********************************************************************
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.XX.05"
TRB2->DESCRICAO	:= "PROVISAO VENDAS-DESPESA"
TRB2->ORDEM		:= _cOrdem
MsUnlock()
*/
//***********************************************************************

RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.XX.06"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "SALDO PROVISIONADO"
else
	TRB2->DESCRICAO	:= "PROVIDED BALANCE"
endif
TRB2->ORDEM		:= _cOrdem

for _ni := 1 to _nCampos

	TRB2->(dbskip(-4))
	nSF := TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(4))
	
	
	TRB2->(dbskip(-2))
	nRV := TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(2))
	
	TRB2->(dbskip(-1))
	nDV := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(1))

	FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , nSF + nRV + nDV )

next _ni

MsUnlock()


//***********************************************************************
/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.01"
TRB2->DESCRICAO	:= ""
TRB2->ORDEM		:= _cOrdem
MsUnlock()
//***********************************************************************

RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.02"
TRB2->DESCRICAO	:= "SALDO BANCOS"
TRB2->ORDEM		:= _cOrdem
MsUnlock()
*/
//***********************************************************************
//***********************************************************************
SA6->(dbsetorder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)


//***********************************************************************
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.04"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "SALDO BANCOS"
else
	TRB2->DESCRICAO	:= "TOTAL OF CASH AVAILABLE"
endif	
TRB2->ORDEM		:= _cOrdem


for _ni := 1 to _nCampos
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		if dtos(cField5) >= dtos( Date() )
			
			_nSaldoB1 := 0
		else
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			BANCOS->(dbgotop())
			while BANCOS->( ! EOF() ) 
				
				cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
				cField5 := dtoc(ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)))
				
				If alltrim(BANCOS->A6_OK) == ""
					BANCOS->(dbskip())
					loop
				else
					cBanco		:= alltrim(BANCOS->A6_COD)
					cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
					cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
					cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
				endif
				
				//msginfo (cField5)
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				dDtini 	:= Dtos(SE8->E8_DTSALAT)
				
				if 	SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
					//msginfo ("achou")
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
					_nSaldoB1 += SE8->E8_SALATUA
				else
				
					dDtini 	:= Dtos(SE8->E8_DTSALAT)
			
					if dDtini <> Dtos(_dDataIni)
						SE8->(dbSeek( xFilial("SE8") +cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						SE8->(dbSkip(-1))
						if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
							SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == cBanco2+cAgencia2+cConta2
							_nSaldoB1 += SE8->E8_SALATUA
						else
							_nSaldoB1 += 0
						endif		
					endif
				endif	
				//SE8->(dbgotop())
				//while SE8->( ! EOF() ) 
												
				BANCOS->(dbskip())	
			enddo
		endif
	FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
	_nSaldoB1 := 0
next _ni


MsUnlock()

//***********************************************************************

RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.12"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "LIMITE CREDITO (EMPREST./CHEQUE ESPECIAL)"
else
	TRB2->DESCRICAO	:= "CREDIT LIMIT"
endif
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
	nLimite1 := (Posicione("SA6",1,xFilial("SA6") + "100","A6_LIMCRED"))
	nLimite2 := (Posicione("SA6",1,xFilial("SA6") + "115","A6_LIMCRED"))
	nLimite3 := (Posicione("SA6",1,xFilial("SA6") + "200","A6_LIMCRED"))
	nLimite4 := (Posicione("SA6",1,xFilial("SA6") + "500","A6_LIMCRED"))
	nLimite7 := (Posicione("SA6",1,xFilial("SA6") + "502","A6_LIMCRED"))
	nLimite6 := nLimite1 + nLimite2 + nLimite3 + nLimite4 + nLimite7
	FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , nLimite6)
next _ni
MsUnlock()


RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.13"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "LIMITE CREDITO DISPON�VEL "
else
	TRB2->DESCRICAO	:= "AVAILABLE CREDIT LIMIT "
endif
TRB2->ORDEM		:= _cOrdem
nLimite1 := (Posicione("SA6",1,xFilial("SA6") + "100","A6_LIMCRED"))
nLimite2 := (Posicione("SA6",1,xFilial("SA6") + "115","A6_LIMCRED"))
nLimite3 := (Posicione("SA6",1,xFilial("SA6") + "200","A6_LIMCRED"))
nLimite4 := (Posicione("SA6",1,xFilial("SA6") + "500","A6_LIMCRED"))
nLimite7 := (Posicione("SA6",1,xFilial("SA6") + "502","A6_LIMCRED"))
nLimite6 := nLimite1 + nLimite2 + nLimite3 + nLimite4 + nLimite7

for _ni := 1 to _nCampos

	// Emprestimo contas receber


	TRB2->(dbskip(-17))
	nL2 := TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(17))
	
	// emprestimo contas a pagar
	TRB2->(dbskip(-10))
	nL4 := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	TRB2->(dbskip(10))
	
	/*----------------Banco 115-------------------------*/
	nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

			cBanco		:= "115"
			cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
			cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
			cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
			
			SA6->(dbgotop())
			while SA6->(!eof())
			
				//******************************** SALDO ANTERIOR
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				nL5 := SE8->E8_SALATUA
				dDtini 	:= Dtos(SE8->E8_DTSALAT)
				
					//while SE8->E8_SALATUA == 0
					if dDtini <> Dtos(_dDataIni)
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						SE8->(dbSkip(-1))	
					else
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						//SE8->(dbSkip(-1))	
					end if
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				SE8->(dbSkip(-1))
				
				
				if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
					SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
					nL5 := SE8->E8_SALATUA 
				else
					nL5 := 0
				endif
			
			
				//***************************************
			
				SA6->(dbskip())
			enddo
	
			if nL5 > 0 
				nL5 := 0
			else
				nL5 := -1 * nL5
			endif
	
	/*---------------- 502 -------------------------*/
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

			cBanco		:= "502"
			cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
			cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
			cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
			
			SA6->(dbgotop())
			while SA6->(!eof())
			
				//******************************** SALDO ANTERIOR
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				nL8a := SE8->E8_SALATUA
				dDtini 	:= Dtos(SE8->E8_DTSALAT)
				
					//while SE8->E8_SALATUA == 0
					if dDtini <> Dtos(_dDataIni)
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						SE8->(dbSkip(-1))	
					else
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						//SE8->(dbSkip(-1))	
					end if
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				SE8->(dbSkip(-1))
				
				
				if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
					SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
					nL8a := SE8->E8_SALATUA 
				else
					nL8a := 0
				endif
			
			
				//***************************************
			
				SA6->(dbskip())
			enddo
	
		
		if nL8a > 0 
			nL8a := 0
		else
			nL8a := -1 * nL8a
		endif
	
	/*
	// Banco 115
	TRB2->(dbskip(-11))
	
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL5 := 0
	else
		nL5 := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(11))
	
	// Banco 100
	TRB2->(dbskip(-10))
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL6 := 0
	else
		nL6 := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(10))
	
	// Banco 104
	TRB2->(dbskip(-9))
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL6a := 0
	else
		nL6a := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(9))
	
	// Banco 200
	TRB2->(dbskip(-8))
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL7 := 0
	else
		nL7 := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(8))
	
	// Banco 202
	TRB2->(dbskip(-7))
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL7a := 0
	else
		nL7a := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(7))
	
	// Banco 500
	TRB2->(dbskip(-6))
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL8 := 0
	else
		nL8 := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(6))
	
	// Banco 502
	TRB2->(dbskip(-5))
	if TRB2->(FieldGet(fieldpos(_aCpos[_ni]))) > 0
		nL8a := 0
	else
		nL8a := -1 * TRB2->(FieldGet(fieldpos(_aCpos[_ni])))
	endif
	TRB2->(dbskip(5))
	*/

	
	//if _ni > 1 //dtos(cField2) > dtos(mv_par01) .and. dtos(cField2) <= dtos(mv_par02) .and. valtype(TRB2->(FieldGet(fieldpos(_aCpos[_ni-1])))) == "N" //TRB2->(FieldGet(fieldpos(_aCpos[_ni-1]))) < nLimite6 .and. 
		//FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , (((TRB2->(FieldGet(fieldpos(_aCpos[_ni-1]))) - nL2 - (nL5+nL8a)  ) + nL4 ))  )
		//FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , (( TRB2->(FieldGet(fieldpos(_aCpos[_ni-1]))) - nL2 - (nL5+nL8a)  ) + nL4   ) )  
		//FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , (TRB2->(FieldGet(fieldpos(_aCpos[_ni-1]))) - nL2 - nL6 - nL6a -  nL7 -  nL7a -  nL8  ) + nL4   )
	//else
		FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , (((nLimite6 - nL2 - (nL5+nL8a)  ) + nL4 ))  )
		//FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , ((nLimite6 - nL2 - nL5 - nL6 - nL6a -  nL7 -  nL7a -  nL8 -  nL8a) + nL4 ) )
	//endif
	
next _ni
MsUnlock()

/*--------------------------------------------------------------*/
/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.14"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "115"
else
	TRB2->DESCRICAO	:= "115"
endif	
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
	cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
	if dtos(cField5) >= dtos(mv_par03)
			
		_nSaldoB1 := 0
	else

		
	
			nX := 0
			
			cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
			cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
			cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

			cBanco		:= "115"
			cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
			cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
			cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
			
			SA6->(dbgotop())
			while SA6->(!eof())
			
				//******************************** SALDO ANTERIOR
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				_nSaldoB1 := SE8->E8_SALATUA
				dDtini 	:= Dtos(SE8->E8_DTSALAT)
				
					//while SE8->E8_SALATUA == 0
					if dDtini <> Dtos(_dDataIni)
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						SE8->(dbSkip(-1))	
					else
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						//SE8->(dbSkip(-1))	
					end if
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				SE8->(dbSkip(-1))
				
				
				if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
					SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
					_nSaldoB1 := SE8->E8_SALATUA 
				else
					_nSaldoB1 := 0
				endif
			
			
				//***************************************
			
				SA6->(dbskip())
			enddo
				
		FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
		_nSaldoB1 := 0
		

	endif
next _ni
MsUnlock()

/*--------------------------------------------------------------*/

/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.16"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "502"
else
	TRB2->DESCRICAO	:= "502"
endif	
TRB2->ORDEM		:= _cOrdem

for _ni := 1 to _nCampos
	cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
	if dtos(cField5) >= dtos(mv_par03)
			
		_nSaldoB1 := 0
	else

	
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

		cBanco		:= "502"
		cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
		cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
		cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
		
		SA6->(dbgotop())
		while SA6->(!eof())
		
			//******************************** SALDO ANTERIOR
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			_nSaldoB1 := SE8->E8_SALATUA
			dDtini 	:= Dtos(SE8->E8_DTSALAT)
			
				//while SE8->E8_SALATUA == 0
				if dDtini <> Dtos(_dDataIni)
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					SE8->(dbSkip(-1))	
				else
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					//SE8->(dbSkip(-1))	
				end if
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			SE8->(dbSkip(-1))
			
			
			if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
				SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
				_nSaldoB1 := SE8->E8_SALATUA 
			else
				_nSaldoB1 := 0
			endif
		
		
			//***************************************
		
			SA6->(dbskip())
		enddo
			
			FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
			_nSaldoB1 := 0
		
	endif
next _ni	
MsUnlock()

/*--------------------------------------------------------------*/

/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.17"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "100"
else
	TRB2->DESCRICAO	:= "100"
endif	
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
if dtos(cField5) >= dtos(mv_par03)
			
	_nSaldoB1 := 0
else

	
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)
			
			cBanco		:= "100"
			cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
			cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
			cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
			
			SA6->(dbgotop())
			while SA6->(!eof())
			
				//******************************** SALDO ANTERIOR
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				_nSaldoB1 := SE8->E8_SALATUA
				dDtini 	:= Dtos(SE8->E8_DTSALAT)
				
					//while SE8->E8_SALATUA == 0
					if dDtini <> Dtos(_dDataIni)
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						SE8->(dbSkip(-1))	
					else
						SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
						//SE8->(dbSkip(-1))	
					end if
				SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
				SE8->(dbSkip(-1))
				
				
				if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
					SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
					_nSaldoB1 := SE8->E8_SALATUA 
				else
					_nSaldoB1 := 0
				endif
			
			
				//***************************************
			
				SA6->(dbskip())
			enddo
				
				FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
				_nSaldoB1 := 0
	
	
endif
next _ni
MsUnlock()

/*--------------------------------------------------------------*/
/*

RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.18"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "104"
else
	TRB2->DESCRICAO	:= "104"
endif	
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
if dtos(cField5) >= dtos(mv_par03)
			
	_nSaldoB1 := 0
else

	
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

		cBanco		:= "104"
		cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
		cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
		cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
		
		SA6->(dbgotop())
		while SA6->(!eof())
		
			//******************************** SALDO ANTERIOR
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			_nSaldoB1 := SE8->E8_SALATUA
			dDtini 	:= Dtos(SE8->E8_DTSALAT)
			
				//while SE8->E8_SALATUA == 0
				if dDtini <> Dtos(_dDataIni)
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					SE8->(dbSkip(-1))	
				else
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					//SE8->(dbSkip(-1))	
				end if
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			SE8->(dbSkip(-1))
			
			
			if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
				SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
				_nSaldoB1 := SE8->E8_SALATUA 
			else
				_nSaldoB1 := 0
			endif
		
		
			//***************************************
		
			SA6->(dbskip())
		enddo
			
			FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
			_nSaldoB1 := 0
		
endif
next _ni
MsUnlock()

/*--------------------------------------------------------------*/

/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.19"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "200"
else
	TRB2->DESCRICAO	:= "200"
endif	
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
if dtos(cField5) >= dtos(mv_par03)
			
	_nSaldoB1 := 0
else


	
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

		cBanco		:= "200"
		cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
		cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
		cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
		
		SA6->(dbgotop())
		while SA6->(!eof())
		
			//******************************** SALDO ANTERIOR
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			_nSaldoB1 := SE8->E8_SALATUA
			dDtini 	:= Dtos(SE8->E8_DTSALAT)
			
				//while SE8->E8_SALATUA == 0
				if dDtini <> Dtos(_dDataIni)
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					SE8->(dbSkip(-1))	
				else
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					//SE8->(dbSkip(-1))	
				end if
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			SE8->(dbSkip(-1))
			
			
			if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
				SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
				_nSaldoB1 := SE8->E8_SALATUA 
			else
				_nSaldoB1 := 0
			endif
		
		
			//***************************************
		
			SA6->(dbskip())
		enddo
			
			FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
			_nSaldoB1 := 0
	
endif
next _ni
MsUnlock()

/*--------------------------------------------------------------*/

/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.20"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "202"
else
	TRB2->DESCRICAO	:= "202"
endif	
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
if dtos(cField5) >= dtos(mv_par03)
			
	_nSaldoB1 := 0
else

	
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

		cBanco		:= "202"
		cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
		cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
		cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
		
		SA6->(dbgotop())
		while SA6->(!eof())
		
			//******************************** SALDO ANTERIOR
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			_nSaldoB1 := SE8->E8_SALATUA
			dDtini 	:= Dtos(SE8->E8_DTSALAT)
			
				//while SE8->E8_SALATUA == 0
				if dDtini <> Dtos(_dDataIni)
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					SE8->(dbSkip(-1))	
				else
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					//SE8->(dbSkip(-1))	
				end if
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			SE8->(dbSkip(-1))
			
			
			if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
				SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
				_nSaldoB1 := SE8->E8_SALATUA 
			else
				_nSaldoB1 := 0
			endif
		
		
			//***************************************
		
			SA6->(dbskip())
		enddo
			
		FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
		_nSaldoB1 := 0
	
		
endif
next _ni
MsUnlock()

/*--------------------------------------------------------------*/

/*
RecLock("TRB2",.T.)
TRB2->GRUPO		:= "9.ZZ.21"
if mv_par07 = 1
	TRB2->DESCRICAO	:= "500"
else
	TRB2->DESCRICAO	:= "500"
endif	
TRB2->ORDEM		:= _cOrdem
for _ni := 1 to _nCampos
cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		
if dtos(cField5) >= dtos(mv_par03)
			
	_nSaldoB1 := 0
else

	
	
		nX := 0
		
		cField2 :=   ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2))
		cField5 :=   DataValida(stod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)),.F.)
		cField2b :=  dtoc(ctod(Substr(_aCpos[_ni],6,4) + Substr(_aCpos[_ni],4,2) +  Substr(_aCpos[_ni],2,2)))
		
			cField3 := Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4)
			cField4 := ctod(Substr(_aCpos[_ni],2,2) + "/" + Substr(_aCpos[_ni],4,2) + "/" + Substr(_aCpos[_ni],6,4))
			
			//msginfo ( cField3 ) 
			SE8->(dbsetorder(1))
			SE8->(dbgotop())
			SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)

		cBanco		:= "500"
		cBanco2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_COD")
		cAgencia2 	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_AGENCIA")
		cConta2		:= POSICIONE("SA6",1,XFILIAL("SA6")+cBanco,"A6_NUMCON")
		
		SA6->(dbgotop())
		while SA6->(!eof())
		
			//******************************** SALDO ANTERIOR
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			_nSaldoB1 := SE8->E8_SALATUA
			dDtini 	:= Dtos(SE8->E8_DTSALAT)
			
				//while SE8->E8_SALATUA == 0
				if dDtini <> Dtos(_dDataIni)
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					SE8->(dbSkip(-1))	
				else
					SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))	
					//SE8->(dbSkip(-1))	
				end if
			SE8->(dbSeek( xFilial("SE8")+cBanco2+cAgencia2+cConta2+Dtos(cField4),.T.))
			SE8->(dbSkip(-1))
			
			
			if 	SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
				SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == +cBanco2+cAgencia2+cConta2
				_nSaldoB1 := SE8->E8_SALATUA 
			else
				_nSaldoB1 := 0
			endif
		
		
			//***************************************
		
			SA6->(dbskip())
		enddo
			
			FieldPut(TRB2->(fieldpos(_aCpos[_ni])) , _nSaldoB1 )
			_nSaldoB1 := 0
	
	
endif
next _ni
MsUnlock()

*/
return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaVlr  �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava valor no arquivo sintetico                           ���
�������������������������������������������������������������������������ͼ ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function GravaVlr(_cGrupo, _nValor, _nPosCpo)
local _nValAtual := 0

if TRB2->(dbseek(_cGrupo))
	
	_nValAtual := TRB2->(FieldGet(_nPosCpo))
	
	RecLock("TRB2",.F.)
	FieldPut(_nPosCpo , _nValor + _nValAtual)
	TRB2->TOTAL += _nValor
	MsUnlock()


/*else // Se o grupo nao existir
	
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuSaldo  �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o Saldo inicial de todos os dias no TRB2          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function AtuSaldo()
local _cQuery 	:= ""
local _aSaldos	:= {}
local _nPos		:= 0
local _ni


for _ni := 1 to _nCampos
	aAdd(_aSaldos,{_aCpos[_ni] ,0})
next _ni

TRB2->(dbgotop())
while TRB2->(!eof())
	if TRB2->(recno())<>_nRecSaldo .and. !empty(TRB2->GRUPOSUP) .and. ascan(_aGrpSint,TRB2->GRUPO) == 0 ;
	   .or. alltrim(TRB2->DESCRICAO) == "SEM NATUREZA OU GRUPO" .and. ! TRB2->GRUPO $ "1.0X.01/9.EM.00" 
		for _ni := 1 to _nCampos
			_nPos := Ascan(_aSaldos,{|x| x[1]==_aCpos[_ni]})
			if _nPos > 0
				_aSaldos[_nPos,2] += &("TRB2->" + _aCpos[_ni])
			endif
		next _ni
	endif
	TRB2->(dbskip())
enddo

TRB2->(dbgoto(_nRecSaldo)) // Posiciona no registro de saldo inicial

_nSaldo := _nSaldoIni
for _ni := 1 to _nCampos-1
	_nSaldo += _aSaldos[_ni,2]
	&("TRB2->" + _aCpos[_ni+1] + " := _nSaldo")  // Grava o saldo inicial do dia seguinte
next _ni

/*
TRB2->(DBGoBottom()) // Posiciona no registro de saldo inicial
TRB2->(dbskip(-2))
_nSaldo := _nSaldoIni
for _ni := 1 to _nCampos-1
	_nSaldo += _aSaldos[_ni,2]
	&("TRB2->" + _aCpos[_ni] + " := _nSaldo")  // Grava o saldo inicial do dia seguinte
next _ni
*/



return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaTela �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta a tela de visualizacao do Fluxo Sintetico            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function MontaTela()

local _ni
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
Private bColor

if mv_par07 = 1
	cCadastro := "Fluxo de caixa - Sint�tico - de " + dtoc(_dDataIni) + " at� " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - Per�odo de " + alltrim(str(_nDiasPer,4,0)) + " dias", " - Di�rio")
else
	cCadastro := "Cash Flow - Synthetic - from " + dtoc(_dDataIni) + " up to " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - Period of " + alltrim(str(_nDiasPer,4,0)) + " days", " - Daily")
endif
// Monta aHeader do TRB2

aadd(aHeader, {"Descri��o/Description","DESCRICAO","",50,0,"","","C","TRB2","R"})

for _ni := 1 to len(_aCpos) // Monta campos com as datas
	aadd(aHeader, {_aLegPer[_ni],_aCpos[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
next _dData
aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})
aadd(aHeader, {"Grupo/Group","GRUPO","",10,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgSint ;
TITLE "Fluxo de caixa - Sint�tico - de " + dtoc(_dDataIni) + " at� " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - Per�odo de " + alltrim(str(_nDiasPer,4,0)) + " dias", " - Di�rio") ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"



_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2")

_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

// COR DA FONTE
_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
// COR DA LINHA
//_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| fTrocaCor(2)}
_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

//aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "Simula��o" } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Plan.Excel s/formata��o" } )
//aadd(aButton , { "BMPTABLE2" , { || zExportExc()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE1" , { || zExportExc()}, "Gerar Plan. Excel " } )
aadd(aButton , { "BMPTABLE2" , { || zAtualizar()}, "Atualizar Sint�tico " } )
aadd(aButton , { "BMPTABLE3" , { || zExFuA()}, "Anal�tico Geral " } )


_oDlgSint:Refresh()
_oGetDbSint:ForceRefresh()


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.02"; _cCor := CLR_LIGHTGRAY; endif
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.01"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.XX.03"; _cCor := CLR_LIGHTGRAY ; endif
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.10"; _cCor := CLR_LIGHTGRAY ; endif
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
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.02"; _cCor := CLR_LIGHTGRAY ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.XX.03"; _cCor := CLR_LIGHTGRAY ; endif
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.10"; _cCor := CLR_LIGHTGRAY ; endif
   	  //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.08"; _cCor := CLR_HGREEN  ; endif
   	  if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.13"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "0.XX.00"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "1.99.99"; _cCor := CLR_YELLOW ; endif
      //if ALLTRIM(TRB2->GRUPO) ==  "9.XX.01"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.11"; _cCor := CLR_HGREEN ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.12"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.01"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.02"; _cCor := CLR_HGREEN ; endif
      //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.09"; _cCor := CLR_HGREEN ; endif
      //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.11"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.12"; _cCor := CLR_YELLOW ; endif
      //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.18"; _cCor := CLR_HCYAN ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.04"; _cCor := CLR_YELLOW ; endif
      if ALLTRIM(TRB2->GRUPO) ==  "9.XX.05"; _cCor := CLR_YELLOW ; endif
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ShowAnalit�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

cCadastro := "Fluxo de caixa - Anal�tico - " + _cPeriodo


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
aadd(aHeader, {"Data Real"	,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Vencimento"	,"VENCTO"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Emiss�o"	,"EMISSAO"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Banco"		,"BANCO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Prefixo"	,"PREFIXO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"No.Titulo/OC","NTITULO"	,"",09,0,"","","C","TRB1","R"})
aadd(aHeader, {"Parcela"	,"PARCELA"	,"",01,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPOD"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descri��o"	,"DESC_NAT"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Cli/For","CLIFOR"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cli/For"	,"NCLIFOR"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Loja"		,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Hist�rico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - Anal�tico - " + _cPeriodo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA ORIGEM: MB - Movimento Banc�rio / CR - Contas a Receber / CP - Contas a Pagar / OC - Ordem de Compras / PV - Pedido de Vendas "  COLORS 0, 16777215 PIXEL

_oGetDbAnalit:oBrowse:BlDblClick := {|| EditReg() }
_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula��o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula��o" } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE3" , { || zExpAnalitico()}, "Gerar Plan. Excel " } )

_oGetDbAnalit:ForceRefresh()
_oDlgAnalit:Refresh()

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

//TRB1->(dbclearfil())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ShowAnalit�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function zExFuA()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro := "Fluxo de caixa - Anal�tico " 

TRB1->(dbclearfil())

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
aadd(aHeader, {"Data Real"	,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Vencimento"	,"VENCTO"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Emiss�o"	,"EMISSAO"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Banco"		,"BANCO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Prefixo"	,"PREFIXO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"No.Titulo/OC","NTITULO"	,"",09,0,"","","C","TRB1","R"})
aadd(aHeader, {"Parcela"	,"PARCELA"	,"",01,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPOD"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descri��o"	,"DESC_NAT"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cod.Cli/For","CLIFOR"	,"",10,0,"","","C","TRB1","R"})
aadd(aHeader, {"Cli/For"	,"NCLIFOR"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Loja"		,"LOJA"		,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Hist�rico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Fluxo de caixa - Anal�tico Geral"  From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")


@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA ORIGEM: MB - Movimento Banc�rio / CR - Contas a Receber / CP - Contas a Pagar / OC - Ordem de Compras / PV - Pedido de Vendas "  COLORS 0, 16777215 PIXEL

_oGetDbAnalit:oBrowse:BlDblClick := {|| EditReg() }
//_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}

//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula��o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula��o" } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE3" , { || zExpAnalitico()}, "Gerar Plan. Excel " } )

_oGetDbAnalit:ForceRefresh()
_oDlgAnalit:Refresh()

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

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
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Fluxo de caixa - Anal�tico") 
        //Criando a Tabela
        oFWMsExcel:AddTable("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico")
        
        aAdd(aColunas, "Item Conta")							// 3 Item Conta
        aAdd(aColunas, "No.T�tulo/OC")							// 5 No.Titulo/OC
        aAdd(aColunas, "Tipo")									// 7 Tipo
        aAdd(aColunas, "Cod.Cli./For.")							// 10 Codigo Cliente / Fornecedor
        aAdd(aColunas, "Cliente/Fornecedor")					// 11 Cliente / Fornecedor
        aAdd(aColunas, "Loja")									// 12 Loja
        aAdd(aColunas, "Emiss�o")								// 1 Data
        aAdd(aColunas, "Vencimento")							// 1 Data
        aAdd(aColunas, "Data Real")								// 1 Data
        aAdd(aColunas, "Valor")									// 13 Valor
        aAdd(aColunas, "Banco")									// 2 Banco
        aAdd(aColunas, "Prefixo")								// 4 Prefixo
        aAdd(aColunas, "Parcela")								// 6 Parcela
        aAdd(aColunas, "Natureza")								// 8 Natureza
        aAdd(aColunas, "Descri��o")								// 9 Descri��o Natureza
        aAdd(aColunas, "Hist�rico")								// 13 Hist�rico
        aAdd(aColunas, "Origem")								// 14 Origem
         
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Item Conta",1,2)			// 3 Item Conta  
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "No.T�tulo/OC",1,2)			// 5 No.Titulo/OC
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Tipo",1,2)					// 7 Tipo
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Cod.Cli./For.",1,2)			// 10 Codigo Cliente / Fornecedor
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Cliente/Fornecedor",1,2)	// 11 Cliente / Fornecedor
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Loja",1,2)					// 12 Loja 
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Emiss�o",2,4)					// 1 Data
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Vencimento",2,4)					// 1 Data
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Data Real",2,4)					// 1 Data
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Valor",1,2)					// 13 Valor       
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Banco",1,2)					// 2 Banco
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Prefixo",1,2)				// 4 Prefixo
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Parcela",1,2)				// 6 Parcela
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Natureza",1,2)				// 8 Natureza
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Descri��o",1,2)				// 9 Descri��o
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Hist�rico",1,2)					// 13 Valor
        oFWMsExcel:AddColumn("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , "Origem",1,2)				// 14 Origem
           
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->ITEMCONTA
        	aLinhaAux[2] := TRB1->NTITULO
        	aLinhaAux[3] := TRB1->TIPOD
        	aLinhaAux[4] := TRB1->CLIFOR
        	aLinhaAux[5] := TRB1->NCLIFOR
        	aLinhaAux[6] := TRB1->LOJA
        	aLinhaAux[7] := TRB1->EMISSAO
        	aLinhaAux[8] := TRB1->VENCTO
        	aLinhaAux[9] := TRB1->DATAMOV
        	aLinhaAux[10] := TRB1->VALOR
        	aLinhaAux[11] := TRB1->BANCO
        	aLinhaAux[12] := TRB1->PREFIXO
        	aLinhaAux[13] := TRB1->PARCELA
        	aLinhaAux[14] := TRB1->NATUREZA
        	aLinhaAux[15] := TRB1->DESC_NAT
        	aLinhaAux[16] := TRB1->HISTORICO
        	aLinhaAux[17] := TRB1->ORIGEM
           	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        		
        		oFWMsExcel:AddRow("Fluxo de caixa - Anal�tico","Fluxo de caixa - Anal�tico" , aLinhaAux)
        	//endif
            TRB1->(DbSkip())

        EndDo

        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             	//Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)                 	//Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

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
    	
    	cCadastro := "Altera��o Ordem de Compra"
    
	    DbSelectArea("SC7")
	    SC7->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	    SC7->(DbGoTop())
	     
	    //Se conseguir posicionar no produto
	    If SC7->(DbSeek(xFilial('SC7')+cTitulo))
	    	
	        nOpcao := fAltRegSC7()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten��o")
	        EndIf
	       
	    EndIf
	ENDIF
	
	IF cOrigem == "CP"  
		cCadastro := "Altera��o Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB1->NTITULO+TRB1->CLIFOR+dData+TRB1->LOJA) )
			//nOpcao := AxAltera("SE2", SE2->(RecNo()), 4)
	        nOpcao := zAltRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten��o")
	            MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	       
	        EndIf
	    endif
	ENDIF
		
	IF cOrigem == "CR"  

		cCadastro := "Altera��o Contas a Receber"
	
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
	    SE1->(DbGoTop())
	    
	    //Se conseguir posicionar no produto
	    If SE1->(DbSeek(xFilial("SE1")+TRB1->NTITULO+TRB1->CLIFOR+dData+TRB1->LOJA ))
	       nOpcao := fAltRegSE1()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Aten��o")
	            MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	        EndIf
	    EndIf
	    
	ENDIF
	
	IF cOrigem $ "MB/SB"  
		 MsgInfo("Registro n�o pode ser alterado...", "Aten��o")
	ENDIF
     
   
    RestArea(aAreaC7)
    RestArea(aAreaE2)
    RestArea(aAreaE1)
    RestArea(aArea)
Return

//**********************************************************************
// Altera��o Ordem de Compra


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
		  	SC7->C7_DATPRF := DataValida(dVencto,.T.) //Proximo dia �til
		  	MsUnlock()
		  	SC7->( dbSkip() )
		  	
		enddo
		
	EndIf
  	
  Endif

   
  
Return _nOpc

// Altera��o registro Contas a Receber
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

  DEFINE MSDIALOG _oDlg TITLE "Altera T�tulo" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

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
  	SE1->E1_VENCREA := DataValida(dVencto,.T.) //Proximo dia �til
  	SE1->E1_VALOR	:= nValor
  	SE1->E1_VLCRUZ	:= nValor
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
		TRB1->VALOR := nValor
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
	
	MSAguarde({|| PFIN01PC()},"Ordem de compra")
	
	DbSelectArea("TRB2")
	zap
	MSAguarde({||PFIN01SINT()},"Atualizando arquivo sint�tico.")
	//MSAguarde({|| AtuSaldo()},"Atualizando Fluxo de Caixa")
	
	TRB2->(dbgotop())
	
	
	
	
Return nil

/*
// Altera��o registro Contas a Pagar

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

  DEFINE MSDIALOG _oDlg TITLE "Altera T�tulo" FROM 000, 000  TO 220, 400 COLORS 0, 16777215 PIXEL

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
  	SE2->E2_VENCREA := DataValida(dVencto,.T.) //Proximo dia �til
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GerSimul �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclui Simulacao no Fluxo de Caixa                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerSimul(_cCampo, _cPeriodo)
local _nOpca := 0

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0
	return
endif

private _nOpcoes 	:= 1
private _aOpcoes 	:= {"Simula��o a Pagar ","Simula��o a Receber"}
private _cGrupo	 	:= TRB2->DESCRICAO
private _cLegPer 	:= _aLegPer[ascan(_aCpos,_cCampo)]
private _nValor	 	:= 0
private _cHistorico	:= space(130)

@ 000,000 To 280,350 Dialog _oDlgSimul Title "Simula��o"

@ 010,005 Say "Grupo"
@ 010,035 Get _cGrupo Size 125,10 When .F.

@ 025,005 Say "Per�odo"
@ 025,035 Get _cLegPer Size 55,10 When .F.

@ 045,005 Radio _aOpcoes Var _nOpcoes

@ 070,005 Say "Valor"
@ 070,035 Get _nValor Picture "@E 999,999,999.99" Valid positivo() Size 55,10

@ 085,005 Say "Hist�rico"
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
	
	if msgyesno("Deseja guardar essa simula��o para consultas futuras?")
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
	MSAguarde({||PFIN01SINT()},"Gerando arquivo sint�tico.")
	
endif

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DelSimul �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Excluir Simulacao no Fluxo de Caixa                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DelSimul()
local _nOpca := 0
local _nPos
local _nRecTRB1

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
if TRB1->SIMULADO <> "S"
	
	MsgStop("Apenas movimentos de simula��o podem ser exclu�dos.")
	
elseif msgyesno("Confirma exclus�o do movimento de simula��o?")
	
	_nRecTRB1 := TRB1->(recno())
	RecLock("TRB1",.F.)
	dbdelete()
	MsUnlock()
	
	if msgyesno("Deseja excluir essa simula��o de consultas futuras?")
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
	MSAguarde({||PFIN01SINT()},"Gerando arquivo sint�tico.")
	
	//_oDlgAnalit:End()
	TRB1->(dbgotop())
	TRB2->(dbgotop())
	
endif

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraExcel �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera Arquivo em Excel e abre                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraCSV   �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera Arquivo em Excel e abre                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)

local cDirDocs  := MsDocPath() 
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
local _ni

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
	MsgAlert("Falha na cria��o do arquivo") 
Endif	

(_cAlias)->(dbclearfil())

Return


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
    Local cPlan		:= ""
    Local cTabela	:= ""
	local _ni
	local nAux
   //Local oExcel	:= YExcel():new()
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#000080")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFE0")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
    
    if mv_par07 = 1
    	cPlan 		:= "Fluxo de Caixa"
    	cTabela 	:= "Fluxo de caixa - Sint�tico - de " + dtoc(_dDataIni) + " at� " + dtoc(_dDataFim)
    else
    	cPlan 		:= "Cash Flow"
    	cTabela 	:= "Cash Flow - Synthetic - from " + dtoc(_dDataIni) + " up to " + dtoc(_dDataFim)
    endif
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cPlan) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable(cPlan,cTabela)
        
        aAdd(aColunas, "Descri��o" + SPACE(25))
        for _ni := 1 to len(_aCpos) // Monta campos com as datas
        	aAdd(aColunas,  _aLegPer[_ni])
        next _dData
        
        For nAux := 1 To Len(aColunas)
            oFWMsExcel:AddColumn(cPlan,cTabela, aColunas[nAux],1,2)
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
            	alltrim(aLinhaAux[1]) == "TOTAL DESPESAS" .OR. alltrim(aLinhaAux[1]) == "SALDO FINAL" .OR. ;
            	alltrim(aLinhaAux[1]) == "BEGINNING BALANCE" .OR. alltrim(aLinhaAux[1]) == "CASH IN" .OR. ;
            	alltrim(aLinhaAux[1]) == "CASH OUT" .OR. alltrim(aLinhaAux[1]) == "CLOSING BALANCE"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#4169E1")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif alltrim(aLinhaAux[1]) == "SALDO PROVISIONADO" .OR. alltrim(aLinhaAux[1]) == "SALDO BANCOS" .OR. ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO (EMPREST./CHEQUE ESPECIAL)" .OR. ;
            	alltrim(aLinhaAux[1]) == "PROVIDED BALANCE" .OR. alltrim(aLinhaAux[1]) == "TOTAL OF CASH AVAILABLE" .OR. ;
            	alltrim(aLinhaAux[1]) == "CREDIT LIMIT" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#4169E1")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO DISPONIVEL" .OR. alltrim(aLinhaAux[1]) == "AVAILABLE CREDIT LIMIT"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "SANTADER (CC 100/104)" .OR. ;
            	alltrim(aLinhaAux[1]) == "BRADESCO (CC 200/202)" .OR. ;
            	alltrim(aLinhaAux[1]) == "CAIXA GERAL (CX1)" .OR. alltrim(aLinhaAux[1]) == "GENERAL BOX (CX1)"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "SALDOS BANCOS" .OR. ;
            	alltrim(aLinhaAux[1]) == "SANTADER (EMPRESTIMO 115" .OR. ;
            	alltrim(aLinhaAux[1]) == "ITAU (CC 500/502)" .OR. ;
            	alltrim(aLinhaAux[1]) == "XP INVESTIMENTOS" .OR. ;
            	alltrim(aLinhaAux[1]) == "TOTAL OF CASH AVAILABLE" .OR. ;
            	alltrim(aLinhaAux[1]) == "SANTADER (LOAN 115)" .OR. ;
            	alltrim(aLinhaAux[1]) == "ITAU (CC 500)" .OR. ;
            	alltrim(aLinhaAux[1]) == "INVESTMENTS XP"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#F0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE DE CREDITO ATUAL" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#F0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO EMPRESTIMO"
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#F0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif ;
            	alltrim(aLinhaAux[1]) == "LIMITE CREDITO CHEQUE ESPECIAL" .OR. ;
            	alltrim(aLinhaAux[1]) == "TOTAL CREDITO" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            elseif;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SALDO INICIAL" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "BEGINNING BALANCE" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "TOTAL RECEITAS" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "CASH IN" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "TOTAL DESPESAS" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "CASH OUT" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SALDO FINAL" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "CLOSING BALANCE" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SALDOS BANCOS" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "TOTAL OF CASH AVAILABLE" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (CC 100)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (CC 104)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "BRADESCO (CC 200)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "BRADESCO (CC 202)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "CAIXA GERAL (CX1)" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "GENERAL BOX (CX1)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (EMPRESTIMO 115)" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (LOAN 115)" .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "ITAU (CC 500)"  .OR. ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "ITAU (CC 502)" .OR.  ;
            	nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "LIMITE CREDITO DISPONIVEL" .OR. nCL = 1 .AND. alltrim(aLinhaAux[1]) <> "AVAILABLE CREDIT LIMIT"
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)   
            	nCL := 2
            elseif ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SALDO INICIAL" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "BEGINNING BALANCE" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "TOTAL RECEITAS" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "CASH IN" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "TOTAL DESPESAS" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "CASH OUT" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SALDO FINAL" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "CLOSING BALANCE" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SALDOS BANCOS" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "TOTAL OF CASH AVAILABLE" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (CC 100)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (CC 104)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "BRADESCO (CC 200)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "BRADESCO (CC 202)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "CAIXA GERAL (CX1)" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "GENERAL BOX (CX1)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (EMPRESTIMO 115)" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "SANTADER (LOAN 115)" .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "ITAU (CC 500)"  .OR. ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "ITAU (CC 502)" .OR.  ;
            	nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "LIMITE CREDITO DISPONIVEL" .OR. nCL = 2 .AND. alltrim(aLinhaAux[1]) <> "AVAILABLE CREDIT LIMIT"
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FAFAD2")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            	nCL := 1
            
            else
            	oFWMsExcel:AddRow(cPlan,cTabela, aLinhaAux,aColsMa)
            endif

            TRB2->(DbSkip())

        EndDo
        
    TRB2->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
  
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
    

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AbreArq   �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function AbreArq()
local aStru 	:= {}
local _dData
local _nDias	:= 1
local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("N�o foi poss�vel abrir o arquivo PFIN01.XLS pois ele pode estar aberto por outro usu�rio.")
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
	
	if _dData == DataValida(_dData) // Apenas dias uteis
		
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
aAdd(aStru,{"VENCTO"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"EMISSAO"	,"D",08,0}) // Data de movimentacao
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
//aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)

aStru := {}
aAdd(aStru,{"GRUPO"		,"C",10,0}) // Codigo da Natureza
aAdd(aStru,{"DESCRICAO"	,"C",50,0}) // Descricao da Natureza
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RETGRUPO �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o grupo de uma determinada natureza                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RETCAMPO �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o grupo de uma determinada natureza                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function RetCampo(_dData)
local _cRet := ""

_nPos := Ascan(_aDatas , { |x| x[1] == _dData })

if _nPos > 0
	_cRet := _aDatas[_nPos,2]
endif

return(_cRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDPARAM  �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os parametros digitados                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function VldParam()

if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos par�metros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de in�cio do processamento deve ser menor ou igual a data de refer�ncia.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de refer�ncia.")
	return(.F.)
endif

return(.T.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ABREDOC   �Autor  �Marcos Zanetti G&Z  � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre o XLS com os dados do fluxo de caixa                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	MsgStop("Ocorreram problemas na c�pia do arquivo.")
endif

return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDPERG �Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria as perguntas do SX1                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
PutSX1(cPerg,"05","Dias por periodo"		,"Dias por periodo"		,"Dias por periodo"		,"mv_ch5","N",02,0,0,"G","",""		,"",,"mv_par05","","","","","","","","","","","","","","","","",{"Indica quantos dias ser�o considerados","por per�odo (coluna) do relat�rio"})
//PutSX1(cPerg,"08","Seleciona Bancos"		,"Seleciona Bancos"		,"Seleciona Bancos"		,"mv_ch8","N",01,0,0,"C","",""		,"",,"mv_par08","Sim","","","","Nao","","","","","","","","","","","")
//PutSX1(cPerg,"09","Considera Previsoes"	    ,"Considera Previsoes"	,"Considera Previsoes"	,"mv_ch9","N",01,0,0,"C","",""		,"",,"mv_par09","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"07","Idioma?" 	,"Idioma?","Idioma?","mv_ch7","N",01,0,0,"N","",""		,"",,"mv_par07","Portugues","","","","Ingles","","","","","","","","","","","")

return
