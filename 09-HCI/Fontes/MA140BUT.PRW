#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Rwmake.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MA140BUT  ?Autor  ?ROBSON BUENO        ? Data ?  13/02/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Ponto de Entrada na Ordem de Compra (PC) para agregar       ???
???          ?observacoes especificas do negocio HCI (VIA CONTRATO)       ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MA140BUT()             
aBotao:={}
aadd(aBotao,{"PRODUTO",{ || U_AtuaEnt()},"IMPORTAR"})
aadd(aBotao,{"PRODUTO",{ || U_MA140BO2()},"COPIA"})

Return(aBotao)




/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MA120B01  ?Autor  ?Robson Bueno        ? Data ?  13/02/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Amarrar Observacao na OC                                    ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MA140BO1()


Return(.T.)


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MA120B01  ?Autor  ?Robson Bueno        ? Data ?  13/02/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Amarrar Observacao na OC                                    ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MA140BO2()

Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
LOCAL cDesComp 	:=Space(255)
LOCAL cFornecedor 	:=Space(6)
LOCAL cLoja		:=Space(2)
Local cNota 	:=Space(9)//Space(TamSX3('D1_DOC'))
Local cSr 		:=Space(3)
Local oDlgL
Local cTitulo :="Copia de NF Ja Processada" 


//DEFINE MSDIALOG oDlgL TITLE "C?lculo do Pre?o de Venda" FROM C(000),C(000) TO C(180),C(400) PIXEL
@ 000,000 To 180,400 Dialog OdlgL Title OemToAnsi("Dados para Carregamento")
@ 003,008 To 85,200 Title OemToAnsi("Parametros")

@ 015,015 Say OemToAnsi("Fornecedor	:") OF Odlgl PIXEL
@ 015,045 msget cFornecedor  SIZE 60,10 PICTURE PesqPict("SA2","A2_COD") F3 "SA2" OF OdlgL PIXEL 
@ 030,015 Say OemToAnsi("Loja 	:") OF OdlgL PIXEL
@ 030,045 msget cLoja  SIZE 60,10 PICTURE PesqPict("SA2","A2_LOJA") OF OdlgL PIXEL
@ 045,015 Say OemToAnsi("Nota		:") OF OdlgL PIXEL
@ 045,045 msget cNota  SIZE 60,10  OF OdlgL PIXEL
@ 060,015 Say OemToAnsi("Serie	:") OF OdlgL PIXEL
@ 060,045 msget cSr  SIZE 60,10 OF OdlgL PIXEL
@ 075,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc2(odlgL,cFornecedor,cLoja,cNota,cSr)},cTitulo,"Atualizando dados, aguarde...")
@ 075,060 BMPBUTTON TYPE 2 ACTION Finaliza2(odlgL)

Activate Dialog OdlgL CENTER
 
   
/*

?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?Finaliza  ?Autor  ?Robson Bueno        ? Data ? 18/04/2007  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Finalizacao do Objeto                                       ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?HCI                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function Finaliza2(Odlg1)

Close(Odlg1)

Return
         

/*

?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?Finaliza  ?Autor  ?Robson Bueno        ? Data ? 18/04/2007  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Finalizacao do Objeto                                       ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?HCI                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function Okproc2(Odlg1,cFornecedor,cLoja,cNota,cSr)

Local aAreaSD1 := SD1->(GetArea("SD1"))
Local cItSD1:="0000"
Local nAcols
local nUsado
SD1->(dbsetOrder(1))
SD1->(dbSeek(xFilial("SD1")+cNota+cSr+cFornecedor+cLoja)) 

While 	SD1->(!EOF()) .and.	xFilial('SD1')  == SD1->D1_FILIAL .and. SD1->D1_DOC == cNota .and. ;
   		SD1->D1_SERIE   == cSr  .and. SD1->D1_FORNECE == cFornecedor .and. SD1->D1_LOJA    == cLoja 
   	nUsado := Len(aHeader)
    if cItSD1<>"0000"
	  Aadd(aCols,Array(nUsado+1))
	endif
	nAcols := Len(aCols)
	aCols[nAcols,nUsado+1] := .F.
	For nCntFor := 1 To nUsado-2
		Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_ITEM" )
				cItSD1 := Soma1(cItSD1)
	  			aCols[nAcols,nCntFor] := cItSD1
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_COD" )
				aCols[nAcols,nCntFor] := SD1->D1_COD
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "D1_XDESCRI" )
				aCols[nAcols,nCntFor] := SD1->D1_XDESCRI
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "D1_UM" )
				aCols[nAcols,nCntFor] := SD1->D1_UM
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_QUANT" )
				aCols[nAcols,nCntFor] := SD1->D1_QUANT 
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_VUNIT" )
				aCols[nAcols,nCntFor] := SD1->D1_VUNIT
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_LOCAL" )
				aCols[nAcols,nCntFor] := SD1->D1_LOCAL	
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_TOTAL" )
				aCols[nAcols,nCntFor] := SD1->D1_TOTAL
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_QTDETI" )
				aCols[nAcols,nCntFor] := SD1->D1_QTDETI
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_CONTA" )
				aCols[nAcols,nCntFor] := SD1->D1_CONTA
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_FORNECE" )
				aCols[nAcols,nCntFor] := SD1->D1_FORNECE
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_LOJA" )
			 	aCols[nAcols,nCntFor] := SD1->D1_LOJA
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_GRUPO" )
     			aCols[nAcols,nCntFor] := SD1->D1_GRUPO
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_TIPO" )
				aCols[nAcols,nCntFor] := SD1->D1_TIPO
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_TP" )
				aCols[nAcols,nCntFor] := SD1->D1_TP
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_CLASFIS" )
				aCols[nAcols,nCntFor] := SD1->D1_CLASFIS
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_CONHEC" )
				aCols[nAcols,nCntFor] := SD1->D1_ITEM
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_VISUAL" )
				aCols[nAcols,nCntFor] := SD1->D1_VISUAL 
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_DOC" )
				aCols[nAcols,nCntFor] := CNFISCAL
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_SERIE" )
				aCols[nAcols,nCntFor] := cSerie
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	Next nCntFor   	 

SD1->(dbskip())
enddo
Close(Odlg1)

Return



/*??????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ?   C()      ? Autor ? Norbert Waage Junior  ? Data ?10/05/2005???
????????????????????????????????????????????????????????????????????????????Ĵ??
???Descricao  ? Funcao responsavel por manter o Layout independente da       ???
???           ? resolu??o horizontal do Monitor do Usuario.                  ???
?????????????????????????????????????????????????????????????????????????????ٱ?
????????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //???????????????????????????Ŀ                                               
  //?Tratamento para tema "Flat"?                                               
  //?????????????????????????????                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 


