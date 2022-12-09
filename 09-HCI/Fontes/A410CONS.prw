#INCLUDE "rwmake.ch"       
#INCLUDE "Protheus.Ch" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A410CONS บAutor  ณFernando R. Ribeiro บ Data ณ  27/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para adicionar um botao na enchoice da    บฑฑ
ฑฑบ          ณ tela de Pedido                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8    HCI                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A410CONS()
Local aBUTTON := {}                   
AAdd(aBUTTON,{"S4WB005N",{|| u_HC410MC()},"MC%","MC%"})//INCLUI BOTAO NO ARRAY
If Inclui .or. Altera   //CASO SEJA ROTINA DE INClUSAO...
	If cPaisLoc = "PTG"
	    AAdd(aBUTTON,{"S4WB005N",{|| U_AJTES()},"Altera TES","Alt. Massa"})//INCLUI BOTAO NO ARRAY	
	Else
		AAdd(aBUTTON,{"S4WB005N",{|| U_AJTES()},"Altera TES","Alt. Massa"})//INCLUI BOTAO NO ARRAY	    
	    AAdd(aBUTTON,{"S4WB005N",{|| U_MIGRAPV()},"OC x PV","OC x PV"})//INCLUI BOTAO NO ARRAY 
	    AAdd(aBUTTON,{"S4WB005N",{|| U_MIGRAOS()},"OS x PV","OS x PV"})//INCLUI BOTAO NO ARRAY
	    AAdd(aBUTTON,{"PRODUTO",{|| U_MIGRANF()},"NF","NF"})//INCLUI BOTAO NO ARRAY                 
	EndIf    
EndIf
Return(aBUTTON)

USER FUNCTION AJTES()

// ALteracao em massa da tes de saida do pedido
Local oDlgl
Private cTes:=Space(3)
Private nIPI:=0
Private cLOCAL:=Space(2)
Private nDescon:=0
Private nPorc1:=0
Private nFator:=0
 			
    @ 000,000 To 220,400 Dialog oDlgl Title OemToAnsi("Alteracoes em massa")
    @ 003,008 To 110,200 Title OemToAnsi("Deseja Alterar as Informacoes Abaixo?")
    @ 015,015 Say OemToAnsi("Digite N Tes: ") OF Odlgl PIXEL
    @ 015,065 MSGET cTes SIZE 65,5 F3 "SF4" PICTURE PesqPict("SC6","C6_TES") OF Odlgl PIXEL 
    @ 027,015 Say OemToAnsi("Digite % IPI: ") OF Odlgl PIXEL
    @ 027,065 MSGET nIPI SIZE 65,5 PICTURE PesqPict("SC6","C6_IPI") OF Odlgl PIXEL  
    @ 039,015 Say OemToAnsi("Almoxarifado: ") OF Odlgl PIXEL
    @ 039,065 MSGET cLOCAL SIZE 65,5 PICTURE PesqPict("SC6","C6_LOCAL") OF Odlgl PIXEL 
    @ 051,015 Say OemToAnsi("Digite FAT Desc:") OF Odlgl PIXEL
    @ 051,065 MSGET nDescon SIZE 65,5 PICTURE PesqPict("SC7","C7_PRECO") OF Odlgl PIXEL 
    @ 063,015 Say OemToAnsi("Digite % Com :") OF Odlgl PIXEL
    @ 063,065 MSGET nporc1 SIZE 65,5 PICTURE PesqPict("SC6","C6_COMIS1") OF Odlgl PIXEL 
    @ 075,015 Say OemToAnsi("Carrega Custo Fator:") OF Odlgl PIXEL
    @ 075,065 MSGET nfator SIZE 65,5 PICTURE PesqPict("SC6","C6_COMIS1") OF Odlgl PIXEL 
	@ 090,030 BMPBUTTON TYPE 1 ACTION OkProc(odlgl)
    @ 090,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlgl)
    Activate Dialog Odlgl CENTER
    
RETURN .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIGRAPV() บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION MIGRAPV()
// 1 PASSO - ABRIR LISTA DE OCS A SEREM IMPORTADAS
Local oDlgl
Private cOc1:=Space(6)
Private cOc2:=Space(6)
Private cForn:=Space(6)
Private cLoja:=Space(2) 
// 2 Passo - Muda empresa - filial para 0101
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
dbCloseAll()
if cEmpAtual="02"
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt			:= "01"
  OpenSM0("0101")
else  
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt			:= "50"
  OpenSM0("0250")
endif
OpenSXs()
InitPublic()
@ 000,000 To 220,400 Dialog oDlgl Title OemToAnsi("Importacao de Dados")
@ 003,008 To 110,200 Title OemToAnsi("Informe a Faixa de Ocs a Importar?")
@ 015,015 Say OemToAnsi("OC Inicio :") OF Odlgl PIXEL
@ 015,065 MSGET cOC1 SIZE 65,5 F3 "SC7" PICTURE PesqPict("SC7","C7_NUM") OF Odlgl PIXEL 
@ 027,015 Say OemToAnsi("OC Fim    :") OF Odlgl PIXEL
@ 027,065 MSGET cOC2 SIZE 65,5 F3 "SC7" PICTURE PesqPict("SC7","C7_NUM") OF Odlgl PIXEL  
@ 039,015 Say OemToAnsi("Fornecedor:") OF Odlgl PIXEL
@ 039,065 MSGET cForn SIZE 65,5 F3 "SA2" PICTURE PesqPict("SA2","A2_COD") OF Odlgl PIXEL  
@ 051,015 Say OemToAnsi("Loja      :") OF Odlgl PIXEL
@ 051,065 MSGET cLoja SIZE 65,5 PICTURE PesqPict("SA2","A2_LOJA") OF Odlgl PIXEL 
@ 090,030 BMPBUTTON TYPE 1 ACTION OkPR3(odlgl,cOc1,cOc2,cEmpAtual)
@ 090,060 BMPBUTTON TYPE 2 ACTION Final2(odlgl,cEmpAtual)
Activate Dialog Odlgl CENTER
RETURN      


// MIGRANDO DADOS PARA O PEDIDO DE VENDA
STATIC FUNCTION OkPR3(oDlga)
Local cItSC6:="00"
Local nAcols
Local nCntfor
Local nUsado
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
dbSelectArea("SC7")
DbSetOrder(1)
MsSeek(xFilial("SC7")+cOc1+"0001")
DO WHILE (SC7->C7_NUM<=cOc2 .and. !EOF())
 	nUsado := Len(aHeader)
    if cItsc6<>"00"
	  Aadd(aCols,Array(nUsado+1))
	endif
	nAcols := Len(aCols)
	aCols[nAcols,nUsado+1] := .F.
	For nCntFor := 1 To nUsado
		Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEM" )
				cItSC6 := Soma1(cItSC6)
	  			aCols[nAcols,nCntFor] := cItSC6
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRODUTO" )
				aCols[nAcols,nCntFor] := SC7->C7_PRODUTO
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCRI" )
				aCols[nAcols,nCntFor] := SC7->C7_DESCRI
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_UM" )
				aCols[nAcols,nCntFor] := SC7->C7_UM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_COMIS1" )
				aCols[nAcols,nCntFor] := 0 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_IPI" )
				aCols[nAcols,nCntFor] := 5
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDVEN" )
				aCols[nAcols,nCntFor] := SC7->C7_QUANT
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRCVEN" )
				aCols[nAcols,nCntFor] := SC7->C7_PRECO
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALOR" )
				aCols[nAcols,nCntFor] := SC7->C7_TOTAL
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_TES" )
				aCols[nAcols,nCntFor] := "502"
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CF" )
			 	aCols[nAcols,nCntFor] := "5101"
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_SEGUM" )
				aCols[nAcols,nCntFor] := SC7->C7_SEGUM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_LOCAL" )
				aCols[nAcols,nCntFor] := SC7->C7_LOCAL
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALDESC" )
				aCols[nAcols,nCntFor] := SC7->C7_VLDESC
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCONT" )
				aCols[nAcols,nCntFor] := SC7->C7_DESC
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ENTREG" )
				aCols[nAcols,nCntFor] := SC7->C7_DATPRF
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_NUMREF" )
				aCols[nAcols,nCntFor] := SC7->C7_NUMREF 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PV" )
				aCols[nAcols,nCntFor] := SC7->C7_PV
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEMCLI" )
				aCols[nAcols,nCntFor] := SC7->C7_ITEMCLI	
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_XOBS" )
				aCols[nAcols,nCntFor] := SC7->C7_OBS
		    Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DSCTEC" )
				aCols[nAcols,nCntFor] := SC7->C7_TECNICO  
		    Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CLASFIS" )
				aCols[nAcols,nCntFor] :="000" 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDLIB" )
					aCols[nAcols,nCntFor] := SC7->C7_QUANT
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	Next nCntFor
    dbSkip()
endDo
dbCloseAll()
if cEmpAtual="01"
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt			:= "50"
  OpenSM0("0250")
else
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt			:= "01"
  OpenSM0("0101")
endif  
OpenSXs()
InitPublic()
Close(Odlga)


RETURN













/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIGRAOS() บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION MIGRAOS()


// 1 PASSO - ABRIR LISTA DE OCS A SEREM IMPORTADAS

Local oDlgl
Private cOS1:=Space(6)
Private cOS2:=Space(6)
Private cForn:=Space(15)
Private cLoja:=Space(3) 
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
dbCloseAll()
if cEmpAtual="02"
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt			:= "01"
  OpenSM0("0101")
else  
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt			:= "50"
  OpenSM0("0250")
endif
OpenSXs()
InitPublic()
@ 000,000 To 220,400 Dialog oDlgl Title OemToAnsi("Importacao de Dados")
@ 003,008 To 110,200 Title OemToAnsi("Informe a Faixa de OSs a Importar?")
@ 015,015 Say OemToAnsi("Os Inicio :") OF Odlgl PIXEL
@ 015,065 MSGET cOs1 SIZE 65,5 F3 "SC5" PICTURE PesqPict("SC6","C6_NUM") OF Odlgl PIXEL 
@ 027,015 Say OemToAnsi("Os Fim    :") OF Odlgl PIXEL
@ 027,065 MSGET cOs2 SIZE 65,5 F3 "SC5" PICTURE PesqPict("SC6","C6_NUM") OF Odlgl PIXEL  
@ 039,015 Say OemToAnsi("Cod Serv  :") OF Odlgl PIXEL
@ 039,065 MSGET cForn SIZE 65,5 F3 "SB1" PICTURE PesqPict("SB1","B1_COD") OF Odlgl PIXEL  
@ 051,015 Say OemToAnsi("TES       :") OF Odlgl PIXEL
@ 051,065 MSGET cLoja SIZE 65,5 F3 "SF4" PICTURE PesqPict("SF4","F4_CODIGO") OF Odlgl PIXEL 
@ 090,030 BMPBUTTON TYPE 1 ACTION OkPr4(odlgl,cForn)
@ 090,060 BMPBUTTON TYPE 2 ACTION Final2(odlgl)
Activate Dialog Odlgl CENTER
RETURN              

STATIC FUNCTION OkPR4(oDlga)
Local aAreaAnt 
Local cItSC6:="00"
Local nAcols
Local nCntfor
Local nUsado
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
IF LEN(ACOLS)>1 
  cItSC6:=ACOLS[LEN(ACOLS),1]
ENDIF
dbSelectArea("SC6")
DbSetOrder(1)
MsSeek(xFilial("SC5")+cOs1+"01")
DO WHILE (SC6->C6_NUM<=cOs2 .and. !EOF())
 	nUsado := Len(aHeader)
    if cItsc6<>"00"
	  Aadd(aCols,Array(nUsado+1))
	endif
	nAcols := Len(aCols)
	aCols[nAcols,nUsado+1] := .F.
	For nCntFor := 1 To nUsado
		Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEM" )
				cItSC6 := Soma1(cItSC6)
	  			aCols[nAcols,nCntFor] := cItSC6
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRODUTO" )
			    IF cForn="               "
			    	aCols[nAcols,nCntFor] := SC6->C6_PRODUTO
	   		    else
	   		        aCols[nAcols,nCntFor] := cForn
	   		    endif
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCRI" )
				IF cForn="               "
					aCols[nAcols,nCntFor] := SC6->C6_DESCRI
		   	    else
		   	        aCols[nAcols,nCntFor] :=Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_DESENT")
		   	    endif
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_UM" )
				aCols[nAcols,nCntFor] := SC6->C6_UM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_COMIS1" )
				aCols[nAcols,nCntFor] := 0 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_IPI" )
				aCols[nAcols,nCntFor] := 0
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDVEN" )
				IF cForn="               "
			    	aCols[nAcols,nCntFor] := SC6->C6_QTDVEN
	   		    else
	   		        aCols[nAcols,nCntFor] := Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_QTENT")
	   		    endif
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRCVEN" )
				IF cForn="               "
			    	aCols[nAcols,nCntFor] := SC6->C6_PRCVEN
	   		    else
	   		        aCols[nAcols,nCntFor] := Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_CUSUNI")
	   		    endif
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALOR" )
				IF cForn="               "
			    	aCols[nAcols,nCntFor] := SC6->C6_VALOR
	   		    else
	   		        aCols[nAcols,nCntFor] := Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_CUSTOT")
	   		    endif
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_TES" )
				IF cForn="               "
			    	aCols[nAcols,nCntFor] := cLoja
	   		    else
	   		        aCols[nAcols,nCntFor] := cLoja
	   		    endif
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CF" )
		   	        aCols[nAcols,nCntFor] := Posicione("SF4",1,xFilial("SF4")+cLoja,"F4_CF")
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_SEGUM" )
				aCols[nAcols,nCntFor] := SC6->C6_SEGUM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_LOCAL" )
				aCols[nAcols,nCntFor] := "01"
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALDESC" )
				aCols[nAcols,nCntFor] := SC6->C6_VALDESC
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCONT" )
				aCols[nAcols,nCntFor] := SC6->C6_DESCONT
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ENTREG" )
				aCols[nAcols,nCntFor] := SC6->C6_ENTREG
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_NUMREF" )
				aCols[nAcols,nCntFor] := SC6->C6_NUMREF 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PV" )
				aCols[nAcols,nCntFor] := SC6->C6_NOTA
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEMCLI" )
				aCols[nAcols,nCntFor] := SC6->C6_ITEMCLI	
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_XOBS" )
				aCols[nAcols,nCntFor] := SC6->C6_XOBS
		    Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DSCTEC" )
				aCols[nAcols,nCntFor] := U_MATATEC(SC6->C6_PRODUTO)  
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CLASFIS" )
				aCols[nAcols,nCntFor] :="041" 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDLIB" )
					aCols[nAcols,nCntFor] := SC6->C6_QTDLIB
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	Next nCntFor
    dbSkip()
endDo
dbCloseAll()
if cEmpAtual="01"
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt			:= "50"
  OpenSM0("0250")
else
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt			:= "01"
  OpenSM0("0101")
endif  
OpenSXs()
InitPublic()
FOR nLinhas:= 1 TO nAcols
	For nCntFor := 1 To nUsado
		Do Case
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CF" )
		   	        aCols[nLinhas,nCntFor] := Posicione("SF4",1,xFilial("SF4")+cLoja,"F4_CF")
		
		EndCase
	Next nCntFor
next nLinhas
Close(Odlga)


RETURN





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIGRAOS() บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION MIGRANF()


// 1 PASSO - ABRIR LISTA DE OCS A SEREM IMPORTADAS

Local oDlgl
Private cNf:=Space(6)
Private cTes1:=Space(3)
Private cTes2:=Space(3)
Private cServ:=Space(15)
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
dbCloseAll()
if cEmpAtual="02"
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt			:= "01"
  OpenSM0("0101")
else  
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt			:= "50"
  OpenSM0("0250")
endif
OpenSXs()
InitPublic()
@ 000,000 To 220,400 Dialog oDlgl Title OemToAnsi("Importacao de Dados")
@ 003,008 To 110,200 Title OemToAnsi("Informe a Nota Fiscal?")
@ 015,015 Say OemToAnsi("Nota Fiscal:") OF Odlgl PIXEL
@ 015,065 MSGET cNF SIZE 65,5  PICTURE PesqPict("SD2","D2_DOC") OF Odlgl PIXEL 
@ 027,015 Say OemToAnsi("Cod Serv  :") OF Odlgl PIXEL
@ 027,065 MSGET cServ SIZE 65,5 F3 "SB1" PICTURE PesqPict("SB1","B1_COD") OF Odlgl PIXEL  
@ 039,015 Say OemToAnsi("TES RET   :") OF Odlgl PIXEL
@ 039,065 MSGET cTes1 SIZE 65,5 F3 "SF4" PICTURE PesqPict("SF4","F4_CODIGO") OF Odlgl PIXEL  
@ 051,015 Say OemToAnsi("TES SERV  :") OF Odlgl PIXEL
@ 051,065 MSGET cTes2 SIZE 65,5 F3 "SF4" PICTURE PesqPict("SF4","F4_CODIGO") OF Odlgl PIXEL 
@ 090,030 BMPBUTTON TYPE 1 ACTION OkPr5(odlgl)
@ 090,060 BMPBUTTON TYPE 2 ACTION Final2(odlgl)
Activate Dialog Odlgl CENTER
RETURN             

STATIC FUNCTION OkPR5(oDlga)
Local cCfop
Local aAreaAnt 
Local cItSC6:="00"
Local nAcols
Local nCntfor
Local nUsado 
Local aTes:={}
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
IF LEN(ACOLS)>1 
  cItSC6:=ACOLS[LEN(ACOLS),1]
ENDIF
dbSelectArea("SD2")
DbSetOrder(3)
MsSeek(xFilial("SD2")+cNf)
DO WHILE (SD2->D2_DOC=cNf .and. !EOF())
  dbSelectArea("SC6")
  DbSetOrder(1)
  MsSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
  DO WHILE (SC6->C6_NUM=SD2->D2_PEDIDO .AND. SC6->C6_ITEM=SD2->D2_ITEMPV .and. !EOF())
 	// INSERINDO O ITEM DO RETORNO
 	nUsado := Len(aHeader)
    if cItsc6<>"00"
	  Aadd(aCols,Array(nUsado+1))
	endif
	nAcols := Len(aCols)
	aCols[nAcols,nUsado+1] := .F.
	For nCntFor := 1 To nUsado
		Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEM" )
				cItSC6 := Soma1(cItSC6)
	  			aCols[nAcols,nCntFor] := cItSC6
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRODUTO" )
			    aCols[nAcols,nCntFor] := SC6->C6_PRODUTO
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCRI" )
				aCols[nAcols,nCntFor] := SC6->C6_DESCRI
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_UM" )
				aCols[nAcols,nCntFor] := SC6->C6_UM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_COMIS1" )
				aCols[nAcols,nCntFor] := 0 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_IPI" )
				aCols[nAcols,nCntFor] := 0
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDVEN" )
				aCols[nAcols,nCntFor] := SC6->C6_QTDVEN
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRCVEN" )
				aCols[nAcols,nCntFor] := SC6->C6_PRCVEN
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALOR" )
			   	aCols[nAcols,nCntFor] := SC6->C6_VALOR
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_TES" )
				aCols[nAcols,nCntFor] := cTes1
				Aadd(aTes,cTes1)
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CF" )
		   	     aCols[nAcols,nCntFor] := Posicione("SF4",1,xFilial("SF4")+cTes1,"F4_CF") 
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_SEGUM" )
				aCols[nAcols,nCntFor] := SC6->C6_SEGUM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_LOCAL" )
				aCols[nAcols,nCntFor] := "01"
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALDESC" )
				aCols[nAcols,nCntFor] := SC6->C6_VALDESC
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCONT" )
				aCols[nAcols,nCntFor] := SC6->C6_DESCONT
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ENTREG" )
				aCols[nAcols,nCntFor] := SC6->C6_ENTREG
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_NUMREF" )
				aCols[nAcols,nCntFor] := SC6->C6_NUMREF 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PV" )
				aCols[nAcols,nCntFor] := SC6->C6_NOTA + "/" + SD2->D2_ITEM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEMCLI" )
				aCols[nAcols,nCntFor] := SC6->C6_ITEMCLI	
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_XOBS" )
				aCols[nAcols,nCntFor] := SC6->C6_XOBS
		    Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DSCTEC" )
				aCols[nAcols,nCntFor] := U_MATATEC(SC6->C6_PRODUTO)  
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CLASFIS" )
				aCols[nAcols,nCntFor] :="041" 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDLIB" )
					aCols[nAcols,nCntFor] := SC6->C6_QTDLIB
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	Next nCntFor
    // INSERINDO O ITEM DE SERVICO
    IF cServ<>"               "
    nUsado := Len(aHeader)
    if cItsc6<>"00"
	  Aadd(aCols,Array(nUsado+1))
	endif
	nAcols := Len(aCols)
	aCols[nAcols,nUsado+1] := .F.
	For nCntFor := 1 To nUsado
		Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEM" )
				cItSC6 := Soma1(cItSC6)
	  			aCols[nAcols,nCntFor] := cItSC6
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRODUTO" )
			    aCols[nAcols,nCntFor] := cServ
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCRI" )
				// CENARIO ADRIANA NOVO
				//aCols[nAcols-1,nCntFor] :=Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_DESENT") 
				//aCols[nAcols,nCntFor] :=Posicione("SB1",1,xFilial("SB1")+cServ,"B1_DESC") 
				// CENARIO ATUAL
				aCols[nAcols,nCntFor] :=Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_DESENT") 
			case ( AllTrim(aHeader[nCntFor,2]) == "C6_UM" )
				aCols[nAcols,nCntFor] := SC6->C6_UM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_COMIS1" )
				aCols[nAcols,nCntFor] := 0 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_IPI" )
				aCols[nAcols,nCntFor] := 0
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDVEN" )
				aCols[nAcols,nCntFor] := Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_QTENT")
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PRCVEN" )
			    aCols[nAcols,nCntFor] := Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_CUSUNI")
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALOR" )
			    aCols[nAcols,nCntFor] := Posicione("AB7",1,xFilial("AB7")+SUBSTRING(SC6->C6_PEDCLI,1,6)+"01","AB7_CUSTOT")
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_TES" )
			    aCols[nAcols,nCntFor] := cTes2
			   	Aadd(aTes,cTes2)
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CF" )
		   	    aCols[nAcols,nCntFor] := Posicione("SF4",1,xFilial("SF4")+cTes2,"F4_CF") 
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_SEGUM" )
				aCols[nAcols,nCntFor] := SC6->C6_SEGUM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_LOCAL" )
				aCols[nAcols,nCntFor] := "01"
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_VALDESC" )
				aCols[nAcols,nCntFor] := SC6->C6_VALDESC
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DESCONT" )
				aCols[nAcols,nCntFor] := SC6->C6_DESCONT
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ENTREG" )
				aCols[nAcols,nCntFor] := SC6->C6_ENTREG
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_NUMREF" )
				aCols[nAcols,nCntFor] := SC6->C6_NUMREF 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_PV" )
				aCols[nAcols,nCntFor] := SC6->C6_NOTA + "/" + SD2->D2_ITEM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_ITEMCLI" )
				aCols[nAcols,nCntFor] := SC6->C6_ITEMCLI	
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_XOBS" )
				aCols[nAcols,nCntFor] := SC6->C6_XOBS
		    Case ( AllTrim(aHeader[nCntFor,2]) == "C6_DSCTEC" )
				aCols[nAcols,nCntFor] := U_MATATEC(SC6->C6_PRODUTO)  
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CLASFIS" )
				aCols[nAcols,nCntFor] :="041" 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C6_QTDLIB" )
					aCols[nAcols,nCntFor] := SC6->C6_QTDLIB
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	Next nCntFor
	endif
    SC6->(DbSkip())
  endDo
  SD2->(DbSkip())
enddo
dbCloseAll()
if cEmpAtual="01"
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt		:= "50"
  OpenSM0("0250")
else
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt		:= "01"
  OpenSM0("0101")
endif  
OpenSXs()
InitPublic()
/*

FOR AE:=1 TO LEN(ACOLS)
   IncProc("Atualizando CFOP's dos Pedidos...")
   A410MultT("C6_TES",ACols[AE,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})])  
NEXT  
cCFOP:=ACols[01,aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})]
FOR AE:=1 TO LEN(ACOLS)
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP                                                                                                                     
   A410ZERA()
NEXT
*/
/*
IF ACols[1,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]<>'   ' 
  FOR AE:=1 TO LEN(ACOLS)
     IncProc("Atualizando CFOP's dos Pedidos...")
     A410MultT("C6_TES",ACols[AE,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})])  
  NEXT  
  cCFOP:=ACols[01,aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})]
  FOR AE:=1 TO LEN(ACOLS)
     ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP                                                                                                                     
     A410ZERA()
  NEXT
ENDIF
*/

FOR nLinhas:= 1 TO nAcols
	For nCntFor := 1 To nUsado
		Do Case
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C6_CF" )
		   	        aCols[nLinhas,nCntFor] := Posicione("SF4",1,xFilial("SF4")+aTes[nLinhas],"F4_CF")
		
		EndCase
	Next nCntFor
	A410ZERA()
next nLinhas

Close(Odlga)


RETURN









// 2 PASSO - FILTRAR AS OCS RELATIVA A FAIXA DE PEDIDOS
           

// 3 PASSO - ALIMENTAR O ARRAY DOS CAMPOS DA VENDA COM OS DADOS DA COMPRA


 













/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHC410VC() บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION HC410VC(nRET,cTipo,cCliente,cLoja)

Local cRetorno:=""


if cTipo="B" .OR. cTipo="D" 
  if nRet=1
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_NOME")                             
  endif
  if nRet=2
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_NREDUZ")
  endif
  if nRet=3
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_CONTATO")                          
  endif
  if nRet=4
    cRetorno:="000000" 
  endif
  if nRet=5
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_END")
  endif
  if nRet=6
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_BAIRRO")   
  endif
  if nRet=7
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_MUN")                                                            
  endif
  if nRet=8
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_EST")  
  endif
  if nRet=9
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_CEP") 
  endif
  if nRet=10
    cRetorno:=Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_TIPOF")
    
  endif                                                     
ELSE
  if nRet=1
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")                             
  endif
  if nRet=2
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")
  endif
  if nRet=3
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CONTATO")                          
  endif
  if nRet=4
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_VEND")                          
  endif
  if nRet=5
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END")
  endif
  if nRet=6
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO")   
  endif
  if nRet=7
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN")                                                            
  endif
  if nRet=8
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")  
  endif
  if nRet=9
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CEP") 
  endif
  if nRet=10
    cRetorno:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TIPOCLI")
  endif                               
ENDIF
IF cPaisLoc=="BRA"
  //IF A410Loja().And.A410ReCalc()
  //ENDIF
  IF NRET=2
    IF ACols[1,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]<>'   ' 
    FOR AE:=1 TO LEN(ACOLS)
       IncProc("Atualizando CFOP's dos Pedidos...")
       A410MultT("C6_TES",ACols[AE,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})])  
    NEXT  
    cCFOP:=ACols[01,aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})]
    FOR AE:=1 TO LEN(ACOLS)
       ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP                                                                                                                     
       A410ZERA()
    NEXT
    ENDIF
  ENDIF
endif                                                                                                           
return (cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc(odlgL)
local lret
FOR AE:=1 TO LEN(ACOLS)
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})] := cTes
   if cLocal<>"  "
     ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})] := cLocal
   endif
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_IPI"})] := nIPI                                                                                                       
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})] := nPORC1                                                                                                       
   IF NDESCON>0  
     ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := ROUND(ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]*NdESCON*(1-(nIPI/100)),2)                                                                                                           
   ENDIF
   //acertando custo para transferencia
   if nFator<>0
     DbSelectArea("PAA")
     dbSetOrder(1)
     if MsSeek(xfilial("PAA")+ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})])
       if PAA->PAA_UNIT=0 
	     ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]:=0.01 
	   else 
         ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]:=round(PAA->PAA_UNIT/nFator,2)
	   endif 
     else
       ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]:=0.01 
     endif
   endif 
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]:=ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]*ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]
NEXT   
FOR AE:=1 TO LEN(ACOLS)
   IncProc("Atualizando CFOP's dos Pedidos...")
   A410MultT("C6_TES",ACols[AE,aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})])  
NEXT  
cCFOP:=ACols[01,aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})]
FOR AE:=1 TO LEN(ACOLS)
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP                                                                                                                     
   A410ZERA()
   ACols[AE][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] :=IIF(M->C5_TIPOPV=" ","0"+SF4->F4_SITTRIB,M->C5_TIPOPV+SF4->F4_SITTRIB)  
NEXT
Close(OdlgL)
lRet:=.t.
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza(Odlga)

Close(Odlga)

Return
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Final2(Odlga)

Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
dbCloseAll()
if cEmpAtual="02"
  oApp:cEmpAnt	:= "01"
  oApp:cNumEmp	:= "0101"
  cFilAnt			:= "01"
  OpenSM0("0101")
else  
  oApp:cEmpAnt	:= "02"
  oApp:cNumEmp	:= "0250"
  cFilAnt			:= "50"
  OpenSM0("0250")
endif
OpenSXs()
InitPublic()
Close(Odlga)
Return

