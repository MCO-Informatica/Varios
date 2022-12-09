#Include "Protheus.Ch"
#INCLUDE "TOPCONN.CH"  
/*
----------------------------------------------------------------
Funcao  : RFatA02							Data  : 09.01.07
Autor   : Gildesio Campos
----------------------------------------------------------------
Objetivo: Selecao das Notas Fiscais 
----------------------------------------------------------------		  
*/                                             
User Function RFatA02()
Local nOpca
Local nSeqReg
Local aSays := {}, aButtons := {}
Private cTitulo := "Nota Fiscal de Saida"//"Alteracao dos Volumes e Transportadora na NF Gerada"
Private cCadastro := OemToAnsi(cTitulo)
Private cPerg  := Padr("RFAT02",Len(SX1->X1_GRUPO))
Private cDesc1 := "Selecao das Notas Fiscais para alteração de dados"
Private cDesc2 := "Volumes, Transportadora, Peso Liquido e Bruto, Mensagens"
Private cDesc3 := ""
Private cDesc4 := ""

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))

nOpca    := 0
//cCadastro:=OemToAnsi(cTitulo)
RFatA02Perg(cPerg)        

AAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.)}})
AAdd(aButtons,{1,.T.,{|| nOpca := 1,FechaBatch()}})
AAdd(aButtons,{2,.T.,{|| nOpca := 0,FechaBatch()}})

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| U_RFatA02Proc()}, "Selecionando Documentos")
Endif

Return
/*
--------------------------------------------------------------------------
Programa : RFatA02Proc		Autor   : Gildesio Campos		Data: 24.04.07
Descricao: Gravacao do volume, peso liquido, peso bruto, transportadora
--------------------------------------------------------------------------
*/
User Function RFatA02Proc()
Local   aIndices := {} , _cFiltro

Private aCores := {}
Private aRotina := {{ "Pesquisar"  ,"AxPesqui"    ,0,1},;	//"Pesquisar"
					{ "Visualizar" ,"U_RFatA02Vis",0,2},;	//"Visual"   
					{ "Alterar"    ,"U_RFatA02Alt",0,4},;   //"Alterar"
					{ "Legenda"    ,"U_RFatA02Leg",0,2}}    //"Legenda"

Private _aCpoSF2 := {"F2_DOC","F2_SERIE","F2_EMISSAO","F2_CLIENTE","F2_LOJA","F2_VOLUME1","F2_TRANSP",;
					 "F2_PLIQUI","F2_PBRUTO","F2_X_BOX","F2_REDESP"}

_cFiltro := "F2_DOC >= Mv_Par01 .And. F2_DOC <= Mv_Par02 .And. dtos(F2_EMISSAO) == dtos(Mv_Par03)" //.And. dtos(F2_EMISSAO) <= dtos(Mv_Par04)"
bFilBrw	:=	{|| FilBrowse('SF2',@aIndices,_cFiltro)}   
Eval( bFilBrw )

mBrowse( 6,1,22,75,"SF2",,,,,,aCores)
EndFilBrw("SF2",aIndices) 

Return(.T.)
/*
-----------------------------------------------------------------------------
Funcao   : RFatA02Alt        
Autor    : Gildesio Campos                                    |Data: 24.04.07
-----------------------------------------------------------------------------
Descricao: Viabilizar a alteracao de campos determinados na NF gerada 
-----------------------------------------------------------------------------
*/
User Function RFatA02Alt(cAlias,nReg,nOpc)
Local 	aCpoAlt := {"F2_VOLUME1", "F2_TRANSP","F2_PLIQUI","F2_PBRUTO","F2_X_BOX","F2_REDESP"}
Private aTELA[0][0],aGETS[0]

INCLUI := .F.
ALTERA := .T.
nOpcA  := 0

nOpcA  :=AxAltera( cAlias, nReg, nOpc,_aCpoSF2,aCpoAlt,,)         //1-Ok 3-Cancela

If nOpcA = 3  // Se cancelou
	Return
EndIf

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatA02Vis       
Autor    : Gildesio Campos                                    |Data: 24.04.07
-----------------------------------------------------------------------------
Descricao: Viabilizar a alteracao de campos determinados na NF gerada 
-----------------------------------------------------------------------------
*/
User Function RFatA02Vis(cAlias,nReg,nOpc)
Local 	aCpoAlt := {"F2_VOLUME1", "F2_TRANSP","F2_REDESP"}
Private aTELA[0][0],aGETS[0]

INCLUI := .F.
ALTERA := .T.
nOpcA  := 0

nOpcA  :=AxVisual( cAlias, nReg, nOpc,_aCpoSF2,,,)         //1-Ok 3-Cancela

If nOpcA = 3  // Se cancelou
	Return
EndIf

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatA02Leg        
Autor    : Gildesio Campos                                    |Data: 24.04.07
-----------------------------------------------------------------------------
Descricao: Legenda
-----------------------------------------------------------------------------
*/
User Function RFatA02Leg()
Private aCorDesc 
aCorDesc := {{"ENABLE" ,"Nota Fiscal Gerada"},;
			 {"DISABLE","Nota Fiscal Impressa"}}

BrwLegenda( "Notas Fiscais","Legenda ", aCorDesc )

Return( .T. )      
               
/*
-----------------------------------------------------------------------------
Funcao   : RFatA02Perg        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Verifica as perguntas incluindo-as caso nao existam
-----------------------------------------------------------------------------
*/
Static Function RFatA02Perg(xPerg)
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)                                                              
aRegs:={}

AADD(aRegs,{cPerg,"01","Nota Fiscal de    ?","","","mv_ch1" ,"C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","SF2"})
AADD(aRegs,{cPerg,"02","Nota Fiscal Ate   ?","","","mv_ch2" ,"C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","SF2"})
AADD(aRegs,{cPerg,"03","Data de Emissao   ?","","","mv_ch3" ,"D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return

