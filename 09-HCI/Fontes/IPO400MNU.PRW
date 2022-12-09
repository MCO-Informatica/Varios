#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA490MNU  บAutor  ณROGERIO NAGY        บ Data ณ  07/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada para ajuste de comissoes                   บฑฑ
ฑฑบ          ณInclui Reprocessa e Consulta NF   no menu da rotina         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IPO400MNU()             
//Aadd(aRotina,{"Prod x Forn x Fabr","U_POVINCFO()", 0 , 4})
//{{"Ajustes NF"	,"U_MA103AJN()" , 0 , 3}}
Return({{"Prod x Forn x Fabr","U_POVINCFO()", 0 , 4}})

                
USER FUNCTION POVINCFO()
Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
Local oDlgL
Local cSI:=Space(6)
Local cCCu:=Space(5)
Local cFornNv:=Space(6)
Local cLoJaNv:=Space(2)
Local cTitulo :="Processo de Vincula็ใ Aut. Prod x Forn"
@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Processo De Vinculacao")
@ 003,008 To 85,200 Title OemToAnsi("Selecione Dados")
@ 015,015 Say OemToAnsi("Num. SI:") OF Odlgl PIXEL
@ 015,045 msget cSi SIZE 30,10 F3 "SW0" PICTURE PesqPict('SW0','W0__NUM') OF Odlgl PIXEL
@ 015,120 msget cCCu SIZE 30,10 PICTURE PesqPict('SW0','W0__CC') OF Odlgl PIXEL 
@ 030,015 Say OemToAnsi("Forn.  :") OF Odlgl PIXEL
@ 030,045 msget cfornNv SIZE 30,10 F3 "SA2" PICTURE PesqPict('SC7','C7_FORNECE') OF Odlgl PIXEL
@ 030,120 msget cLojaNV SIZE 10,10 PICTURE PesqPict('SC7','C7_LOJA') OF Odlgl PIXEL 
@ 065,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,cSi,cCCu,cfornNv,cLojaNv)},cTitulo,"Atualizando dados, aguarde...")
@ 065,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 

Return(.T.)       

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
Static Function OkProc(oDlg1,cSi, cCCu,cFornNv,cLojaNv)
Local lRet		:= .T.
// verificacao se pode alterar ou nao o fornecedor
// etapa1 (Verificar se ja houve entregas)
// etapa2 (Verificar se Existiu Cotacao de Compras)
dbSelectArea("SW1")
DbSetOrder(1)
MsSeek(xFilial("SW1")+cCCu+cSi)
do while (!Eof() .And. cSi==SW1->W1_SI_NUM)
    // 1 PARTE GRAVANDO FORNECEDOR / FABRICANTE NA SW1
     Reclock("SW1",.F.)
     SW1->W1_FABR:=cFornNv 
     SW1->W1_FORN:=cFornNv
     MsUnLock()
     // 2 PARTE VINCULANDO PRODUTO X FORNECEDOR
     dbSelectArea("SA5")
     DbSetOrder(1)
     IF MsSeek(xFilial("SA5")+cFornNv+cLojaNv+SW1->W1_COD_I)
     // NADA A FAZER
     ELSE
       Reclock("SA5",.T.)
       SA5->A5_FILIAL	:=xFilial("SA5")
       SA5->A5_FORNECE	:=cFornNv 
       SA5->A5_LOJA		:=cLojaNv
       SA5->A5_FABR		:=cFornNv
       SA5->A5_FALOJA	:=cLojaNv
       SA5->A5_PRODUTO	:=SW1->W1_COD_I
       MsUnLock()
     ENDIF  
     dbSelectArea("SW1")
     dbSkip()
enddo
//3 PARTE GRAVANDO NO CABECALHO DA SI
 MsgInfo("Processo Concluido com Sucesso....")
Close(Odlg1)

Return .T.


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
Static Function Finaliza()
 Close(Odlg1)
Return .T.
                 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()      ณ Autor ณ Norbert Waage Junior  ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolu็ใo horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
  //ณTratamento para tema "Flat"ณ                                               
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 
