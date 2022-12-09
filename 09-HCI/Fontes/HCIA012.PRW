
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Grupos de Aprovadores                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "Protheus.Ch"

User Function HCIA012()

Private cAlias1 := "PA3"
Private cFilPA3 := ""
Private cCadastro := "Cadastro de Grupos de Aprovadores"
Private aRotina   := {}    
Private cCodigo := Space(Len(PA3->PA3_CODIGO))
Private cDesc   := Space(Len(PA3->PA3_DESC))

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"    ,0,1})
aAdd( aRotina, {"Visualizar" ,'u_Mod2Visual',0,2})
aAdd( aRotina, {"Incluir"    ,'u_Mod2Inclui',0,3})
aAdd( aRotina, {"Alterar"    ,'u_Mod2Altera',0,4})
aAdd( aRotina, {"Excluir"    ,'u_Mod2Exclui',0,5})

dbSelectArea(cAlias1)
dbSetOrder(1)

cFilPA3 := xFilial(cAlias1)
dbGoTop()

mBrowse(,,,,cAlias1)

dbSelectArea(cAlias1)
dbSetOrder(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mod2Visual -> Visualizacao dos registros                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mod2Visual( cAlias1, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local oTPane1
Local oTPane2

Local cCod2 := PA3->PA3_CODIGO
Local cDesc   := PA3->PA3_DESC

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0     

dbSelectArea(cAlias1)
If RecCount() == 0
	Return
Endif

u_CarregaGrid(cCod2)

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 520,800 OF oMainWnd
    oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,45,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP	
	
	@  9, 006 SAY "Cod. Grupo"     SIZE 70,7 PIXEL OF oTPane1
	@ 19, 006 SAY "Descrição"     SIZE 70,7 PIXEL OF oTPane1
    
  	@ 7,040 MSGET cCod2  When .F. SIZE 180,7 PIXEL OF oTPane1  		
	@ 18,040 MSGET cDesc   When .F. SIZE 180,7 PIXEL OF oTPane1  		
	
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2 :Align     := CONTROL_ALIGN_BOTTOM
	
    oGet := MSGetDados():New(100,100,100,100,nOpcX)	   
   	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT      

	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mod2Inclui -> Inclusao de Grupos                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Mod2Inclui(cAlias1,nReg,nOpcX)
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oTPane1
Local oTPane2

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	
  
   If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA3_FILIAL, PA3_CODIGO, PA3_DESC"))
   //If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL 
		nUsado++
		AADD(aHeader,{  TRIM(X3Titulo()),;
		               X3_CAMPO    ,;
		               X3_PICTURE  ,;
		               X3_TAMANHO  ,;
		               X3_DECIMAL  ,;
		               X3_VALID    ,;
		               X3_USADO    ,;
		               X3_TIPO     ,;
		               X3_ARQUIVO  ,;
		               X3_CONTEXT  })
	Endif
	dbSkip()
End

aAdd( aCOLS,Array(Len(aHeader)+1))

dbSelectArea("SX3")
dbSeek(cAlias1)
nUsado:=0
While !EOF() .And. X3_ARQUIVO == cAlias1

	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA3_FILIAL, PA3_CODIGO, PA3_DESC"))

		nUsado++
		IF X3_TIPO == "C"
			aCOLS[1][nUsado] := SPACE(x3_tamanho)			
		ELSEIF X3_TIPO == "N"
			aCOLS[1][nUsado] := 0
		ELSEIF X3_TIPO == "D"
			aCOLS[1][nUsado] := dDataBase
		ELSEIF X3_TIPO == "M"
		   	aCOLS[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		ELSE
			aCOLS[1][nUsado] := .F.
		Endif
		If X3_CONTEXT == "V"
			aCols[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		Endif
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSetOrder(1)

aCOLS[1][nUsado+1] := .F.
cCodigo := space(6)
cDesc :=  space(15)

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 520,800 OF oMainWnd

    oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,45,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@  9, 006 SAY "Cod. Grupo"  SIZE 70,7 PIXEL OF oTPane1
	@ 19, 006 SAY "Descricao"   SIZE 70,7 PIXEL OF oTPane1
    
	@  7,040 MSGET cCodigo PICTURE "@!" VALID (U_PesqPA3(cCodigo) .And. Alltrim(cCodigo)) SIZE 030,7 PIXEL OF oTPane1
	//@ 3, 080 MSGET cNome When .F.             SIZE 78,7 PIXEL OF oTPane1
	@ 18,040 MSGET cDesc   When .T. SIZE 180,7 PIXEL OF oTPane1  	
	      
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	
   	oGet :=    MSGetDados():New(100,100,100,100,nOpcX,"u_Mod2TudOk()","u_Mod2TudOk()",,.T.)
	
   	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT      


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	//Begin Transaction
	   Mod2Grava(cAlias1)
	//End Transaction
Endif
dbSelectArea(cAlias1)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de Grupos de Aprovadores                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mod2Altera( cAlias1, nRecNo, nOpcX )
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local oTPane1
Local oTPane2

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

  dbSelectArea(cAlias1)

  If RecCount() == 0
  	  Return .T.
  Endif
  
  cCodigo := PA3->PA3_CODIGO
  cDesc   := PA3->PA3_DESC
   
  u_CarregaGrid(cCodigo)
  //nOpcX      := GD_INSERT+GD_DELETE+GD_UPDATE
  DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd
	
	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,/*45*/45,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	//oTPane1:NCLRPANE := 14803406

	@  9, 006 SAY "Cod. Prod."  SIZE 70,7 PIXEL OF oTPane1
	@ 19, 006 SAY "Descricao"   SIZE 70,7 PIXEL OF oTPane1
    
	@  7,040 MSGET cCodigo When .F. SIZE 78,7 PIXEL   OF oTPane1
	@ 18,040 MSGET cDesc   When .T. SIZE 180,7 PIXEL OF oTPane1  
           
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	//oTPane2:NCLRPANE := 14803406
   	
//	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2TudOk()","u_Mod2TudOk()", "PA3_CODAPR",.T.)
    oGet := MSGetDados():New(0,0,0,0,4,,,,.T.,,,,,,,,,)	
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
                                                                                                                      
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})
//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
   //Begin Transaction
      Mod2Grava(cAlias1)
   //End Transaction
Endif

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclusao de Grupos de Aprovadores                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mod2Exclui( cAlias1, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local nX       := 0
Local oTPane1
Local oTPane2

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := {}

dbSelectArea(cAlias1)
If RecCount() == 0
	Return .T.
Endif

//Fazer pesquisa para saber se o(s) registro(s) pode(m) ser excluídos
cCodigo := PA3->PA3_CODIGO
cDesc   := PA3->PA3_DESC

u_CarregaGrid(cCodigo)

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd
	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,45,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP	
	//oTPane1:NCLRPANE := 14803406

	@  9, 006 SAY "Cod. Prod."  SIZE 70,7 PIXEL OF oTPane1
	@ 19, 006 SAY "Descricao"   SIZE 70,7 PIXEL OF oTPane1
    
	@  7,040 MSGET cCodigo When .F. SIZE 78,7 PIXEL   OF oTPane1
	@ 18,040 MSGET cDesc   When .F. SIZE 180,7 PIXEL OF oTPane1  
           
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	//oTPane2:NCLRPANE := 14803406   	  
	  	  
	oGet := MSGetDados():New(100,100,100,100,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})


If nOpcA == 1
   //Begin Transaction
      dbSelectArea(cAlias1)
      dbSetOrder(1)    
      dbSeek( cFilPA3 + cCodigo)
      
      While !Eof() .And. PA3->PA3_FILIAL + PA3->PA3_CODIGO == cFilPA3 + cCodigo
	     RecLock(cAlias1,.F.)
	     dbDelete()
	     MsUnLock()
	     
    	 dbSkip()	     
      End;
   	//End Transaction
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizado para Validacoes da grid(Nao utilizado)           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mod2TudOk()
Local lRet := .T.

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA012   ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa no Grupos de Aprovadores                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Mod2Pesq(cCampo)
Local nPos := 0
nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2]))==cCampo})
Return(nPos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Mod2Grava ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava as alteracoes no banco                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Mod2Grava(cAlias1)
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local lExist := .F.
Local cMsg := ""   
Local cCod2 := cCodigo   

cCodigo := ""

dbSelectArea(cAlias1)
dbSetOrder(1)

For nI := 1 To Len(aCols)                                     
   dbSeek( cFilPA3 + cCod2)
      
   lExist := .F.
   While !Eof() .And. PA3->PA3_FILIAL + PA3->PA3_CODIGO == CFilPA3 + cCod2
   	  If aCols[nI][Mod2Pesq("PA3_CODAPR")] == PA3->PA3_CODAPR
        lExist := .T.        
        exit
   	  endif         
   	  
   	  dbSkip()
   end
   	  
   If !aCols[nI][nUsado+1]            
      If lExist
         RecLock(cAlias1,.F.)
      Else
         dbGoTop()
         RecLock(cAlias1,.T.)
      Endif
      
      PA3->PA3_FILIAL := cFilPA3
      PA3->PA3_CODIGO := cCod2
      PA3->PA3_DESC   := cDESC
              
      For nY = 1 to Len(aHeader)
          cVar := Trim(aHeader[nY][2])
          Replace &cVar. With aCols[nI][nY]
      Next nY                
      
      MsUnLock(cAlias1)      
   Else
      If !lExist
         Loop
      Endif
      //Fazer pesquisa para saber se o item poderar ser deletado
      RecLock(cAlias1,.F.)
      dbDelete()
      MsUnLock(cAlias1)
   Endif
Next nI

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Mod2Grava ºAutor  ³Rafael Marin        º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava as alteracoes no banco                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PesqPA3()
Local lRet := .T.

dbSelectArea(cAlias1)
dbSetOrder(1)                  

If dbSeek( cFilPA3 + cCodigo)
   Alert("Codigo de Grupo já cadastrado!")
   lRet := .F.
Endif
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValidGrid ºAutor  ³Rafael Marin   º Data ³  31/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizada na Validacao do CodApr                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                           

User Function ValidGrid()
	Local aColsTemp := aClone(aCols)
    Local nI := 1
    Local lRet
    Local lUsr
          
    lRet := .T.
    For nI:=1 to Len(aCols)
    	If (aColsTemp[nI][Mod2Pesq("PA3_CODAPR")]==M->PA3_CODAPR) .And. (nI != n)
    		lRet := .F.
			Alert("Usuário já cadastrado neste grupo !")    	 
    		Return lRet
    	EndIf
    	
    	lUsr := Alltrim(Posicione("PA2",1,xFilial("PA2")+M->PA3_CODAPR,"PA2_CODUSR"))
    	If lUsr == ""
    		lRet := .F.
			Alert("Codigo de Aprovador não cadastrado !")    	 
    		Return lRet  	
    	EndIf    	
    End                -                                                                                 
          
	If lRet
    	aCOLS[n][Mod2Pesq("PA3_CODAPR")] := M->PA3_CODAPR
    	aCOLS[n][Mod2Pesq("PA3_CODUSR")] := Posicione("PA2",1,xFilial("PA2")+M->PA3_CODAPR,"PA2_CODUSR")	
	    aCOLS[n][Mod2Pesq("PA3_NOMUSR")] := Posicione("PA2",1,xFilial("PA2")+M->PA3_CODAPR,"PA2_NOME")
   		aCOLS[n][Mod2Pesq("PA3_TIPO")] 	 := Posicione("PA2",1,xFilial("PA2")+M->PA3_CODAPR,"PA2_TIPO")	                      
    Else 
    	aCOLS[n][Mod2Pesq("PA3_CODAPR")] := ""
    	aCOLS[n][Mod2Pesq("PA3_CODUSR")] := ""
	    aCOLS[n][Mod2Pesq("PA3_NOMUSR")] := ""
   		aCOLS[n][Mod2Pesq("PA3_TIPO")] 	 := ""
 	EndIf
Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarregaGridºAutor ³Microsiga           º Data ³  04/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CarregaGrid(cCod)             
Local cCodApr := Space(Len(PA3->PA3_CODAPR))
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias1 )
	While !EOF() .And. X3_ARQUIVO == cAlias1
		If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA3_FILIAL, PA3_CODIGO, PA3_DESC"))
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
	    	           X3_TAMANHO       ,;
	        	       X3_DECIMAL       ,;
	            	   X3_VALID         ,;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
		Endif
		dbSkip()
	End

	dbSelectArea(cAlias1)
	dbSeek( cFilPA3 + cCod)

	While !Eof() .And. PA3->PA3_FILIAL + PA3->PA3_CODIGO == cFilPA3 + cCod
        aAdd( aCOLS,Array(Len(aHeader)+1))
		nUsado:=0
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek( cAlias1 )
		
		While !EOF() .And. X3_ARQUIVO == cAlias1

		  If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA3_FILIAL, PA3_CODIGO, PA3_DESC"))
			nUsado++
			If X3_CONTEXT # "V"
  			    
  			    cVarTemp := cAlias1+"->"+(X3_CAMPO)
			    aCOLS[Len(aCOLS),nUsado] := &cVarTemp               
			    IF alltrim(X3_CAMPO) == "PA3_CODAPR"                                                           
			      cCodApr := &cVarTemp  
			    EndIf       
			Else    
			    IF alltrim(X3_CAMPO) == "PA3_CODUSR" 
    				aCOLS[Len(aCOLS)][nUsado] := Posicione("PA2",1,xFilial("PA2")+cCodApr,"PA2_CODUSR")	
			                                                              
			    ElseIF alltrim(X3_CAMPO) == "PA3_NOMUSR"                                                           
				    aCOLS[Len(aCOLS)][nUsado] := Posicione("PA2",1,xFilial("PA2")+cCodApr,"PA2_NOME")
			    
			    ElseIF alltrim(X3_CAMPO) == "PA3_TIPO"                                                           
			   		aCOLS[Len(aCOLS)][nUsado] 	 := Posicione("PA2",1,xFilial("PA2")+cCodApr,"PA2_TIPO")	                      
			    
			    EndIf			
			EndIf    
			    
	      EndIf
    	  dbSkip()
		End
		aCOLS[Len(aCOLS)][nUsado+1] := .F.
 	    dbSelectArea(cAlias1)
		dbSkip()
	End
Return NIL