#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch"                                                                                                                                  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "MSGRAPHI.CH"    
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"       
#INCLUDE "FWADAPTEREAI.CH"                                                                                                
#DEFINE ENTER chr(13)+chr(10)                                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AOF01     ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±                                                                                
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de OF - Utiliza Funcao Modelo3 (Igual aoº±±                                                           
±±º          ³ pedido de venda)                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Aumund Ltda                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function browsetst()   

Local aCores    :={}		// OF liberada pela Gerencia Geral
Local aCposBrw 		:= {}      
Local nCnt  := 0
Local nI    := 0
Local nSoma := 0

SetPrvt("NUSADO,AHEADER,ACOLS,CTITULO,CALIASENCHOICE,CALIASGETD,CLINOK")
SetPrvt("cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,_nOpPcEG,_nOpcEG,cFieldOk,_LRET,_LINCLUI,_nTamSZ6,_nj,_ni,_aCampos")

PRIVATE bFiltraBrw := {|| Nil}                                                        
Private aCposFOR 	:= {}     
Private cQuery 		:= " "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE aRotina := {}

Private cCadastro := "Cadastro de Perdas"
    Private aCols 		:= {}
    Private aHeader 	:= {}
    Private aCpoEnchoice:= {}
    Private aAltEnchoice:= {}
    Private cTitulo
    Private cAlias1 	:= "FOR"
    Private cAlias2 	:= "FOI"


DbSelectArea(cAlias1)
DbSetOrder(1)

cQuery := "SELECT FORN.FOR_FILIAL,FORN.FOR_NUM,FOR_COD,FOR_LOJA,FOR_EMISSA,FOR_STATUS "

cQuery += " FROM " + RetSqlName("FOR") + " FORN (NOLOCK)"

cQuery += " WHERE FORN.D_E_L_E_T_=''  "
/*and  FORN.FOR_FILIAL='"+cFilAnt+"'"  */

cQuery += " ORDER BY FORN.FOR_FILIAL,FORN.FOR_NUM"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"FORTMP", .T., .T.)
TcSetField('FORTMP','FOR_EMISSA','D',0)

dbSelectArea("SX3")
DbSetOrder(1)
aAreaSX3 := GetArea()
If dbSeek("FOR")
	While !Eof() .And. X3_ARQUIVO == "FOR"
		If Trim(X3_CAMPO) $ cQuery
			AAdd(aCposFOR,{Trim(X3_CAMPO), X3_TIPO, X3_TAMANHO, X3_DECIMAL})
			If X3USO(X3_USADO)
				AAdd(aCposBrw,{X3TITULO(X3_CAMPO), &("{|| "+aCposFOR[Len(aCposFOR),1]+"}"), X3_TIPO, X3_TAMANHO, X3_DECIMAL, RTrim(X3_PICTURE) })
			EndIf
		EndIf
		SX3->(dbSkip())
	EndDo
	AAdd(aCposFOR,{"R_E_C_N_O_","N",14,0})
Else
	Alert("Tabela FOR não cadastrada")
	Return
EndIf
RestArea(aAreaSX3)

For nI := 1 to Len(aCposFOR)
	If aCposFOR[nI,2] <> "C"
		TCSetField("FORTMP", aCposFOR[nI,1], aCposFOR[nI,2], aCposFOR[nI,3], aCposFOR[nI,4])
	Endif
Next


cArqTrab := CriaTrab( aCposFOR,.T.)
dbUseArea( .T., "DBFCDX", cArqTrab, "TRB", .T. ,.F. )

IndRegua( "TRB", cArqTrab, "FOR_NUM" )

cAlias := "TRB"
dbSelectArea('TRB')
dbSetOrder(1)           
FORTMP->(dbGoTop())
ProcRegua(nCnt)

While !FORTMP->(Eof())

	RecLock('TRB', .T.,.F.)
	
	For nI := 1 To Len(aCposFOR) - 1
		&('TRB' + "->" + aCposFOR[nI,1]) := &("FORTMP->" + aCposFOR[nI,1])

	Next
	
	TRB->R_E_C_N_O_ := nCnt
	
	MsUnLock()
	
	FORTMP->(dbSkip())
	nCnt++
End


aAdd( aRotina, {"Pesquisa"  	, "PesqBrw"	,0,1,0,.f.} )
aAdd( aRotina, {"Visualiza" 	, "U_AOF01VIS" 		,0,2} )
aAdd( aRotina, {"Inclui"  	, "U_AOF01INC"	,0,3} ) //Saida
aAdd( aRotina, {"altera"  	, "U_AOF01ALT"   		,0,4} )
aAdd( aRotina, {"Excluir"  	, "U_AOF01EXC"   		,0,5} )
aAdd( aRotina, {"Gera Pedido"	, "U_AOF01Pln"  		,0,6} )
aAdd( aRotina, {"Legenda"	, "U_AOF01LEG"  		,0,7} )


aAdd(aCores, { "(TRB->FOR_STATUS == '1')", "BR_AMARELO"  	}) //Separacao divergente
aAdd(aCores, { "(TRB->FOR_STATUS == '2')", "BR_AZUL"     	}) //Expedicao Ok

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(,,,,'TRB',aCposBrw,,,,,aCores)
                                                             
DbCloseArea()

dbSelectArea("TRB")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01VIS ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de OF - Visualizacao de dados           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01VIS()
dbSelectArea("SZ6")

If BOF() .And. EOF()
	Help("",1,"ARQVAZIO")
	Return
Endif

// A funcao RegToMemory foi colocada fora da CRIAMOD3 pois ela cria variaveis privadas, que
// perdem a visibilidade com a saida da funcao CRIAMOD3 e eh preciso gravar SZ6 com os dados de M->
RegToMemory("SZ6",.F.)

CRIAMOD3(2,.F.)

_cNumOF := M->Z6_NUM
if SZ8->(dbseek(xFilial("SZ8") + M->Z6_NUM)) .and. msgyesno("Deseja visualizar a documentacao para cliente dessa OF ?")
	// Chama a rotina de visualizacao de documentos da OF
	U_AOF02VIS()
endif

if SZJ->(dbseek(xFilial("SZJ") + M->Z6_NUM)) .and. msgyesno("Deseja visualizar as entregas dessa OF ?")
	// Chama a rotina de visualizacao de eventos da OF
	U_AOF06VIS()
endif

if SZC->(dbseek(xFilial("SZC") + M->Z6_NUM)) .and. msgyesno("Deseja visualizar os eventos dessa OF ?")
	// Chama a rotina de visualizacao de eventos da OF
	U_AOF05VIS()
endif

if SZA->(dbseek(xFilial("SZA") + M->Z6_NUM)) .and. msgyesno("Deseja visualizar as garantias financeiras dessa OF ?")
	// Chama a rotina de visualizacao das garantias da OF
	U_AOF03VIS()
endif

if SZB->(dbseek(xFilial("SZB") + M->Z6_NUM)) .and. msgyesno("Deseja visualizar as multas e penalidades dessa OF ?")
	// Chama a rotina de visualizacao das garantias da OF
	_nLimTot 	:= SZB->ZB_LIMTOT
	U_AOF04VIS()
endif

if SZO->(dbseek(xFilial("SZO") + M->Z6_NUM)) .and. msgyesno("Deseja visualizar o Budget dessa OF ?")
	// Chama a rotina de visualizacao das garantias da OF
	U_AOF09VIS()
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01LIB ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de liberacao de OF                                  º±±
±±º          ³ O parametro _lMsg indica se deverao ser exibidas           º±±
±±º          ³ de avisos.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01LIB(_lMsg)
dbSelectArea("SZ6")

If BOF() .And. EOF()
	Help("",1,"ARQVAZIO")
	Return
Endif

if !empty(SZ6->Z6_DTENC)
	msgstop("Essa OF nao pode sofrer liberacao pois esta encerrada.")
	return
endif

if SZD->(dbseek(xFilial("SZD")+__CUSERID)) .and. SZD->ZD_NIVEL != "0"
	if val(SZ6->Z6_STATUS) > val(SZD->ZD_NIVEL)
		if _lMsg
			msgstop("Esta OF ja esta liberada em nivel igual ou " +chr(13)+chr(10)+;
			"superior ao do usuario atual.")
		endif
		return
	endif
else
	if _lMsg
		msgstop("Usuario sem permissao para liberar OF.")
	endif
	return
endif

// A funcao RegToMemory foi colocada fora da CRIAMOD3 pois ela cria variaveis privadas, que
// perdem a visibilidade com a saida da funcao CRIAMOD3 e eh preciso gravar SZ6 com os dados de M->
RegToMemory("SZ6",.F.)
if CRIAMOD3(2,.F.) .and. iif(_lMsg , msgyesno("Confirma liberacao da OF ?") , .T. )
	RecLock("SZ6",.F.)
	SZ6->Z6_STATUS := SZD->ZD_NIVEL                                              
	MsUnlock()
	// Gera e envia email com os dados basicos
	// da OF para os principais usuarios                                                                                   
	_GeraEmail()       // Gera E-Mail para os usuarios JAS
endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01ENC ºAutor  ³Marcos Zanetti-1265 º Data ³  07/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Encerramento / Reabertura                        º±±
±±º          ³ O parametro _lEncerra indica se a OF sera encerrada (.T.)  º±±
±±º          ³ ou Reaberta (.F.)                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01ENC(_lEncerra)
dbSelectArea("SZ6")

If BOF() .And. EOF()
	Help("",1,"ARQVAZIO")
	Return
Endif

if SZD->(dbseek(xFilial("SZD")+__CUSERID)) .and. SZD->ZD_ENCOF == "S"
	if _lEncerra .and. !empty(SZ6->Z6_DTENC)
		msgstop("Esta OF ja esta encerrada.")
		return
	elseif !_lEncerra .and. empty(SZ6->Z6_DTENC)
		msgstop("Esta OF nao pode ser reaberta pois nao esta encerrada.")
		return
	endif
else
	msgstop("Usuario sem permissao para encerrar ou reabrir OF.")
	return
endif

// A funcao RegToMemory foi colocada fora da CRIAMOD3 pois ela cria variaveis privadas, que
// perdem a visibilidade com a saida da funcao CRIAMOD3 e eh preciso gravar SZ6 com os dados de M->
RegToMemory("SZ6",.F.)
if CRIAMOD3(2,.F.) .and. msgyesno(iif(_lEncerra , "Confirma encerramento da OF ?" ,"Confirma reabertura da OF ?" ))
	RecLock("SZ6",.F.)
	SZ6->Z6_DTENC := iif(_lEncerra , dDatabase , ctod("  /  /  ") )
	MsUnlock()
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01LEG ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de liberacao de OF                                  º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01LEG()

Local aLegenda    :={{  'BR_PRETO'	, "OF encerrada" },;
{  'DISABLE'	, "OF nao liberada" },;
{  'BR_AMARELO'	, "OF liberada pelo emitente" },;
{  'BR_AZUL'	, "OF liberada pela Gerencia de Vendas" },;
{  'ENABLE' 	, "OF liberada pela Gerencia Geral" }}

BrwLegenda("Status das OFs","Legenda" ,aLegenda)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01INC ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de OF - Inclusao de dados               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01INC()

Local _bCampo	:= { |_nCPO| Field(_nCPO) }
Local _cItem:="0000"
Local _aItens  :=""
Local _bItens  :={}
local _cStrAux:= ""
Local _cStrCod := ""
Local _cGrupo:=""
Local Grupo:=""
Private _aProds	:= {}

calias:=""


_LINCLUI 	:= .T.
_aCampos	:= {}

// A funcao RegToMemory foi colocada fora da CRIAMOD3 pois ela cria variaveis privadas, que
// perdem a visibilidade com a saida da funcao CRIAMOD3 e eh preciso gravar FOR com os dados de M->
RegToMemory("FOR",.T.)
//RegToMemory("FOI",.T.)

if CRIAMOD3(3,.T.)

	calias:="FOR"
	// Grava o registro em SZ6
	dbSelectArea("FOR") 
	RecLock("FOR",.T.)
		FOR_FILIAL:= cFilAnt
		FOR_NUM:= M->FOR_NUM
		FOR_COD:= M->FOR_COD
		FOR_LOJA:= M->FOR_LOJA
		FOR_NOME:= M->FOR_NOME	
		FOR_EMISSA:=M->FOR_EMISSA
		FOR_TIPO:=M->FOR_TIPO
		FOR_STATUS:='1' 

	MsUnlock()
	
	// Grava o conteudo do aCols no arquivo no SZ7
	for _ni := 1 to len(acols)
		if !(acols[_ni,len(aHeader)+1])
			_cItem := soma1(_cItem)           
			RecLock("FOI",.T.)
			FOI_FILIAL 	:= cFilAnt
			FOI_NUM		:= M->FOR_NUM
		   	FOI_ITEM := _cItem 
			FOI_CODFOR:=M->FOR_COD
			FOI_LOJA:=M->FOR_LOJA
			FOI_EMISSS:=M->FOR_EMISSA
			FOI_PRODUT:=aCols[_nI,2]
			FOI_DESCR:=aCols[_nI,3]
			FOI_UNIT:=0
			FOI_ENTRAD:=aCols[_nI,4]
			FOI_VENDAS:=0
			FOI_ANTERI:=0
			FOI_DEVOL:=0
			FOI_ENCALH:=0
			FOI_PERDAS:=0
			MsUnlock()		
			
			Grupo:=Posicione("SB1",1,xFilial("SB1")+aCols[_nI,2],"B1_GRUPO")

			if!empty(alltrim(_cGrupo))
			_cGrupo:=Grupo+"/"+_cGrupo
			
			else
			_cGrupo:=Grupo
			endif
						
			aadd(_bItens,{aCols[_nI,2],aCols[_nI,4]})
			if!empty(alltrim(_aItens))
			_aItens:=aCols[_nI,2]+","+_aItens
			
			
			else
			_aItens:=aCols[_nI,2]
			endif
		endif
	next _ni
	
	
	_cStrCod := _aItens

	If Select("TMP") > 0
			TMP->( DbCloseArea() )
	EndIf
		DO CASE
		CASE M->FOR_TIPO=='1'
		cQuery := "SELECT B6_PRODUTO, SUBSTRING(B1_DESC,1,30) AS DESCR, SUM(CASE WHEN B6_PODER3 = 'R' THEN B6_QUANT ELSE 0 END) CONSIGNACAO,"
		cQuery += _cEnter + " SUM(CASE WHEN B6_PODER3 = 'D' THEN B6_QUANT ELSE 0 END) DEVOLUCOES, AVG(B6_PRUNIT)AS B6_PRUNIT,"
		
		IF _cGrupo $ " 0005/0004/0006"
			cQuery += _cEnter + " COALESCE((SELECT SUM(D2_QUANT) "
			cQuery += _cEnter + " 			FROM "+RetSqlName("SD2")+" SD2 (NOLOCK) "
			cQuery += _cEnter + " 			WHERE D2_FILIAL 	= B6_FILIAL  AND D2_COD = B6_PRODUTO"
			cQuery += _cEnter + " 			AND ( D2_ORIGLAN 	= 'LO' OR D2_CLIENTE = '999999' )
			cQuery += _cEnter + " 			AND D2_EMISSAO 		>= ( SELECT TOP 1 F1_EMISSAO "
			cQuery += _cEnter + " 									FROM " + RetSqlname("SF1") + " SF1 "
			cQuery += _cEnter + " 									WHERE F1_FILIAL 	= '" + xFilial("SF1") + "'
			cQuery += _cEnter + " 									AND F1_FORNECE 		= '" + M->FOR_COD + "'
			cQuery += _cEnter + " 									AND F1_LOJA 		= '" + M->FOR_LOJA + "'"
			cQuery += _cEnter + " 									AND SF1.D_E_L_E_T_ 	= '' "
			cQuery += _cEnter + " 									ORDER BY F1_EMISSAO DESC ) "
			cQuery += _cEnter + " 			AND SD2.D_E_L_E_T_ 	= '' ),0) AS 'VENDAS' "
		Else
			cQuery += _cEnter + " COALESCE((SELECT SUM(D2_QUANT) "
			cQuery += _cEnter + " 			FROM "+RetSqlName("SD2")+" SD2 (NOLOCK) "
			cQuery += _cEnter + " 			WHERE D2_FILIAL 	= B6_FILIAL
			cQuery += _cEnter + " 			AND D2_COD 			= B6_PRODUTO "
			cQuery += _cEnter + " 			AND ( D2_ORIGLAN 	= 'LO' OR D2_CLIENTE = '999999' )
			cQuery += _cEnter + " 			AND SD2.D_E_L_E_T_ 	= '' ),0) AS 'VENDAS' "
		EndIf
		
		cQuery += _cEnter + " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK) "
		cQuery += _cEnter + " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
		cQuery += _cEnter + " 									ON B6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
		cQuery += _cEnter + " WHERE B6_FILIAL 		= '"+xFilial("SB6")+"'"
		cQuery += _cEnter + " AND B6_PRODUTO 		IN ( "+_cStrCod+" )"
		cQuery += _cEnter + 		" AND (B6_TES < '500' OR B6_TES in  " + FormatIn(alltrim(GetMv("MV_TESDCO")),',') + ")"
		cQuery += _cEnter + " AND B6_CLIFOR 		= '" + M->FOR_COD + "'"
		cQuery += _cEnter + " AND B6_LOJA 			= '" + M->FOR_LOJA+"'"
		cQuery += _cEnter + " AND B6_TPCF 			= 'F'"
		cQuery += _cEnter + " AND SB6.D_E_L_E_T_ 	= ''"
		
		cQuery += _cEnter + " GROUP BY B6_FILIAL, B6_PRODUTO, B1_DESC "
		
		CASE M->FOR_TIPO=='2'
				cQuery := "SELECT D1_COD AS B6_PRODUTO, SUBSTRING(B1_DESC,1,30) AS DESCR,SUM(CASE WHEN D1_TIPO = 'N' THEN D1_QUANT ELSE 0 END) CONSIGNACAO,"
		cQuery += _cEnter + " SUM(CASE WHEN D1_TIPO = 'D' THEN D1_QUANT ELSE 0 END) DEVOLUCOES, AVG(D1_VUNIT)AS B6_PRUNIT,"
		
			cQuery += _cEnter + " COALESCE((SELECT SUM(D2_QUANT) "
			cQuery += _cEnter + " 			FROM "+RetSqlName("SD2")+" SD2 (NOLOCK) "
			cQuery += _cEnter + " 			WHERE D2_FILIAL 	= D1_FILIAL
			cQuery += _cEnter + " 			AND D2_COD 			= D1_COD "
			cQuery += _cEnter + " 			AND ( D2_ORIGLAN 	= 'LO' OR D2_CLIENTE = '999999' )
			cQuery += _cEnter + " 			AND SD2.D_E_L_E_T_ 	= '' ),0) AS 'VENDAS' "
		
		cQuery += _cEnter + " FROM "+RetSqlName("SD1")+" SD1 (NOLOCK) "
		cQuery += _cEnter + " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
		cQuery += _cEnter + " 									ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
		cQuery += _cEnter + " WHERE D1_FILIAL 		= '"+xFilial("SD1")+"'"
		cQuery += _cEnter + " AND D1_COD 		IN ( "+_cStrCod+" )"
		cQuery += _cEnter + " AND D1_FORNECE 		= '" + M->FOR_COD + "'"
		cQuery += _cEnter + " AND D1_LOJA 			= '" + M->FOR_LOJA+"'"    
		cQuery += _cEnter + " AND D1_TES in  ('263') "
		cQuery += _cEnter + " AND SD1.D_E_L_E_T_ 	= ''"
		
		cQuery += _cEnter + " GROUP BY D1_FILIAL, D1_COD, B1_DESC "

ENDCASE

		MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQRY(,,cQuery ),"TMP",.T.,.T.)},'Selecionando informações...')
		
		DbSelectArea("TMP")
		Aadd(_aProds, {TMP->B6_PRODUTO, TMP->DESCR, TMP->B6_PRUNIT , TMP->CONSIGNACAO,	TMP->VENDAS, TMP->DEVOLUCOES, 0, 0,0 } )
		
		If !eof()
			_aProds := {}
		EndIf
		Do While TMP->( !Eof() )
			
			Aadd(_aProds, {TMP->B6_PRODUTO, TMP->DESCR, TMP->B6_PRUNIT , TMP->CONSIGNACAO,	TMP->VENDAS, TMP->DEVOLUCOES, 0, 0,0 } )
			TMP->( DbSkip() )
			
		EndDo
		For _nI := 1 To Len(_bItens)
		
		nPos := aScan(_aProds , {|x| x[1] == _bItens[_nI,1] })
		
		If nPos > 0
			_aProds[nPos,7] += _bItens[_nI,2]
			_aProds[nPos,8] :=  _aProds[nPos,4] - _aProds[nPos,5] - _aProds[nPos,6] - _aProds[nPos,7]
			_aProds[nPos,9] :=(_aProds[_nI,7]+_aProds[_nI,6]) / _aProds[_nI,4] * 100   
		EndIf
		
	Next _nI

	_cItem:="0000"
	
	for _ni := 1 to len(_aProds)
			
			_cItem := soma1(_cItem)           
			
			RecLock("FOI",.F.)
			FOI_FILIAL 	:= cFilAnt
			FOI_NUM		:= M->FOR_NUM
		   	FOI_ITEM := _cItem 
			FOI_CODFOR:=M->FOR_COD
			FOI_LOJA:=M->FOR_LOJA
			FOI_PRODUT:=_aProds[_nI,1]
			FOI_UNIT:=_aProds[_nI,3]
			FOI_VENDAS:=_aProds[_nI,5]
			FOI_ANTERI:=_aProds[_nI,6]
			FOI_DEVOL:=_aProds[_nI,7]
			FOI_ENCALH:=_aProds[_nI,9]
			FOI_PERDAS:=_aProds[_nI,8]
			MsUnlock()		

	next _ni
	

endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01ALT ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de OF - Alteracao de dados              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01ALT(cAlias,nReg,nOpc)
  Local nQtdcpo 	:= 0
    Local i			:= 0
    Local nCols 	:= 0
	Local aButtons	:= {}       
nUsado:=0     

dbSelectArea('TRB')
dbSetOrder(1)           
While !Eof().And. nReg==TRB->R_E_C_N_O_
M->FOR_FILIAL:=TRB->FOR_FILIAL
M->FOR_NUM:= TRB->FOR_NUM
M->FOR_EMISSA:=TRB->FOR_EMISSA
M->FOR_COD:=TRB->FOR_COD
M->FOR_LOJ:=TRB->FOR_LOJ
M->FOR_TIPO:=TRB->FOR_TIPO
M->FOR_STATUS:=TRB->FOR_STATUS
	dbSkip()
	
Enddo


DbSelectArea("SX3")
SX3->(DbGotop())
SX3->(DbSetorder(1))
dbSeek("FOI")
aHeader:={}
While !Eof().And.(SX3->X3_ARQUIVO=="FOI")
	
	If Alltrim(SX3->X3_CAMPO) $ "FOI_FILIAL"
		dbSkip()
		Loop
	Endif
	
	If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
		nUsado ++
		Aadd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, ;
		X3_DECIMAL,X3_VLDUSER,X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
	Endif
 	
	dbSkip()
	
Enddo

    
    nQtdcpo 		:= len(aHeader)
    aCols			:= {}

 dbselectarea(cAlias2)
    dbsetorder(1)
    dbseek(xfilial(cAlias2)+(cAlias1)->FOR_NUM)
    while .not. eof() .and. (cAlias2)->FOI_FILIAL == xfilial(cAlias2) .and. (cAlias2)->FOI_NUM==(cAlias1)->FOR_NUM
        aAdd(aCols,array(nQtdcpo+1))
        nCols++
        for i:= 1 to nQtdcpo
            if aHeader[i,10] <> "V"
                aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
            else
                aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
            endif
        next i
        aCols[nCols,nQtdcpo+1] := .F.
        dbselectarea(cAlias2)
        dbskip()

    enddo    

	cTitulo:="Cadastro de Perdas"
	cAliasEnchoice:="FOR"
	cAliasGetD:="FOI"
	cLinOk:="AllwaysTrue()" 
	cTudOk:="AllwaysTrue()" 
	cFieldOk:="AllwaysTrue()" 
	aCpoEnchoice:={}
_nOpcEG:=4 
_nOpPcEG:=4
	nResW := oMainWnd:nClientWidth - 6                                                                      
	nResH := oMainWnd:nClientHeight - 1

    	_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,_nOpPcEG,_nOpcEG,cFieldOk, , 200, , ,aButtons, {6, 1,nResH,nResW},200)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01EXC ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de OF - Exclusao de dados               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOF01EXC()

dbSelectArea("SZ6")
If BOF() .And. EOF()
	Help("",1,"ARQVAZIO")
	Return
Endif

if !empty(SZ6->Z6_DTENC)
	msgstop("Essa OF nao pode ser excluida pois esta encerrada.")
	return
endif

_cQuery := " SELECT COUNT(*) QTDREG"
_cQuery += " FROM " + RetSQLName("SD2") + " SD2, "
_cQuery += " " + RetSQLName("SZ6") + " SZ6, "
_cQuery += " " + RetSQLName("SZ7") + " SZ7"
_cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ7.D_E_L_E_T_ = ' '"
_cQuery += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "'"
_cQuery += " AND SZ6.Z6_NUM = '" + SZ6->Z6_NUM + "'"
_cQuery += " AND SZ6.Z6_NUM = SZ7.Z7_OF"
_cQuery += " AND SZ7.Z7_NUMPV = SD2.D2_PEDIDO AND SZ7.Z7_ITEMPV = SD2.D2_ITEMPV"
_cQuery += " AND SZ7.Z7_NUMPV <> ' '"

TcQuery _cQuery New Alias "QRY"
_lContinua := QRY->QTDREG == 0
QRY->(dbclosearea())

if !_lContinua
	msgstop("Essa OF não pode ser excluída pois gerou pedidos de venda que já foram faturados.")
	return
endif

// A funcao RegToMemory foi colocada fora da CRIAMOD3 pois ela cria variaveis privadas, que
// perdem a visibilidade com a saida da funcao CRIAMOD3 e eh preciso gravar SZ6 com os dados de M->
RegToMemory("SZ6",.F.)
if CRIAMOD3(2,.F.) .and. msgyesno("Confirma a exclusao da OF e dos seguintes cadastros relacionados? "+ chr(13)+chr(10)+;
	"- Documentacao para cliente "+ chr(13)+chr(10)+;
	"- Entregas  "+ chr(13)+chr(10)+;
	"- Eventos  "+ chr(13)+chr(10)+;
	"- Garantias financeiras "+ chr(13)+chr(10)+;
	"- Multas e penalidades"+ chr(13)+chr(10)+;
	"- Budget")
	
	if SZ7->(dbSeek(xFilial("SZ7")+M->Z6_NUM))
		While SZ7->(!eof()) .and. SZ7->Z7_OF == M->Z6_NUM
			
			// Efetua a exclusao do pedido de venda
			if SZ7->Z7_GERAPV == "S" .and. !empty(alltrim(SZ7->Z7_NUMPV)) // Se ja tem PV
				// Chama a funcao de exclusao de PV
				U_POF02(SZ7->Z7_OF, SZ7->Z7_ITEM, SZ7->Z7_NUMPV, SZ7->Z7_ITEMPV, 3)
			endif
			
			RecLock("SZ7",.F.)
			SZ7->(dbdelete())
			MsUnlock()
			SZ7->(dbskip())
			
		Enddo
	endif
	
	if SZ8->(dbSeek(xFilial("SZ8")+M->Z6_NUM))
		While SZ8->(!eof()) .and. SZ8->Z8_OF == M->Z6_NUM
			RecLock("SZ8",.F.)
			SZ8->(dbdelete())
			MsUnlock()
			SZ8->(dbskip())
		Enddo
	endif
	
	if SZ9->(dbSeek(xFilial("SZ9")+M->Z6_NUM))
		While SZ9->(!eof()) .and. SZ9->Z9_OF == M->Z6_NUM
			RecLock("SZ9",.F.)
			SZ9->(dbdelete())
			MsUnlock()
			SZ9->(dbskip())
		Enddo
	endif
	
	if SZA->(dbSeek(xFilial("SZA")+M->Z6_NUM))
		While SZA->(!eof()) .and. SZA->ZA_OF == M->Z6_NUM
			RecLock("SZA",.F.)
			SZA->(dbdelete())
			MsUnlock()
			SZA->(dbskip())
		Enddo
	endif
	
	if SZB->(dbSeek(xFilial("SZB")+M->Z6_NUM))
		While SZB->(!eof()) .and. SZB->ZB_OF == M->Z6_NUM
			RecLock("SZB",.F.)
			SZB->(dbdelete())
			MsUnlock()
			SZB->(dbskip())
		Enddo
	endif
	
	if SZO->(dbSeek(xFilial("SZO")+M->Z6_NUM))
		While SZO->(!eof()) .and. SZO->ZO_OF == M->Z6_NUM
			RecLock("SZO",.F.)
			SZO->(dbdelete())
			MsUnlock()
			SZO->(dbskip())
		Enddo
	endif
	
	if SZJ->(dbSeek(xFilial("SZJ")+M->Z6_NUM))
		While SZJ->(!eof()) .and. SZJ->ZJ_OF == M->Z6_NUM
			RecLock("SZJ",.F.)
			SZJ->(dbdelete())
			MsUnlock()
			SZJ->(dbskip())
		Enddo
	endif
	
	if SZC->(dbSeek(xFilial("SZC")+M->Z6_NUM))
		While SZC->(!eof()) .and. SZC->ZC_OF == M->Z6_NUM
			if !empty(SZC->ZC_TITULO)
				U_ExcSE1()  // Exclusao do titulo
			endif
			RecLock("SZC",.F.)
			SZC->(dbdelete())
			MsUnlock()
			SZC->(dbskip())
		Enddo
	endif
	
	RecLock("SZ6",.F.)
	SZ6->(dbdelete())
	MsUnlock()
	
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRIAMOD3 ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao das variaveis para o modelo 3 (Enchoice e Acols)   º±±
±±º          ³ Parametros da rotina 									  º±±
±±º          ³ _nOpcEG - indica o metodo de acesso                        º±±
±±º          ³     2- Nao Permite Alteracao dos dados                     º±±
±±º          ³     3- Permite Alteracao dos dados                         º±±
±±º          ³ _lNew - indica se sera criado um novo registro (.T.)       º±±
±±º          ³ ou sera carregado o corrente (.F.)                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CRIAMOD3(_nOpcEG,_lNew)

Local aButtons	:= {}
lOCAL cAlias:="FOR"

//+--------------------------------------------------------------+
//¦ Cria aHeader e aCols da GetDados                             ¦
//+--------------------------------------------------------------+

nUsado:=0
DbSelectArea("SX3")
SX3->(DbGotop())
SX3->(DbSetorder(1))
dbSeek("FOI")
aHeader:={}
While !Eof().And.(SX3->X3_ARQUIVO=="FOI")
	
	If Alltrim(SX3->X3_CAMPO) $ "FOI_FILIAL"
		dbSkip()
		Loop
	Endif
	
	If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
		nUsado ++
		Aadd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, ;
		X3_DECIMAL,X3_VLDUSER,X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
	Endif
 	
	dbSkip()
	
Enddo

If _lNew
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
M->FOR_FILIAL:=cFilAnt 
M->FOI_FILIAL:=cFilAnt 
//M->FOR_NUM:= GETSXENUM( "FOR", "FOR_NUM", "FOR",1, cFilAnt)                                                                                                                 
//M->FOI_NUM		:= GETSXENUM( "FOR", "FOR_NUM", "FOR",1, cFilAnt)                                                                                                                 
M->FOR_NUM:= M->FOR_NUM
M->FOI_NUM		:= M->FOR_NUM
M->FOI_EMISSS	:=M->FOR_EMISSA
M->FOI_CODFOR:=M->FOR_COD
M->FOI_LOJA:=M->FOR_LOJA
Else

	aCols:={}
	dbSelectArea("FOI")                         
	FOI->(DbSetOrder(1))
	dbSeek(xFilial("FOI")+M->FOR_NUM)                                
	While !eof() .and. FOI->FOI_NUM == M->FOR_NUM
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1] := .F.
		dbSkip()
	End
Endif                                 



// Executa a Modelo 3
If Len(aCols)>0
	
	cTitulo:="Cadastro de Perdas"
	cAliasEnchoice:="FOR"
	cAliasGetD:="FOR"
	cLinOk:="AllwaysTrue()" 
	cTudOk:="AllwaysTrue()" 
	cFieldOk:="AllwaysTrue()" 

	nResW := oMainWnd:nClientWidth - 6                                                                      
	nResH := oMainWnd:nClientHeight - 1
	
	_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,_nOpPcEG,_nOpcEG,cFieldOk, , 200, , ,aButtons, {6, 1,nResH,nResW},200)
	////////////////////////////////////////////////////
Else                                                                                                                                                              

	msgstop("Erro")
	_lRet := .F.
Endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_GeraEmailºAutor  ³Marcos Zanetti 1265 º Data ³  04/03/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o email com os prinicipais dados da OF.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                                                                                                        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _GeraEmail()

local _cSerMail		:= alltrim(GetMV("MV_RELSERV"))
local _cConta  		:= alltrim(GetMV("MV_RELACNT"))
local _cSenha		:= alltrim(GetMV("MV_RELPSW"))
local _lEnviado		:= .F.
local _lConectou	:= .F.
local _cMailError	:= ""

local _cRemet		:= ""
local _cDest		:= ""
local _cCC			:= ""
local _cAssunto		:= "Mensagem automatica - OF " + SZ6->Z6_NUM
local _cBody		:= U_GeraHTML(SZ6->Z6_NUM)

local _cStatus		:= ""
local _cErroDest	:= ""

//local _cBody		:= "Teste de email do protheus " + dtoc(date()) + " as " + time()

if SZ9->(dbseek(xFilial("SZ9")+SZ6->Z6_NUM))
	while SZ9->(!eof()) .and. SZ9->Z9_OF == SZ6->Z6_NUM
		_cAssunto := "Mensagem automatica - OF " + SZ6->Z6_NUM + " - Rev. " + SZ9->Z9_REVISAO
		SZ9->(dbskip())
	enddo
endif


// Define o remetente do email. Se o usuario possuir o email cadastrado
// usa esse endereco, senao usa a conta do proprio Protheus
PswOrder(1)
If PswSeek(__CUSERID)
	_cRemet	:=	alltrim(PswRet(1)[1][14])
EndIf
if empty(_cRemet)
	_cRemet := _cConta
endif
/*
SZD->(dbgotop())
while SZD->(!eof())
if SZD->ZD_RECMAIL == "S" .and. !empty(alltrim(SZD->ZD_EMAIL))
_cDest += iif(empty(alltrim(_cDest)),"",",") + alltrim(SZD->ZD_EMAIL)
endif
SZD->(dbskip())
enddo
*/
// Conecta ao servidor de email
CONNECT SMTP SERVER _cSerMail ACCOUNT _cConta PASSWORD _cSenha Result _lConectou

if !(_lConectou)
	// Se nao conectou ao servidor de email, avisa ao usuario
	GET MAIL ERROR _cMailError
	MsgBox("Nao foi possivel conectar ao Servidor de email."+chr(13)+chr(10)+;
	"Procure o Administrador da rede."+chr(13)+chr(10)+;
	"Erro retornado: "+_cMailError)
	
else
	
	SZD->(dbgotop())
	while SZD->(!eof())
		
		if SZD->ZD_RECMAIL == "S" .and. !empty(alltrim(SZD->ZD_EMAIL))
			
			_cDest += iif(empty(alltrim(_cDest)),"",",") + alltrim(SZD->ZD_EMAIL)
			
			SEND MAIL FROM alltrim(_cRemet) ;
			To alltrim(SZD->ZD_EMAIL) ;
			SUBJECT	alltrim(_cAssunto) ;
			Body _cBody FORMAT TEXT RESULT _lEnviado
			
			/*
			SEND MAIL FROM alltrim(_cRemet) ;
			To alltrim(_cDest) ;
			Cc alltrim(_cCc) ;
			SUBJECT	alltrim(_cAssunto) ;
			Body _cBody FORMAT TEXT RESULT _lEnviado
			*/
			
			if !(_lEnviado)
				GET MAIL ERROR _cMailError
				_cErroDest += alltrim(SZD->ZD_EMAIL) + chr(13) + chr(10)
				_cStatus := "ERRO"
				/*
				MsgBox("Nao foi possivel enviar o email." + chr(13) + chr(10) +;
				"Procure o Administrador da rede." + chr(13) + chr(10) +;
				"Erro retornado: " + _cMailError + chr(13) + chr(10) +;
				"Destinatario: " + alltrim(SZD->ZD_EMAIL))
				*/
			else
				_cStatus := "OK"
			endif
			
			Reclock("SZL",.T.)
			SZL->ZL_FILIAL	:= xFilial("SZL")
			SZL->ZL_OF		:= SZ6->Z6_NUM
			SZL->ZL_USUARIO	:= SZD->ZD_NOME
			SZL->ZL_DATA	:= date()
			SZL->ZL_HORA	:= time()
			SZL->ZL_EMAIL	:= alltrim(SZD->ZD_EMAIL)
			SZL->ZL_STATUS	:= _cStatus
			MsUnlock()
			
		endif
		
		SZD->(dbskip())
		
	enddo
	
	if !empty(_cErroDest)
		MsgBox("Nao foi possivel enviar o email." + chr(13) + chr(10) +;                                                       
		"Procure o Administrador da rede." + chr(13) + chr(10) +;
		"Erro retornado: " + _cMailError + chr(13) + chr(10) +;
		"Destinatarios: " + chr(13) + chr(10)+_cErroDest)
	endif
	
	DISCONNECT SMTP SERVER
	
endif

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AOF01ALT ºAutor  ³Marcos Zanetti-1265 º Data ³  14/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de OF - Alteracao de dados              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function AOFMEN()
private _cNumPV		:= ""

U_ManMOF(SZ6->Z6_NUM,"  ",.F.,.T.,"OF") 

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AOF01Pln  ºAutor  ³ Anderson Silva     º Data ³  30/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de importacao dos dados a partir a planilha excel    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                    

User Function AOF01Pln()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cArq			:= ""
Local cPerg			:= "AUDEGH01"
Local cType			:=	"Arquivos XLS|*.XLS|Todos os Arquivos|*.*"
Local aParams		:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10,MV_PAR11,MV_PAR12,MV_PAR13,MV_PAR14,MV_PAR15}
Local nX			:= 0
Local aDadosPlan	:= {}
Local aRegs			:= {}
Local aArea			:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona o arquivo                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq := cGetFile(cType, OemToAnsi("Selecione a planilha excel para importação."),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE)
If Empty(cArq)
	Aviso("Inconsistência","Selecione a planilha excel para importação.",{"Ok"},,"Atenção:")
	Return()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os parametros da rotina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aRegs,{cPerg,"01","Folder Planilha ?"		,"","","mv_ch1","C",30,0,0,"G","NaoVazio()","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Seleciona Produtos?"	,"","","mv_ch2","N",01,0,2,"C","","mv_par02","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","S","","",""})
Aadd(aRegs,{cPerg,"03","Ordenação?"				,"","","mv_ch3","N",01,0,2,"C","","mv_par03","Planilha","","","","","Artigo","","","","","Descrição","","","","","","","","","","","","","","","S","","",""})
Aadd(aRegs,{cPerg,"04","Linhas Planilha ?"		,"","","mv_ch4","N",05,0,0,"G","NaoVazio()","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
CriaSx1(aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os parametros originais                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Pergunte(cPerg,.T.)
	For nX := 1 to Len(aParams)
		&("MV_PAR"+StrZero(nX,2)) := aParams[nX]
	Next nX
	RestArea(aArea)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Importa a planilha excel                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDadosPlan	:= U_GetExcel(cArq,Alltrim(MV_PAR01),"A2","L"+Alltrim(Str(MV_PAR04)))
TelaImpExc(aDadosPlan,cArq)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TelaImpExc ºAutor  ³ Anderson Silva     º Data ³ 31/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de exibicao dos dados da planilha excel importada      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TelaImpExc(aDadosPlan,cArqExcel)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpcConf		:= 0
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aCposGet		:= {}                                                             
Local nOpcA			:= 0
Local oFont8		:= TFont():New("Arial",6.5,15,.T.,.T.,5,.T.,5,.T.,.F.)
Local oFont12N		:= TFont():New("Arial",12,15,.T.,.T.,5,.T.,5,.T.,.F.)
Local nX			:= 0                                                                       
Local nY			:= 0                                                                       
//Local aTitLBox		:= {"","Artigo","Descrição","Dimensão","Material","Peso","Desenho","Norma","Quantidade","Produto","Operação","Nro. SC","Nro. PC","Operação"}
Local aTitLBox		:= {"","Nivel","Item","Artigo","Descrição","Dimensão","Peso","Desenho","Material","Norma","Quantidade","Produto","Operação","Nro. SC","Nro. PC","Operação"}
Local nPosArr		:= 0
Local aArea			:= GetArea()
Local oFldImp		:= Nil                                                                                                                                        
Local aListaExcel	:= {}
Local nLoop			:= 0
Local oOk 			:= LoadBitmap( GetResources(), "LBOK" )
Local oNo 			:= LoadBitmap( GetResources(), "LBNO" )
Local aDadosProd	:= {"","",""}
Local cQuery		:= ""
Local aDadosSC		:= {"","","",0}
Local _cniveltmp:=""
Private oListBox	:= Nil
Private oDlgMain	:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza o processamento das linhas do excel           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CursorWait()
For nLoop := 1 to Len(aDadosPlan)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a linha eh valida                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//_cniveltmp:=" "
	If Empty(aDadosPlan[nLoop,11])
		Loop
	Endif
	
    If Alltrim(aDadosPlan[nLoop,1])="0.1.4.14" .Or.  Alltrim(aDadosPlan[nLoop,1])="0.2" .or.  Alltrim(aDadosPlan[nLoop,1])="0.6"
      _parada:=.T.      
   EndIf
	
	                            
	//Rastreia o NIVEL 
	If Empty(aDadosPlan[nLoop,01])  .And.  nLoop>1
	    For _pniv:=nLoop to 1 Step-1
	        If !Empty(aDadosPlan[nLoop,01])
	           _cniveltmp:=aDadosPlan[_pniv,01]
	           Exit
	        EndIf
	    Next _pniv
	 Else
	    _cniveltmp:=aDadosPlan[nLoop,01]
	 EndIf  
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define os dados do produto                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDadosProd		:= {"","","",0,""}                                                         // jasproduto
	aDadosProd[1]	:= Alltrim(Upper(aDadosPlan[nLoop,11]))
	aDadosProd[3]	:= Alltrim(Upper(aDadosPlan[nLoop,4]))                                                                                                        
	aDadosProd[5]	:= Alltrim(Upper(aDadosPlan[nLoop,4]))
	If !Empty(aDadosPlan[nLoop,5])
		aDadosProd[3]	+= "|"+Alltrim(Upper(aDadosPlan[nLoop,5]))
		aDadosProd[5]	+= "|DIM:"+Alltrim(Upper(aDadosPlan[nLoop,5]))
	Endif	
	If !Empty(aDadosPlan[nLoop,6])
		aDadosProd[3]	+= "|"+Alltrim(Upper(aDadosPlan[nLoop,6]))
		aDadosProd[5]	+= "|MAT:"+Alltrim(Upper(aDadosPlan[nLoop,6]))
	Endif	
	If !Empty(aDadosPlan[nLoop,7])
		aDadosProd[3]	+= "|"+Alltrim(Upper(aDadosPlan[nLoop,7]))
		aDadosProd[5]	+= "|NOR:"+Alltrim(Upper(aDadosPlan[nLoop,7]))
	Endif	
	aDadosProd[3] := StrTran(StrTran(aDadosProd[3],"'"," "),'"',' ')
	aDadosProd[5] := StrTran(StrTran(aDadosProd[5],"'"," "),'"',' ')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se o produto existe                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT ISNULL(SB1.R_E_C_N_O_ ,0) AS RECSB1"	
	cQuery += " FROM "+RetSqlName("SB1")+" SB1 (NOLOCK)"
	cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND LEFT(B1_COD,"+Alltrim(Str(Len(Alltrim(aDadosPlan[nLoop,11]))))+") = '"+Alltrim(Upper(aDadosPlan[nLoop,11]))+"'"
	cQuery += " AND RTRIM(B1_DESCRCO) = '"+aDadosProd[5]+"'"
	cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
	cQuery += " ORDER BY B1_COD DESC"
	cQuery := ChangeQuery(cQuery)
	If Select("QRYTRB") > 0
		DbSelectArea("QRYTRB")
		DbCloseArea()
	Endif
	TcQuery cQuery New Alias "QRYTRB"
	DbSelectArea("QRYTRB")
	DbGoTop()
	If !EOF()                                                    
		If QRYTRB->RECSB1 > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona no SB1                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SB1")
			DbGoTo(QRYTRB->RECSB1)                                                                                                                       
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Salva os dados do produto localizado                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDadosProd[2] := SB1->B1_COD
			aDadosProd[4] := QRYTRB->RECSB1
		Endif
	Endif                                                              
	If Select("QRYTRB") > 0
		DbSelectArea("QRYTRB")
		DbCloseArea()
	Endif
	
	aDadosSC := {"","","",0}                                                                              
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se existe a Solicitacao de Compras             ³              
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aDadosProd[4] > 0                                                                //If  Alltrim(aDadosProd[4])="0.1.4.14"  .Or. 
		cQuery := " SELECT ISNULL(SC1.R_E_C_N_O_ ,0) AS RECSC1"	
		cQuery += " FROM "+RetSqlName("SC1")+" SC1 (NOLOCK)"
		cQuery += " WHERE C1_FILIAL = '"+xFilial("SC1")+"'"
		cQuery += " AND C1_PRODUTO = '"+aDadosProd[2]+"'"
		cQuery += " AND C1_XOF = '"+SZ6->Z6_NUM+"'"
		//cQuery += " AND C1_NIVELP = '"+_cniveltmp+"'"
		//cQuery += " AND	C1_NIVELP LIKE '%" +alltrim(_cniveltmp) + "%'"
		cQuery += " AND	C1_NIVELP LIKE  '"+Iif(Empty(alltrim(_cniveltmp)),'','%')+alltrim(_cniveltmp)+Iif(Empty(alltrim(_cniveltmp)),'','%')+"'"
		cQuery += " AND C1_QUJE = 0"                                                                                                                  
		cQuery += " AND SC1.D_E_L_E_T_ <> '*'"
		cQuery += " ORDER BY C1_EMISSAO"                                                                              
		cQuery := ChangeQuery(cQuery)
		If Select("QRYTRB") > 0
			DbSelectArea("QRYTRB")
			DbCloseArea()
		Endif                                                                                                                                           
		TcQuery cQuery New Alias "QRYTRB"
	
		aDadosSC := {"","","",0}
		DbSelectArea("QRYTRB")
		DbGoTop()
		If !EOF()                                                    
			If QRYTRB->RECSC1 > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona no SC1                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SC1")
				DbGoTo(QRYTRB->RECSC1)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Salva os dados da SC localizada                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aDadosSC[1] 	:= SC1->C1_NUM
				aDadosSC[4] 	:= QRYTRB->RECSC1
			Endif
		Endif
		If Select("QRYTRB") > 0
			DbSelectArea("QRYTRB")
			DbCloseArea()
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Localiza SC com pedidos de compra existentes          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aDadosSC[4] == 0
			cQuery := " SELECT ISNULL(SC1.R_E_C_N_O_ ,0) AS RECSC1"	
			cQuery += " FROM "+RetSqlName("SC1")+" SC1 (NOLOCK)"
			cQuery += " WHERE C1_FILIAL = '"+xFilial("SC1")+"'"
			cQuery += " AND C1_PRODUTO = '"+aDadosProd[2]+"'"
			cQuery += " AND C1_XOF = '"+SZ6->Z6_NUM+"'"
			cQuery += " AND	C1_NIVELP LIKE  '"+Iif(Empty(alltrim(_cniveltmp)),'','%')+alltrim(_cniveltmp)+Iif(Empty(alltrim(_cniveltmp)),'','%')+"'"
			//cQuery += " AND C1_NIVELP = '"+_cniveltmp+"'"
			cQuery += " AND C1_QUJE > 0"
			cQuery += " AND SC1.D_E_L_E_T_ <> '*'"
			cQuery += " ORDER BY C1_EMISSAO DESC"
			cQuery := ChangeQuery(cQuery)
			If Select("QRYTRB") > 0
				DbSelectArea("QRYTRB")
				DbCloseArea()
			Endif
			TcQuery cQuery New Alias "QRYTRB"
		
			aDadosSC := {"","","",0}
			DbSelectArea("QRYTRB")
			DbGoTop()
			If !EOF()                                                    
				If QRYTRB->RECSC1 > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona no SC1                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SC1")
					DbGoTo(QRYTRB->RECSC1)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva os dados da SC localizada                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDadosSC[1] 	:= SC1->C1_NUM
					aDadosSC[2] 	:= SC1->C1_PEDIDO
					aDadosSC[3] 	:= SC1->C1_ITEMPED
					aDadosSC[4] 	:= QRYTRB->RECSC1
				Endif
			Endif
			If Select("QRYTRB") > 0                                                                                                                                     
				DbSelectArea("QRYTRB")
				DbCloseArea()
			Endif
			
		Endif
	Endif
		                                               
   If Alltrim(aDadosPlan[nLoop,1])="0.1.4.14" .Or.  Alltrim(aDadosPlan[nLoop,1])="0.2" .or.  Alltrim(aDadosPlan[nLoop,1])="0.6"
      _parada:=.T.      
   EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no array de exibicao                         ³                                                                                                                                 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aListaExcel,{	Iif(MV_PAR02 == 1,.T.,.F.),;														//1. Selecao
	                    aDadosPlan[nLoop,1],;	   														           //2 . Nivel
	                    aDadosPlan[nLoop,2],;	   														           //3 . Item
						Upper(Alltrim(aDadosPlan[nLoop,11])),;												//4. Artigo
						Upper(Alltrim(aDadosPlan[nLoop,4])),;												//5. Descricao do Produto
						Upper(Alltrim(aDadosPlan[nLoop,5])),;												//6. Dimensao
						Upper(Alltrim(aDadosPlan[nLoop,09])),;												//7. Sub.Kg // jas
						Upper(Alltrim(aDadosPlan[nLoop,12])),;											//8. Desenho
						Upper(Alltrim(aDadosPlan[nLoop,6])),;												//9. Material
						Upper(Alltrim(aDadosPlan[nLoop,7])),;												//10. Norma
						Val(aDadosPlan[nLoop,3]),;	   														//11. Quantidade
						aDadosProd[2],;																		//12. Produto Protheus
						Iif(aDadosProd[4] == 0,"Novo Produto","Revisão"),;									//13. Operacao com o Produto
						aDadosSC[1],;																		//14. Numero da SC
						Iif(!Empty(aDadosSC[2]),aDadosSC[2]+"-"+aDadosSC[3],""),;							//15. Numero do PC
						Iif(aDadosSC[4] == 0 .or. (aDadosSC[4] > 0 .and. !Empty(aDadosSC[3])),"Inclusão SC",IIf(aDadosSC[4] > 0 .and. Empty(aDadosSC[3]),"Revisão SC","")),;	//12. Operacao com a SC
						aDadosProd[4],;																		//13. Recno SB1
						aDadosProd[3],;																		//14. Descricao do Produto
						aDadosProd[5],;																		//15. Descricao Completa do Produto
						aDadosSC[4],;																		//16. Recno SC1
						0,;																					//17. Recno SC7                                                          
						Alltrim(aDadosPlan[nLoop,09])})														//18. SUB (kg)
Next nLoop                                                                                                                                                                     
CursorArrow()
If Len(aListaExcel) == 0                                                                                                                                                                                        
	Aviso("Inconsistencia","Não foram localizados produtos para importação na planilha selecionada.",{"Sair"},,"Atenção:")
	Return                                                                                                                                                                                       
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordena os produtos                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR03 == 2
	aListaExcel := ASort(aListaExcel, , , { |x,y| x[4] <= y[4] } )	
ElseIf MV_PAR03 == 3
	//aListaExcel := ASort(aListaExcel, , , { |x,y| x[3]+x[4]+x[5]+x[6] <= y[3]+y[4]+y[5]+y[6] } )	
	aListaExcel := ASort(aListaExcel, , , { |x,y| x[5]+x[6]+x[9]+x[10] <= y[5]+y[6]+y[9]+y[10] } )	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 
	
oDlgMain := TDialog():New(aSize[7],00,aSize[6],aSize[5],OemToAnsi("Importação Excel"),,,,,,,,oMainWnd,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os folders da tela                                              		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFldImp	:= TFolder():New(aPosObj[1,1],aPosObj[1,2],{"Lista de Produtos"},,oDlgMain,,,,.T.,.T.,(aPosObj[1,4]-aPosObj[1,2]),((aPosObj[1,3]-aPosObj[1,1])))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o listbox de linhas lidas do excel                               		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 000,000 LISTBOX oListBox VAR cListBox ;
	Fields HEADER 	aTitLBox[01],;
	                aTitLBox[02],;
	                aTitLBox[03],;
					aTitLBox[04],;
					aTitLBox[05],;
					aTitLBox[06],;
					aTitLBox[07],;
					aTitLBox[08],;
					aTitLBox[09],;                                                  
					aTitLBox[10],;
					aTitLBox[11],;
					aTitLBox[12],;
					aTitLBox[13],;
					aTitLBox[14],;
					aTitLBox[15],;
					aTitLBox[16] ;
	OF oFldImp:aDialogs[1] PIXEL SIZE  (oFldImp:aDialogs[1]:nClientWidth/2),(oFldImp:aDialogs[1]:nClientHeight/2) ;
	ON DBLCLICK (Fselitem(aListaExcel,oListBox:nAt),aListaExcel[oListBox:nAt,1] := !aListaExcel[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL
oListBox:SetArray(aListaExcel)
oListBox:bLine 		:= {||{	If(aListaExcel[oListBox:nAt,1],oOk,oNo),;
                            aListaExcel[oListBox:nAt,2],;
                            aListaExcel[oListBox:nAt,3],;                                                                     
							aListaExcel[oListBox:nAt,4],;
							aListaExcel[oListBox:nAt,5],;
							aListaExcel[oListBox:nAt,6],;
							aListaExcel[oListBox:nAt,7],;
							aListaExcel[oListBox:nAt,8],;
							aListaExcel[oListBox:nAt,9],;
							aListaExcel[oListBox:nAt,10],;
							Transform(aListaExcel[oListBox:nAt,11],"@E 9,999,999.9999"),;
							aListaExcel[oListBox:nAt,12],;
							aListaExcel[oListBox:nAt,13],;
							aListaExcel[oListBox:nAt,14],;
							aListaExcel[oListBox:nAt,15],;
							aListaExcel[oListBox:nAt,16]}}

oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| (nOpcA := 1,oDlgMain:End())},{||(nOpcA := 0,oDlgMain:End())},,)})

If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava os dados importados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CursorWait()
	LjMsgRun(OemToAnsi("Aguarde, incluindo produtos e solicitações de compra..."),, {|| GravaDados(aListaExcel,cArqExcel), CLR_HRED } )
	CursorArrow()
Endif

RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaDadosºAutor  ³ Anderson Silva     º Data ³  31/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de efetivacao da gravacao dos dados da importacao    º±±
±±º          ³excel                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GravaDados(aListaExcel,cArqExcel)	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLoop			:= 0                                                                       
Local nLoopProd		:= 0                                                                       
Local cQuery		:= ""
Local aCodProd		:= {"",0}
Local cNumSC		:= ""
Local aDadosSC		:= {}
Local nPosSC		:= 0
Local nPosProd		:= 0   
Local _cniveltmp   :=""

For nLoop := 1 to Len(aListaExcel)	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se esta selecionado pelo usuario                             		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aListaExcel[nLoop,1] 
		Loop
	Endif
	
	
	//Rastreia o NIVEL 
	If Empty(aListaExcel[nLoop,02])  .And.  nLoop>1
	    For _pniv:=nLoop to 1 Step-1
	        If !Empty(aListaExcel[nLoop,02])
	           _cniveltmp:=aListaExcel[_pniv,02]
	           Exit
	        EndIf
	    Next _pniv
	 Else
	    _cniveltmp:=aListaExcel[nLoop,02]
	 EndIf  
	
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a inclusao do novo produto                                    		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aListaExcel[nLoop,17] == 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Retorna o ultimo produto da sequencia do artigo       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := " SELECT ISNULL(MAX(B1_COD),'') AS B1_COD"	
		cQuery += " FROM "+RetSqlName("SB1")+" SB1 (NOLOCK)"
		cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " AND LEFT(B1_COD,"+Alltrim(Str(Len(Alltrim(aListaExcel[nLoop,4]))))+") = '"+Alltrim(Upper(aListaExcel[nLoop,4]))+"'"
		cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
		cQuery := ChangeQuery(cQuery)
		If Select("QRYTRB") > 0
			DbSelectArea("QRYTRB")
			DbCloseArea()
		Endif
		TcQuery cQuery New Alias "QRYTRB"
                                                                    
		aCodProd := {Alltrim(Upper(aListaExcel[nLoop,4])),"00"}
		DbSelectArea("QRYTRB")
		DbGoTop()
		If !EOF()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Salva os dados do produto localizado                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(QRYTRB->B1_COD)
				aCodProd[2] := "00"
			Else
				If Alltrim(Upper(QRYTRB->B1_COD)) == Alltrim(Upper(aListaExcel[nLoop,4]))
					aCodProd[2] := "00"
				Else
					aCodProd[2] := Alltrim(Substr(Alltrim(Upper(QRYTRB->B1_COD)),Len(Alltrim(Upper(aListaExcel[nLoop,4])))+2,10))
				Endif					
			Endif
		Endif
		If Select("QRYTRB") > 0
			DbSelectArea("QRYTRB")
			DbCloseArea()
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inclui o novo produto                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SB1")
		RecLock("SB1",.t.)
		SB1->B1_FILIAL		:= xFilial("SB1")
		SB1->B1_COD			:= aCodProd[1]+"/"+Soma1(Alltrim(aCodProd[2]),2)
		SB1->B1_CODFAM		:= ""
		SB1->B1_DESC		:= aListaExcel[nLoop,18]
		SB1->B1_DESCRCO		:= aListaExcel[nLoop,19]
		SB1->B1_ESPTECN		:= "ARTIGO: "+aListaExcel[nLoop,4]+Chr(13)+Chr(10)+"DESCRICAO: "+aListaExcel[nLoop,5]+Chr(13)+Chr(10)+"DIMENSAO: "+aListaExcel[nLoop,6]+Chr(13)+Chr(10)+"MATERIAL: "+aListaExcel[nLoop,9]+Chr(13)+Chr(10)+"NORMA: "+aListaExcel[nLoop,10]+Chr(13)+Chr(10)+"SUB.[kg]: "+aListaExcel[nLoop,22]+Chr(13)+Chr(10)+"PLANILHA DE ORIGEM:"+cArqExcel
		SB1->B1_TIPO		:= "PA"
		SB1->B1_UM			:= "UN"
		SB1->B1_LOCPAD		:= "01"
		MsUnlock()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza no array                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aListaExcel[nLoop,12] 	:= SB1->B1_COD
		aListaExcel[nLoop,17] 	:= SB1->(Recno())
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aglutina as SCs                                                       		³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aListaExcel[nLoop,17] > 0
		cNumSC := ""
		If aListaExcel[nLoop,20] > 0 .and. Empty(aListaExcel[nLoop,15])
			cNumSC := aListaExcel[nLoop,14]
		Endif
	
		nPosSC := AScan(aDadosSC,{|x| x[1] == cNumSC})
		If nPosSC == 0
			Aadd(aDadosSC,{	cNumSC,;
							{},;
							Repl("0",Len(SC1->C1_ITEM))	})
			nPosSC := Len(aDadosSC)
		Endif
		nPosProd := AScan(aDadosSC[nPosSC,2],{|x| Alltrim(x[1]) == Alltrim(aListaExcel[nLoop,12])})
		If nPosProd == 0
			Aadd(aDadosSC[nPosSC,2], {	aListaExcel[nLoop,12],;
										0,;
										aListaExcel[nLoop,17],;
										aListaExcel[nLoop,20],;
										_cniveltmp})
			nPosProd := Len(aDadosSC[nPosSC,2])
		Endif
		aDadosSC[nPosSC,2,nPosProd,2] += aListaExcel[nLoop,11]
		aDadosSC[nPosSC,2,nPosProd,5]+="/"+_cniveltmp
	Endif
Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa as SCs                                                      		³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aDadosSC)
	If Empty(aDadosSC[nLoop,1])
		cNumSC := GetNumSC1()
		For nLoopProd := 1 to Len(aDadosSC[nLoop,2])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define o numero do item do SC                                         		³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDadosSC[nLoop,3] := Soma1(aDadosSC[nLoop,3],Len(aDadosSC[nLoop,3]))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no SB1                                                      		³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SB1")
			DbGoTo(aDadosSC[nLoop,2,nLoopProd,3])
		
			DbSelectArea("SC1")
			RecLock("SC1",.T.)
			SC1->C1_FILIAL		:= xFilial("SC1")
			SC1->C1_NUM			:= cNumSC
			SC1->C1_ITEM		:= aDadosSC[nLoop,3]
			SC1->C1_PRODUTO		:= aDadosSC[nLoop,2,nLoopProd,1]
			SC1->C1_UM			:= SB1->B1_UM
			SC1->C1_QUANT		:= aDadosSC[nLoop,2,nLoopProd,2]
			SC1->C1_SEGUM		:= SB1->B1_SEGUM
			SC1->C1_QTSEGUM		:= 0
			SC1->C1_AORIGEM		:= "1"
			SC1->C1_DATPRF		:= dDataBase
			SC1->C1_XOF			:= SZ6->Z6_NUM
			SC1->C1_DESCRI		:= SB1->B1_DESC
			SC1->C1_XREVIS		:= ""
			SC1->C1_LOCAL		:= SB1->B1_LOCPAD
			SC1->C1_EMISSAO		:= dDataBase
			SC1->C1_QUJE		:= 0                                                                                                            
			SC1->C1_IMPORT		:= ""
			SC1->C1_USER		:= __cUserID
			SC1->C1_ORIGEM		:= "EXCEL"
			SC1->C1_OBS			:= "PLANILHA "+Upper(cArqExcel)
			SC1->C1_NIVELP      :=aDadosSC[nLoop,2,nLoopProd,5]
			MsUnlock()                                                                                                                     
		Next nLoopProd
	ElseIf !Empty(aDadosSC[nLoop,1])
		For nLoopProd := 1 to Len(aDadosSC[nLoop,2])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no SC1                                                      		³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SC1")
			DbGoTo(aDadosSC[nLoop,2,nLoopProd,4])
		
			DbSelectArea("SC1")
			RecLock("SC1",.F.)
			SC1->C1_QUANT		:= aDadosSC[nLoop,2,nLoopProd,2]
			SC1->C1_EMISSAO		:= dDataBase
			SC1->C1_USER		:= Substr(cUsuario,7,15)
			SC1->C1_USER		:= __cUserID
			SC1->C1_ORIGEM		:= "EXCEL"
			SC1->C1_OBS			:= "PLANILHA "+Upper(cArqExcel)
			MsUnlock()
		Next nLoopProd
	Endif   
Next nLoop
Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaSx1  ºAutor  ³ Anderson Silva	 º Data ³ 12/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa a posição do campo no aheader.			          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Aumund Brasil                        			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSx1(aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX1")
DbSetOrder(1)
For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			Endif
		Next nJ                                                                                                                                   
		MsUnlock()
	Endif
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

User Function CALCULA()                                          
Local _aSaveArea:=GetArea()                                               
Local _laltera:=.F.
Local cVar   := AllTrim(SubStr(ReadVar(),4,10))                                                          
                                                                                                                                           
If cVar=="C5_VARPR"   .Or.  cVar=="C6_VARPR"     
   For _i:=1 to Len(aCols)
        _lprocItem:=.T.                                                                                                                     
        _ITEM    :=aCols[_i][Ascan(aHeader,{|x|AllTrim(x[2])=="C6_ITEM"})]
        _NUMPV:=M->C5_NUM  //aCols[_i][Ascan(aHeader,{|x|AllTrim(x[2])=="C6_NUM"})]
        If SC9->(dbseek(xFilial("SC9") + _NUMPV + _ITEM))
            If !empty(SC9->C9_NFISCAL)
               _lprocItem:=.F.                                                                                                                   
            EndIf
        EndIf    
        
        If  _lprocItem
            _laltera:=.T.
			acols[_i,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_VARPR" })]:=M->C5_VARPR
        EndIf
   Next _i
   GetDRefresh()
EndIf                                                                                                                                         

RestArea(_aSaveArea)                                            
Return .T.


User Function FCALPR01()
Local cVar   := AllTrim(SubStr(ReadVar(),4,10))
Local lRet   := .t.
Local _nVal:=0                                                                                                                                        

If cVar<>"Z6_VENDA"   .And.   cVar<>"Z6_EURO"
   U_GATOF02()
Else   
   For nX:=1 to Len(aCols)
		If aCols[nX,Len(aHeader)+1] == .f. //Nao Deletado                                                                 
		   U_GATOF021(nX)
		EndIf   
   Next
EndIf   
SysRefresh()
GetdRefresh()
Return (.T.)


Static Function Fselitem(aListaExcel,_pos)
Local _ltodmar:=.T.
Local _ltoddmar:=.T.
If !Empty(aListaExcel[_pos,2])  .And.  _pos+1<=Len(aListaExcel)
   If  Empty(aListaExcel[_pos+1,2])  .Or. _pos=1 
      For nLoop := _pos+1 to Len(aListaExcel)	
            If  Empty(aListaExcel[nLoop,2])
                aListaExcel[nLoop,1] :=Iif(!aListaExcel[nLoop,1],.T.,.F.)
                _ltodmar :=Iif(!aListaExcel[nLoop,1],.F.,_ltodmar)
                _ltoddmar :=Iif(aListaExcel[nLoop,1],.F.,_ltoddmar)
            Else
                If _pos<>1
                  Exit    
                Else
                  aListaExcel[nLoop,1] :=Iif(!aListaExcel[nLoop,1],.T.,.F.)
                  _ltodmar :=Iif(!aListaExcel[nLoop,1],.F.,_ltodmar)
                  _ltoddmar :=Iif(aListaExcel[nLoop,1],.F.,_ltoddmar)
                EndIf  
            EndIf    
      Next  nLoop     
      If  ((_ltodmar .And. aListaExcel[_pos,1]) .Or. (_ltoddmar .And. !aListaExcel[_pos,1]))
         For nLoop := _pos+1 to Len(aListaExcel)	
             If  Empty(aListaExcel[nLoop,2])
                 aListaExcel[nLoop,1] :=Iif(!aListaExcel[nLoop,1],.T.,.F.)
             Else
                Exit    
             EndIf    
         Next  nLoop     
      EndIf                                                                                                                                        
   EndIf
EndIf      
oListBox:Refresh()
Return .T.