
#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT011   º Autor ³ Willian Costa      º Data ³ 12/08/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento                                   º±±
±±º          ³ Incluso a coluna natureza 23/09/11 Willian                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda - Actual Trend                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                                 	
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT011()
 //
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio"
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relacao de Faturamento"
Local cPict         := ""
Local titulo        := "Relacao de Faturamento"
Local nLin          := 80
                       //          1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890         
Local Cabec1         := "  Obra       Descrição                                Valor Faturado  Nota Fiscal Serie       Natureza        INSS        ISS        IRF         COFINS       PIS          CSLL     Valor liquido      Data emissão"
Local Cabec2         := ""
                    //  {1,        10,                                       52,            67,        68,         90,              108,      118,       128,          142,          156,        168,     176,             200          }                                                                                  	
Local imprime       := .T.
Private aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.                                                                                                               	
Private CbTxt       := ""
Private limite      := 200
Private tamanho     := "G"
Private nomeprog    := "RFAT011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "CTT"
Private cbtxt       := Space(10)
Private cbcont      := 00                                                                  
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFAT011" // nome do arquivo usado para impressao em disco
Private cArqTrab                                          	
Private cString     := "SD2"   
Private aPcol       := {1, 12,52, 73, 83, 94,99, 113, 124, 136, 147, 161,179,200}
Private aMeses:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Private c_texto		:= 'FILIAL; OBRA; DESCRIÇÃO; VALOR FATURADO; NUMERO NF; SERIE; NATUREZA; INSS; ISS; IRF; COFINS; PIS; CSLL; LIQUIDO; EMISSAO ' + chr(13)//cabecario excel			

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



If msgYesNo('Deseja Exportar os dados do relatório para o Excel?','ATENÇÃO')
	c_path := AllTrim(GetTempPath())+'RFAT011.csv'
	memowrite(c_path, c_texto)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(c_path) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	WinExec(c_path)
EndIf
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
Private cObra   := ""
Private cDesc   := ""
Private nFat    := 0
Private cNota   := ""
Private cSERIE  := ""	
Private cNature := ""

Private nInss    := 0   
Private nIss     := 0   
Private nIrf     := 0  
Private nCofins  := 0  
Private nPis     := 0  
Private nCsll    := 0  
Private dEmis    := "" 
Private nLiquido := 0 

Private nTotFilInss   := 0
Private nTotFilIss    := 0 
Private nTotFilIrf    := 0
Private nTotFilCofins := 0
Private nTotFilPis    := 0 
Private nTotFilCsll   := 0
Private nTotFilLiq    := 0

Private nTotMesInss   := 0
Private nTotMesIss    := 0 
Private nTotMesIrf    := 0
Private nTotMesCofins := 0
Private nTotMesPis    := 0 
Private nTotMesCsll   := 0
Private nTotMesLiq    := 0

Private nTotGerInss   := 0
Private nTotGerIss    := 0
Private nTotGerIrf    := 0
Private nTotGerCofins := 0   
Private nTotGerPis    := 0 
Private nTotGerCsll   := 0
Private nTotGerLiq    := 0

Private lPul1 := .F.
Private lPul2 := .F.
Private lTotF := .F.
Private lTotM := .F.    

Private cNumNota := ""

ArqTrb(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)
            
DbSelectArea("TRB")

DbGoTop()          

SetRegua(TRB->(RecCount()))                                                                     

nTotFil := 0
nTotMes := 0
nTotGer := 0


if TRB->(!Eof())      
                                
	lIp := .T.   
	cFilV := TRB->FILIAL  
  	cMesD := SubStr(DtoC(TRB->EMISSAO),4,2)
  	lPul3 := .F.   
  	cNumNota := TRB->NOTA  
 	
 	While TRB->(!EOF()) 
	
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
 
         /*  If TRB->NOTA = cNumNota
		  	TotalizaVar()	
	  		cObra  := TRB->OBRA      //Codigo da Obra
			cDesc  := TRB->DESCRI    //Descricao
	 	//	nFat   := TRB->TOTAL     //Valor faturado                   
	    	cSERIE := TRB->SERIE     //Numero Serie 
	  	//  cNature:= TRB->NATUREZA
	    	dEmis  := TRB->EMISSAO   //Data da emissao   
            c_filial := TRB->FILIAL
           	
            Endif    */
	
		   
	                                                                     
		       		
		If TRB->NOTA = cNumNota
			TotalizaVar() 
		  	 /*	cObra    := TRB->OBRA      //Codigo da Obra
				cDesc    := TRB->DESCRI    //Descricao
		    	cSERIE   := TRB->SERIE     //Numero Serie 
		    	dEmis    := TRB->EMISSAO   //Data da emissao  
		    	cFilV    := TRB->FILIAL	 */
		Else    	            	                               
	        Impressao()            
		        
			If cFilV == TRB->FILIAL 
				lTotF := .F.
			    lPul1 := .F.     
		   	else
			    lTotF := .T.   	
			    lPul1 := .T.
		   	EndIf  
	             
	        	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³        Totaliza a Filial              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    If lTotF  
		  		@ Prow()+1,aPcol[1]  PSay Replicate("_",215) 
				@ Prow()+1,aPcol[1]  PSay "Total da filial "+cFilV+":"
			  	@ Prow() ,aPcol [3]  PSay nTotFil       Picture "@RE 999,999,999.99"
			  	@ Prow() ,aPcol[07]  PSay nTotFilInss   Picture "@RE 999,999,999.99" 
			   	@ Prow() ,aPcol[08]  PSay nTotFilIss    Picture "@RE 999,999,999.99"
			  	@ Prow() ,aPcol[09]  PSay nTotFilIrf    Picture "@RE 999,999,999.99"
			  	@ Prow() ,aPcol[10]  PSay nTotFilCofins Picture "@RE 999,999,999.99"
			  	@ Prow() ,aPcol[11]  PSay nTotFilPis    Picture "@RE 999,999,999.99"
			  	@ Prow() ,aPcol[12]  PSay nTotFilCsll   Picture "@RE 999,999,999.99"
	            @ Prow() ,aPcol[13]  PSay nTotFilLiq    Picture "@RE 999,999,999.99"
	            
	            nTotFil       := 0
	            nTotFilInss   := 0
	            nTotFilIss    := 0
	            nTotFilIrf    := 0
	            nTotFilCofins := 0
	            nTotFilPis    := 0
	            nTotFilCsll   := 0
	            nTotFilLiq    := 0 
	             
	     	EndiF  
	       
	       	If cMesD == SubStr(DtoC(TRB->EMISSAO),4,2)    
				lTotM := .F.
				lPul2 := .F.
		  	else
			    lTotM := .T.
			    lPul2 := .T.
		   	EndIf 
                
       		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³            Totaliza o mes             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
				
		   	If lTotM                               		
				@ Prow()+1,aPcol[1]  PSay Replicate("-",215)  
				@ Prow()+1,aPcol[1]  PSay "Total do mês de "+aMeses[Val(cMesD)]+":"
				@ Prow()  ,aPcol[3]  PSay nTotMes       Picture "@RE 999,999,999.99"   
				@ Prow() ,aPcol[07]  PSay nTotMesInss   Picture "@RE 999,999,999.99" 
				@ Prow() ,aPcol[08]  PSay nTotMesIss    Picture "@RE 999,999,999.99"
				@ Prow() ,aPcol[09]  PSay nTotMesIrf    Picture "@RE 999,999,999.99"
				@ Prow() ,aPcol[10]  PSay nTotMesCofins Picture "@RE 999,999,999.99"
				@ Prow() ,aPcol[11]  PSay nTotMesPis    Picture "@RE 999,999,999.99"
				@ Prow() ,aPcol[12]  PSay nTotMesCsll   Picture "@RE 999,999,999.99"
		        @ Prow() ,aPcol[13]  PSay nTotMesLiq    Picture "@RE 999,999,999.99"
		        
			   	nTotMes      :=0 			   
			   	nTotMesInss  :=0
			   	nTotMesIss   :=0
			   	nTotMesIrf   :=0
			   	nTotMesCofins:=0
			   	nTotMesPis   :=0
			   	nTotMesCsll  :=0
	     	   	nTotMesLiq   :=0                                                                                                                                                 	
		  	Endif    
		        
		   	TotalizaVar()
	    EndIf
		  
	   	cFilV := TRB->FILIAL  
		cMesD := SubStr(DtoC(TRB->EMISSAO),4,2)  
        cNumNota := TRB->NOTA 
        	 
       	TRB->(DbSkip())  
       	
        totais()
	EndDo	
  	         
      
	@ Prow()+1,aPcol[1]  PSay Replicate("=",215)                                
	@ Prow()+1,aPcol[1]  PSay "Total geral do período:"
	@ Prow()  ,aPcol[3]  PSay nTotGer       Picture "@RE 999,999,999.99"   
    @ Prow()  ,aPcol[7]  PSay nTotGerInss   Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[8]  PSay nTotGerIss    Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[9]  PSay nTotGerIrf    Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[10] PSay nTotGerCofins Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[11] PSay nTotGerPis    Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[12] PSay nTotGerCsll   Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[13] PSay nTotGerLiq    Picture "@RE 999,999,999.99"

EndIf

TRB->(DbCloseArea()) 

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

Static Function TotalizaVar()
If AllTrim(TRB->NATUREZA)     == 'INSS'
    nInss   += TRB->TOTAL
ELseIf AllTrim(TRB->NATUREZA) == 'ISS'          
	nIss    += TRB->TOTAL 
ElseIf AllTrim(TRB->NATUREZA) == 'IRF'              
	nIrf    += TRB->TOTAL
ElseIf AllTrim(TRB->NATUREZA) == 'COFINS'
	nCofins += TRB->TOTAL
ElseIf AllTrim(TRB->NATUREZA) == 'PIS'
	nPis    += TRB->TOTAL
ElseIf AllTrim(TRB->NATUREZA) == 'CSLL'
	nCsll   += TRB->TOTAL
Else //If AllTrim(TRB->TIPO)     == 'NF' 
    nFat    += TRB->TOTAL
   	cNature := TRB->NATUREZA
EndIf	                     

nLiquido := nFat-(nInss+nIss+nIrf+nCofins+nPis+nCsll)
   
cObra    := TRB->OBRA      //Codigo da Obra
cDesc    := TRB->DESCRI    //Descricao
cSERIE   := TRB->SERIE     //Numero Serie 
dEmis    := TRB->EMISSAO   //Data da emissao  
cFilV    := TRB->FILIAL                                  

Return        

Static Function Impressao() 

c_texto += cFilV + ';'
@ Prow()+If(lPul1.Or.lPul2,2,1),aPcol[1] PSay cObra 
c_texto += cObra + ';'
@ Prow(),aPcol[2]   PSay Left(cDesc,35)
c_texto += Left(cDesc,35) + ';'                                                              
@ Prow(),aPcol[3]   PSay nFat       Picture "@RE 999,999,999.99" 
c_texto += transform(nFat, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[4]   PSay cNumNota
c_texto += cNumNota  + ';' 
@ Prow(),aPcol[5]   PSay cSERIE 
c_texto += cSERIE  + ';'
@ Prow(),aPcol[6]   PSay cNature
c_texto += cNature   + ';'  
@ Prow(),aPcol[7]   PSay nInss      Picture "@RE 999,999,999.99"
c_texto += transform(nInss, '@E 999,999,999.99') + ';'	    
@ Prow(),aPcol[8]   PSay nIss       Picture "@RE 999,999,999.99"
c_texto += transform(nIss, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[9]   PSay nIrf       Picture "@RE 999,999,999.99" 
c_texto += transform(nIrf, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[10]  PSay nCofins    Picture "@RE 999,999,999.99"
c_texto += transform(nCofins, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[11]  PSay nPis       Picture "@RE 999,999,999.99"
c_texto += transform(nPis, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[12]  PSay nCsll      Picture "@RE 999,999,999.99"
c_texto += transform(nCsll, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[13]  PSay nLiquido   Picture "@RE 999,999,999.99"
c_texto += transform(nLiquido, '@E 999,999,999.99') + ';'
@ Prow(),aPcol[14]  PSay DtoC(dEmis)
c_texto += DtoC(dEmis) + ';'
c_texto += chr(13) 
    	    	   		     	
nTotFil       +=nFat
nTotFilInss   +=nInss 
nTotFilIss    +=nIss 
nTotFilIrf    +=nIrf
nTotFilCofins +=nCofins
nTotFilPis    +=nPis
nTotFilCsll   +=nCsll
nTotFilLiq    +=nLiquido
   
nTotMes       +=nFat                         
nTotMesInss   +=nInss
nTotMesIss    +=nIss
nTotMesIrf    +=nirf
nTotMesCofins +=nCofins
nTotMesPis    +=nPis
nTotMesCsll   +=nCsll
nTotMesLiq    +=nLiquido  
     
nTotGer       +=nFat
nTotGerInss   +=nInss
nTotGerIss    +=nIss
nTotGerIrf    +=nIrf
nTotGerCofins +=nCofins 
nTotGerPis    +=nPis
nTotGerCsll   +=nCsll
nTotGerLiq    +=nLiquido  
       
nFat:=0
nInss:=0
nIss:=0
nIrf:=0
nCofins:=0
nPis:=0
nCsll:=0
nLiquido:=0                

Return

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT011   ºAutor  ³Microsiga           º Data ³  09/30/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime os totais gerais                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function totais()  
         
If TRB->(Eof())          
    Impressao() 

	//Imprime totais da filial
	@ Prow()+1,aPcol[1]   PSay Replicate("_",215) 
	@ Prow()+1,aPcol[1]   PSay "Total da filial "+cFilV+":"
	@ Prow()  ,aPcol[3]   PSay nTotFil       Picture "@RE 999,999,999.99" 	
    @ Prow()  ,aPcol[07]  PSay nTotFilInss   Picture "@RE 999,999,999.99" 
    @ Prow()  ,aPcol[08]  PSay nTotFilIss    Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[09]  PSay nTotFIlIrf    Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[10]  PSay nTotFilCofins Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[11]  PSay nTotFilPis    Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[12]  PSay nTotFilCsll   Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[13]  PSay nTotFilLiq    Picture "@RE 999,999,999.99"
  
    //Imprime total do mes
	@ Prow()+1,aPcol[1]   PSay Replicate("-",210)  
	@ Prow()+1,aPcol[1]   PSay "Total do mês de "+aMeses[Val(cMesD)]+":"      	 
	@ Prow()  ,aPcol[3]   PSay nTotMes       Picture "@RE 999,999,999.99"
   	@ Prow()  ,aPcol[07]  PSay nTotMesInss   Picture "@RE 999,999,999.99" 
	@ Prow()  ,aPcol[08]  PSay nTotMesIss    Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[09]  PSay nTotMesIrf    Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[10]  PSay nTotMesCofins Picture "@RE 999,999,999.99"                                        
	@ Prow()  ,aPcol[11]  PSay nTotMesPis    Picture "@RE 999,999,999.99"
	@ Prow()  ,aPcol[12]  PSay nTotMesCsll   Picture "@RE 999,999,999.99"
    @ Prow()  ,aPcol[13]  PSay nTotMesLiq    Picture "@RE 999,999,999.99"
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
           
Static Function ARQTRB(cFilIni, cFilFim, cDtIni, cDtFim)
Local aCampos    := {}

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                               
aTam:=TamSX3("D2_FILIAL")
aAdd(aCampos,{ "FILIAL"  ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("D2_CCUSTO")
aAdd(aCampos,{ "OBRA"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("CTT_DESC01")
aAdd(aCampos,{ "DESCRI"  ,"C",aTam[1],aTam[2] } ) 

aTam:=TamSX3("D2_DOC")
aAdd(aCampos,{ "NOTA"   ,"C",aTam[1],aTam[2] } ) 

aTam:=TamSX3("D2_SERIE")
aAdd(aCampos,{ "SERIE"   ,"C",aTam[1],aTam[2] } ) 

aTam:=TamSX3("E1_NATUREZ")
aAdd(aCampos,{ "NATUREZA"   ,"C",aTam[1],aTam[2] } )
                                                    
aTam:=TamSX3("E1_VALOR")
aAdd(aCampos,{ "TOTAL"   ,"N",aTam[1],aTam[2] } )  

aTam:=TamSX3("D2_EMISSAO")
aAdd(aCampos,{ "EMISSAO"  ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("E1_TIPO")
aAdd(aCampos,{ "TIPO"   ,"C",aTam[1],aTam[2] } )  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)
 
DbSelectArea("TRB")

DbGoTop()      

cAliasSD2 := "RF011TRB"
aStruSD2  := SD2->(dbStruct())   

//SELECT D2_FILIAL, D2_CCUSTO, CTT_DESC01, D2_DOC, D2_SERIE,E1_TIPO,E1_VALOR,E1_NATUREZ, D2_EMISSAO
 //  FROM SD2010 SD2

cQuery := "SELECT D2_FILIAL, D2_CCUSTO, CTT_DESC01, D2_DOC, D2_SERIE, E1_TIPO, E1_PARCELA, E1_VALOR,E1_NATUREZ,D2_EMISSAO"
cQuery += CRLF + "  FROM "+RetSQLName("SD2")+" SD2 "

cQuery += CRLF + "  INNER JOIN "+RetSQLName("CTT")+" CTT "
cQuery += CRLF + "  ON CTT.D_E_L_E_T_ = ' ' "
cQuery += CRLF + "  AND CTT_CUSTO = D2_CCUSTO "
    
cQuery += CRLF + " INNER JOIN "+ RetSQLName( "SC5" ) +" SC5 "
cQuery += CRLF + " ON SC5.D_E_L_E_T_=' ' "
cQuery += CRLF + " AND C5_FILIAL = D2_FILIAL" 
cQuery += CRLF + " AND C5_NUM = D2_PEDIDO "
cQuery += CRLF + " AND C5_XPEDFIN = 'S' "      
                                        
cQuery += CRLF + " INNER JOIN "+ RetSQLName( "SE1" ) +" SE1 "
cQuery += CRLF + " ON SE1.D_E_L_E_T_=' ' "
cQuery += CRLF + " AND E1_NUM = D2_DOC "  
cQuery += CRLF + " AND E1_PREFIXO = D2_SERIE"
cQuery += CRLF + " AND E1_FILIAL = D2_FILIAL"
                                   
cQuery += CRLF + " WHERE SD2.D_E_L_E_T_ = ' ' "
cQuery += CRLF + " AND D2_FILIAL BETWEEN '"+cFilIni+"' AND '"+cFilFim+"' "
cQuery += CRLF + " AND D2_EMISSAO BETWEEN '"+DtoS(cDtIni)+"' AND '"+DtoS(cDtFim)+"' "
cQuery += CRLF + " AND D2_CCUSTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += CRLF + " GROUP BY D2_FILIAL, D2_EMISSAO, D2_CCUSTO, CTT_DESC01, D2_DOC, D2_SERIE,E1_NATUREZ , E1_TIPO,E1_PARCELA,E1_VALOR" 
cQuery += CRLF + " ORDER BY SUBSTRING(D2_EMISSAO,1,6),D2_FILIAL,D2_EMISSAO, D2_CCUSTO, D2_DOC, D2_SERIE, E1_PARCELA, E1_NATUREZ, E1_VALOR DESC"
             
//SUBSTRING(D2_EMISSAO,1,6)
Memowrite("RFAT011.SQL",cQuery)    

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

TcSetField(cAliasSD2,"D2_EMISSAO","D",08,0)    
TcSetField(cAliasSD2,"E1_VALOR","N",15,2)

DbSelectArea(cAliasSD2)
DbGoTop()
Do While !Eof()
		
   	DbSelectArea("TRB")
	RecLock("TRB",.T.)

	TRB->FILIAL  	:= (cAliasSD2)->D2_FILIAL
	TRB->OBRA     	:= (cAliasSD2)->D2_CCUSTO
	TRB->DESCRI 	:= (cAliasSD2)->CTT_DESC01
	TRB->NOTA     	:= (cAliasSD2)->D2_DOC
	TRB->SERIE  	:= (cAliasSD2)->D2_SERIE
	TRB->NATUREZA   := (cAliasSD2)->E1_NATUREZ
	TRB->TOTAL  	:= (cAliasSD2)->E1_VALOR 
	TRB->EMISSAO	:= (cAliasSD2)->D2_EMISSAO  
	TRB->TIPO    	:= (cAliasSD2)->E1_TIPO    
		
	MsUnlock()

	DbSelectArea(cAliasSD2)
	DbSkip()
EndDo

(cAliasSD2)->(DbCloseArea())

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

Aadd(aPerg, {"01","De Filial ? ","?","?","mv_ch1","C",2,"G","mv_par01","","","","","","","",0,""})
Aadd(aPerg, {"02","Ate Filial ?","?","?","mv_ch2","C",2,"G","mv_par02","","","","","","","",0,""})
Aadd(aPerg, {"03","De Data ?   ","?","?","mv_ch3","D",8,"G","mv_par03","","","","","","","",0,""}) 
Aadd(aPerg, {"04","Ate Data ?  ","?","?","mv_ch4","D",8,"G","mv_par04","","","","","","","",0,""})
Aadd(aPerg, {"05","Obra de  ?  ","?","?","mv_ch5","C",15,"G","mv_par05","","","","","","","",0,""})
Aadd(aPerg, {"06","Obra Ate ?  ","?","?","mv_ch6","C",15,"G","mv_par06","","","","","","","",0,""})

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
		PutSX1Help("P.RFAT01101.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe ate qual filial")                                                                                                              	
		
		aAdd(aHelpSpa,"Informe ate qual filial")
		aAdd(aHelpEng,"Informe ate qual filial")
		PutSX1Help("P.RFAT01102.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe de qual data")
		aAdd(aHelpSpa,"Informe de qual data")
		aAdd(aHelpEng,"Informe de qual data")
		PutSX1Help("P.RFAT01103.",aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {}
		aHelpSpa := {}
		aHelpEng := {}
		aAdd(aHelpPor,"Informe ate qual data")
		aAdd(aHelpSpa,"Informe ate qual data")
		aAdd(aHelpEng,"Informe ate qual data")
		PutSX1Help("P.RFAT01104.",aHelpPor,aHelpEng,aHelpSpa)
		
		MsUnlock()
	EndIf
Next
                                                                                                                                                                               	
DbSelectArea(cAlias)

Return
