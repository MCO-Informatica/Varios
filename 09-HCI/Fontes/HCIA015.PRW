/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA015   ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Desconto/Valor Maximo                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "Protheus.Ch"

User Function HCIA015()

Private cAlias1 := "PA4"
Private cFilPA4 := ""
Private cCadastro := "Cadastro de Desconto x Valor Máximo"
Private aRotina   := {}    

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"    ,0,1})
aAdd( aRotina, {"Incluir"    ,'u_DVInclui',0,3})
aAdd( aRotina, {"Alterar"    ,'u_DVAltera',0,4})
aAdd( aRotina, {"Excluir"    ,'u_DVExclui',0,5})

dbSelectArea(cAlias1)
dbSetOrder(1)

cFilPA4 := xFilial(cAlias1)
dbGoTop()

mBrowse(,,,,cAlias1)

dbSelectArea(cAlias1)
dbSetOrder(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA015   ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mod2Inclui -> Inclusao de Tipos por Filial                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DVInclui(cAlias1,nReg,nOpcX)
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oTPane2

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	
  
   If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA4_FILIAL"))
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

	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA4_FILIAL"))

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

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 520,800 OF oMainWnd
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_ALLCLIENT
	
   	oGet :=    MSGetDados():New(100,100,100,100,nOpcX,"u_Mod2TudOk()","u_Mod2TudOk()",,.T.)
   	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT      

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	   Mod2Grava(cAlias1)
	End Transaction
Endif
dbSelectArea(cAlias1)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA015   ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de Tipos por Filiais                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DVAltera( cAlias1, nRecNo, nOpcX )
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local oTPane2

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias1)

If RecCount() == 0
	Return .T.
Endif

dbSetOrder(1)
dbSeek(cFilPA4)

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL  .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA4_FILIAL"))  
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
dbSeek(cFilPA4)

While !EOF() .And. PA4->PA4_FILIAL == cFilPA4
   
   aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek(cAlias1)
	While !EOF() .And. X3_ARQUIVO == cAlias1
	 IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL  .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA4_FILIAL"))
		 //IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL  
	 
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
		 		aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))			                 
			Endif
		Endif
		dbSkip()
	End
	aCOLS[Len(aCOLS),nUsado+1] := .F.
	dbSelectArea(cAlias1)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_ALLCLIENT
	//oTPane2:NCLRPANE := 14803406

   	
	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2TudOk()","u_Mod2TudOk()", "PA4_TIPO",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
   Begin Transaction
      Mod2Grava(cAlias1)
   End Transaction
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA015   ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclusao de Grupos de Aprovadores                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DVExclui( cAlias1, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local nX       := 0
Local oTPane2

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := {}

dbSelectArea(cAlias1)
If RecCount() == 0
	Return .T.
Endif

//Fazer pesquisar para saber se o(s) registro(s) pode(m) ser excluídos

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias1 )
While !EOF() .And. X3_ARQUIVO == cAlias1
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA4_FILIAL"))
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
dbSeek( cFilPA4)

While !Eof() .And. PA4->PA4_FILIAL == cFilPA4
   aAdd( aCOLS, Array(Len(aHeader)+1))
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias1 )
	While !EOF() .And. X3_ARQUIVO == cAlias1
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. (.NOT. ALLTRIM(X3_CAMPO) $ ("PA4_FILIAL"))
       /// If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL 
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))			                 
			Endif
		Endif
		dbSkip()
	End
	dbSelectArea(cAlias1)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_ALLCLIENT
	  	  
	oGet := MSGetDados():New(100,100,100,100,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})


If nOpcA == 1
   Begin Transaction
      dbSelectArea(cAlias1)
      dbSetOrder(1)
      For nX = 1 to Len(aCols)
	     dbSeek( cFilPA4 )
	     RecLock(cAlias1,.F.)
	        dbDelete()
     Next nx
     MsUnLock(cAlias1)
   End Transaction
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA015   ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizado para Validacoes da grid(Nao utilizado)           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DVTudOk()
Local lRet := .T.

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIA015   ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
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
±±ºFuncao    ³Mod2Grava ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
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

dbSelectArea(cAlias1)
dbSetOrder(1)

For nI := 1 To Len(aCols)                                     
   dbSeek( cFilPA4)
      
   lExist := .F.
   While !Eof() .And. PA4->PA4_FILIAL == CFilPA4
   	  If aCols[nI][Mod2Pesq("PA4_TIPO")] == PA4->PA4_TIPO
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
      
      PA4->PA4_FILIAL := cFilPA4
             
      For nY = 1 to Len(aHeader)
          cVar := Trim(aHeader[nY][2])
          &cVar. := aCols[nI][nY]
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
±±ºFuncao    ³ValidTipo ºAutor  ³Rafael Marin        º Data ³  02/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizada na Validacao do Tipo por Filial                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                           

User Function ValidTipo()
	Local aColsTemp := aClone(aCols)
    Local nI := 1
    Local lRet
          
    lRet := .T.
    For nI:=1 to Len(aCols)
    	If (aColsTemp[nI][Mod2Pesq("PA4_TIPO")]==M->PA4_TIPO) .And. (nI != n)
    		lRet := .F.
			Alert("Tipo ja cadastrado nesta Filial")    	 
    		Exit
    	EndIf
    End                                                                                                 
Return(lRet)