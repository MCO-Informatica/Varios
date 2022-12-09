#Include "Protheus.Ch"
#Include "RwMake.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: ParCalPre | Autor: Nelson Junior          | Data: 10/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Tela para alteracao dos parametros para calculo de preco   |||
||+-----------+------------------------------------------------------------+||
||| Alterado Por: | Danilo Alves Del Busso				| Data: 30/07/2015 |||
||+-----------+------------------------------------------------------------+||
||| Descrição:| Layout ajustado para exibir opções de juros para até 30, 35|||
|| ,60 90 dias.                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/                                       

User Function ParCalPre()

Local oDlgPrm
Local nOpca	  				:= 0
Local dDataCotacao			:= GetMV("VQ_DTCOTAC", .F.)
Local nTaxaMoeda2			:= GetMV("VQ_TXMOED2", .F.)
Local nFreteTonelada		:= GetMV("VQ_FRETONE", .F.)
Local nFreteMetroCubico		:= GetMV("VQ_FRETMET", .F.)
Local nBaseCalculoLitros	:= GetMV("VQ_BASELIT", .F.)   
Local a 			:= GetMV("VQ_TJUR30", .F.)   
Local b			:= GetMV("VQ_TJUR60", .F.)   
Local c			:= GetMV("VQ_TJUR90", .F.)   

Define MsDialog oDlgPrm From 100,004 To 480,255 Title "Parâmetros para Cálculo de Preço" Pixel

@ 005,004 TO	170,125 LABEL "" Pixel

@ 013,008 Say OemToAnsi("Data da Ultima Cotacao:")     			Size 150,024 Pixel
@ 033,008 Say OemToAnsi("Taxa da Moeda 2:")            	  		Size 150,024 Pixel
@ 053,008 Say OemToAnsi("Custo Frete por Tonelada:")   	  		Size 150,024 Pixel
@ 073,008 Say OemToAnsi("Custo Frete por M³:")         	  		Size 150,024 Pixel
@ 093,008 Say OemToAnsi("Base de Cálculo por Litros:") 			Size 150,024 Pixel   
@ 113,008 Say OemToAnsi("Juros(%) Até 35 dias:") 				Size 150,024 Pixel
@ 133,008 Say OemToAnsi("Juros(%) >35 dias:")  	   				Size 150,024 Pixel
@ 153,008 Say OemToAnsi("Juros(%) >65 dias:") 		   			Size 150,024 Pixel


@ 012,078 MsGet dDataCotacao       	Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(dDataCotacao)       When .F. Pixel
@ 032,078 MsGet nTaxaMoeda2        	Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(nTaxaMoeda2)        Pixel
@ 052,078 MsGet nFreteTonelada     	Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(nFreteTonelada)     Pixel
@ 072,078 MsGet nFreteMetroCubico  	Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(nFreteMetroCubico)  Pixel
@ 092,078 MsGet nBaseCalculoLitros 	Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(nBaseCalculoLitros) Pixel
@ 112,078 MsGet a			Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(a) 		 Pixel
@ 132,078 MsGet b			Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(b)		 Pixel
@ 152,078 MsGet c			Size 043,009 Picture "@E 99,999,999.99" Valid !Empty(c) 		 Pixel

Define sButton From 175,065 Type 1 Action (nOpca := 1,oDlgPrm:End()) Enable Of oDlgPrm
Define sButton From 175,095 Type 2 Action oDlgPrm:End() 			 Enable Of oDlgPrm

Activate MsDialog oDlgPrm Center

If nOpca == 1

	DbSelectArea("Z01")
	RecLock("Z01", .T.)
		Z01->Z01_FILIAL := xFilial("Z01")
		Z01->Z01_DATA	:= dDataBase
		Z01->Z01_TAXAM2	:= nTaxaMoeda2
		Z01->Z01_FTONEL := nFreteTonelada
		Z01->Z01_FMETRO := nFreteMetroCubico
		Z01->Z01_BASECA	:= nBaseCalculoLitros           
		Z01->Z01_USER	:= __cUserId 
		Z01->Z01_TJUR30 := a  
		Z01->Z01_TJUR60 := b    
		Z01->Z01_TJUR90 := c 
		Z01->Z01_DTINCL	:= Date()
		Z01->Z01_HRINCL	:= Time()                 

	Z01->(MsUnlock())

	PutMV("VQ_DTCOTAC",dDataBase)
	PutMV("VQ_TXMOED2",nTaxaMoeda2)
	PutMV("VQ_FRETONE",nFreteTonelada)
	PutMV("VQ_FRETMET",nFreteMetroCubico)
	PutMV("VQ_BASELIT",nBaseCalculoLitros) 
	PutMV("VQ_TJUR30",a)
	PutMV("VQ_TJUR60",b)
	PutMV("VQ_TJUR90",c)                           
                                    
	
	AtParams()

	MsgInfo("Parametros atualizados com sucesso."+Chr(13)+Chr(10)+"Data base: "+DtoC(dDataBase))

EndIf

Return()       

Static Function AtParams()  

         
Local aCondPgt  := {}   
Local QtdDias 	:= 0
Local nTxJurFin := 0.00  // Taxa de juros de acordo com media de dias identificada pelo GetMV na SX6
Local nIndCorre := 0           
Local nJurosSe4 := 0
Local nQtdDiaPd := 30 //Quantidade de dias padrão mês Financeiro

dbSelectArea("SE4")
dbSetOrder(1)
dbGoTop()

	while !EoF()      
		QtdDias := 0
		If AllTrim(SE4->E4_TIPO) == "1" .And. !Empty(SE4->E4_COND)
			aCondPgt := &("{"+AllTrim(SE4->E4_COND)+"}")
		If Len(aCondPgt) > 0
			For nX := 1 To Len(aCondPgt)   
				QtdDias += aCondPgt[nX]
			Next nX
			QtdDias := Round(QtdDias / Len(aCondPgt),0)
			IF QtdDias <= 30    
				nTxJurFin = GetMV("VQ_TJUR30") / 100
				nIndCorre :=  1 + (nTxJurFin / nQtdDiaPd)  * QtdDias  
			ElseIF QtdDias > 30 .AND. QtdDias <=35
				nTxJurFin = GetMV("VQ_TJUR30") / 100    
				nIndCorre := ( (1+nTxJurFin)^(1/nQtdDiaPd) )^QtdDias
			ElseIF QtdDias > 35 .AND. QtdDias <= 65    
		   		nTxJurFin = GetMV("VQ_TJUR60") / 100
				nIndCorre := ( (1+nTxJurFin)^(1/nQtdDiaPd) )^QtdDias
			Else            
				nTxJurFin = GetMV("VQ_TJUR90") / 100
				nIndCorre := ( (1+nTxJurFin)^(1/nQtdDiaPd) )^QtdDias
			EndIf
			nJurosSe4 := (nIndCorre-1)*100         
			Reclock("SE4", .F.)    
			
			SE4->E4_VQ_INDI := nIndCorre
			
			SE4->(MsUnlock())
		EndIf
	EndIf
		dbSelectArea("SE4")
		dbSkip()
	Enddo
	
	
Return()
