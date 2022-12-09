#INCLUDE "rwmake.ch" 
#INCLUDE "TOPCONN.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RLORC     º Autor ³ Elvis Kinuta       º Data ³  10/01/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO Pedido de Revenda                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RLFATRV()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2	:= "de Pedido Revenda por cliente "
Local cDesc3	:= ""
Local cPict     := ""
Local titulo    := "Pedido Revenda Cozil Equipamentos."
Local Cabec1    := ""
Local Cabec2    := ""
Local imprime   := .T.
Local aOrd 		:= {}
Private nLin         := 80
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "M"
Private nomeprog     := "RLFATRV" // Coloque aqui o nome do programa para impressao no cabecalho.
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "XRLFATRV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "RLFATRV"
Private cCodTab		 := ""
Private cFornece 	 := ""  
Private cString 	 := "SC5"   
Private teste 	 	 := 1

ValidPerg()
IF ! Pergunte(cPerg,.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

	SetDefault(aReturn,cString,,,"M",1)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/01/06   º±±
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

Local cQuery
Local cChave := ""
Local nValTot := 0

CABEC1 := ""
CABEC2 := ""

		cQuery := " SELECT *" 
		cQuery += " FROM "+retsqlname("SC6")+" SC6 ,"+retsqlname("SC5")+" SC5 "
		cQuery += " WHERE SC5.C5_FILIAL  = '"+XFILIAL("SC5")+"'"
		cQuery += " AND   SC5.C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
		cQuery += " AND   SC5.C5_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'"
		//cQuery += " AND   SC5.C5_CLIENTE = '"+MV_PAR05+"'"
		cQuery += " AND   SC5.D_E_L_E_T_ = ' '"
		cQuery += " AND   SC6.C6_FILIAL = '"+XFILIAL("SC6")+"'"
		cQuery += " AND   SC6.C6_CLI = SC5.C5_CLIENTE"
		cQuery += " AND   SC6.C6_NUM = SC5.C5_NUM
		cQuery += " AND   SC6.C6_LOJA    = SC5.C5_LOJACLI"
		cQuery += " AND   SC6.D_E_L_E_T_ = ' '" 
		cQuery += " AND   SC6.C6_XTPPROD = 'RV'" // para trazer somente itens que sejam revenda
		cQuery := ChangeQuery(cQuery)
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
	
	dbSelectArea("TMP")
	TMP->(DbGotop())
	                   
SetRegua(Select("TMP"))

If TMP->(Eof())
   MsgInfo("Nao existem registros com o filtro escolhido!")
   set filter to
   dbGotop()
   TMP->(DbCloseArea())
   Return
EndIf

DbSelectArea("SC5")
DbSetOrder(1)//C5_FILIAL+C5_NUM+C5_CLIENTE+C5_LOJACLI
DbSeek(xFilial("SC5")+TMP->C5_NUM+TMP->C5_CLIENTE+TMP->C5_LOJACLI)

DbSelectArea("SC6")
DbSetOrder(2)//C6_FILIAL+C6_CLI+C6_LOJA+C6_NUM+C6_ITEM+C6_PRODUTO
DbSeek(xFilial("SC6")+TMP->C6_CLI+TMP->C6_LOJA+TMP->C6_NUM)


nLin := 1
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
nLin := 6

While TMP->(!EOF())
	
	If nLin > 55 
		nLin := 1
  	  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
		nLin := 6

	 	@ nLin,010 PSAY SM0->M0_NOMECOM
	  	nLin++               

	   	@ nLin,010 PSAY "CNPJ...:"+SM0->M0_CGC+"   "+"I.E...:"+SM0->M0_INSC
	    nLin++

	    @ nLin,010 PSAY SM0->M0_ENDCOB
	    nLin++                                                                           

	    @ nLin,010 PSAY "CEP."+Substr(SM0->M0_CEPCOB,1,5)+"-"+Substr(SM0->M0_CEPCOB,6,8)// "@R 99999-999")
	    nLin++

	    @ nLin,010 PSAY "TEL. (+55 11)"+Substr(SM0->M0_TEL,1,4)+"-"+Substr(SM0->M0_TEL,5,8)// "@R 9999-9999")
	    nLin++

	    @ nLin,010 PSAY "WWW.COZIL.COM.BR" 
		nLin := nLin + 2

		@ nLin,010 PSAY "Pedido No:.. "+TMP->C5_NUM
		nLin++

		@ nLin,010 PSAY "====================="
		nLin := nLin + 2
        
		cContat := Posicione("SA1",1,xFilial("SA1")+TMP->C5_CLIENT,"A1_CONTATO")

		@ nLin,010 	PSAY "CLIENTE  :" 
		@ nLin,020 	PSAY TMP->C5_CLIENT
		@ nLin,026 	PSAY " / " + cNomCli
		nLin := nLin + 1       

		@ nLin,010 	PSAY "CONTATO  :" 
		@ nLin,020 	PSAY cContat
		nLin := nLin + 2
			
		@ nLin,010       	PSAY "COD. PRODUTO"
		@ nLin,PCOL()+7 	PSAY "DESCRICAO DO PRODUTO"
		@ nLin,98        	PSAY "QUANT."
		@ nLin,PCOL()+1  	PSAY "PREÇO UNIT."
		@ nLin,PCOL()+4  	PSAY "VALOR TOTAL"     
		nLin := nLin + 1

		@ nLin,010       	PSAY "___________"              // CODIGO
		@ nLin,PCOL()+7  	PSAY "_____________________"    // DESCRICAO
		@ nLin,98        	PSAY "_____"                   // QUANTIDADE
		@ nLin,PCOL()+2  	PSAY "__________"              // PRECO UNITARIO
		@ nLin,PCOL()+5  	PSAY "___________"              // VALOR TOTAL
	 	nLin := nLin + 1              
	Endif  		 
	                       
      		
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		TMP->(DbCloseArea())
		Exit
	Endif
 	
 	cNomCli := Posicione("SA1",1,xFilial("SA1")+TMP->C5_CLIENT,"A1_NOME")                  
	cContat := Posicione("SA1",1,xFilial("SA1")+TMP->C5_CLIENT,"A1_CONTATO")
	                      
	If TMP->C5_CLIENT+TMP->C5_LOJACLI <> cChave
            
		cChave := TMP->C5_CLIENT+TMP->C5_LOJACLI
	 	
	  	nLin++               
        
		@ nLin,010 PSAY "Pedido No:.. "+TMP->C5_NUM
		nLin := nLin + 1
	   	
		@ nLin,010 PSAY "CLIENTE  :" 
		@ nLin,020 PSAY TMP->C5_CLIENT
		@ nLin,026 PSAY " / " + cNomCli
		nLin := nLin + 2       

					
		@ nLin,010       	PSAY "COD. PRODUTO"
		@ nLin,PCOL()+7  	PSAY "DESCRICAO DO PRODUTO"
		@ nLin,98        	PSAY "QUANT."
		@ nLin,PCOL()+1  	PSAY "PREÇO UNIT."
		@ nLin,PCOL()+4  	PSAY "VALOR TOTAL"     
		nLin := nLin + 1

		@ nLin,010       	PSAY "___________"              // CODIGO
		@ nLin,PCOL()+7  	PSAY "_____________________"    // DESCRICAO
		@ nLin,98        	PSAY "_____"                    // QUANTIDADE
		@ nLin,PCOL()+2  	PSAY "__________"               // PRECO UNITARIO
		@ nLin,PCOL()+5  	PSAY "___________"              // VALOR TOTAL
	 	nLin := nLin + 1              
	        
  	EndIf                 
	
	
	@ nLin,010       	PSAY TMP->C6_PRODUTO
	@ nLin,PCOL()+ 3 	PSAY TMP->C6_DESCRI 
 	@ nLin,99        	PSAY TMP->C6_QTDVEN PICTURE "@EZ 9999" 
  	@ nLin,PCOL()+ 2 	PSAY TMP->C6_PRCVEN PICTURE "@EZ 999,999.99"
    @ nLin,PCOL()+ 6 	PSAY TMP->C6_VALOR  PICTURE "@EZ 999,999.99"

   // Tratamento para campo Memo
    nTamLinha := 45
	lWordWrap := .t.

cMemo     := Posicione("SC6",1,xFilial("SC6")+TMP->C6_NUM+TMP->C6_ITEM+TMP->C6_PRODUTO,"C6_XESPEC")	
nMemCount := MlCount( cMemo, nTamLinha,,lWordWrap )
               
If !Empty( nMemCount) 

   For nLinha := 1 To nMemCount

      cLinha := MemoLine( cMemo, nTamLinha, nLinha )

	If ( nLin > 60 )     
        nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
        nLin ++
	EndIf
nLin++
      @ nLin,28 PSAY cLinha
     

   Next nLinha

EndIf
    
    
   	nLin := nLin + 1
	nValTot += TMP->C6_VALOR
	nLin := nLin + 1  			  	
  	
  	TMP->(dbSkip())
  	

EndDo

DbSelectArea("TMP")
TMP->(DbGotop())      

nLin := nLin + 3
If nLin > 55 
	nLin := 1
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
	nLin := 6
Endif            
nLin := nLin + 3
@ nLin,010 PSAY "__________________________________________________________________________________________________________________________"
nLin := nLin + 1
@ nLin,010 PSAY "VALOR TOTAL DOS EQUIPAMENTOS:" 
@ nLin,117 PSAY "R$"
@ nLin,119  PSAY +nValTot PICTURE "@EZ 9,999,999.99"
nLin := nLin + 1
@ nLin,010 PSAY "__________________________________________________________________________________________________________________________"
If nLin > 55 
	nLin := 1
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
	nLin := 6
Endif            

nLin := nLin + 2
//@ nLin,010 PSAY "Observação....:"
//@ nLin,029 PSAY SC5->C5_COTCLI //CRIAR ESTE CAMPO E COLOCAR NO LUGAR DO QUE ESTA ELVIS C5_OBS1
//nLin ++
                     
			
//@ nlin,01 PSAY __PrtfatLine() // IMPRIME TRAÇO 
//nLin ++
 			
cDecE4 	:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")              
cA1EST	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJACLI,"A1_EST")                  
nBICM	:= Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_BASEICM")                  
nBIPI	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_IPI")
			
nLin ++
If nLin > 55 
	nLin := 1
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
	nLin := 6
Endif            



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()                             
	
	SET PRINTER TO
	OurSpool(wnrel)
Endif
                   
CHKFILE("TMP")

MS_FLUSH()

TMP->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALIDPERG ³ Autor ³ Thiago Menegocci      ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica as perguntas incluindo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local aRegs   := {}

//Estrutura {Grupo	/Ordem	/Pergunta			/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid	/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01	/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
Aadd( aRegs,{ cPerg, "01","Numero Pedido      ","                 ","                 ","mv_ch1    ","C    ", 6        ,0          ,0      ,"G"    ,;
                      "                                                            ",;
                      "mv_par01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","          ","                                                            ","     ","   " } )
Aadd( aRegs,{ cPerg, "02","Numero Orcamento Ate ","                              ","                              ","mv_ch2","C", 6,0,0,"G",;
                      "                                                            ",;
                      "mv_par02       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","          ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "03","Emissao de                      ","                              ","                              ","mv_ch3","D", 8,0,0,"G",;
                      "                                                            ",;
                      "mv_par03       ","               ","               ","               ","'01/01/08'                                                  ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","          ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "04","Emissao ate                     ","                              ","                              ","mv_ch4","D", 8,0,0,"G",;
                      "                                                            ",;
                      "mv_par04       ","               ","               ","               ","'31/12/08'                                                  ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","          ","                                                            ","      ","   " } )
//Aadd( aRegs,{ cPerg, "05","Cliente                         ","                              ","                              ","mv_ch5","C", 6,0,0,"G",;
//                      "                                                            ",;
//                      "mv_par05       ","               ","               ","               ","'zzzzzz'                                                  ","               ","               ","               ","               ","                                                            ",;
//                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
//                      "               ","               ","               ","          ","                                                            ","SA1  ","   " } )                      

lValidPerg( aRegs )

Return
