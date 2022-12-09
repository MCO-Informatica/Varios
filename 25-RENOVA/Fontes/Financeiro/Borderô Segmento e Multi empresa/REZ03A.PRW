#include "Colors.ch"
#Include "Protheus.Ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/* 
Nome			: REZ03A() -> Nil
Descrição		: Modelo2 - bancos do processo de bordero em "lote" - varias empresas / filiais
Nota			: 
Ambiente		: FIN
Cliente			: RENOVA
Autor			: 
Data Criação		: 19/10/2015
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão		: 
Data Revisão		: 
Revisor			: 
Nota			: 
*/

User Function REZ03A()
LOCAL LRET	:= LFAZ	:= .F.
lOCAL ATIPOX	:= {}
LOCAL ATIPOA	:= {}
LOCAL CDT_ULT	:= ""

Private cCadastro 	:= "Bancos para Bordero"
Private aRotina 	:= {}
Private cAlias		:= "Z03"
Private bVisual		:= {|| MntPCP08(cAlias,(cAlias)->(RecNo()),2,cCadastro) }
Private bInclui		:= {|| MntPCP08(cAlias,(cAlias)->(RecNo()),3,cCadastro) }
Private bAltera		:= {|| MntPCP08(cAlias,(cAlias)->(RecNo()),4,cCadastro) }
Private bExclui		:= {|| MntPCP08(cAlias,(cAlias)->(RecNo()),5,cCadastro) }

Private bVal1		:= {|| yvldemp() }

Private aEmpresas	:= {}
Private aBancos		:= {}

Private cBanco__1	:= criavar("Z03_BANCO"	,.F.)
Private cAgenc__1	:= criavar("Z03_AGENC"	,.F.)
Private cNumCon__1	:= criavar("Z03_NUMCON"	,.F.)
PRIVATE CNOME__1	:= CRIAVAR("Z03_NOMEAG" ,.F.)


FillEmpx() // preenche se necessario a tabela Z03 com todas as empresas e filiais

	//Define os Menus da Tela
	
	aAdd( aRotina , { "Pesquisar"   , "AxPesqui"            , 0 , 1 } )
	aAdd( aRotina , { "Visualizar"	, "Eval(bVisual)"       , 0 , 2 } )
	aAdd( aRotina , { "Incluir"	    , "Eval(bInclui)"       , 0 , 3 } )
	aAdd( aRotina , { "Alterar"	    , "Eval(bAltera)"       , 0 , 4 } )
	aAdd( aRotina , { "Excluir"	    , "Eval(bExclui)"       , 0 , 5 } )
	
	//Seleciiona a Tabela e Posiciona
	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGotop())
	
	//Apresenta o Browse
	MBrowse(6,1,22,75,cAlias)	

Return Nil

//Função da Rotina de Manutenção (Visualização, Alteração e Exclusão) da Tabela Especificada no Modelo2
Static Function MntPCP08(cAlias,nReg,nOpc,cTitulo)
Local aArea	 		:= GetArea()
Local aCab	 		:= {}
Local aRoda	 		:= {}
Local aGrid		 	:= {84,5,50,300}
Local cLinhaOk			:= "U_Z03LOK()"
Local cTudoOk			:= "U_Z03TOK()"
Local lRetMod2			:= .F.
Local nColuna			:= 0
Local lDel			:= Iif(nOpc == 3 .Or. nOpc == 4,.T.,.F.) //Se Inclusão ou Alteração Permite excluir itens na GetDados

Private aCols		:= {}
Private aHeader	:= {}
Private aReg	 	:= {}
Private cEmpVar	:= ""
Private cFilVar	:= ""
Private cNomeEmp := ""
Private cNomeFil := ""

	//Define o Contéudo das Variáveis dos Campos do Cabeçalho
	If nOpc == 3 //Se Inclusão
		cEmpVar := CRIAVAR("Z03_GRP",.T.)
		cNomeEmp := CRIAVAR("Z03_NGRP",.T.)
	Else //Caso Contrário busca o Valor Atual do Campo
		cEmpVar := (cAlias)->Z03_GRP
		cNomeEmp := (cAlias)->Z03_NGRP
	Endif

	//Define os Campos do Cabeçalho do Modelo 2
	//Carrega os Campos do Cabeçalho pelo Dicionário de Dados
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	If SX3->(dbSeek("Z03_GRP"))
		aAdd(aCab,{ "cEmpVar",;
					{15,10},;
					Trim(x3Titulo()),;
					X3_PICTURE,;
					"eval(bval1)" ,; // "U_xVLDEMP()",; //X3_VALID,;
					X3_F3,;
					Iif(nOpc == 3,.T.,.F.)})
	Endif
	
	If SX3->(dbSeek("Z03_NGRP"))
		aAdd(aCab,{ "cNomeEmp",;
					{15,80},;
					Trim(x3Titulo()),;
					X3_PICTURE,;
					X3_VALID,;
					X3_F3,;
					.F.})
	Endif

	//Carrega o Cabeçalho 
	//Sintaxe: Mod2aHeader(cAlias,cCposEnch)->Nil
//	Mod2aHeader(cAlias,"Z03_FILIAL,Z03_EMP,Z03_FIL,Z03_NEMP,Z03_NFIL")
	Mod2aHeader(cAlias,"Z03_GRP,Z03_NGRP")
	
	//Carrega os Dados
	//Mod2aCols(cAlias,nReg,nOpc)
	//Sintaxe: Mod2aCols(cAlias,nReg,nOpc,cChaveIni,cFiltro)->Nil
	Mod2aCols(cAlias,nReg,nOpc,xFilial(cAlias)+cEmpVar,"(cAlias)->(Z03_FILIAL + Z03_GRP) == xFilial(cAlias) + cEmpVar")
	            
	//Monta a Tela de Cadastro no Modelo2 
	//Modelo2 - Formulário para cadastro ( cTitulo [ aC ] [ aR ] [ aGd ] [ nOp ] [ cLinhaOk ] [ cTudoOk ]aGetsD [ bF4 ] [ cIniCpos ] [ nMax ] [ aCordW ] [ lDelGetD ] [ lMaximazed ] [ aButtons ] ) 
	//lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOk,cTudoOk,,,,,,lDel)
	lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,nOpc,cLinhaOK,cTudoOk,,,,,, .F.,.T. )  // fixei .f. lDel) - Luiz 08/10/2020 - .T. pra maximizado
	
	//Tratamento para Inclusão, Alteração (possilita inclusão de itens) e Exclusão
	//Para visualização nada ocorre
	If lRetMod2
		If nOpc == 3 //Se for Inclusão 
		
			//Se o codigo nao existir
			If !(cAlias)->(DBSeek(xFilial()+cEmpVar))
				//For nLinha:=1 to Len(aCols)
				//	If !aCols[nLinha,Len(aHeader)+1] //Se a linha não estiver marcada como excluída
				//		//RecLock(cAlias,.T.) 
				//		//	//Grava os Dados do Cabeçalho
				//		//	(cAlias)->ZZH_FILIAL := xFilial(cAlias)
				//		//	(cAlias)->ZZH_CODIGO := cEmpVar
				//		//	(cAlias)->ZZH_DESCRI := cFilVar
				//		//	
				//		//	//Grava os Dados dos Itens
				//		//	For nCol:=1 To Len(aHeader)
				//		//		FieldPut(FieldPos(aHeader[nCol,2]),aCols[nLinha,nCol])
				//		//	Next nCol
				//		//(cAlias)->(MsUnLock())
				//	EndIf
				//Next nLinha
				
				//Confirma a Numeração
				//ConfirmSX8()
			Else
				MsgStop("Já existe registro com essa informação.","JAGRAVADO")
			EndIf
		ElseIf nOpc == 4 //Se for alteração
			For nLinha:=1 to Len(aCols)
				If nLinha <= Len(aReg) //Se for menor ou igual pode ser uma alteração ou exclusão
					(cAlias)->(dbGoto(aReg[nLinha]))					
					If aCols[nLinha,Len(aHeader)+1] //Se a linha estiver marcada como excluída
						RecLock(cAlias,.F.)
							(cAlias)->(DbDelete())
						(cAlias)->(MsUnlock())
					Else
						RecLock(cAlias,.F.) //Caso contrário é uma alteração
					Endif
				Else //Caso contrário é uma inclusão
					if !aCols[nLinha,Len(aHeader)+1] //Se a linha não estiver marcada como excluída
						RecLock(cAlias,.T.)
					Else
						// Nada Faz
					EndIf				
				Endif
				
				If !aCols[nLinha,Len(aHeader)+1] //Se a linha não estiver marcada como excluída
					//Altera ou Inclui				 
					//Grava os Dados do Cabeçalho
					//(cAlias)->ZZH_FILIAL := xFilial(cAlias)
					//(cAlias)->ZZH_CODIGO := cEmpVar
					//(cAlias)->ZZH_DESCRI := cFilVar
					(cAlias)->Z03_FILIAL		:= XFILIAL("Z03")
					(cAlias)->Z03_GRP		:= cEmpVAR
					// JJ EM 05/11/15 (cAlias)->Z03_NGRP		:= cNomeEmp	 // GRUPO E NOME DO GRUPO
					
					//Grava os Dados dos Itens
					For nCol:=1 To Len(aHeader)
						FieldPut(FieldPos(aHeader[nCol,2]),aCols[nLinha,nCol])
					Next nCol				 
					(cAlias)->(MsUnlock())
				Endif
			Next nLinha		
		ElseIf nOpc == 5 //Se for exclusão, exclui todos os itens
			//For nLinha:=1 to Len(aReg)
			//	(cAlias)->(dbGoto(aReg[nLinha]))
			//	RecLock(cAlias,.F.)
			//		(cAlias)->(DbDelete())
			//	(cAlias)->(MsUnlock())				
			//Next nLinha
		Endif
	Else
		//Desfaz a Numeração caso seja cancelado
		//RollBackSX8()
	Endif
	      
	//Restaura área de trabalho
	RestArea(aArea)

Return Nil

//Verifica se a Linha está OK antes de continuar
User Function Z03LOK()
Local lRet	:= .T.
Local nI		:= 0
ni := ni              
	If !aCOLS[n, Len(aHeader)+1]

		If Empty(aCOLS[n,GdFieldPos("Z03_FIL")])
			MsgInfo("Atenção! Não é possivel incluir nova filial. Inclusão é Automática.","AVISO")
			lRet := .F.
			Return (lRet)
		Endif
		
		If !empty( aCOLS[n,GdFieldPos("Z03_BANCO")] )
			lret := .f.

			SA6->(DBSETORDER(1))
			if sa6->(dbseek( PADR( aCOLS[n,GdFieldPos("Z03_EMP")] + aCOLS[n,GdFieldPos("Z03_UND")]  , LEN(CRIAVAR("Z03_FILIAL")) )  + ;
				aCOLS[n,GdFieldPos("Z03_BANCO")] + aCOLS[n,GdFieldPos("Z03_AGENC")] + aCOLS[n,GdFieldPos("Z03_NUMCON")] ))
				LRET := .T.
			ENDIF
			
			IF !LRET
				MsgInfo("Atenção! Banco/Agencia/Conta nao informado.","AVISO")
				lRet := .F.
				Return (lRet)
			ENDIF			
			
			If empty( aCOLS[n,GdFieldPos("Z03_FILCON")] )
				lret := .F.
			EndIf
			
			IF !LRET
				MsgInfo("Atenção! Filial Consolidadora nao informado.","AVISO")
				lRet := .F.
				Return (lRet)
			ENDIF			
			
			_cZ03GRP := cEmpVAR
			_cZ03EMP := aCOLS[n,GdFieldPos("Z03_EMP")]
			_cZ03UND := aCOLS[n,GdFieldPos("Z03_UND")]
			_cZ03FIL := aCOLS[n,GdFieldPos("Z03_FILCON")]
			
			
			cQZ03 := GetNextAlias()

			BeginSql Alias cQZ03
				SELECT
				
				Z03.Z03_GRP,
				Z03.Z03_EMP,
				Z03.Z03_UND,
				Z03.Z03_FIL
				
				FROM 	%Table:Z03% Z03
				
				WHERE
				Z03.Z03_FILIAL  = %XFilial:Z03%
				AND Z03.Z03_GRP = %Exp:_cZ03GRP%
				AND Z03.Z03_EMP = %Exp:_cZ03EMP%
				AND Z03.Z03_UND = %Exp:_cZ03UND%
				AND Z03.Z03_FIL = %Exp:_cZ03FIL%
				AND Z03.%NotDel%
			EndSql
			
			DbSelectArea(cQZ03)
			(cQZ03)->(DbGoTop())
			If (cQZ03)->(!Eof())
				(cQZ03)->(DbCloseArea())
				LRET := .T.
			Else
				LRET := .F.
			EndIf
			
			
			IF !LRET
				MsgInfo("Atenção! Filial Consolidadora informada não existe.","AVISO")
				lRet := .F.
				Return (lRet)
			ENDIF

	
		Endif
		//
					//
	Else // deletada a linha
		MsgInfo("Atenção! Não permitido Deletar Linha."+ Chr(13)+Chr(10)+"Deixe o Banco em branco caso não seja processada essa unidade/filial." ,"AVISO.")
		lRet := .F.
		Return (lRet)		
	Endif

Return(lRet)

//Função para Verificar se tudo está OK após confirmar a operação
User Function Z03TOK()
Local lRet		:=.T.
Local nI := 0

	For nI := 1 To Len( aCOLS )
		If aCOLS[nI, Len(aHeader)+1]
			lRet := .f.
			MsgStop("Atenção! Não pode excluir Linha."+ Chr(13)+Chr(10)+"Deixe o Banco em branco caso não seja processada essa unidade/filial." ,"AVISO")
		EndIf
	Next

Return (lRet)

//##########################################################
//FUNÇÕES AUXILIARES
//##########################################################
          
//Função para Gerar o Cabeçalho dos Dados
Static Function Mod2aHeader(cAlias,cCposEnch)
Local aArea := GetArea()

	//Carrega o aHeader pelo Dicionário de Dados
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	while SX3->(!EOF()) .And. X3_ARQUIVO == cAlias

		If	X3Uso(X3_Usado) .And. cNivel >= X3_Nivel .And. ;
			!(ALLTRIM(X3_CAMPO) $ cCposEnch ) //NAO PODE SER NENHUM DOS CAMPOS DA ENCHOICE    
				
				aAdd( aHeader, {	Trim(x3Titulo()),;
									X3_CAMPO,;
									X3_PICTURE,;
									X3_TAMANHO,;
									X3_DECIMAL,;
									X3_VALID,;
									X3_USADO,;
									X3_TIPO,;
									X3_F3,;
									X3_CONTEXT,;
									X3_CBOX,;
									X3_RELACAO })

		Endif  
		SX3->(dbSkip())
	EndDo	

	//Restaura Área de Trabalho
	RestArea(aArea)
Return Nil
               
//Monta os Registros dos Dados da GetDados
Static Function Mod2aCols(cAlias,nReg,nOpc,cChaveIni,cFiltro)
Local aArea := GetArea()
Local nCont := 0

	If nOpc <> 3 //Se não for Inclusão
		dbSelectArea(cAlias)
	 	(cAlias)->(dbSetOrder(1))
	    (cAlias)->(DbSeek(cChaveIni))
	    
	    While !Eof() .And. &(cFiltro)
        
        	aAdd(aReg, (cAlias)->(RecNo())) //
        	aAdd(aCols, Array(Len(aHeader) + 1))
	        
	        For nCont := 1 To Len(aHeader)
	          If aHeader[nCont,10] == "V" //contexto
	             aCols[Len(aCols),nCont] := CriaVar(aHeader[nCont,2],.T.) //Para campos virtuais busca o inicializador padrão
	          Else                                                 
	             aCols[Len(aCols),nCont] := FieldGet(FieldPos(aHeader[nCont,2]))
	          Endif 
	        Next nCont
	        
	        aCols[Len(aCols),Len(aHeader)+1] := .F.
	        (cAlias)->(DbSkip())	        
	     EndDo
  	Else
  		aAdd(aCols, Array(Len(aHeader)+1))  
	    For nCont := 1 To Len(aHeader)
	        aCols[1, nCont] := CriaVar(aHeader[nCont, 2], .T.)      
	    Next nCont
	    aCols[01, Len(aHeader)+1] := .F.
  Endif           
  
  //Restaura Área de Trabalho
  RestArea(aArea)
  
Return Nil


/* 

*/

Static Function FillEmpX()
local aArea	:= getarea()
local cemp	:= cEmpAnt
local cfil	:= cFilAnt
Local aAreaSM0	:= SM0->(getarea())
Local aEmp	:= {}
Local nPos	:= nEMP	:= 0
local lret	:= .f.

	DBSELECTAREA("SM0")
	dbsetorder(1)
	dbgotop()
	DO WHILE .NOT. EOF()

		aadd( aEMPRESAS , {SM0->M0_CODIGO , SM0->M0_CODFIL , SM0->M0_NOME , SM0->M0_FILIAL , SUBSTR(SM0->M0_CODFIL , 1,3 ), SUBSTR(SM0->M0_CODFIL ,4,2) , SUBSTR(SM0->M0_CODFIL ,6,2 )  , SM0->M0_NOMECOM } )
		//                             1      2                     3        4                5                                   6                               7                             8

		nPos := ascan( aemp , {|X| X[1] == SM0->M0_CODIGO })
		IF NPOS == 0
			AADD( AEMP , { SM0->M0_CODIGO , SM0->M0_CODFIL } )
		ENDIF

		nEmp := len(aEmpresas)
		DBSELECTAREA("Z03")
		IF !(DBSEEK( XFILIAL("Z03") + aEMPRESAS[nEmp][1] + SUBSTR( aEMPRESAS[nEmp][2],1,7) ))
			RECLOCK("Z03",.T.)
			Z03_FILIAL		:= XFILIAL("Z03")
			Z03_GRP			:= aEMPRESAS[nEMP][1]
			Z03_NGRP		:= AEMPRESAS[nEMP][3]
			Z03_EMP			:= aEMPRESAS[nEMP][5]
			Z03_UND			:= AEMPRESAS[nEMP][6]
			Z03_FIL			:= aEMPRESAS[nEMP][7]
			Z03_NEMP		:= aEMPRESAS[nEmp][8]
			Z03_NFIL		:= aEMPRESAS[nEMP][4]
			MSUNLOCK()
		ENDIF

		DBSELECTAREA("SM0")
		DBSKIP()
	ENDDO

RESTAREA(AAREASM0)
RESTAREA(AAREA)
RETURN(Nil)

//USER FUNCTION xVLDEMP()
static function xVLDEMP()
LOCAL NPOS	:= 0
LOCAL lRET	:= .T.

NPOS := ASCAN( AEMPRESAS , {|X| X[1] == cEmpVar })
IF NPOS = 0
	RETURN(.F.)
ELSE
	cnomeemp := aempresas[npos,3]
ENDIF

if !empty( cFilVar )
	NPOS := ASCAN( AEMPRESAS , {|X| X[1] == cEmpVar .and. x[2] == cFilVar })
	IF NPOS = 0
		RETURN(.F.)
	ELSE
		cnomefil := aempresas[npos,4]
	ENDIF

endif

RETURN(lRET)

static FUNCTION yVLDEMP()
LOCAL NPOS	:= 0
LOCAL lRET	:= .T.

RETURN(lRET)


////Z03F3
//Function a016TabRel()
USER FUNCTION Z03F3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oListBox
Local oPanel
Local aPars     := {}
Local cVar	    := Upper( Alltrim( ReadVar() ) )
Local cConteudo := ""
Local cCodigo   := ""
Local nPosList  := nPOS := nselect := 0
Local lOk		:= .T.
LOCAL aCODREL		:= {}
local cemp_	:= cUND_	:= ""


if N > 0
	cemp_ := aCOLS[n,GdFieldPos("Z03_EMP")]
	cUND_ := aCOLS[n,GdFieldPos("Z03_UND")]
	SA6->(DBSETORDER(1))
	IF SA6->(DBSEEK(PADR( cEMP_ + CUND_  , LEN(CRIAVAR("Z03_FILIAL"))  )))
		WHILE SA6->(!EOF()) .AND. SA6->a6_FILIAL == PADR( cEMP_ + CUND_  , LEN(CRIAVAR("Z03_FILIAL")) )
			AADD( ACODREL , { ;
			SA6->A6_COD  ,;
			SA6->A6_AGENCIA  ,;
			SA6->A6_NUMCON  ,;
			SA6->A6_NOME  ,;
			SA6->A6_NOMEAGE  ;
			})

			SA6->(DbSkip())
		ENDDO
	ENDIF
EndIf

if len( acodrel ) = 0
	aadd( acodrel, {  "","","","","" } )
endif

nSelect := TmsF3Array( {"BCO","AG","CONTA","NOME","NOME AGE"} , acodrel , "Bancos da Empresa " + cempvar + " " + alltrim(cNomeEmp) , .F. , {} , {"BCO","AGENCIA","CONTA","NOME","NOME AGE"})

if nSelect = 0
	lOk := .f.
else
	cbanco__1	:= acodrel[nselect,1]
	cagenc__1	:= acodrel[nselect,2]
	cnumcon__1	:= acodrel[nselect,3]
	CNOME__1	:= ALLTRIM(acodrel[nselect,4])+ " " + alltrim(acodrel[nselect,5])
endif

Return lOk


/* 
criando arquivo temporario // markbrow para escolher empresas / filiais que vao fazer bordero

*/
User Function ReZ03Cria(aSelFil, aSelEmp ) //cNomeArq)
//local aCampos	:= {}
Local cNomeArq	:= ""
LOCAL aSemSX3	:= {} //{{"Z03_OK  ","C",2,0}}
LOCAL nX	:= nPos := 0
LOCAL AHEAD_	:= {}
LOCAL ACOLS_	:= {}

	Local nOpca		:= 0
	Local nOpcTit		:= 0
	Local cIndex		:= ""
	Local cChave		:= ""

	Local cMod		:= cModulo
	Local aStruct		:= {}
	//Local aCampos	:= {}
	Local aArea		:= GetArea()
	Local aAreaSM0		:= SM0->(getArea())
	//Local aAreaTRB		:= TRB->(GetArea())	
	Local lInverte		:= .F.
	Local oDlg
	Local oMark
	Local oPanel
Local aCores	:= {}

	//Local oSt1		:= QryProc():Create()
	//Local oStExc		:= QryProc():Create()
	//Local oStCons		:= QryProc():Create()
	
	Private lMsErroAuto := .F.
	PRIVATE cMarca	 := GetMark()


Private ACAMPOS := {} //Array(EE7->(FCount()))
//Private aHeader[0]

Default aSelFil := {}
Default aSelEmp := {}

IF TYPE("AHEADER") == "A'
	AHEAD_		:= aclone( aheader)
	acols_		:= aclone( acols )
	
	aheader		:= {}
	acols		:= {}
else
	aheader		:= {}
	acols		:= {}
endif


acampos := Array(Z03->(FCount()))
AADD( ASEMsX3 , {"Z03_OK  ","C",2,0} )
AADD( ASEMSX3 , {"Z03_SEMBCO","C",2,0} )

dbselectarea("Z03")

cNomeArq := e_Criatrab("Z03" , aSemSX3 , "XWORKX" )
IndRegua("XWORKX",cNomeArq+OrdBagExt(), "Z03_SEMBCO+Z03_GRP+Z03_EMP+Z03_UND+Z03_FIL",,,OemToAnsi("Selecionando Registros..."))  //

Z03->(dbsetorder(1))
Z03->(dbgotop())
while Z03->(!eof())

	XWORKX->(RECLOCK("XWORKX",.T.))
	AvReplace("Z03","XWORKX")
	XWORKX->Z03_OK := IF(EMPTY(Z03->Z03_BANCO),"",CMARCA)
	XWORKX->Z03_SEMBCO := IF(EMPTY(Z03->Z03_BANCO),"X","")
	XWORKX->(MSUNLOCK())

	Z03->(dbskip())
enddo

XWORKX->(DBGOTOP())
nx := nx
		aCampos := {}
		AADD(aCampos,{"Z03_OK","","  ",""})
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		dbSeek ("Z03")
		
		//Adiciona o campo E2_FILIAL no browse somente se o SE2 estiver exclusivo e em uso.
		//If !Empty( cFilFwSE2 ) .Or. X3USO(x3_usado) .And. cNivel >= x3_nivel
		//	AADD(aCampos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
			SX3->(dbSkip())
		//EndIf
		
		While !EOF() .And. (x3_arquivo == "Z03")
			IF X3USO(x3_usado)  .AND. cNivel >= x3_nivel .and. X3_CONTEXT != "V"
				IF ALLTRIM(X3_CAMPO) <> 'Z03_GRP' .AND. ALLTRIM(X3_CAMPO) <> 'Z03_NGRP'
					AADD(aCampos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
				ENDIF
			Endif
			SX3->(dbSkip())
		Enddo

	Aadd(aCores, {'!empty(XWORKX->Z03_BANCO)','BR_VERDE'} )
	Aadd(aCores, {'empty(XWORKX->Z03_BANCO)','BR_VERMELHO'} )


aSize := MSADVSIZE()
	//Monta a tela  
	//DEFINE MSDIALOG oDlg TITLE "Manutenção de Lotes BANDAG" From 6,1 To 22,75 OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Empresas / Filiais" From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	oDlg:lMaximized := .T.
	
	//Monta o markbrowse
	oMark := MsSelect():New("XWORKX","Z03_OK","" /* FILTRO*/,aCampos,@lInverte,@cMarca,{50,oDlg:nLeft,oDlg:nBottom,oDlg:nRight},,,,,aCores)
	oMark:oBrowse:lColDrag := .T.  
//	oMark:bMark := {| | FA380Displ(cMarca,lInverte,oQtdaP,oQtdaR,oValRec,oValPag)}
	oMark:oBrowse:bAllMark := { || u_reZ03all(cMarca , oMark ) } //u_PCP29Inv(cMarca)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	//Mostra a tela juntamente com a enchoicebar
	//ACTIVATE MSDIALOG oDlg ON INIT (u_PCP29BAR(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()},oMark,nOpc),oMark:oBrowse:Refresh()) CENTERED
	ACTIVATE MSDIALOG oDlg ON INIT (u_PCP29BAR(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()},oMark),oMark:oBrowse:Refresh()) CENTERED

nOpca := nOpca

if nOpca = 1

	SM0->(dbsetorder(1))
	XWORKX->(DbGoTop())
	aselfil := {}
	aselemp := {}
	While !Eof()
		IF !EMPTY(XWORKX->Z03_BANCO) .and. XWORKX->Z03_OK == cMarca
			nPos := ascan( aSelFil , {|Z| Z = XWORKX->(  Z03_EMP + Z03_UND + Z03_FIL ) } )
			if nPos = 0		
				aadd( aSelFil , XWORKX->(  Z03_EMP + Z03_UND + Z03_FIL ) )
			endif

			//nPos := ascan( aSelEmp , {|X| X[1] = XWORKX->(  Z03_EMP + Z03_UND ) .and. X[2] = XWORKX->(Z03_BANCO+Z03_AGENC+Z03_NUMCON) })      /// array com empresas participantes. para fazer um bordero por empresa.
			nPos := ascan( aSelEmp , {|X| X[1] = XWORKX->(  Z03_EMP + Z03_UND )  })      /// array com empresas participantes. para fazer um bordero por empresa.
			if nPos = 0
				if sm0->(dbseek( cEmpAnt + XWORKX->(  Z03_EMP + Z03_UND ) ))
					aadd( aSelEmp , { XWORKX->(  Z03_EMP + Z03_UND )  , XWORKX->(Z03_BANCO+Z03_AGENC+Z03_NUMCON) , SM0->M0_CODFIL , SPACE(6) } )  // para guardar a primeira filial 
				else
					aadd( aSelEmp , { XWORKX->(  Z03_EMP + Z03_UND )  , XWORKX->(Z03_BANCO+Z03_AGENC+Z03_NUMCON) , "" , SPACE(6) } )
				endif
			endif
		EndIf

		XWORKX->(DBSKIP())
	EndDo

endIF

XWORKX->(E_EraseArq(cNomeArq))

acols := aclone( acols_ )
aheader := aclone( ahead_ )
restarea(aareaSM0)
restarea(aarea)
RETURN

User Function PCP29Bar(oDlg,bOk,bCancel,oMark,nOpc)
	Local oBar, bSet15, bSet24, bSet18, lOk
	Local lVolta :=.f.
	
	//DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg

//	//DEFINE BUTTON oBtnEdt RESOURCE "NOTE" OF oBar ACTION PCP29Edit(nOpc) TOOLTIP "Edita"

	DEFINE BUTTON oBtnEdt RESOURCE "NOTE" OF oBar ACTION  PCP29Edit(nOpc) //TOOLTIP "Edita"
	SetKey(5,oBtnEdt:bAction)
	oBar:nGroups += 1
	
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) //TOOLTIP "Ok"
	SetKEY(15,oBtOk:bAction)
	
	DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,bSet18,.T.)) //TOOLTIP "Cancelar"
	SetKEY(24,oBtCan:bAction)

	oDlg:bSet15 := oBtOk:bAction
	oDlg:bSet24 := oBtCan:bAction

	oBar:bRClicked := {|| AllwaysTrue()}

Return Nil

Static Function PCP29Edit(nOpc)
	Local oDlg1 
	Local odlg
	//Local nRecOri	:= TRBX->(RECNO())
	Local nOpcao	:= nOpca :=  nMoedAdt := 0
	Local nValor	:= 0 // ZZ5_VLRAPR
	Local cfilx		:= cfilant
	Local cCtr1	:= xworkx->Z03_contr

Private cBanco__1	:= xworkx->Z03_banco	//criavar("Z03_BANCO"	,.F.)
Private cAgenc__1	:= xworkx->Z03_agenc	//criavar("Z03_AGENC"	,.F.)
Private cNumCon__1	:= xworkx->Z03_numcon	//criavar("Z03_NUMCON"	,.F.)
PRIVATE CNOME__1	:= CRIAVAR("Z03_NOMEAG" ,.F.)

If XWORKX->(EOF()) .AND. XWORKX->(BOF())
	return
EndIf

sm0->(dbsetorder(1))
cfilant := xworkx->( Z03_emp + Z03_und + Z03_fil )
sm0->(dbseek( cEmpAnt + XWORKX->(  Z03_EMP + Z03_UND + Z03_fil ) ))

	While .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra Get do Banco de Entrada								³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOpca := 0
		DEFINE MSDIALOG oDlg FROM 15, 5 TO 25, 60 TITLE "Banco da Filial" // 38

		@	0.4,2	say XWORKX->Z03_NFIL of oDlg  COLOR CLR_BLUE
		@	1,2 say "Banco da Filial " + xworkx->( Z03_emp + " " + Z03_und + " " + Z03_fil ) Of oDlg  COLOR CLR_HBLUE

		@	2.0,2 	Say "Banco:"   Of oDlg // "Banco : "
		@	3.0,2	MSGET cBanco__1 F3 "SA6" Valid if(empty(cBanco__1),.t.,CarregaSa6( @cBanco__1,,,,,,, @nMoedAdt )) Of oDlg HASBUTTON
		
		@	2.0,6 	Say "Agencia:"  Of  oDlg // "Agˆncia : "
		@	3.0,6	MSGET cAgenc__1 Valid if(empty(cBanco__1),.t.,CarregaSa6(@cBanco__1,@cAgenc__1)) Of oDlg
		
		@	2.0,10 	Say "Conta :"  Of  oDlg // "Conta : " 
		@	3.0,10	MSGET cNumCon__1 Valid if(empty(cBanco__1),.t.,CarregaSa6(@cBanco__1,@cAgenc__1,@cNumCon__1,,,.T.)) Of oDlg
		
		@	2.0,18	say "Contrato" of oDlg
		@	3.0,18	MSGET cCtr1 SIZE 42,10 Of oDlg Picture "@S3"

		//@	 .3,1 TO 5.3,15.5 OF oDlg
		@	 .3,1 TO 5.3,27 OF oDlg
		
		DEFINE SBUTTON FROM 061,120   TYPE 1 ACTION (nOpca := 1,If(!Empty(cBanco__1).and. CarregaSa6(@cBanco__1,@cAgenc__1,@cNumCon__1,,,.T.,, @nMoedAdt),oDlg:End(),; //60
		if(empty(cBanco__1),oDlg:End(),nOpca:=0))) ENABLE OF oDlg

		DEFINE SBUTTON FROM 061,150   TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oDlg // 97.1

		ACTIVATE MSDIALOG oDlg
		IF nOpca != 0

			XWORKX->(RECLOCK("XWORKX"))
			xworkx->Z03_banco	:= cBanco__1
			xworkx->Z03_agenc	:= cAgenc__1
			xworkx->Z03_numcon	:= cNumCon__1
			xworkx->Z03_contr	:= cCtr1
			
			IF EMPTY(cBANCO__1)
				XWORKX->Z03_SEMBCO := "X"
				xworkx->Z03_ok = " "
				XWORKX->Z03_NOMEAGE = ' '
			ELSE
				XWORKX->Z03_SEMBCO := " "
				if empty(xworkx->Z03_ok)
					xworkx->Z03_ok := cmarca
				endif
				XWORKX->Z03_NOMEAGE := ALLTRIM(SA6->A6_NOME)+ " " + alltrim(SA6->A6_NOMEAGE)
			ENDIF
			XWORKX->(MSUNLOCK())
			
			Z03->(dbsetorder(1))
			if Z03->(dbseek( XFILIAL("Z03") + XWORKX->( Z03_GRP + Z03_EMP + Z03_UND + Z03_FIL ) ))
				Z03->(RECLOCK("Z03"))	
				Z03->Z03_banco	:= cBanco__1
				Z03->Z03_agenc	:= cAgenc__1
				Z03->Z03_numcon	:= cNumCon__1
				Z03->Z03_contr	:= cCtr1
				IF EMPTY(CBANCO__1)
					Z03->Z03_NOMEAGE := " "
				ELSE
					Z03->Z03_NOMEAGE := ALLTRIM(SA6->A6_NOME)+ " " + alltrim(SA6->A6_NOMEAGE)
				ENDIF
				Z03->(MSUNLOCK())
			ENDIF

			//lRetorna := .T.
			Exit
		else
			Exit
		EndIF
	Enddo

sm0->(dbseek( cempant + cfilx ))
cfilant := cfilx
Return Nil

User Function ReZ03all(cMarca , oMark)
	Local nReg	:= XWORKX->(Recno())
	Local aArea	:= getarea()

	DbSelectArea("XWORKX")                                                                                                                    
	DbGoTop()
	
	While !Eof()
		IF EMPTY(XWORKX->Z03_BANCO)
			RecLock("XWORKX")
				Replace XWORKX->Z03_OK with "  "
			MsUnlock()
		ELSE			
			If XWORKX->Z03_OK == cMarca
				RecLock("XWORKX")
					Replace XWORKX->Z03_OK with "  "
				MsUnlock()
			Else
				RecLock("XWORKX")
					Replace XWORKX->Z03_OK with cMarca
				MsUnlock()
			Endif
		ENDIF
		dbskip()
	EndDo
	
	DbSelectArea("XWORKX")
	DbGoTo(nReg)
	
	oMark:oBrowse:Refresh()

restarea(aArea)	
Return Nil     

