#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE "FILEIO.CH"
#Define ENTER Chr(13)+Chr(10) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI030  ºAutor  ³ºFelipi Marques       Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manifestação do Destinatário                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMMI030() 

Local aCores  	:= {}
Local aCoresNew	:= {}

Local lRet    	:= .T.
Local lInverte  := .F.

Local cFilSQL 	:= ""

Private aRotina	  := MenuDef()
Private cMarca	  := GetMark(,"Z01", "Z01_OK" )
Private cCadastro := "Monitor de Ciencia da Operação" 
Private aRegMark  := {}
Private aCols     := {}
Private aIndices  := {}
Private aHeader   := {}	                                           
Private aIndZ01	:= {}
Private cFilBrw 	:= ""


aAdd(aCores,{"Z01_STAXML $  ('1*5*0')   .And. Z01_STADOW == '1'"      , "ENABLE"      ,"Aguardando Ciência"                    })	// -- "Aguardando Ciência"    
aAdd(aCores,{"Z01_STAXML $  ('4')       .And. Z01_STADOW == '1'"      , "BR_AZUL"     ,"Ciência Realizada"                     })	// -- "Ciência Realizada"  MH 28/12/2019  
aAdd(aCores,{"Z01_STAXML $  ('1*4*5*9') .And. Z01_STADOW == '2' "     , "DISABLE"     ,"Manifestação Realizada"                })	// -- "Manifestação Realizada"   
aAdd(aCores,{"Z01_STAXML $  ('9') .And. Z01_STADOW == '1' "           , "BR_LARANJA"  ,"Erro na importação XML"                })	// -- "Erro na importação XML"   
aAdd(aCores,{"Z01_STAXML == '6' .AND. Z01_STADOW == '1' "             , "BR_AMARELO"  ,"Erro na Manifestação"                  })	// -- "Erro na Manifestação" // MH 07/01/2019
aAdd(aCores,{"Z01_STAXML == '6' .AND. Z01_STADOW == '2' "             , "BR_PRETO"    ,"Cancelada/Denegada"                    })	// -- "Cancelada/Denegada" // MH 07/01/2019
aAdd(aCores,{"Z01_STAXML == '7' .AND. Z01_STADOW == '3' "             , "BR_BRANCO"   ,"Nfe fora do Período da Sefaz"          })	// -- "Nfe fora do Período da Sefaz" // MH 07/01/2019
aAdd(aCores,{"Z01_STAXML == '7' .AND. Z01_STADOW == '2' "             , "BR_CINZA"    ,"Nfe não tratada (Complemento/Ajuste)"  })	// -- "Nfe não tratada (Complemento/Ajuste)" // MH 08/01/2019
aAdd(aCores,{"Z01_STAXML $  '2/3' "                                   , "BR_VIOLETA"  ,"Op não realizada/Nfe Desconhecida"     })	// -- "Op não realizada/Nfe Desconhecida" // MH 08/01/2019

cFilBrw += ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("Z01")
dbSetOrder(2)
bFiltraBrw := {|| FilBrowse("Z01",@aIndZ01,@cFilBrw) }

If lRet                                                                                                                                     //Z01_STAXML == '9'
	MsgRun("Aplicando filtros e preparando inferface... ","Aguarde",{|| CursorWait(),Eval(bFiltraBrw),CursorArrow(),MarkBrow("Z01","Z01_OK"," ",,lInverte,cMarca,'StaticCall(COMMI030,MarkAll)',,,,'U_CXMark()',,,,aCores)}) 
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Legenda()

Local aLegenda    := {  {"ENABLE"     ,OemToAnsi("Aguardando Ciência"         )    },;
   				        {"BR_AZUL"    ,OemToAnsi("Ciência Realizada"          )    },; ///MH 28/12/2019
   				        {"BR_AMARELO" ,OemToAnsi("Erro na Manifestação"       )    },; // MH 07/01/2019
   				        {"BR_PRETO"   ,OemToAnsi("Cancelada/Denegada"         )    },; // MH 07/01/2019
   				        {"BR_CINZA"   ,OemToAnsi("Nfe não tratada (Complemento/Ajuste)" )},; // MH 08/01/2019
   				        {"BR_VIOLETA" ,OemToAnsi("Op não realizada/Nfe Desconhecida" )   },; // MH 08/01/2019
   				        {"BR_BRANCO"  ,OemToAnsi("Nfe fora do Período da Sefaz"  ) },; // MH 07/01/2019
   				        {"BR_LARANJA" ,OemToAnsi("Erro Importação XML"		  )    },;   	
   						{"DISABLE"    ,OemToAnsi("Manifestação Realizada"     )    }} 
   						/*
 						{"BR_AZUL"    ,OemToAnsi("Ciência"           		  )    },;
						{"BR_LARANJA" ,OemToAnsi("Confirmada"       		  )    },;
				        {"BR_AMARELO" ,OemToAnsi("Desconhecida"     		  )    },;
  				        {"BR_CINZA"    ,OemToAnsi("Não realizada"    		  )    },;  
  				        {"BR_VIOLETA" ,OemToAnsi("Erro na Ciência"            )    },;    						
                        */
   						
			      
BrwLegenda( cCadastro, "Legenda", aLegenda)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDef  ºAutor  ³Felipi Marques      º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta as opcoes de rotina.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MenuDef                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
Local aRotAlt		:= {}
PRIVATE aRotina	:= {}

aAdd(aRotina,{"Pesquisar"              ,"PesqBrw"		                      ,0,1,0,.F.}) 					 
aAdd(aRotina,{"Visualizar"             ,"U_COMMS3VI(2,RecNo())"		          ,0,2,0,NIL})	 
aAdd(aRotina,{"Busca NFe Sefaz"		   ,"StaticCall(COMMI030,Pesquisa)"       ,0,3,0,nil}) 
aAdd(aRotina,{"Ciência"                ,"StaticCall(COMMI030,Ciencia)"        ,0,6,0,nil}) 
aAdd(aRotina,{"Manifestação"   	       ,"StaticCall(COMMI030,Manifesta)"      ,0,6,0,nil}) 
aAdd(aRotina,{"Log de Operação"        ,"U_COMMS3ER(2,RecNo())"               ,0,6,0,nil}) 
aAdd(aRotina,{"Exporta XML"            ,"StaticCall(COMMI030,Exportar)"       ,0,2,0,nil})  
aAdd(aRotina,{"Wiz.Config"       	   ,"SpedNFeCfg"                          ,0,3,0,nil}) 
aAdd(aRotina,{"Legenda"                ,"StaticCall(COMMI030,Legenda)"        ,0,3,0,.F.})	   

Return aRotina

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ pesquisa  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Pesquisa de notas fiscais                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/    

Static Function pesquisa()

U_MCOMR01()

dbSelectArea("Z01")
dbSetOrder(2)
bFiltraBrw := {|| FilBrowse("Z01",@aIndZ01,@cFilBrw) }
Eval(bFiltraBrw)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MarkAll  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function MarkAll()
Local nRecno := Z01->(Recno())
Local nPosReg := 0

Z01->(dbGoTop())
While !Z01->(EOF())
	If Z01->Z01_STAXML <> '9'
		Reclock("Z01",.F.)
		Z01->Z01_OK := If(Z01->Z01_OK == cMarca,"",cMarca)
		Z01->(MsUnlock())

		//³ Armazena ou exclui os registros de aRegMark conforme a marcacao.³
		nPosReg := aScan(aRegMark,{|x| x == Z01->(Recno())})

		If IsMark("Z01_OK",cMarca)
			If nPosReg == 0
				aAdd(aRegMark,Z01->(Recno()))
			EndIf
		Else
			If nPosReg > 0
				aDel(aRegMark,nPosReg)
				aSize(aRegMark,(Len(aRegMark)-1))
			EndIf
		EndIf
	EndIf
	Z01->(dbSkip())
EndDo

Z01->(dbGoto(nRecno))
    
Return


/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±± 
±±ºPrograma  ³ ComXMark	ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para armazenar os numeros dos registros marcados na º±±
±±º            MarkBrowse para que não seja necessário percorrer toda a   º±±
±±º            tabela SDS para gerar os documentos.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CXMark()

Local aArea   := GetArea()
Local nRecno  := Recno()
Local nPosReg := aScan(aRegMark,{|x| x == nRecno})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Codigo para tratamento da marcacao de registros na MarkBrowse.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("Z01",.F.)
Z01->Z01_OK := Iif( IsMark("Z01_OK",cMarca) , Space(Len(Z01->Z01_OK)) , cMarca )
MsUnLock()
Z01->(dbCommit())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena ou exclui os registros de aRegMark conforme a marcacao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsMark("Z01_OK",cMarca)
	If nPosReg == 0
		aAdd(aRegMark,Z01->(Recno()))
	EndIf
Else
	If nPosReg > 0
		aDel(aRegMark,nPosReg)
		aSize(aRegMark,(Len(aRegMark)-1))
	EndIf
EndIf

RestArea(aArea)
MarkBRefresh()

Return .T.   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Ciencia  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function Ciencia()

Local nRegs   := 0
Local nRecno  := SDS->(Recno())
Local nQtdNF	:= Len(aRegMark)
Local oGet1
Local cGet1 := "Selecionar um tipo de Manifestação"
Local oGet2
Local cGet2 := Space(150)
Local oSay1                     
Local cSay2 
Local oSay2
Local oSButton1     
Local oFont  	:= TFont():New("Arial",,014,,.F.,,,,,.F.,.F.) 
Local oMemoFont := TFont():New("Courier New",6,0,.F.,.F.,,,,.F.,.F.,,,,,,)
Local lConfirma :=.F.

Static oDlgMan
Private nCbx      := 3
Private oComboBo1
Private cComboBo1 := "3-Ciência da operação"

If nQtdNF = 0
	Return
EndIf

 DEFINE MSDIALOG oDlgMan TITLE "Manifestar NF-e" FROM 000, 000  TO 400, 500 COLORS 0, 16777215 PIXEL
    
	@ 003, 022 SAY oSay1 PROMPT "Tipo de Manifestação" SIZE 200, 009 OF oDlgMan COLORS 0, 16777215 PIXEL Font oFont

    @ 013, 022 MSCOMBOBOX oComboBo1 VAR cComboBo1 ITEMS {"1-Tipo de Manifestação","2-Confirma a operação","3-Ciência da operação","4-Desconhecimento da Operação","5-Operação não realizada"} SIZE 200, 010 OF oDlgMan COLORS 0, 16777215 PIXEL   
    oComboBo1:bChange := {|| AjManif(@oGet1,@cGet1,@oGet2,@cGet2,@oSay2,@cSay2) }
    
    @ 038, 022 GET oGet1 VAR cGet1 OF oDlgMan MULTILINE SIZE 199, 101 COLORS 0, 16777215 HSCROLL PIXEL  FONT oMemoFont READONLY DESIGN NOBORDER
  
    @ 148, 021 SAY oSay2 PROMPT cSay2  SIZE 198, 007 OF oDlgMan COLORS 0, 16777215 PIXEL
	
	@ 156, 022 MSGET oGet2 VAR cGet2 SIZE 200, 024 OF oDlgMan COLORS 0, 16777215 PIXEL
	
	oGet2:Hide()
    oSay2:Hide()                                                                       
                                                                                          
    
    DEFINE SBUTTON FROM 185,167 TYPE 1 ACTION (lConfirma:=.T.,oDlgMan:End()) OF oDlgMan ENABLE  
    DEFINE SBUTTON FROM 185,195 TYPE 2 ACTION (lConfirma:=.F.,oDlgMan:End()) OF oDlgMan ENABLE                                                                                                                                                                              


  ACTIVATE MSDIALOG oDlgMan CENTERED
  
    cComboBo1 := SubStr(cComboBo1,1,1)  
  
	Do Case
		Case cComboBo1 == "1" 
			Aviso("Atenção","Selecionar um tipo de Manifestação",{"OK"}) 
			Return()
		Case cComboBo1 == "2"
			If MsgYesNo("Confirmação dos documentos dos itens selecionados?","Atenção") 
				LJMsgRun("Monitor de Confirmação da Operação","Geração de Confirmação",{|| ProcConf(nQtdNF) })
				SDS->(dbGoTo(nRecno))
				aRegMark := {}
			EndIf 
		Case cComboBo1 == "3" 
			If MsgYesNo("Confirma a ciência dos documentos para os itens selecionados?","Atenção") 
			   	LJMsgRun("Monitor de Ciencia da Operação","Geração de Ciências",{|| ProcCien(nQtdNF) })
				SDS->(dbGoTo(nRecno))
				aRegMark := {}
			EndIf
		Case cComboBo1 == "4" 
			If MsgYesNo(,"Atenção") 
				LJMsgRun("Confirma o desconhecimento dos documentos para os itens selecionados?","Monitor de desconhecimento da Operação",{|| ProcDesc(nQtdNF , Alltrim(UPPER(cGet2)) ) })
				SDS->(dbGoTo(nRecno))
				aRegMark := {}
			EndIf 
		Case cComboBo1 == "5" 
			If MsgYesNo("Confirma a operação não realizada dos documento para os itens selecionados?","Atenção") 
		  		LJMsgRun("Monitor de operação não realizada","Geração de Confirmação",{|| ProcNReal(nQtdNF) })
				SDS->(dbGoTo(nRecno))
				aRegMark := {}
			EndIf  
	End	Case

dbSelectArea("Z01")
dbSetOrder(2)
bFiltraBrw := {|| FilBrowse("Z01",@aIndZ01,@cFilBrw) }
Eval(bFiltraBrw)
Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI030  ºAutor  ³Microsiga           º Data ³  08/18/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjManif(oGet1,cGet1,oGet2,cGet2,oSay2,cSay2)

Do Case
	Case oComboBo1:nAt == 1 
		cGet1 := "Selecionar um tipo de Manifestação"	
		oGet2:Hide()
		oSay2:Hide()
	Case oComboBo1:nAt == 2
		cGet1 := "Confirmação da operação – confirmando a ocorrência da operação e o recebimento da mercadoria (para as operações com circulação de mercadoria);"	
		nCbx := oComboBo1:nAt
		oGet2:Hide() 
		oSay2:Hide()
	Case oComboBo1:nAt == 3 
		cGet1 := "Ciência da emissão – declarando ter ciência da operação destinada ao CNPJ, mas ainda não possui elementos suficientes para apresentar uma manifestação conclusiva, como as acima citadas." 	
		oGet2:Hide()
		oSay2:Hide()
	Case oComboBo1:nAt == 4 
		cGet1 := "Desconhecimento da operação – declarando o Desconhecimento da Operação;"	
		cSay2 := "Justificativa"
		oGet2:Show() 
		oSay2:Show() 
	Case oComboBo1:nAt == 5 
		cGet1 := "Operação não Realizada – declarando que a Operação não foi Realizada (com Recusado Recebimento da mercadoria e outros) e a justificativa porque a operação não se realizou;"		
		oSay2:Hide()
		oGet2:Hide()
End	Case
	
	oGet1:Refresh()
	oGet2:Refresh()
	oSay2:Refresh()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcCien  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function ProcCien(NREGS)

Local lRet		:= .F.
Local nX	 	:= 0
Local nY		:= 0
Local nCount 	:= 0 
	
Local cTpAmb	:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
Local cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
Local cEvento   := "210210–Ciencia da Operacao"
Local cJust     := ""
Local cCNPJ		:= SM0->M0_CGC    
Local nRegSav	:= 0

ProcRegua(nRegs)
For nY := 1 To nRegs 
	Z01->(dbGoTo(aRegMark[nY]))
	If (Z01->Z01_OK == cMarca)    
		nRegSav := Z01->(Recno())

		If Z01->Z01_STAXML $ ('1*5*0') .AND. Z01->Z01_STADOW <> "9" 
			
			// Rotina para geração da ciencia
			U_ACOMR05(cTpAmb, cUfAutor, cCNPJ, 1, Z01->Z01_CHVNFE,cEvento,cJust)
			
			// Limpa Flag Ok 
			DbSelectArea("Z01")
			DbGoto(nRegSav)
			
			RecLock("Z01",.F.)
			Z01->Z01_OK	:= ''
			Z01->(MsUnLock())
			
			Z01->(DbSkip())
		End
	EndIf

Next nY

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcConf  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function ProcConf(NREGS)

Local lRet		:= .F.
Local nX	 	:= 0
Local nY		:= 0
Local nCount 	:= 0 
	
Local cTpAmb	:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
Local cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
Local cEvento   := "210200–Confirmacao da Operacao"
Local cJust     := ""
Local cCNPJ		:= SM0->M0_CGC

ProcRegua(nRegs)
For nY := 1 To nRegs 
	Z01->(dbGoTo(aRegMark[nY]))
	If (Z01->Z01_OK == cMarca)

		If Z01->Z01_STAXML $  ('1*5*0') .AND. Z01->Z01_STADOW <> "9" //Z01->Z01_STAXML == "1" .And. 
			
			// Rotina para geração da ciencia
			U_ACOMR05(cTpAmb, cUfAutor, cCNPJ, 1, Z01->Z01_CHVNFE,cEvento,cJust)
			
			// Limpa Flag Ok
			RecLock("Z01",.F.)
			   	Replace Z01->Z01_OK	With ''
			Z01->(MsUnLock())
			
			Z01->(DbSkip())
		End
	EndIf

Next nY

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcDesc  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function ProcDesc(NREGS,cJust)

Local lRet		:= .F.
Local nX	 	:= 0
Local nY		:= 0
Local nCount 	:= 0 
	
Local cTpAmb	:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
Local cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
Local cEvento   := "210220–Desconhecimento da Operacao"
Local cCNPJ		:= SM0->M0_CGC

ProcRegua(nRegs)
For nY := 1 To nRegs 
	Z01->(dbGoTo(aRegMark[nY]))
	If (Z01->Z01_OK == cMarca)

		If .NOT. Z01->Z01_STAXML $ ('2/3') 
					
			// Rotina para geração da ciencia
			U_ACOMR05(cTpAmb, cUfAutor, cCNPJ, 1, Z01->Z01_CHVNFE,cEvento,cJust)
			
			// Limpa Flag Ok
			RecLock("Z01",.F.)
			   	Replace Z01->Z01_OK	With ''
			Z01->(MsUnLock())
						
			Z01->(DbSkip())
		End
	EndIf

Next nY

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcNReal  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function ProcNReal(NREGS)

Local lRet		:= .F.
Local nX	 	:= 0
Local nY		:= 0
Local nCount 	:= 0 
	
Local cTpAmb	:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
Local cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
Local cEvento   := "210240–Operacao nao Realizada"
Local aRetTela  := {}
Local cJust     := ""
Local cCNPJ		:= SM0->M0_CGC

ProcRegua(nRegs)
For nY := 1 To nRegs 
	Z01->(dbGoTo(aRegMark[nY]))
	If (Z01->Z01_OK == cMarca)

		If .NOT. Z01->Z01_STAXML $ ('3')  
            //Chama Rotina para tela.
			aRetTela := TelaJust()		
            
            cJust  := aRetTela[1]
            cJust  := U_ConvASC(cJust)
            nOpcTl := aRetTela[2]
            
            //Vaidação do retorno de tela
			If nOpcTl == 0
		   		Return
			ElseIf Empty(cJust) 
				MsgStop("Digitar a Justificativa, rotina Cancelada!","Atenção")
				Return
			EndIf 
			
			// Rotina para geração da ciencia
			U_ACOMR05(cTpAmb, cUfAutor, cCNPJ, 1, Z01->Z01_CHVNFE,cEvento,cJust)
			
			// Limpa Flag Ok
			RecLock("Z01",.F.)
			   	Replace Z01->Z01_OK	With ''
			Z01->(MsUnLock())
						
			Z01->(DbSkip())
		End
	EndIf

Next nY

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  COMMS3VI ºAutor ³Felipi Marques         º Data ³   02/08/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta interface de visualização e vinculo do documeto.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nOpc: opcao de rotina acionada (2=Visualizar )        	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function COMMS3VI(nOpc,_nRecno) 

Local alAdvSz    := MsAdvSize(,.F.,400)
Static oDlg
Local nOpcA      	:= 0
Local bCancel  	    := {|| nOpcA := 0, oDlgMain:End() }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Botões de visualizações das legendas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aButtons      := {}

aAdd(aButtons, {'LEGENDA'	,{||TelaL()},"Visualizar Legenda",OemToAnsi("Legenda")} )

DEFINE MSDIALOG oDlg TITLE "Visualização status da ciência" FROM alAdvSz[7]+45,0 TO alAdvSz[6],alAdvSz[5] COLORS 0, 16777215 PIXEL
    RegToMemory("Z01", .F., .F.)
    fEnchoic1()
    fMSNewGe1()
 
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()},, aButtons)


Return
 


//------------------------------------------------ 
Static Function fEnchoic1()
//------------------------------------------------ 
Local aFields      := {}
Local aAlterFields := {}  
lOCAL aCampos      := {} 
Local aSize    	   := MsAdvSize()
Static oEnchoic1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida o usuário para descubrir que campo usar no preenchimento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aCampos, "Z01_CHVNFE" )
aAdd( aCampos, "Z01_NUMNFE" )
aAdd( aCampos, "Z01_SERNFE" )
aAdd( aCampos, "Z01_NOME"   )
aAdd( aCampos, "Z01_CGC"    )
aAdd( aCampos, "Z01_INSCR"  )
aAdd( aCampos, "Z01_DTEMIS" )
aAdd( aCampos, "Z01_HORA"   )
aAdd( aCampos, "Z01_TOTAL"  )
aAdd( aCampos, "Z01_STAXML" )
aAdd( aCampos, "NOUSER"     )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
AAdd( aObjects,{200,200, .t., .T. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

oEnchoic1 := MSMGet():New("Z01", Z01->(RecNo()),3,,,,aCampos,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},aCampos,1,,,,oDlg,,,,,.T.,.T.,,,)

Return()

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"Z02_NUMNF","Z02_SERIE","Z02_NFXML","Z02_DTIMP","Z02_HRIMP","Z02_USER"} 
Local aAlterFields	:= {}
Local aSize     	:= MsAdvSize()
Local y				:= 0
Static oMSNewGe1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Leds utilizados para as legendas das rotinas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oRed      := LoadBitmap( GetResources(), "BR_VERMELHO")
Local oBlue     := LoadBitmap( GetResources(), "BR_AZUL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campo de marcacao																		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aHeaderEx,{	"","COR","@BMP",1,;
					0,.T.,"","",""	,;
					"R","","",.F.,"A",;
					.T.,"","",""         })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o aHeader              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("Z02")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX])) 
    	Aadd(aHeaderEx, {  AllTrim( X3Titulo()),;
			                        SX3->X3_CAMPO,;
			                        SX3->X3_PICTURE,;
			                        SX3->X3_TAMANHO,;
			                        SX3->X3_DECIMAL,;
			                        SX3->X3_VALID,;
			                        SX3->X3_USADO,;
			                        SX3->X3_TIPO,;
			                        SX3->X3_F3,;
			                        SX3->X3_CONTEXT,;
			                        SX3->X3_CBOX,;
			                        SX3->X3_RELACAO,;
			                        SX3->X3_WHEN,;
			                        "V",;
			                        SX3->X3_VLDUSER,;
			                        SX3->X3_PICTVAR,;
			                        SX3->X3_OBRIGAT} )
	Endif
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Monta o aCols. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
Z02->(dbSetOrder(1))
_nUsado := Len(aHeaderEx)
If Z02->(dbSeek( xFilial("Z02") + Z01->Z01_CHVNFE)  )
	While Z02->Z02_CHVNFE == Z01->Z01_CHVNFE .and. !Z02->(EOF())			
		AADD(aColsEx, Array(_nUsado + 1))   
		
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Começamos o y a partir do dois por causa    ³
        //³da coluna de legenda                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For y := 2 to _nUsado
			aColsEx[Len(aColsEx), y] := Z02->(FieldGet(FieldPos(aHeaderEx[y, 2])))
		Next
		
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Marca a legenda³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Z02->Z02_STATUS =='2'
            aColsEx[Len(aColsEx)][1]  := oBlue
        Else
			aColsEx[Len(aColsEx)][1]  := oRed
		EndIf
		
		aColsEx[Len(aColsEx), _nUsado + 1] := .F.
		Z02->(dbSkip())
	EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄü©I¿
//³Se nao encontrar nenhum reg., abre um aCols em vazio apenas para exibir.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄü©IÙ
Else
	nUsado := Len(aHeaderEx)
	aColsEx := {Array(_nUsado + 1)}
	aColsEx[1, _nUsado + 1] := .F. 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Começamos o y a partir do dois por causa    ³
    //³da coluna de legenda                        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For y := 2 to _nUsado
		aColsEx[1, y] := CriaVar(aHeaderEx[y, 2], .F.)
	Next y
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
AAdd( aObjects,{100,070, .t., .f. })
AAdd( aObjects,{100,080, .t., .t. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

oMSNewGe1 := MsNewGetDados():New( aPosObj[2][1]+22,aPosObj[2,2], aPosObj[2,3]-22 ,aPosObj[2,4], , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function TelaL()

Local aLegenda    := {{"BR_AZUL"      , OemToAnsi("Aguardando Manifestação"     ) },; 
				      {"BR_VERMELHO"  , OemToAnsi("Manifestação Realizada"      ) } }

BrwLegenda( cCadastro, "Legenda", aLegenda)

Return .T.    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI030  ºAutor  ³Microsiga           º Data ³  08/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TelaJust()

Local oGet1
Local cGet1 := Space(150) 
Local aRet  := {} 
Local nOpcA
Static oDlg

DEFINE MSDIALOG oDlg TITLE "Justificativa De Operação Não Realizada" FROM 000, 000  TO 300, 650 COLORS 0, 16777215 PIXEL     

    RegToMemory("Z01", .F., .F.)
    fEnchoJust() 
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()},, )

aRet := {M->Z01_JUSTIF ,nOpcA}

Return(aRet)

//------------------------------------------------
Static Function fEnchoJust()
//------------------------------------------------
Local aCampos := {}
Local aAlterFields := {"Z01_JUSTIF"}
Static oEnchoic1   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida o usuário para descubrir que campo usar no preenchimento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aCampos, "Z01_NUMNFE" )
aAdd( aCampos, "Z01_SERNFE" )
aAdd( aCampos, "Z01_NOME"   )
aAdd( aCampos, "Z01_CGC"    )
aAdd( aCampos, "Z01_DTEMIS" )
aAdd( aCampos, "Z01_HORA"   )
aAdd( aCampos, "Z01_TOTAL"  )
aAdd( aCampos, "Z01_JUSTIF" )
aAdd( aCampos, "NOUSER"     )

oEnchoic1 :=  MSMGet():New("Z01", Z01->(RecNo()),4,,,,aCampos,{50,0,138,352},aAlterFields,1,,,,oDlg,,,,,.T.,.T.,,,)

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Manifesta  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function Manifesta()

Local nRegs   := 0
Local nRecno  := SDS->(Recno())
Local nQtdNF	:= Len(aRegMark)

If nQtdNF > 0 .And. MsgYesNo("Confirma a Manifestação dos documento para os itens selecionados?","Atenção") 
	
	Processa({|| ProcManif(nQtdNF),"Monitor de operação não realizada" +" - " +"Geração de Confirmação"}) 

	SDS->(dbGoTo(nRecno))
	aRegMark := {}
EndIf   

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcManif  ºAutor ³Felipi Marques       º Data ³  07/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para marcar todos os registros da MarkBrowse.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function ProcManif(NREGS)

Local lRet		:= .F.
Local nX	 	:= 0
Local nY		:= 0
Local nCount 	:= 0 
	
Local cTpAmb	:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
Local cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
Local aRetTela  := {}
Local cJust     := ""
Local cCNPJ		:= SM0->M0_CGC 
Local lStatus   := .T.

ProcRegua(nRegs)
For nY := 1 To nRegs 
	Z01->(dbGoTo(aRegMark[nY]))
	If (Z01->Z01_OK == cMarca)

		If .NOT. Z01_STAXML $ ('1*5*0') .AND. Z01->Z01_STADOW <> "2" // MH - 15/05/2019
									
			//Verifica se o evento de ciencia da nota solicitada foi enviado com sucesso.
		    //If Posicione("Z01",1, xFilial("Z01")+Z01->Z01_CHVNFE,"Z01_STAXML") <> "0"
			//	Processa({|| lStatus := U_ACOMR03( cTpAmb, cUfAutor, cCNPJ, 1, Z01->Z01_CHVNFE, "1.00" ) },"Aguarde... Realizando manifestação e download do XML da NFe junto a Sefaz.",.F.)
			//EndIf
			U_ACOMR03( cTpAmb, cUfAutor, cCNPJ, 1, Z01->Z01_CHVNFE, "1.00" ) 

			Z01->(dbGoTo(aRegMark[nY]))
			RecLock("Z01",.F.)
		   	Replace Z01->Z01_OK	With ''
			Z01->(MsUnLock())	
			Z01->(dbGoTo(aRegMark[nY]))
		End
	EndIf

Next nY

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMS3ER  ºAutor ³Felipi Marques       º Data ³   02/08/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta interface de visualização e vinculo do documeto.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nOpc: opcao de rotina acionada (2=Visualizar )        	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function COMMS3ER(nOpc,_nRecno) 

Local alAdvSz    := MsAdvSize(,.F.,400)
Static oDlg
Local nOpcA      	:= 0
Local bCancel  	    := {|| nOpcA := 0, oDlgMain:End() }
Local aZ01area := Z01->(GetArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Botões de visualizações das legendas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aButtons      := {}

DEFINE MSDIALOG oDlg TITLE "Visualização Erro" FROM alAdvSz[7]+45,0 TO alAdvSz[6],alAdvSz[5] COLORS 0, 16777215 PIXEL
    RegToMemory("Z01", .F., .F.)
    fEnchoic2()
    fMSNewGe2()
 
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()},, )

// Limpa Flag Ok
RecLock("Z01",.F.)
  	Replace Z01->Z01_OK	With ''
Z01->(MsUnLock())

RestArea(aZ01area)

Return

//------------------------------------------------ 
Static Function fEnchoic2()
//------------------------------------------------ 
Local aFields      := {}
Local aAlterFields := {}  
lOCAL aCampos      := {} 
Local aSize    	   := MsAdvSize()
Static oEnchoic1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida o usuário para descubrir que campo usar no preenchimento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aCampos, "Z01_CHVNFE" )
aAdd( aCampos, "Z01_NUMNFE" )
aAdd( aCampos, "Z01_SERNFE" )
aAdd( aCampos, "Z01_NOME"   )
aAdd( aCampos, "Z01_CGC"    )
aAdd( aCampos, "Z01_INSCR"  )
aAdd( aCampos, "Z01_DTEMIS" )
aAdd( aCampos, "Z01_HORA"   )
aAdd( aCampos, "Z01_TOTAL"  )
aAdd( aCampos, "Z01_HORA"   )
aAdd( aCampos, "NOUSER"     )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
AAdd( aObjects,{200,200, .t., .T. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

oEnchoic1 := MSMGet():New("Z01", Z01->(RecNo()),3,,,,aCampos,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},aCampos,1,,,,oDlg,,,,,.T.,.T.,,,)

Return()

//------------------------------------------------ 
Static Function fMSNewGe2()
//------------------------------------------------ 
Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"Z04_CHVNFE","Z04_NSU","Z04_ROTINA","Z04_MOTIVO","Z04_STAT","Z04_RETWS"} 
Local aAlterFields	:= {}
Local aSize     	:= MsAdvSize()
Local y				:= 0
Static oMSNewGe1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o aHeader              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("Z04")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX])) 
    	Aadd(aHeaderEx, {  AllTrim( X3Titulo()),;
			                        SX3->X3_CAMPO,;
			                        SX3->X3_PICTURE,;
			                        SX3->X3_TAMANHO,;
			                        SX3->X3_DECIMAL,;
			                        SX3->X3_VALID,;
			                        SX3->X3_USADO,;
			                        SX3->X3_TIPO,;
			                        SX3->X3_F3,;
			                        SX3->X3_CONTEXT,;
			                        SX3->X3_CBOX,;
			                        SX3->X3_RELACAO,;
			                        SX3->X3_WHEN,;
			                        "V",;
			                        SX3->X3_VLDUSER,;
			                        SX3->X3_PICTVAR,;
			                        SX3->X3_OBRIGAT} )
	Endif
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Monta o aCols. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
Z04->(dbSetOrder(1))
_nUsado := Len(aHeaderEx)
If Z04->(dbSeek( xFilial("Z04") + Z01->Z01_CHVNFE)  )
	While Z04->Z04_CHVNFE == Z01->Z01_CHVNFE .and. !Z04->(EOF())			
		AADD(aColsEx, Array(_nUsado + 1))
		For y := 1 to _nUsado
			aColsEx[Len(aColsEx), y] := Z04->(FieldGet(FieldPos(aHeaderEx[y, 2])))
		Next
		aColsEx[Len(aColsEx), _nUsado + 1] := .F.
		Z04->(dbSkip())
	EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄü©I¿
//³Se nao encontrar nenhum reg., abre um aCols em vazio apenas para exibir.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄü©IÙ
Else
	nUsado := Len(aHeaderEx)
	aColsEx := {Array(_nUsado + 1)}
	aColsEx[1, _nUsado + 1] := .F.
	For y := 1 to _nUsado
		aColsEx[1, y] := CriaVar(aHeaderEx[y, 2], .F.)
	Next y
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
AAdd( aObjects,{100,070, .t., .f. })
AAdd( aObjects,{100,080, .t., .t. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

oMSNewGe1 := MsNewGetDados():New( aPosObj[2][1]+22,aPosObj[2,2], aPosObj[2,3]-22 ,aPosObj[2,4], , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return

        
//-----------------------------------------------------------------------
/*/{Protheus.doc} Exportar
Rotina de exportacao das notas
@author Felipi Marques
@since 15.06.2018
/*/
//-----------------------------------------------------------------------
Static Function Exportar()

Local aPerg   	 := {}
Local aParam  	 := {Space(Len(Z02->Z02_SERIE )),Space(Len(Z02->Z02_NUMNF )),Space(Len(Z02->Z02_NUMNF )),Space(60),CToD(""),CToD(""),Space(14),Space(14)}  
Local lObrigat   := .T. 
Local cParNfeExp := SM0->M0_CODIGO+SM0->M0_CODFIL+"XMLNFEEXP"
Local cIdEnt     := ""

aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.}) 
aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,lObrigat}) 
aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,lObrigat})
aadd(aPerg,{6,"Diretório de destino",aParam[04],"",".T.","!Empty(mv_par04)",80,.T.,"Arquivos XML |*.XML","",GETF_RETDIRECTORY+GETF_LOCALHARD,.T.})
aadd(aPerg,{1,"Data Inicial",aParam[05],"",".T.","",".T.",50,lObrigat}) 
aadd(aPerg,{1,"Data Final",aParam[06],"",".T.","",".T.",50,lObrigat})
aadd(aPerg,{1,"CNPJ Inicial",aParam[07],"",".T.","",".T.",50,.F.}) 
aadd(aPerg,{1,"CNPJ final",aParam[08],"",".T.","",".T.",50,.F.}) 


aParam[01] := ParamLoad(cParNfeExp,aPerg,1,aParam[01])
aParam[02] := ParamLoad(cParNfeExp,aPerg,2,aParam[02])
aParam[03] := ParamLoad(cParNfeExp,aPerg,3,aParam[03])
aParam[04] := ParamLoad(cParNfeExp,aPerg,4,aParam[04])
aParam[05] := ParamLoad(cParNfeExp,aPerg,5,aParam[05])
aParam[06] := ParamLoad(cParNfeExp,aPerg,6,aParam[06])

If ParamBox(aPerg,"",@aParam,,,,,,,cParNfeExp,.T.,.T.)
	Processa({|lEnd| fExpXml(cIdEnt,aParam[01],aParam[02],aParam[03],aParam[04],lEnd,aParam[05],IIF(Empty(aParam[06]),dDataBase,aParam[06]),aParam[07],aParam[08],,,)},"Processando","Aguarde, exportando arquivos",.F.)
EndIf                                                                    

dbSelectArea("Z01")
dbSetOrder(2)
bFiltraBrw := {|| FilBrowse("Z01",@aIndZ01,@cFilBrw) }
Eval(bFiltraBrw)

Return()
//-----------------------------------------------------------------------
/*/{Protheus.doc} fExpXml
@author Felipi Marques
@since 15.06.2018
/*/
//-----------------------------------------------------------------------
Static Function fExpXml(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,lEnd,dDataDe,dDataAte,cCnpjDIni,cCnpjDFim)
//Declaracao de variaveis    
Local cDestino 	:= ""
Local cDrive   	:= ""
Local cAlias    := CriaTrab(,.F.)
Local cSelect   := ""
Local cQry	    := ""
Local cXMl      := ""  
Local aArea   := GetArea()
Local nArquivo := 0
Local cPreName := "NFe"
Local cNomeArq := ""
//Corrigi diretorio de destino
SplitPath(cDirDest,@cDrive,@cDestino,"","")
cDestino := cDrive+cDestino

//Monta a query de seleção
cQry := " SELECT DISTINCT   Z02.R_E_C_N_O_ AS REGZ02 "
cQry += " FROM   " + RETSQLTAB("Z02")    
cQry += " WHERE    Z02_NUMNF  >= '" +cNotaIni +"'             AND  Z02_NUMNF  <= '" +cNotaFim +"'              "
If !empty(Alltrim(cSerie))
	cQry += " AND    Z02_SERIE  = '" +cSerie +"' "    
EndIf 
If !(empty(Alltrim(cCnpjDIni)) .and. empty(Alltrim(cCnpjDFim)))
cQry += " AND    Z02_CGC    >= '" +cCnpjDIni +"'             AND  Z02_CGC    <= '" +cCnpjDFim +"'           "
EndIf
cQry += " AND    Z02_DTNFE  >= '"  +DToS(dDataDe) +"'   AND  Z02_DTNFE  <= '"  +DToS(dDataAte) +"'    "

cQry += " AND "+RETSQLCOND("Z02")             

//Compatibiliza a query de acordo com o banco utilizado
cQry := ChangeQuery(cQry)

//Abre um alias com a query informada.
MPSysOpenQuery(cQry, cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

ProcRegua( (cAlias)->( RecCount() ) )

// Prepara Exportação
While !(cAlias)->(EoF())

	IncProc()
	
	//Posiciona nos registros necessários
	dbSelectArea( "Z02" )
	Z02->(dbGoTo( (cAlias)->REGZ02 ))
    //Remove caractere especiais
	cXml    := fXMLChar(Z02->Z02_NFXML )
	//Nome do arquivo salvo
	cNomeArq:= cPreName+Z02->Z02_CHVNFE+".XML" 				 			
	
	If ( nArquivo := MsFcreate( cDestino + cNomeArq ) ) > 0
		FWrite( nArquivo, cXml )	  
	EndIf              
	
	If nArquivo > 0
		FClose(nArquivo)
	EndIf
	
	(cAlias)->(dbSkip())
EndDo

dbCloseArea(cAlias)

RestArea(aArea)

Return()

Return         

//-----------------------------------------------------------------------        
/*/{Protheus.doc} fXMLChar
@param	cTexto			Texto para retirar caracteres especiais
@return	cTexto			Texto sem caracteres especiais
@author Felipi Marques
@since 15.06.2018
/*/
//-----------------------------------------------------------------------
Static Function fXMLChar(cTexto)

Local nI		:= 0
Local aCarac 	:= {}

Aadd(aCarac,{"Á","A"})
Aadd(aCarac,{"À","A"})
Aadd(aCarac,{"Â","A"})
Aadd(aCarac,{"Ã","A"})
Aadd(aCarac,{"á","a"})
Aadd(aCarac,{"à","a"})
Aadd(aCarac,{"â","a"})
Aadd(aCarac,{"ã","a"})
Aadd(aCarac,{"É","E"})
Aadd(aCarac,{"Ê","E"})
Aadd(aCarac,{"é","e"})
Aadd(aCarac,{"ê","e"})
Aadd(aCarac,{"Í","I"})
Aadd(aCarac,{"í","i"})
Aadd(aCarac,{"Ó","O"})
Aadd(aCarac,{"Ô","O"})
Aadd(aCarac,{"Õ","O"})
Aadd(aCarac,{"ó","o"})
Aadd(aCarac,{"ô","o"})
Aadd(aCarac,{"õ","o"})
Aadd(aCarac,{"Ú","U"})
Aadd(aCarac,{"ú","u"})
Aadd(aCarac,{"Ç","C"})
Aadd(aCarac,{"ç","c"})


// Ignora caracteres Extendidos da tabela ASCII
For nI := 128 To 255
	Aadd(aCarac,{Chr(nI)," "})  // Tab
Next nI

For nI := 1 To Len(aCarac)
	If aCarac[nI, 1] $ cTexto
		cTexto := StrTran(cTexto, aCarac[nI,1], aCarac[nI,2])
	EndIf
Next nI

Return cTexto
