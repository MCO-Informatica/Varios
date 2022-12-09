#include 'Protheus.ch'
#include 'TopConn.ch'
#DEFINE MAXGETDAD 4096

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTRMA03   ºAutor  ³Michel A. Sander    º Data ³  01/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Tabelas de Preços de Cursos                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User FUNCTION OpBn()

Local aCores := {}

PRIVATE aRotina := MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi('Ordens de Produção Beneficiamento')

aAdd(aCores,{'SC2->C2_TPOP == "F" .And. Empty(SC2->C2_DATRF) .And. (Max(dDataBase - SC2->C2_DATPRI,0) < If(SC2->C2_DIASOCI==0,1,SC2->C2_DIASOCI))' ,'BR_VERDE'		}) //
aAdd(aCores,{'SC2->C2_TPOP == "F" .And. !Empty(SC2->C2_DATRF) .And. SC2->(C2_QUJE < C2_QUANT)' ,'BR_AZUL'		}) // 
aAdd(aCores,{'SC2->C2_TPOP == "F" .And. !Empty(SC2->C2_DATRF) .And. SC2->(C2_QUJE >= C2_QUANT)' ,'BR_VERMELHO'		}) // 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SC2")
dbSetOrder(1)
Set Filter To LEFT(SC2->C2_NUM,1) = 'X'

mBrowse( 06, 01, 22, 75, 'SC2',,,,)

dbSelectArea("SC2")
Set Filter To 


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRMA03PrecºAutor  ³Michel A. Sander    º Data ³  01/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de manutenção da tabela de preços de cursos         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TRMA03Prec(nOpcX)

Local aObjects		:= {}
Local aInfo 		:= {}
Local aPosGet		:= {}
Local aPosObj		:= {}
Local aBut110		:= {}
Local aButtonUsr    := {}
Local aBtnBack		:= {}
Local aPosObjPE     := {}
Local nOpcA       := 0

PRIVATE aHeader := {}
PRIVATE aCols   := {}
PRIVATE nOpcWindow := nOpcX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader (1)                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

aCampos:={	'C2_ITEM',;
			'C2_PRODUTO',;
			'C2_UM',;
			'C2_LOCAL',;
			'C2_QUANT',;
			'C2_XPRSERV',;
			'C2_DATPRI',;
			'C2_DATPRF',;
			'C2_OBS',;
			'C2_CC'}

nUsado :=0 
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC2")
While ( !Eof() .And. SX3->X3_ARQUIVO == "SC2" )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) 
	   If Ascan(aCampos,ALLTRIM(SX3->X3_CAMPO)) == 0 //$"C2_FILIAL*C2_XOP*C2_NUM*C2_XLETRA*C2_CLI*C2_LOJA*C2_XDESCLI*C2_XDESCL"
	      SX3->(dbSkip())
	      Loop
	   EndIf
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
			TRIM(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT } )
	EndIf	
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aCols 	                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aRatAFM		:= {}					//Variavel utilizada pela Funcao PMSDLGOP - Gerenc. Projetos
PRIVATE bPMSDlgOP	:= {||PmsDlgOP(5,SC2->C2_NUM,SC2->C2_ITEM,SC2->C2_SEQUEN)} // Chamada da Dialog de Gerenc. Projetos
Private l650Auto := .f.
Private cFornece := Iif(nOpcX == 3,Space(06),SC2->C2_XFORNEC)
Private cLoja	 := Iif(nOpcX == 3,Space(02),SC2->C2_XLOJA)
Private cCond	 :=	Iif(nOpcX == 3,Space(03),SC2->C2_XCONDPG)
Private cNomFor	 :=	Iif(nOpcX == 3,Space(40),Posicione("SA2",1,xFilial("SA2")+SC2->C2_XFORNEC+SC2->C2_XLOJA,"A2_NOME"))

If nOpcX == 3		// INCLUSAO
	cLetra := 'X'
	cQry:= "SELECT "+CRLF
	cQry+="   CASE WHEN "+CRLF
	cQry+="     '"+cLetra+"'+REPLICATE('0',5-LEN(MAX(SUBSTRING(C2_NUM,2,6))+1))+''+CONVERT(VARCHAR,MAX(SUBSTRING(C2_NUM,2,6))+1) IS NULL "+CRLF
	cQry+="         THEN "+CRLF
	cQry+="            '"+cLetra+"'+'00001' "+CRLF
	cQry+="		 ELSE "+CRLF
	cQry+="            '"+cLetra+"'+REPLICATE('0',5-LEN(MAX(SUBSTRING(C2_NUM,2,6))+1))+''+CONVERT(VARCHAR,MAX(SUBSTRING(C2_NUM,2,6))+1)"+CRLF
	cQry+="	   END 'NUMSEQ' "+CRLF
	cQry+="FROM " + RetSqlName("SC2") + " WITH(NOLOCK)"+CRLF
	//cQry+=" WHERE D_E_L_E_T_ <> '*'"+CRLF comentado devido ser considerado no momento da exclusao a numeracao
	cQry+="   WHERE LEFT(C2_NUM,1) = '"+cLetra+"'	AND LEN(RTRIM(C2_NUM)) = 6 AND RIGHT(RTRIM(C2_NUM),1) IN ('0','1','2','3','4','5','6','7','8','9')	"+CRLF      
	MemowRite("c:\temp\Qryout.sql",cQry)
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())  // INSERIDO POR MATEUS HENGLE - 17/03/14 PARA TENTAR SOLUCIONAR O ERRO
	EndIf
	
	TcQuery cQry New Alias "TRB"
	
	DbSelectArea("TRB");TRB->(dbGotop())
	DbSelectArea("SC2");SC2->(dbSetOrder(1)) // Necessario para abrir WorkArea
	if TRB->(!Eof())
		cNumOp := Alltrim(TRB->NUMSEQ)
	Else
		cNumOp := 'X00001'
	Endif

	RegToMemory("SC2",.T.)
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	Next nCntFor      
	aCols[1, aScan(aHeader,{|x|AllTrim(x[2])=="C2_ITEM"   }) ] := '01'
	aCOLS[1][Len(aHeader)+1] := .F.        
	
	M->C2_XLETRA := '8'             
	M->C2_XOP 	 := '1'
	
Else
	cNumOp := SC2->C2_NUM
	
	RegToMemory("SC2",.F.)
	bWhile := {|| xFilial("SC2") == SC2->C2_FILIAL .And. ;
	              cNumOp      == SC2->C2_NUM }
	SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cNumOp))
	
	While ( SC2->(!Eof()) .And. Eval(bWhile) )
		aadd(aCols,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			If ( aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := SC2->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCols[Len(aCols)][nCntFor] := SC2->(CriaVar(aHeader[nCntFor][2]))
			EndIf
		Next nCntFor
		aCols[Len(aCols)][nUsado+1] := .F.
		SC2->(dbSkip())
	EndDo
EndIf
                                                    
nGetDados := 0
If nOpcX == 3 .Or. nOpcX == 4
   nGetDados := GD_INSERT + GD_UPDATE + GD_DELETE
Else
   nGetDados := 5
EndIf

aSizeAut	:= MsAdvSize(,.F.)
aadd( aObjects, { 0,    30, .T., .F. } )
aadd( aObjects, { 100, 100, .T., .T. } )
aadd( aObjects, { 0,    3, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ordens de Produção Beneficiamento") From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL Style DS_MODALFRAME 
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL ""  OF oDlg PIXEL 
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define o cabecalho da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ aPosObj[1,1]+05,aPosGet[1,1] SAY OemToAnsi("Numero O.F.:") Of oDlg PIXEL
@ aPosObj[1,1]+04,aPosGet[1,2] MSGET cNumOp Picture '@!' WHEN (nOpcX == 3) Valid(fVldOF(cNumOp,nOpcX)) Of oDlg PIXEL
	
@ aPosObj[1,1]+18,aPosGet[1,1] SAY OemToAnsi("Fornecedor:") Of oDlg PIXEL
@ aPosObj[1,1]+17,aPosGet[1,2] MSGET cFornece Picture '@!' F3 'FOR' WHEN (nOpcX == 3) Valid(!Empty(cFornece)) Of oDlg PIXEL

@ aPosObj[1,1]+17,aPosGet[1,2]+40 MSGET cLoja Picture '@!' SIZE 010,10 WHEN (nOpcX == 3) Valid(!Empty(cLoja) .And. fVldFn(cFornece,cLoja,@cNomFor,nOpcX,@cCond)) Of oDlg PIXEL

@ aPosObj[1,1]+17,aPosGet[1,2]+70 MSGET cNomFor Picture '@!' WHEN .f. Of oDlg PIXEL

@ aPosObj[1,1]+18,aPosGet[1,1]+460 SAY OemToAnsi("Cond.Pgto:") Of oDlg PIXEL
@ aPosObj[1,1]+17,aPosGet[1,2]+450 MSGET cCond Picture '@!' F3 'SE4' WHEN (nOpcX == 3) Valid(!Empty(cCond) .And. fVldCp(cCond,nOpcX)) Of oDlg PIXEL

oGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nGetDados,"AllWaysTrue()","AllWaysTrue()","+C2_ITEM",,,MAXGETDAD,,,,,aHeader,aCols)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||Iif(U_SC2_GRAVA(cNumOp,oGet:aHeader,oGet:Acols,nOpcX),oDlg:End(),nx:=1)},{||oDlg:End()},,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os dados					                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If nOpcA == 1
//   aCols := oGet:Acols
//   MsAguarde({|| U_SC2_GRAVA(cNumOp,aHeader,aCols,nOpcX) },"Processando...","Aguarde, Incluindo Ordem de Produção Beneficiamento ... ")
//EndIf   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PW1_GRAVA ºAutor  ³Michel A. Sander    º Data ³  01/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para atualizar a lista de preços                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SC2_GRAVA(cNumOp,aHeader,aCols,nOpcWindow)
Local aArea := GetArea()
Local lProcura := .t.      
Local i 	   := 0
      
Begin Transaction     

	If ( nOpcWindow == 3)	// Inclusao ou Alteracao
		If MsgYesNo("Confirma a Inclusão da Ordem de Produção Beneficiamento e seus Itens ?")	
		
			cItem := '01'
		
			Begin Transaction
			For nI := 1 To Len(aCols)
				If aCols[Len(aCols)][Len(aHeader)+1]	// Linha Excluida
					Loop
				Endif
			
				IncProc("Criando ordem de produção")
				// Cria OP
				lMsErroAuto := .F.
				
				SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_PRODUTO"   }) ]))
				
				_aVetor := {	{"C2_NUM"    , cNumOp			, Nil},; 
								{"C2_ITEM"   , cItem, Nil},;
								{"C2_SEQUEN" , '001'	, Nil},;
								{"C2_PRODUTO", aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_PRODUTO"   }) ]		, Nil},;
								{"C2_QUANT"  , aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_QUANT"   }) ]				, Nil},;
								{"C2_CC"     , aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_CC"   }) ]			, Nil},;
								{"C2_LOCAL"  , aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_LOCAL"   }) ]		, Nil},;
								{"C2_DATPRI" , aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_DATPRI"   }) ]			, Nil},;
								{"C2_DATPRF" , aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_DATPRF"   }) ]			, Nil},;
								{"C2_EMISSAO", dDataBase, Nil},;
								{"C2_UM", SB1->B1_UM , Nil},;
								{"C2_OBS", aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_OBS"   }) ]			, Nil},;
								{"C2_XLETRA", '8' , Nil},;
								{"C2_XFORNEC", cFornece	, Nil},;
								{"C2_XLOJA", cLoja	, Nil},;
								{"C2_XCONDPG", cCond	, Nil},;
								{"C2_XPRSERV", aCols[nI, aScan(aHeader,{|x|AllTrim(x[2])=="C2_XPRSERV"   }) ]			, Nil},;
								{"AUTEXPLODE", "S"				, Nil}  }
								
				l650Auto	:= .t.								
								
				MSExecAuto({|x, y| mata650(x, y)}, _aVetor, nOpcWindow)	// Inclusao
				
				l650Auto := .f.
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
					Return .f.
				Endif            
				
				If SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cNumOp))
					xItem := '01'
					While SC2->(!Eof()) .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_NUM == cNumOP
						xItem := SC2->C2_ITEM
						
						SC2->(dbSkip(1))
					Enddo
					cItem := Soma1(xItem,2)
				Else
					cItem := Soma1(cItem,2)
				Endif
			Next
			End Transaction
		Endif
	EndIf
		
End Transaction            

If ( nOpcWindow == 3)	// Inclusao ou Alteracao
	nOpc := 1
	MTA650OK(@nOpc)
Endif

Return(.t.)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TRMA03Leg³ Autor ³ Michel A. Sander      ³ Data ³01/05/13    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela contendo a legenda da mBrowse.              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum Codigo do comprador                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RTRMA03                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TRMA03Leg()

Local aCores     := {}
Local aCoresNew  := {}   

aAdd(aCores,{"BR_VERDE"	,"O.F. em Aberto"})
aAdd(aCores,{"BR_AZUL","O.F. Parcial"})
aAdd(aCores,{"BR_VERMELHO","O.F. Encerrada"})
BrwLegenda(cCadastro,"Legenda",aCores)

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Michel A. Sander    º Data ³  01/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Menu Principal 						                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MenuDef()

Local aRotina := { { 'Pesquisar'    ,"axPesqui",       0 , 1},; //Pesquisar
                     { 'Visualizar' ,"U_TRMA03Prec(2)", 0 , 2},;  //Visualizar
                     { 'Incluir'    ,"U_TRMA03Prec(3)", 0 , 3},; //Incluir
                     { 'Imprimir'   ,"U_PEDOPGRF()", 0 , 4},; //Imprimir
                     { 'Legenda'    ,"U_TRMA03Leg()", 0,2 } } //Legenda

//                     { 'Excluir'    ,"U_TRMA03Prec(5)", 0 , 5},;
Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fVldOF   ºAutor  ³ Luiz Alberto V Alvesº Data ³  01/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Menu Principal 						                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVldOF(cNumOp,nOp)
If nOp==3 .And. SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cNumOP))
	MsgStop("Atenção Numeração de Ordem de Fabricação Já Existente !")
	Return .f.
Endif
If nOp==3 .And. Left(cNumOp,1) <> 'X'
	MsgStop("Atenção Para Ordens de Fabricação Beneficiamento, o Inicio da Numeração deve Iniciar-se por X")
	Return .f.
Endif
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fVldOF   ºAutor  ³ Luiz Alberto V Alvesº Data ³  01/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Menu Principal 						                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVldFn(cFornece,cLoja,cNomFor,nOp,cCond)
If !SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+cFornece+cLoja))
	MsgStop("Fornecedor Não Localizado !")
	Return .f.
Endif     
cNomFor	 	:=	Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NOME")
cCond 		:= SA2->A2_COND

M->C2_XFORNEC := cFornece
M->C2_XLOJA	  := cLoja
Return .t.


Static Function fVldCP(cCond,nOp)
If !SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+cCond))
	MsgStop("Condicao de Pagamento Não Localizado !")
	Return .f.
Endif
Return .t.


User Function MTSELEOP()

If Type("l650Auto") == "U"
	l650Auto := .f.
Endif

If l650Auto
	Return .f.
Endif
Return .t.


User Function OpBnPrc(cProduto)
Local aArea := GetArea()
Local nPrec := 0.00

If Type("cFornece") == "U"
	Return nPrec
Endif

If AIA->(dbSetOrder(1), dbSeek(xFilial("AIA")+cFornece+cLoja))
   	If AIB->(dbSetOrder(2), dbSeek(xFilial("AIB")+cFornece+cLoja+AIA->AIA_CODTAB+cProduto))
   		While AIB->(!Eof()) .And. AIB->AIB_FILIAL == xFilial("AIB") .And. AIB->AIB_CODFOR == cFornece .And. AIB->AIB_LOJFOR == cLoja .And. AIB->AIB_CODTAB == AIA->AIA_CODTAB .And. AIB->AIB_CODPRO == cProduto
   			If AIB->AIB_DATVIG >= FirstDate(dDataBase)
				nPrec := AIB->AIB_PRCCOM
				Exit
			Endif
			
			AIB->(dbSkip(1))
		Enddo
	Endif
Endif

RestArea(aArea)
Return nPrec