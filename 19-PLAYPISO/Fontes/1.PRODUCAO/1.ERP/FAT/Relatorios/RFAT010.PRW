#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT010   º Autor ³ Bruno Parreira /    º Data ³  29/08/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Vendas                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda - Actual Trend                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                                 	
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT010()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio"
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relacao de Vendas Realizadas"
Local cPict         := ""
Local titulo        := "Relacao de Vendas Realizadas"
Local nLin          := 80
                       //          1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890         
Local Cabec1         := "  Obra                            Descrição                                Valor de Venda     Custo Previsto    Markup   Porcent(%)"
Local Cabec2         := ""
                                                                                                      	
Local imprime       := .T.
Private aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 110
Private tamanho     := "M"
Private nomeprog    := "RFAT010" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "CTT"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFAT010" // nome do arquivo usado para impressao em disco
Private cArqTrab                                          	
Private cString     := "AF8"		

			AjustaSX1()
			
			pergunte(cPerg,.F.)
                          		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
                                                                                                                                                                            		
nTipo := If(aReturn[4]==1,15,18)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Mauro Nagata       º Data ³  24/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 	
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cObra := ""
Local cDesc := ""
Local nCust := 0
Local nMark := 0	
Local nVend := 0  
Local nPorc := 0   
Private aPCol := {0,12,72,88,104,115}
Private aMeses:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}   
Private cUsuMast  := GetMV('MV_XUSUMST')
Private lPul1 := .F.
Private lPul2 := .F.
Private lTotF := .F.                                                                                                                    	
Private lTotM := .F.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetRegua(RecCount())                                                                     
nCountReg := 0
DbEval({|| nCountReg++})
SetRegua(nCountReg)

ArqTrb(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)
            
DbSelectArea("TRB") 

DbGoTop()     

nTotCFil := 0
nTotMFil := 0
nTotVFil := 0
nTotCMes := 0
nTotMMes := 0
nTotVMes := 0
nTotCGer := 0
nTotMGer := 0
nTotVGer := 0  
nTotFilPorc := 0
nTotMesPorc := 0
nTotGerPorc := 0

if TRB->(!Eof())      
                                                                            '
	// ************************ Monta Estrutura do Temporario Excel
	_aStruct := {} 
	aAdd(_aStruct,{"OBRA","C",10,0})      // Codigo da Obra
	aAdd(_aStruct,{"DESCRICAO","C",60,0}) // Descrição da Obra    
	aAdd(_aStruct,{"VENDA","N",15,2})   // Valor de venda 
	aAdd(_aStruct,{"CUSTO","N",15,2})    // Valor do Custo
	aAdd(_aStruct,{"MARKUP","N",15,2})  // Valor do markup
	aAdd(_aStruct,{"PORCENTO","N",15,2})
	
	
	cArqTMP	:= CriaTrab(_aStruct)   
	
	dbUseArea( .T.,, cArqTmp, "TMP", if(.F. .OR. .F., !.F., NIL), .F. )          //__LocalDriver

	lIp := .T.   
	cFilV := TRB->FILIAL  
	cMesD := SubStr(DtoC(TRB->DTINI),4,2)     
	Do While TRB->(!EOF()) 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		If lAbortPrint
			@Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif                                                                                                                                    		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Prow()>65.Or.lIp
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			lIp := .F.
		EndIf        
	
		IncRegua()        
		
		cObra := TRB->OBRA    // Codigo da Obra
		cDesc := TRB->DESCRI  // Descricao
		nVend := TRB->TOTAL  // Valor do Total   alterado p/WILLIAN 30/08/11
		nCust := TRB->CUSTO  // Valor do Custo   alterado p/WILLIAN 30/08/11
		nMark := TRB->MARKUP  // Valor do markup alterado p/WILLIAN 30/08/11      
		
		If cFilV == TRB->FILIAL 
			lTotF := .F.
		    lPul1 := .F.     
		else
		    lTotF := .T.   	
		    lPul1 := .T.
		EndIf 
	
		      
	   	nTotFilPorc= (nTotVFil/nTotCFil-1)*100
		
	 	If lTotF  
			@ Prow()+1,aPcol[1] PSay Replicate("_",130) 
			@ Prow()+1,aPcol[1] PSay "Total da filial "+cFilV+":"
			@ Prow()  ,aPcol[3] PSay nTotVFil   Picture "@RE 999,999,999.99"
			@ Prow()  ,aPcol[4] PSay nTotCFil   Picture "@RE 999,999,999.99"
			@ Prow()  ,aPcol[5] PSay nTotMFil   Picture "@RE 999,999,999.99"  
            @ Prow()  ,aPcol[6] PSay nTotFilPorc Picture "@RE 999,999,999.99%"                                                                                                           		
		  
			RecLock("TMP",.T.)
			TMP->DESCRICAO := "Total da filial "+cFilV+":"    
			TMP->VENDA     := nTotVFil   
			TMP->MARKUP    := nTotMFil
			TMP->CUSTO     := nTotCFil   
			TMP->PORCENTO  := nTotFilPorc
			MsUnlock()  
			
			RecLock("TMP",.T.)
			TMP->DESCRICAO := " "
			MsUnlock() 
			
			nTotCFil := 0
			nTotMFil := 0
			nTotVFil := 0
		EndIf
		
	  	If  cMesD == SubStr(DtoC(TRB->DTINI),4,2)    
			lTotM := .F.
			lPul2 := .F.
		else
		    lTotM := .T.
		    lPul2 := .T.
		EndIf 
		
		 nTotMesPorc= (nTotVMes/nTotCMes-1)*100
				
		If lTotM                                		
			@ Prow()+1,aPcol[1] PSay Replicate("-",130)  
			@ Prow()+1,aPcol[1] PSay "Total do mês de "+aMeses[Val(cMesD)]+":"
			@ Prow()  ,aPcol[3] PSay nTotVMes    Picture "@RE 999,999,999.99"
			@ Prow()  ,aPcol[4] PSay nTotCMes    Picture "@RE 999,999,999.99"
			@ Prow()  ,aPcol[5] PSay nTotMMes    Picture "@RE 999,999,999.99"   
			@ Prow()  ,aPcol[6] PSay nTotMesPorc Picture "@RE 999,999,999.99%" 
			
			RecLock("TMP",.T.)
			TMP->DESCRICAO := "Total do mês de "+aMeses[Val(cMesD)]+":"
			TMP->VENDA     := nTotVMes
			TMP->MARKUP    := nTotMMes
			TMP->CUSTO     := nTotCMes
			TMP->PORCENTO   := nTotMesPorc
			MsUnlock()  
			
			RecLock("TMP",.T.)
			TMP->DESCRICAO := " "
			MsUnlock() 
	
			nTotCMes := 0
			nTotMMes := 0
			nTotVMes := 0
		EndIf     
		
		
		nPorc = (nVend/nCust-1)*100  
		if nCust=0
		nPorc:=0
		Endif
    
    	
		@ Prow()+If(lPul1.Or.lPul2,2,1),aPcol[1] PSay cObra                                                	
		@ Prow(),aPcol[2] PSay Left(cDesc,60)
		@ Prow(),aPcol[3] PSay nVend Picture "@RE 999,999,999.99"
		@ Prow(),aPcol[4] PSay nCust Picture "@RE 999,999,999.99"
		@ Prow(),aPcol[5] PSay nMark Picture "@RE 999,999,999.99"  
		@ Prow(),aPcol[6] PSay nPorc Picture "@RE 999,999,999.99%"
		
		RecLock("TMP",.T.)
		TMP->OBRA      := cObra
		TMP->DESCRICAO := Left(cDesc,60)
		TMP->VENDA     := nVend
		TMP->MARKUP    := nMark
		TMP->CUSTO     := nCust 
		TMP->PORCENTO   := nPorc   
	 	MsUnlock() 
		                                                                                               	
		nTotCFil += nCust
		nTotMFil += nMark
		nTotVFil += nVend 
		
		nTotCMes += nCust
		nTotMMes += nMark
		nTotVMes += nVend 
		
		nTotCGer += nCust
		nTotMGer += nMark
		nTotVGer += nVend
		
						
		cFilV := TRB->FILIAL  
		cMesD := SubStr(DtoC(TRB->DTINI),4,2)  
		
		TRB->(DbSkip()) 
		 
      //o bloco abaixo orienta os totais com os usuarios comuns e os usuarios masters wcosta 18/10/11
       	if mv_par01 <> mv_par02 .and. AllTrim(PswRet()[1][1]) $ Alltrim(cUsuMast)
        	totais2()     	
	        	Elseif mv_par01 = mv_par02 .and. AllTrim(PswRet()[1][1]) # Alltrim(cUsuMast) 
		         totais1()
	            	Elseif mv_par01 <> mv_par02 .and. AllTrim(PswRet()[1][1]) # Alltrim(cUsuMast) 
	                	totais1()
	  	EndIf   
	  
	    	
	EndDo
	
    nTotGerPorc=(nTotVGer/nTotCGer-1)*100
		
	@ Prow()+1,aPcol[1] PSay Replicate("=",130)   
	@ Prow()+1,aPcol[1] PSay "Total geral do período:"
	@ Prow()  ,aPcol[3] PSay nTotVGer Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[4] PSay nTotCGer Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[5] PSay nTotMGer Picture "@RE 999,999,999.99"  
	@ Prow()  ,aPcol[6] PSay nTotGerPorc Picture "@RE 999,999,999.99%"
	
	TRB->(DbCloseArea())
	
	If Select("TMP") > 0                                                                                                                                               	
		TMP->(DbCloseArea())
	 
		If MsgYesNo("Deseja gerar planilha excel ?")
		
			cExcel :=  AllTrim(GetTempPath())+"RELACAO_VENDAS_"+StrTran(Dtoc(dDatabase),"/","")+".XLS"
			
			fErase(cExcel)
			__CopyFile(cArqTMP+".DBF",cExcel)
			fErase(cArqTMP+".*")
			
			oExcelApp:= MsExcel():New()                        	
			oExcelApp:WorkBooks:Open(cExcel)
			oExcelApp:SetVisible(.T.)                                                                          
			lExcel := .T.
			Return
		EndIf  
	EndIf      
EndIf                                                                
	
Roda(cbcont,cbtxt,tamanho)
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	DbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return   

Static Function Totais1()
If TRB->(EoF())     
nTotMesPorc= (nTotVMes/nTotCMes-1)*100

	@ Prow()+1,aPcol[1] PSay Replicate("-",130)  
	@ Prow()+1,aPcol[1] PSay "Total do mês de "+aMeses[Val(cMesD)]+":"
	@ Prow()  ,aPcol[3] PSay nTotVMes Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[4] PSay nTotCMes Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[5] PSay nTotMMes Picture "@RE 999,999,999.99"    
	@ Prow()  ,aPcol[6] PSay nTotMesPorc Picture "@RE 999,999,999.99%"
	
	RecLock("TMP",.T.)
	TMP->DESCRICAO := "Total do mês de "+aMeses[Val(cMesD)]+":"
   	TMP->VENDA     := nTotVMes  
	TMP->MARKUP    := nTotMMes
    TMP->CUSTO     := nTotCMes
    TMP->PORCENTO   := nTotMesPorc                                                                                	
	MsUnlock()  
	
	RecLock("TMP",.T.)
	TMP->DESCRICAO := " "
	MsUnlock()                                           
EndIf     
  

If TRB->(Eof()) 
	nTotFilPorc= (nTotVFil/nTotCFil-1)*100 
	
	@ Prow()+1,aPcol[1] PSay Replicate("_",130) 
	@ Prow()+1,aPcol[1] PSay "Total da filial "+cFilV+":"
	@ Prow()  ,aPcol[3] PSay nTotVFil Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[4] PSay nTotCFil Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[5] PSay nTotMFil Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[6] PSay nTotFilPorc Picture "@RE 999,999,999.99%"  

	RecLock("TMP",.T.)
	TMP->DESCRICAO := "Total da filial "+cFilV+":"
	TMP->VENDA     := nTotVFil
	TMP->MARKUP    := nTotMFil
	TMP->CUSTO     := nTotCFil 
	TMP->PORCENTO  := nTotFilPorc                                                                                           	
	MsUnlock()    
	
	RecLock("TMP",.T.)
	TMP->DESCRICAO := " "
	MsUnlock() 
EndIf         


Return


Static Function Totais2()
If TRB->(Eof()) 
	nTotFilPorc= (nTotVFil/nTotCFil-1)*100 
	
	@ Prow()+1,aPcol[1] PSay Replicate("_",130) 
	@ Prow()+1,aPcol[1] PSay "Total da filial "+cFilV+":"
	@ Prow()  ,aPcol[3] PSay nTotVFil Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[4] PSay nTotCFil Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[5] PSay nTotMFil Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[6] PSay nTotFilPorc Picture "@RE 999,999,999.99%"  

	RecLock("TMP",.T.)
	TMP->DESCRICAO := "Total da filial "+cFilV+":"
	TMP->VENDA     := nTotVFil
	TMP->MARKUP    := nTotMFil
	TMP->CUSTO     := nTotCFil 
	TMP->PORCENTO  := nTotFilPorc                                                                                           	
	MsUnlock()    
	
	RecLock("TMP",.T.)
	TMP->DESCRICAO := " "
	MsUnlock() 
EndIf         

If TRB->(EoF())     
nTotMesPorc= (nTotVMes/nTotCMes-1)*100

	@ Prow()+1,aPcol[1] PSay Replicate("-",130)  
	@ Prow()+1,aPcol[1] PSay "Total do mês de "+aMeses[Val(cMesD)]+":"
	@ Prow()  ,aPcol[3] PSay nTotVMes Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[4] PSay nTotCMes Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[5] PSay nTotMMes Picture "@RE 999,999,999.99"    
	@ Prow()  ,aPcol[6] PSay nTotMesPorc Picture "@RE 999,999,999.99%"
	
	RecLock("TMP",.T.)
	TMP->DESCRICAO := "Total do mês de "+aMeses[Val(cMesD)]+":"
   	TMP->VENDA     := nTotVMes  
	TMP->MARKUP    := nTotMMes
    TMP->CUSTO     := nTotCMes
    TMP->PORCENTO  := nTotMesPorc                                                                                	
	MsUnlock()                                         	
	RecLock("TMP",.T.)
	TMP->DESCRICAO := " "
	MsUnlock()                                            
EndIf     
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ARQTRB    º Autor ³ Bruno Parreira     º Data ³  23/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para montar a tabela temporaria para uso no         º±±
±±º          ³ relatorio.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
           
Static Function ARQTRB(	cFilIni, cFilFim, cDtIni, cDtFim)
Local aCampos    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                               
aTam:=TamSX3("AF8_MSFIL")
aAdd(aCampos,{ "FILIAL"  ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("AF8_CODOBR")
aAdd(aCampos,{ "OBRA"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("AF8_DESCRI")
aAdd(aCampos,{ "DESCRI"  ,"C",aTam[1],aTam[2] } ) 

aTam:=TamSX3("AF8_START")
aAdd(aCampos,{ "DTINI"   ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("AFC_CUSTO")
aAdd(aCampos,{ "CUSTO"   ,"N",aTam[1],aTam[2] } ) 
                                                                                                                         		
aTam:=TamSX3("AFC_VALBDI")
aAdd(aCampos,{ "MARKUP"  ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("AFC_TOTAL")
aAdd(aCampos,{ "TOTAL"   ,"N",aTam[1],aTam[2] } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]   //qual ordem foi escolhida

//cOrdem := "SUBSTRING(DTINI,5,2)+FILIAL+OBRA"

DbSelectArea("TRB")
//IndRegua("TRB",cArqTrab,cOrdem,,,"Ordenando os Registros...")

DbSelectArea("TRB")
//DbSetOrder(1)
DbGoTop()

cAliasAF8 := "RF010TRB"
aStruAF8  := AF8->(dbStruct())   

cQuery := "         SELECT AF8_MSFIL, AF8_CODOBR, AF8_DESCRI, AF8_START, AFC_CUSTO, AFC_VALBDI, AFC_TOTAL "
cQuery += CRLF + "  FROM "+ RetSQLName( "AF8" ) +" AF8 "

cQuery += CRLF + "  INNER JOIN "+ RetSQLName( "AFC" ) +" AFC "
cQuery += CRLF + "  ON AFC.D_E_L_E_T_ = ' ' "
cQuery += CRLF + "  AND AFC_PROJET = AF8_PROJET "                              
cQuery += CRLF + "  AND AFC_REVISA = '0001' "
cQuery += CRLF + "  AND AFC_NIVEL = '001' "

cQuery += CRLF + "  WHERE AF8.D_E_L_E_T_ = ' ' "                        
cQuery += CRLF + "  AND AF8_CODOBR <> ' ' "    
cQuery += CRLF + "  AND AF8_FASE <> '08' "

 //O bloco abaixo filtra por usuario.   wcosta	18/10/11
// os usuarios com senha master enxergam todas as filiais, enquanto os outros so podem ver a filial que estao loggados 
 if AllTrim(PswRet()[1][1]) $ Alltrim(cUsuMast)
	cQuery += CRLF + "  AND AF8_MSFIL BETWEEN '"+cFilIni+"' AND '"+cFilFim+"' " 
	else
    cQuery += CRLF + "  AND AF8_MSFIL = '"+cFilAnt+"'" 
 Endif

cQuery += CRLF + "  AND AF8_START BETWEEN '"+DtoS(cDtIni)+"' AND '"+DtoS(cDtFim)+"' "
cQuery += CRLF + "  ORDER BY SUBSTRING(AF8_START,5,2),AF8_MSFIL, AF8_CODOBR  "        
    
Memowrite("RFAT010.SQL",cQuery)    

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAF8,.T.,.T.)

For nX := 1 To Len(aStruAF8)
	If ( aStruAF8[nX][2] <> "C" )
		TcSetField(cAliasAF8,aStruAF8[nX][1],aStruAF8[nX][2],aStruAF8[nX][3],aStruAF8[nX][4])
	EndIf
Next nX

TcSetField(cAliasAF8,"AFC_CUSTO","N",14,2)
TcSetField(cAliasAF8,"AFC_VALBDI","N",14,2)    
TcSetField(cAliasAF8,"AFC_TOTAL","N",14,2) 
TcSetField(cAliasAF8,"AF8_START","D",08,0)

SetRegua(-1)

DbSelectArea(cAliasAF8)
DbGoTop()
Do While !Eof()
	
	IncRegua()
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)

	TRB->FILIAL := (cAliasAF8)->AF8_MSFIL
	TRB->OBRA   := (cAliasAF8)->AF8_CODOBR
	TRB->DESCRI := (cAliasAF8)->AF8_DESCRI
	TRB->DTINI  := (cAliasAF8)->AF8_START
	TRB->CUSTO  := (cAliasAF8)->AFC_CUSTO
	TRB->MARKUP := (cAliasAF8)->AFC_VALBDI
	TRB->TOTAL  := (cAliasAF8)->AFC_TOTAL
	
	DbSelectArea(cAliasAF8)
	DbSkip()
EndDo                                                                                          	

(cAliasAF8)->(DbCloseArea())

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Mauro Nagata        ³Data³ 24/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local cAlias := Alias(), aPerg := {}
Local nI, nPerg
//      cGrupo 	cOrde cDesPor cDesSpa	cDesEng   cVar	cTipo 	cTamanho	cDecimal	nPreSel		cGSC	cValid	cF3	cGrpSXG	cPyme	cVar01		cDef1Por	cDef1Spa	cDef1Eng	cCnt01	cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por	cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp) 

Aadd(aPerg, {"01","De Filial ? ","?","?","mv_ch1","C",2,"G","mv_par01","","","","","","","",0,""})
Aadd(aPerg, {"02","Ate Filial ?","?","?","mv_ch2","C",2,"G","mv_par02","","","","","","","",0,""})
Aadd(aPerg, {"03","De Data ?   ","?","?","mv_ch3","D",8,"G","mv_par03","","","","","","","",0,""}) 
Aadd(aPerg, {"04","Ate Data ?  ","?","?","mv_ch4","D",8,"G","mv_par04","","","","","","","",0,""})

nPerg := Len(aPerg)                                                                                                                              	

DbSelectArea("SX1")
DbSetOrder(1)
For nI := 1 To nPerg
	If !DbSeek(Pad(cPerg,10)+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_GSC		With aPerg[nI,08]
		Replace X1_VAR01	With aPerg[nI,09]
		Replace X1_DEF01	With aPerg[nI,10]
		Replace X1_DEFSPA1	With aPerg[nI,11]
		Replace X1_DEFENG1	With aPerg[nI,12]
		Replace X1_CNT01	With aPerg[nI,13]
		Replace X1_DEF02	With aPerg[nI,14]
		Replace X1_DEFSPA2	With aPerg[nI,15]
		Replace X1_DEFENG2	With aPerg[nI,16]
		Replace X1_PRESEL 	With aPerg[nI,17]
		Replace X1_F3    	With aPerg[nI,18]
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe de qual filial")
		aAdd(aHelpSpa,"Informe de qual filial")
		aAdd(aHelpEng,"Informe de qual filial")
		PutSX1Help("P.RFAT01001.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe ate qual filial")                                                                                                              	
		aAdd(aHelpSpa,"Informe ate qual filial")
		aAdd(aHelpEng,"Informe ate qual filial")
		PutSX1Help("P.RFAT01002.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe de qual data")
		aAdd(aHelpSpa,"Informe de qual data")
		aAdd(aHelpEng,"Informe de qual data")
		PutSX1Help("P.RFAT01003.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe ate qual data")
		aAdd(aHelpSpa,"Informe ate qual data")
		aAdd(aHelpEng,"Informe ate qual data")
		PutSX1Help("P.RFAT01004.",aHelpPor,aHelpEng,aHelpSpa)
		
		MsUnlock()
	EndIf
Next

DbSelectArea(cAlias)

Return
