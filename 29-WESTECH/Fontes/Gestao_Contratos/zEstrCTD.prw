#include 'protheus.ch'
#include 'parmtype.ch'
#include "dbtree.ch"

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                        Low Intensity colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                      High Intensity Colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 

user function zEstrCTD()


Private cCadastro := "Gestao de Contratos"
Private cFornece  := ""
Private cAlias1   := "CTD"            // Alias da Enchoice. Tabela Pai   CAPA
  
Private bFiltraBrw := {|| Nil}
Private nTotal    := 0

Private aRotina   := {}
Private aSize     := {}
Private aInfo     := {}
Private aObj      := {}
Private aPObj     := {}
Private aPGet     := {}
Private _cRetorno



Private bCampo    := {|nField| FieldName(nField) }


	// Retorna a area util das janelas Protheus
	aSize := MsAdvSize()

	// Será utilizado três áreas na janela
	// 1ª - Enchoice, sendo 80 pontos pixel
	// 2ª - MsGetDados, o que sobrar em pontos pixel é para este objeto
	// 3ª - Rodapé que é a própria janela, sendo 15 pontos pixel

	AADD( aObj, { 100, 210, .T., .F. })
	AADD( aObj, { 100, 400, .T., .T. })
	AADD( aObj, { 100, 015, .T., .F. })

	// Cálculo automático da dimensões dos objetos (altura/largura) em pixel

	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPObj := MsObjSize( aInfo, aObj )

	// Cálculo automático de dimensões dos objetos MSGET

	aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

	//AADD( aRotina, {"Pesquisar"  , "AxPesqui" , 0, 1} )
	AADD( aRotina, {"Custos" , 'U_zEstruCTR', 0, 2} )
	//AADD( aRotina, {"Incluir"    , 'U_zInvMnt', 0, 3} )
	//AADD( aRotina, {"Alterar"    , 'U_zInvMnt', 0, 4} )
	//AADD( aRotina, {"Excluir"    , 'U_zInvMnt', 0, 5} )
	//AADD( aRotina, {"Imprimir" 	 , 'U_zInvMnt',0,6})

	aCores:={{"CTD_DTEXSF < Date()","GRAY"},;
			 {"CTD_DTEXSF >= Date()", "GREEN"}}

	dbSelectArea(cAlias1)
	dbSetOrder(6)
	dbGoTop()


	SET FILTER TO CTD->CTD_ITEM <> 'ADMINISTRACAO' .AND. CTD->CTD_ITEM<>'PROPOSTA' .AND. CTD->CTD_ITEM<>'QUALIDADE' .AND. CTD->CTD_ITEM<>'ATIVO' ;
			 .AND. CTD->CTD_ITEM<>'ENGENHARIA' .AND. CTD->CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD->CTD_ITEM<>'XXXXXX' .AND. SUBSTR(CTD->CTD_ITEM,9,2) >= '15'


	//MBrowse(,,,,cAlias1)
	MBrowse(,,,,cAlias1,,"CTD_DTEXSF",,,8,aCores)
	
	
Return


user function zEstruCTR()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Custo de Contratos"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"GCIN01"
private _cArq	:= 	"GCIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := CTD->CTD_ITEM
private _cFilial 	:= ALLTRIM(CTD->CTD_FILIAL)

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb4 := CriaTrab(NIL,.F.)


Private _aGrpSint:= {}

//ValidPerg()

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

	_cItemConta 	:= CTD->CTD_ITEM
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	//SET FILTER TO alltrim(SZC->ZC_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZD")
	dbSetOrder(3)
	//SET FILTER TO alltrim(SZD->ZD_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZO")
	dbSetOrder(4)
	//SET FILTER TO alltrim(SZO->ZO_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZU")
	dbSetOrder(2)
	//SET FILTER TO alltrim(SZU->ZU_ITEMIC) = '_cItemConta'


	MntEstru()

//endif


return


static function MntEstru()
//Local oGet1
Local oGet1 := Space(13)
Local nposi

Local IMAGE1 := "FOLDER5"
Local IMAGE2 := "FOLDER6"
Local IMAGE3 := "FOLDER7"
Local aNodes := {}

Local oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Local oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Local oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
Local oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
Local oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Local oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
Local oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
Local oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
Local oPink		:= LoadBitmap( GetResources(), "BR_PINK")
Local oGray		:= LoadBitmap( GetResources(), "BR_CINZA")

private _cItemConta := CTD->CTD_ITEM
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ]+95, aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oDlgSint

	cCadastro :=  "Gestao de Contratos - Sintético - " + _cItemConta

	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Gestao de Contratos - Sintético - " + _cItemConta ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	// Cria a Tree
	
	oTree := DbTree():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],_oDlgSint,,,.T.)
	nX0 := 0
	nX1 := 1
	nX2 := 2
	nX3 := 3
	nX4 := 4
	aadd(aNodes,{cValToChar(nX0),cValtoChar(nX1),"",AllTrim(_cItemConta)+SPACE(40),IMAGE1,IMAGE2})  
	
	nX0++
	nX1++
	
	//msginfo( cValToChar(nX0) )
	//msginfo( cValToChar(nX1) )
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	
	dbSelectArea("SZD")
	dbSetOrder(3)
		
	dbSelectArea("SZO")
	dbSetOrder(4)
	
	dbSelectArea("SZU")
	dbSetOrder(2)
	
	
	SZC->(dbgotop())
	
	//msginfo( cValToChar(nX0) )
	//msginfo( cValToChar(nX1) )
	
	If SZC->(dbSeek(_cItemConta)) //********
	
	While SZC->(!eof()) .AND. ALLTRIM(SZC->ZC_ITEMIC) == alltrim(_cItemConta)
		
		if ALLTRIM(SZC->ZC_ITEMIC) == alltrim(_cItemConta)	
			
			
			cIDPlan := alltrim(SZC->ZC_IDPLAN)
			
			//msginfo( "nivel 2: " +  cValToChar(nX0) + " - " + cIDPlan + " " + _cItemConta )
			//msginfo( "nivel 2: " + cValToChar(nX1)  + " - " + cIDPlan + " " + _cItemConta )
			
			aadd(aNodes,{cValToChar(nX0),cValtoChar(nX1),"",ALLTRIM(SZC->ZC_DESCRI) ;
			+ SPACE(40 - LEN(ALLTRIM(SZC->ZC_DESCRI)) ) ;
			+ space(20) ;
			+ "Total.: " + alltrim(transform(SZC->ZC_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
			nX1++
			
			
			SZD->(dbgotop())
			
			If SZD->(dbSeek(_cItemConta)) //********
				
			While SZD->(!eof()) .AND. ALLTRIM(SZD->ZD_ITEMIC) == alltrim(_cItemConta)
			
				if ALLTRIM(SZD->ZD_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZD->ZD_IDPLAN) == alltrim(cIDPlan) 
					//msginfo( "nivel 3: " +  cValToChar(nX2)  + " - " + cIDPlan + " " + _cItemConta  )
					//msginfo( "nivel 3: " + cValToChar(nX1)  + " - " + cIDPlan + " " + _cItemConta  )
					
					cIDPLSUB := alltrim(SZD->ZD_IDPLSUB)
					aadd(aNodes,{cValToChar(nX2),cValtoChar(nX1),"",alltrim(SZD->ZD_DESCRI) ;
					+ SPACE(40 - LEN(ALLTRIM(SZD->ZD_DESCRI)) ) ;
					+ space(20) ;
					+ "Total.: " + alltrim(transform(SZD->ZD_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2})  
					nX1++
					
					//***************************
					
					SZO->(dbgotop())
					If SZO->(dbSeek(_cItemConta)) //********
					
					While SZO->(!eof()) .AND. ALLTRIM(SZO->ZO_ITEMIC) == alltrim(_cItemConta)
					 
						if ALLTRIM(SZO->ZO_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZO->ZO_IDPLSUB) == alltrim(cIDPLSUB) 
							
							//msginfo( "nivel 4: " +  cValToChar(nX3)  + " - " + cIDPLSUB + " " + _cItemConta  )
							//msginfo( "nivel 4: " + cValToChar(nX1)  + " - " + cIDPLSUB + " " + _cItemConta  )
							
							cIDPLSB2 := alltrim(SZO->ZO_IDPLSB2)
							aadd(aNodes,{cValToChar(nX3),cValtoChar(nX1),"",ALLTRIM(SZO->ZO_DESCRI);
							+ SPACE(40 - LEN(ALLTRIM(SZO->ZO_DESCRI)) ) ;
							+ space(20) ;
							+ "Total.: " + alltrim(transform(SZO->ZO_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
							nX1++
							
							//**************************
							dbSelectArea("SZU")
							dbSetOrder(1)
							
							
							SZU->(dbgotop())
							If SZU->(dbSeek(_cItemConta)) //********
							
							While SZU->(!eof()) .AND. ALLTRIM(SZU->ZU_ITEMIC) == alltrim(_cItemConta)
							
								if ALLTRIM(SZU->ZU_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZU->ZU_IDPLSB2) == alltrim(cIDPLSB2) 
								
									//msginfo( "nivel 5: " +  cValToChar(nX4)  + " - " + cIDPLSB2 + " " + _cItemConta  )
									//msginfo( "nivel 5: " + cValToChar(nX1)  + " - " + cIDPLSB2 + " " + _cItemConta  )
								
									aadd(aNodes,{cValToChar(nX4),cValtoChar(nX1),"",ALLTRIM(SZU->ZU_DESCRI);
									+ SPACE(40 - LEN(ALLTRIM(SZU->ZU_DESCRI)) ) ;
									+ space(20) ;
									+ "Total.: " + alltrim(transform(SZU->ZU_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
									nX1++
									
								endif
								SZU->(dbSkip())
							enddo
							
							ENDIF
							///******************************
						endif
						SZO->(dbSkip())
					enddo
					
					ENDIF
					//****************************
				endif
				SZD->(dbSkip())
			enddo
			ENDIF
			
			
		endif
		SZC->(dbSkip())
		
	enddo
	
	ENDIF //*****
	oTree:PTSendTree( aNodes )

oGroup1:= TGroup():New(0032,0015,0062,0900,'',_oDlgSint,,,.T.)
oGroup2:= TGroup():New(0065,0015,0095,0380,'Venda',_oDlgSint,,,.T.)
oGroup3:= TGroup():New(0065,0385,0095,0900,'Venda Revisado',_oDlgSint,,,.T.)

oGroup4:= TGroup():New(0095,0015,0125,0380,'Custo Vendido',_oDlgSint,,,.T.)
oGroup5:= TGroup():New(0095,0385,0125,0900,'Custo Revisado',_oDlgSint,,,.T.)

@ 0036,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0045,0020 MSGET  _cItemConta  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0045,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0200 Say  "Cod.C·liente: " 	 COLORS 0, 16777215 PIXEL
@ 0045,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0045,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0460 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0045,0460 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0036,0520 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0045,0520 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0060 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0160 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0079,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0260 Say  "s/ Tributos (s/Frete): " 	COLORS 0, 16777215 PIXEL
@ 0079,0260 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0440 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0540 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0079,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0070,0640 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0079,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0060 Say  "Produção " 	COLORS 0, 16777215 PIXEL
@ 0109,0060 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUSTO"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOT"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0440 Say  "Produção " 	COLORS 0, 16777215 PIXEL
@ 0109,0440 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUPRR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0540 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0109,0540 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOR"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0100,0640 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0109,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVBAD"), "@E 999,999,999.99" ) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

CTD->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())

return
