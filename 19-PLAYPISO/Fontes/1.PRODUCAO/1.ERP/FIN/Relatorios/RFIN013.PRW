#Include "RwMake.ch"
#Include "Protheus.ch"                         
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT013   º Autor ³ Bruno Parreira     º Data ³  28/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Previsão de Receitas e Despesas               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lisonda - Actual Trend                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                                 	
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFIN013()                                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio"
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Previsão de Medição"
Local cPict         := ""
Local titulo        := "Previsao de Medicao"
Local nLin          := 80
Local imprime       := .T.
                        //          1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
                        //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890         
Local Cabec1         :=  "|P| Previsto "
Local Cabec2         :=  "|R| Realizado"
//                        Xa.Q |X| 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 999,999,999 9,999,999,999  
Private aPCol 		 := {0,   5,  9,          21,         33,         45,         57,         69,         81,         93,        105,        117,        129,        141,       153,        165,        177,        189,        201}  
/*
Local Cabec1         :=  "Obra      | Descrição                       "
Local Cabec2         :=  "          |                                 "
//                        xxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  99,999,999
Private aPCol 		 := {0,         11,                           42,44,        55,        66,        77,        88,        99,        110,      121,       132,       143,       154,       165,       176,      187,       198,       210}  
*/
                                                                                                      	
Private aOrd        := {}
Private lEnd        := .F.                                            
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RFIN013" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "SZ9"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFIN013" // nome do arquivo usado para impressao em disco
Private cArqTrab                                          	
Private cString     := "SZ9"		

AjustaSX1()
			
Pergunte(cPerg,.F.)
                          		
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
                                                                                                                                                                            		
//nTipo := If(aReturn[4]==1,15,18)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo) 

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
Local oProcess	                    
//Private aPCol := {0,11,50,63,75}  
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 30/11/2011]
Private aMeses:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetRegua(RecCount())                                                                     
nCountReg := 0
DbEval({|| nCountReg++})
SetRegua(nCountReg)           

//definindo cabecalho    
/*
dIniMes := Ctod("01/"+MV_PAR01+"/"+MV_PAR02)
Do While Day(dIniMes) <= 15
   Cabec1 += PadC(StrZero(Day(dIniMes),2),9)+" |"
   Cabec2 += PadC(If(Month(dIniMes+15)=Val(MV_PAR01),StrZero(Day(dIniMes+15),2),""),9)+" |"
   dIniMes++
EndDo       
Cabec1 += ""
*/
Cabec1 += "| Data "+Space(181)+"|    Total     |"
Cabec2 += "| Valor"+Space(181)+"|              |"
                                                                          
nRece    := 0
nDesp    := 0 
nReal    := 0         
nTotRece := 0
nTotDesp := 0   
nTotReal := 0                           
aTPrev   := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}  //Total da previsao
aTReal   := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}  //Total do realizado
aSldPrRe := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}  //Saldo do Previsto vs Realizado

lIp := .T.   

cObraAdm := GetMV("MV_XOBRRES")
DbSelectArea("CTT") 
DbSeek(xFilial("CTT")+MV_PAR03,.T.)  
              
Do While !EOF().And. xFilial("CTT")=CTT->CTT_FILIAL.And.CTT->CTT_CUSTO <= MV_PAR04     
   If AllTrim(CTT->CTT_CUSTO) $ cObraAdm
      CTT->(DbSkip())
      Loop
   EndIf                 
   
   //somente listar as obras que tem previsao de medicao no mes/ano informado e diferente de zero
   DbSelectArea("SZ9")
   DbSetOrder(1)
   If !DbSeek(xFilial("SZ9")+CTT->CTT_CUSTO+MV_PAR02+MV_PAR01)
      DbSelectArea("CTT")
      DbSkip()
      Loop    
   Else
      If Empty(SZ9->Z9_RECEITA)             
         DbSelectArea("CTT")
         DbSkip()
         Loop    
      EndIf   
   EndIf   
   DbSelectArea("CTT")      

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
		If lIp
			@ Prow()+1,aPcol[1] PSay "Medicoes referentes a "+aMeses[Val(MV_PAR01)]+"/"+MV_PAR02+":"
			@ Prow()+1,aPcol[1] PSay " "
		EndIf	
		lIp := .F.
	EndIf        

	IncRegua()        
	
	cObra := CTT->CTT_CUSTO    	// Codigo da Obra
	cDesc := CTT->CTT_DESC01  	// Descricao
	
	aPrev    := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}   //Previsao
	aReal    := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}   //Realizado
	     
    ARQTRB(MV_PAR01,MV_PAR02,CTT->CTT_CUSTO)     
	DbSelectArea("TRB")
	DbSetOrder(1)        
	DbGotop()
    Do While !Eof()
       nDia := Day(TRB->DT)  
       If nDia = 0
          DbSkip()
          Loop
       EndIf   
       
       aPrev[If(nDia <= 15,1,2)][If(nDia <= 15,nDia,nDia-15)] += TRB->VALOR
    	       
	   TRB->(DbSkip())
	EndDo
	
	//oProcess := MsNewProcess():New({|lEnd| U_RFIN013a(oProcess,cObra)},"Processando informações da Obra","Preparando . . .",.T.)
	//oProcess:Activate()        
	U_RFIN013a(cObra)
	
	DbSelectArea("TRAB")
	DbSetOrder(1)
	DbGoTop()

    Do While !Eof()
       nDia := Day(TRAB->TRB_EMISSA)
       
       If nDia = 0
          DbSkip()
          Loop
       EndIf  
       
       aReal[If(nDia <= 15,1,2)][If(nDia <= 15,nDia,nDia-15)] += TRAB->TRB_VALOR
    	       
	   TRAB->(DbSkip())
	EndDo
	
	If Prow()>60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf       
	
	@ Prow()+1,aPcol[3] PSay cObra  
	@ Prow(),Pcol()+1   PSay "-"
	@ Prow()  ,Pcol()+1 PSay cDesc    
    @ Prow()+1,aPcol[3] PSay Replicate("-",210)   
    @ Prow()+1,aPcol[1] PSay ""
	
	dIniMes := Ctod("01/"+MV_PAR01+"/"+MV_PAR02)
	
	Do While Day(dIniMes) <= 15
	   @ Prow(),aPcol[2+Day(dIniMes)] PSay PadC(StrZero(Day(dIniMes),2),11)+"|"
	   dIniMes++
	EndDo    
	@ Prow()+1,aPcol[3] PSay Replicate("-",210)      
	
	For nI := 1 To 2  //quinzena          	    
	    For nJ := 1 To 2    //previsto/realizado 	        
	        If nJ = 1                     
	           @ Prow()+1,aPcol[1] PSay Str(nI,1)+"a.Q"
               @ Prow(),aPcol[2]    PSay "|P|"
            Else
               @ Prow()+1,aPcol[2] PSay "|R|"
            EndIf   
	        For nK := 1 To 16     //dias	            
	            If (nI = 1.And.nK < 16).Or.(nI=2)	                    
                   @ Prow(),aPcol[nK+2] PSay Transform(If(nJ=1,aPrev[nI][nK],aReal[nI][nK]),"@RE 999,999,999")  
                   @ Prow(),Pcol()      PSay "|"                   
                   If nJ = 1 //previsto
                      aTPrev[nI][nK] += aPrev[nI][nK]
                   Else
                      aTReal[nI][nK] += aReal[nI][nK]
                   EndIf      
                EndIf                        
			Next    
	    Next                    
	    If Prow()>58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		EndIf       
	    If nI = 1                                      		   
           @ Prow()+1,aPcol[3] PSay Replicate("-",210)  
	       @ Prow()+1,aPcol[1] PSay ""
		    dIniMes := Ctod("16/"+MV_PAR01+"/"+MV_PAR02)
		    Do While Month(dIniMes) = Val(MV_PAR01)
		       @ Prow(),aPcol[2+Day(dIniMes)-15] PSay PadC(StrZero(Day(dIniMes),2),11)+"|"
		       dIniMes++
		    EndDo   
		    @ Prow()+1,aPcol[3] PSay Replicate("-",210)   
	    EndIf                                            	         
	Next                                                                                                                   
	
	
	@ Prow()+3,aPcol[1] PSay Replicate("=",220)   
	DbSelectArea("CTT")
 	DbSkip()
EndDo
If Prow()>58
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
EndIf                                      
nTotPrev := 0
nTotReal := 0                 
@ Prow()+1,aPCol[1]  PSay "Total:"
For nI := 1 To 2  //quinzena
    For nJ := 1 To 2  //previsto/realizado             
        If nJ = 1                     
           @ Prow()+1,00        PSay ""
           @ Prow(),aPcol[1]    PSay Str(nI,1)+"a.Q"
           @ Prow(),aPcol[2]    PSay "|P|"
        Else                               
           @ Prow()+1,00       PSay ""
           @ Prow()  ,aPcol[2] PSay "|R|"
        EndIf   
        
        For nK := 1 to 16  //dias
            If (nI = 1.And.nK < 16).Or.(nI=2)
               @ Prow(),aPcol[nK+2] PSay If(nJ=1,aTPrev[nI][nK],aTReal[nI][nK]) Picture "@RE 999,999,999"
               @ Prow(),Pcol()      PSay "|"                   
               If nJ = 1 //previsto
                  aSldPrRe[nI][nK] += aTPrev[nI][nK]
                  nTotPrev         += aTPrev[nI][nK]
               Else
                  aSldPrRe[nI][nK] -= aTReal[nI][nK]
                  nTotReal         -= aTReal[nI][nK]
               EndIf      
            EndIf                    
      	Next    
      	If nI = 2
      	   @ Prow(),aPcol[19] PSay If(nJ=1,nTotPrev,nTotReal) Picture "@RE 9,999,999,999"
      	EndIf   
    Next   
    If nI = 1
       @ Prow()+1,aPcol[3] PSay Replicate("-",210)   
    EndIf
Next
@ Prow()+2,aPcol[1] PSay Replicate("=",220)   

        
If Prow()>58
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
EndIf                
@ Prow()+1,aPCol[1] PSay "Saldo Previsto x Realizado:"
For nI := 1 To 2  //quinzena                
    @ Prow()+1,aPcol[1] PSay If(nI = 1,"1a.Q","2a.Q")    
    For nJ := 1 To 16 //dias
        @ Prow(),aPcol[nJ+2] PSay Transform(aSldPrRe[nI][nJ],"@RE 999,999,999")  
        @ Prow(),Pcol()    PSay "|"                   
    Next    
Next                                           
If Prow()>54
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
EndIf                                
nSldAcum := 0
@ Prow()+2,aPcol[1] PSay Replicate("=",220)   
@ Prow()+1,aPCol[1] PSay "Saldo Acumulado:"
//@ Prow()+1,aPCol[1] PSay ""
For nI := 1 To 2  //quinzena             
    @ Prow()+1,aPcol[1] PSay If(nI = 1,"1a.Q","2a.Q")
    For nJ := 1 To 16 //dias             
        nSldAcum += aSldPrRe[nI][nJ]
        @ Prow(),aPcol[nJ+2] PSay nSldAcum Picture "@RE 999,999,999"
        @ Prow(),Pcol()   PSay "|"                             
    Next
Next    
@ Prow()  ,aPcol[19] PSay nSldAcum Picture "@RE 999,999,999"    
@ Prow()+1,aPcol[1] PSay Replicate("=",220)   
        
        		
TRB->(DbCloseArea())
TRAB->(DbCloseArea())
	
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
           
Static Function ARQTRB(cMesRef,cAnoRef,cObra)
Local aCampos    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                               
aTam:=TamSX3("Z9_RECEITA")
aAdd(aCampos,{ "DT"     ,"D",8,0 } )
aAdd(aCampos,{ "VALOR"  ,"N",aTam[1],aTam[2] } )

//inicio blcoco [Mauro Nagata, Actual Trend, 01/12/2011]                         
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf
//fim blcoco [Mauro Nagata, Actual Trend, 01/12/2011]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)
Index On Dtos(DT) to (cArqTrab)

DbSelectArea("TRB")
DbGoTop()

cAliasSZ9 := "RF013TRB"
aStruSZ9  := SZ9->(dbStruct())           

cQuery := "         SELECT Z9_RECEITA AS VALOR, Z9_DATA AS DT"
cQuery += CRLF + "  FROM "+ RetSQLName("SZ9") +" SZ9 "
cQuery += CRLF + "  WHERE SZ9.D_E_L_E_T_ = ' ' "
cQuery += CRLF + "        AND Z9_FILIAL = '"+xFilial("SZ9")+"' "
cQuery += CRLF + "        AND Z9_MES    = '"+cMesRef+"' "
cQuery += CRLF + "        AND Z9_ANO    = '"+cAnoRef+"' "                     
cQuery += CRLF + "        AND Z9_OBRA   = '"+cObra+"' "
cQuery += CRLF + "        AND Z9_RECEITA <> 0 "

cQuery += CRLF + "  ORDER BY Z9_DATA "
    
Memowrite("RFIN013.SQL",cQuery)

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ9,.T.,.T.)

For nX := 1 To Len(aStruSZ9)
	If ( aStruSZ9[nX][2] <> "C" )
		TcSetField(cAliasSZ9,aStruSZ9[nX][1],aStruSZ9[nX][2],aStruSZ9[nX][3],aStruSZ9[nX][4])
	EndIf
Next nX

TcSetField(cAliasSZ9,"VALOR","N",14,2)
TcSetField(cAliasSZ9,"DT","D",8,0)    

DbSelectArea(cAliasSZ9)
DbGoTop()
Do While !Eof()
	                                
	If !Empty((cAliasSZ9)->DT)
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
	
		TRB->DT	 	:= (cAliasSZ9)->DT
		TRB->VALOR 	:= (cAliasSZ9)->VALOR
	EndIf
		
	DbSelectArea(cAliasSZ9)
	DbSkip()
EndDo                                                                                          	

(cAliasSZ9)->(DbCloseArea())

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

Aadd(aPerg, {"01","Mes Ref. ? ","?","?","mv_ch1","C",2,"G","mv_par01","","","","","","","",0,""})
Aadd(aPerg, {"02","Ano Ref. ? ","?","?","mv_ch2","C",4,"G","mv_par02","","","","","","","",0,""})
Aadd(aPerg, {"03","Da Obra  ? ","?","?","mv_ch3","C",9,"G","mv_par03","","","","","","","",0,""})
Aadd(aPerg, {"04","Ate Obra ? ","?","?","mv_ch4","C",9,"G","mv_par04","","","","","","","",0,""})

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
		MsUnlock()
	EndIf
Next

DbSelectArea(cAlias)

Return
      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN013   ºAutor  ³Mauro Nagata        º Data ³  01/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o arquivo temporario para impressao do relatorio.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//User Function RFIN013a(oObj, c_Obra)
User Function RFIN013a(c_Obra)

Local c_query   := ''
Local c_EOL		:= chr(13)+chr(10)
Local a_fatdir	:= {}     

Private cNomeArq

//oObj:SetRegua1(12)
                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquivo de trabalho temporario                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oObj:IncRegua1("Criando arquivo de trabalho")
aStruct := {}
AAdd( aStruct, { "TRB_EMISSA", "D", 08, 0 } )
AAdd( aStruct, { "TRB_VALOR"  , "N", 14, 2 } )

If Select("TRAB") > 0
	DbSelectArea("TRAB")
	DbCloseArea()
EndIf
cArqTrab := CriaTrab( aStruct, .T. )
dbUseArea(.T.,,cArqTrab,"TRAB",.F.,.F.)
Index On Dtos(TRB_EMISSA) to (cArqTrab)
TRAB->(DbSetOrder(1))
dbSelectArea("TRAB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para buscar informaceos do contas a receber                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oObj:IncRegua1("Sel. Registros CR")
c_query := ''
c_query += "SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VALOR, E1_VENCREA, " + c_EOL
c_query += "       sum(E1_SALDO) as E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_FILIAL, E1_DECRESC " + c_EOL
c_query += "FROM (" + c_EOL
c_query += "      SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_BAIXA, E1_EMISSAO, E1_VALOR as VALORI, " + c_EOL
c_query += "             (E1_SALDO*isnull(EZ_PERC,1)*isnull(EV_PERC,1)) as E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, " + c_EOL
c_query += "             E1_FILIAL, isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC, " + c_EOL
c_query += "             E1_DECRESC " + c_EOL
c_query += "      FROM SE1010 " + c_EOL
c_query += "      LEFT JOIN SEV010" + c_EOL
c_query += "           ON EV_FILIAL   = E1_FILIAL" + c_EOL
c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "      LEFT JOIN SEZ010" + c_EOL
c_query += "           ON EZ_FILIAL   = EV_FILIAL" + c_EOL
c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL   
c_query += "      WHERE SE1010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "              and       E1_SALDO  = 0	" + c_EOL
c_query += "          and       SUBSTRING(E1_EMISSAO,1,6) <= '"+MV_PAR02+MV_PAR01+"'" + c_EOL
c_query += "      ) A " + c_EOL
c_query += "WHERE E1_XCC = '"+c_Obra+"'" + c_EOL
c_query += "GROUP BY E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA, E1_VALOR, E1_DECRESC " + c_EOL

c_query += "UNION ALL " + c_EOL

c_query += "SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VALOR, E1_VENCREA, " + c_EOL
c_query += "       SUM(E1_SALDO) as E1_SALDO, E1_EMISSAO, E1_BAIXA, E1_FILIAL, E1_DECRESC " + c_EOL
c_query += "FROM (" + c_EOL
c_query += "      SELECT E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_BAIXA, E1_VALOR as VALORI, " + c_EOL
c_query += "             (E1_SALDO*isnull(EZ_PERC,1)*isnull(EV_PERC,1)) as E1_SALDO, E1_VENCREA, isnull(EV_NATUREZ, E1_NATUREZ) as E1_NATUREZ, EV_PERC, E1_FILIAL, " + c_EOL
c_query += "             isnull(EZ_CCUSTO, E1_XCC) as E1_XCC, isnull(EZ_VALOR,isnull(EV_VALOR, E1_VALOR)) as E1_VALOR, EZ_PERC, " + c_EOL
c_query += "             E1_DECRESC " + c_EOL
c_query += "      FROM SE1010 " + c_EOL
c_query += "      LEFT JOIN SEV010" + c_EOL
c_query += "           ON EV_FILIAL   = E1_FILIAL" + c_EOL
c_query += "              and       EV_PREFIXO  = E1_PREFIXO" + c_EOL
c_query += "              and       EV_NUM      = E1_NUM" + c_EOL
c_query += "              and       EV_PARCELA  = E1_PARCELA" + c_EOL
c_query += "              and       EV_TIPO     = E1_TIPO" + c_EOL
c_query += "              and       EV_CLIFOR   = E1_CLIENTE" + c_EOL
c_query += "              and       EV_LOJA     = E1_LOJA" + c_EOL
c_query += "              and       SEV010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "      LEFT JOIN SEZ010" + c_EOL
c_query += "           ON EZ_FILIAL   = EV_FILIAL" + c_EOL
c_query += "              and       EZ_PREFIXO  = EV_PREFIXO" + c_EOL
c_query += "              and       EZ_NUM      = EV_NUM" + c_EOL
c_query += "              and       EZ_PARCELA  = EV_PARCELA" + c_EOL
c_query += "              and       EZ_TIPO     = EV_TIPO" + c_EOL
c_query += "              and       EZ_CLIFOR   = EV_CLIFOR" + c_EOL
c_query += "              and       EZ_LOJA     = EV_LOJA" + c_EOL
c_query += "              and       EZ_NATUREZ  = EV_NATUREZ" + c_EOL
c_query += "              and       SEZ010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "      WHERE SE1010.D_E_L_E_T_ <> '*'" + c_EOL
c_query += "            AND E1_SALDO  <> 0	" + c_EOL
c_query += "        AND SUBSTRING(E1_EMISSAO,1,6) <= '"+MV_PAR02+MV_PAR01+"'" + c_EOL
c_query += "     ) A" + c_EOL
c_query += "WHERE E1_XCC = '"+c_Obra+"'" + c_EOL
c_Query += "      AND E1_NATUREZ NOT IN ('INSS      ','ISS       ','PIS       ','COFINS    ','CSLL      ','IRF       ')"+" "+ c_EOL
c_query += "GROUP BY  E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_XCC, E1_NATUREZ, E1_VENCREA, E1_EMISSAO, E1_BAIXA, E1_VALOR, E1_DECRESC " + c_EOL
c_query += "ORDER BY  E1_NATUREZ, E1_VENCREA " + c_EOL

memoWrite('RFIN013_VND.sql', c_query)

If Select("QRX") > 0
	DbSelectArea("QRX")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "QRX"
TcSetField("QRX","E1_EMISSAO","D",8,0)           
/*
n_tregcr := 0
QRX->(DbGotop())
While QRX->(!EOF())
	n_tregcr++
	QRX->(DbSkip())
EndDo
*/
         
//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do CONTAS A RECEBER                                              ³*
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************
//oObj:IncRegua1("Proc. Registros CR")
//oObj:SetRegua2(n_tregcr)

QRX->(DbGoTop())

nVlrImpAA := 0
nVlrImp	  := 0  //valores dos impostos
a_rdados  := {}

Do While QRX->(!EOF())
	        
    DbSelectArea("SE1")
    DbSeek(QRX->E1_FILIAL+QRX->E1_PREFIXO+QRX->E1_NUM+QRX->E1_PARCELA+QRX->E1_TIPO)
    U_FC040()        
	       
    nVlrRec := 0
    dEmis   := SE1->E1_EMISSAO
	       
    DbSelectArea("cNomeArq")
    DbGoTop()
    Do While !Eof()        
//       IndRegua()
       If cNomeArq->MOTIVO = "CMP"		          
          aAreaCMP := GetArea()
          cChave := SubStr(cNomeArq->DOCUMENTO,1,3) // Prefixo
          cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO, 4,6), substr(cNomeArq->DOCUMENTO, 5,9))//Numero
          cChave += Iif(len(alltrim(cNomeArq->DOCUMENTO))<= 15, substr(cNomeArq->DOCUMENTO,10,1), substr(cNomeArq->DOCUMENTO,15,2))//Parcela
          cChave += 'RA'
                     
          DbSelectArea('SE1')
          DbSetOrder(1) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
          If DbSeek(cNomeArq->Filial+cChave)   
             dEmis := SE1->E1_EMISSAO
          Else 
             dEmis := QRX->E1_EMISSAO
          EndIf
	              
	      nVlrRec := cNomeArq->VALORRECEB
       EndIf                             
       DbSelectArea("cNomeArq")  
       DbSkip()
    EndDo
    If Select("cNomeArq") > 0
	   DbSelectArea("cNomeArq")
	   Use
	   Ferase(cNomearq+GetDBExtension())
	   Ferase(cNomeArq+OrdBagExt())
	EndIf
	          
	If Substr(Dtos(dEmis),1,6)=MV_PAR02+MV_PAR01
		If TRAB->(DbSeek(Dtos(dEmis)))
			RecLock('TRAB', .F.)
		Else
			RecLock('TRAB', .T.)     
			TRAB->TRB_EMISSA := dEmis
		EndIf                  	         
		TRAB->TRB_VALOR += QRX->E1_VALOR - QRX->E1_DECRESC - If(dEmis != (QRX->E1_EMISSAO),nVlrRec,0)
		TRAB->(MsUnLock())
	EndIf	
		   	
	QRX->(DbSkip())
EndDo
QRX->(DbCloseArea())


//********************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//³Processa as informacoes do faturamento direto                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
//********************************************************************************************

c_query := " SELECT Sum(D1_TOTAL+(C7_VALIPI*(D1_QUANT/C7_QUANT))+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC) as VALOR, C7_DATPRF, D1_TES,"

c_query += "        Sum((C7_QUANT-C7_QUJE)*C7_PRECO + (((C7_QUANT-C7_QUJE)/C7_QUANT)*D1_VALIPI * (D1_QUANT/C7_QUANT))) as VLRAB "
c_query += " FROM SC7010 C7 "
c_query += "      LEFT OUTER JOIN SD1010 D1 "
c_query += "           ON D1.D_E_L_E_T_='' "
c_query += "              AND D1_PEDIDO = C7_NUM "
c_query += "              AND D1_ITEMPC = C7_ITEM "
c_query += "              AND D1_COD    = C7_PRODUTO "
c_query += "              AND D1_TES    <> '' "
c_query += "      INNER JOIN SB1010 B1 "
c_query += "            ON B1.D_E_L_E_T_='' "
c_query += "               AND B1_COD = C7_PRODUTO "
c_query += "      INNER JOIN CTT010 CTT "
c_query += "            ON CTT.D_E_L_E_T_='' "
c_query += "               AND CTT_XLFATD = 'S' "
c_query += "               AND CTT_CUSTO = C7_XCCFTD "
c_query += " WHERE C7_XCCFTD = '"+c_Obra+"'"
c_query += "       AND       SUBSTRING(C7_DATPRF,1,6) = '"+MV_PAR02+MV_PAR01+"'" + c_EOL
c_query += "       AND C7_XCCFTD <> '' "
c_query += "       AND C7_XFATD = 'S' "
c_query += "       AND C7.D_E_L_E_T_ = '' "
c_query += " GROUP BY C7_DATPRF, D1_TES"

MemoWrite("RFIN013_FTD",c_query)

If Select("QRX") > 0
	DbSelectArea("QRX")
	DbCloseArea()
EndIf
TcQuery c_Query New Alias "QRX"

TcSetField("QRX","C7_DATPRF","D",8,0)   

Do While QRX->(!EOF())
   If TRAB->(DbSeek(Dtos(QRX->C7_DATPRF)))
	  RecLock('TRAB', .F.)
   Else
      RecLock('TRAB', .T.)
      TRAB->TRB_EMISSA := QRX->C7_DATPRF
   EndIf   	  
   TRAB->TRB_VALOR += QRX->VALOR
   TRAB->(MsUnLock())
   
   QRX->(DbSkip())
EndDo                    

QRX->(DbCloseArea())