#INCLUDE "PROTHEUS.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Fileio.ch"

# DEFINE BLOCO 400

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuaOrc   บ Autor ณ Rafael Marin       บ Data ณ  29/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza o cadastro de itens de orcamento com base na      บฑฑ
ฑฑบ          ณ leitura de um arquivo texto                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

/*/
User Function AtuaOrc

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private ArqProds

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 50,1 TO 420,410 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 180,190
@ 10,018  Say " Este programa ira ler o conteudo de um arquivo texto, "
@ 18,018  Say " inserindo todos os itens de seu conte๚do dentro do    "
@ 26,018  Say " or็amento ativo                                       "
@ 34,018  Say " Sequencia de campos:                                  "
@ 42,018  Say " Coluna (A) --> Codigo Prod Protheus                   "
@ 50,018  Say " Coluna (B) --> Quantidade                             "
@ 58,018  Say " Coluna (C) --> R$ Unitario                            "
@ 66,018  Say " Coluna (D) --> Prazo                                  "
@ 74,018  Say " Coluna (E) --> Tecnico                                "
@ 82,018  Say " Coluna (F) --> Obs Item                               "
@ 90,018  Say " Coluna (G) --> Referencia do Cliente                  "
@ 98,018  Say " Coluna (H) --> Pedido do Cliente                      "
@ 106,018 Say " Coluna (I) --> Item do Cliente                        " 
@ 114,018 say " Coluna (J) --> IPI									  "
@ 130,50  Get ArqProds                       Size 100,10 when.F.
@ 130,145 BUTTON "..."                       SIZE 10,10 ACTION ArqProds := AbreArq()
@ 160,128 BMPBUTTON TYPE 01 ACTION U_OkLeTxt()
@ 160,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ mp8 IDE            บ Data ณ  29/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cArqTxt := ArqProds
Private nHdl    := fOpen(ArqProds,68)
Private nLog    := fCreate("c:\Import.log")
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| U_RunCont() },"Processando...")
Return       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  29/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RunCont
                           
Local aArea		:= GetArea()
Local nTamFile, cBuffer, nBtLidos, cCod
Local nIni, nFim, nPos, nSize
Local lPode:=.T.
Local aOrc := array(10)
Local nRegLido:=1
//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto lido  :                                บ
//ฬออออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Descri็ใo                                      บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ CK_PRODUTO     ณ Codigo do Produto                              บnPos = 1
//บ CK_NUMREF      ณ Referencia do Produto no Cliente               บnPos = 2
//บ CK_QTDVEN      ณ Quantidade do Produto                          บnPos = 3
//บ CK_ITEMCLI     ณ Numero do Item no Cliente                      บnPos = 4
//บ CK_PROJETO     ณ Referencia do Cliente                          บnPos = 5
//บ CK_OBS         ณ Observacao                                     บnPos = 6
//บ CK_PRCVEN      ณ Valor Unitario                                 บnPos = 7
//ศออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออผ
/* 
@ 42,018  Say " Coluna (01) --> Codigo Prod Protheus                   "
@ 50,018  Say " Coluna (02) --> Quantidade                             "
@ 58,018  Say " Coluna (03) --> R$ Unitario                            "
@ 66,018  Say " Coluna (04) --> Prazo                                  "
@ 74,018  Say " Coluna (05) --> Tecnico                                "
@ 74,018  Say " Coluna (06) --> Obs Item                               "
@ 82,018  Say " Coluna (07) --> Referencia do Cliente                  "
@ 90,018  Say " Coluna (08) --> Pedido do Cliente                      "
@ 98,018  Say " Coluna (09) --> Item do Cliente                        " 
@ 106,018 say " Coluna (10) --> IPI									  "
*/

nBtLidos := 0
nTamFile := FSEEK(nHdl, 0, FS_END) //Troquei funcao de tamanho do arquivo
fSeek(nHdl,0,0) //resetando posicao do ponteiro                                          
ProcRegua(nTamFile) // Numero de registros a processar

               
While nBtLidos < (nTamFile -2)            //Caracteres de fim de arquivo                             
 	//Pega Linha a linha do arquivo  
    cBuffer  := Space(BLOCO) // Variavel para criacao da linha do registro para leitura
    fRead(nHdl,@cBuffer,BLOCO)
	
 	for nSize:=1 to len(cBuffer)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Incrementa a regua                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IncProc()
 	
 	  	if (Substr(cBuffer,nSize,1)=Chr(13))	    
   	      fSeek(nHdl, nBtLidos) 
   	      nSize	++
 	      exit                  	    
 	  	EndIf    
 	End             	 	 	
 	
 	fRead(nHdl,@cBuffer, nSize)  	  
	nBtLidos := nBtLidos + nSize
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava os campos obtendo os valores da linha lida do arquivo texto.  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//Valores Iniciais para busca dos campos
	      
	//Controles de quebra por ponto e virgula 
	nIni := 1 //Posicao inicial na linha
	nFim := 1 //Posicao Final na linha                          
	nPos := 1 //Campo do Vetor
	
	While .T.                      
      lPode:=.t.
      cCod:=""
      If (Substr(cBuffer, nFim, 1) != ';') .And. (Substr(cBuffer, nFim, 1) != Chr(13))  
        nFim ++
      else
        If (Substr(cBuffer, nIni, nFim-nIni)!=Chr(13)) .And. (Substr(cBuffer, nIni, nFim-nIni)!=";") //Se Campo cheio
        	aOrc[nPos] := Substr(cBuffer, nIni, nFim-nIni) //Alimenta
        else              
            aOrc[nPos] := ""      		                   //senao deixa em branco
        EndIf

        IF (Substr(cBuffer, nFim, 1)==Chr(13)) //Fim da Linha sai do laco
		  exit                               
		Endif

		nPos ++		
		nFim ++
		nIni  := nFim		  
      Endif        
    End
    cCod:=""
    FOR xEsp:=1 to len(aOrc[1])
     IF SUBSTRING(aOrc[1],xEsp,1)=" " 
     else
      cCod:=cCod+SUBSTRING(aOrc[1],xEsp,1)
     endif   
    next
    if Len(cCod)>0 
      aOrc[1]:=cCod
    endif  
    dbSelectArea("SB1")
	dbSetOrder(1)
 	if dbSeek(xFilial()+aOrc[1])     
	Else              
			MsgAlert("Registro:["+str(nRegLido)+"]Produto "+ aOrc[1] +" inexistente.... Incluindo!")	
			dbSelectArea("SBP")
			DBGOTOP()
			cCod:=A093MontaCod(aOrc[1],.T.)
			if len(trim(cCod))>0 
			  aOrc[1]:=cCod
			  A093VldCod(cCod,.T.)
			else
			  A093VldCod(aOrc[1],.T.)
			endif
			dbSelectArea("SB1")
			dbSetOrder(1)
            IF dbSeek(xFilial()+aOrc[1])
            else
              MsgAlert("Registro:["+str(nRegLido)+"]Produto "+ aOrc[1] +" Impossivel de ser incluido!")	
              lpode:=.f.
            endif      
	EndIf	                     	
	If (lPode=.t.)
  	    dbSelectArea("TMP1")
 		
 		TMP1->(dbGoBottom())
  	    IF (Empty(TMP1->CK_PRODUTO)) //Se planilha vazia, edita a primeira linha (em branco)
    	    RecLock("TMP1", .F.)
   		ELSE
    	    RecLock("TMP1", .T.)
    	EndIf
    	      	              
    	//PREENCHE DADOS VINDOS DO ARQUIVO
	   /* 
       @ 42,018  Say " Coluna (01) --> Codigo Prod Protheus                   "
       @ 50,018  Say " Coluna (02) --> Quantidade                             "
       @ 58,018  Say " Coluna (03) --> R$ Unitario                            "
       @ 66,018  Say " Coluna (04) --> Prazo                                  "
       @ 74,018  Say " Coluna (05) --> Tecnico                                "
       @ 74,018  Say " Coluna (06) --> Obs Item                               "
       @ 82,018  Say " Coluna (07) --> Referencia do Cliente                  "
       @ 90,018  Say " Coluna (08) --> Pedido do Cliente                      "
       @ 98,018  Say " Coluna (09) --> Item do Cliente                        " 
       @ 106,018 say " Coluna (10) --> IPI									  "

*/
		 	      	    
		TMP1->CK_ITEM    := strzero(TMP1->(RecNo()),2)
  	    TMP1->CK_PRODUTO := aOrc[1] 
  	    TMP1->CK_QTDVEN  := U_HCCVAL(aOrc[2])
  		TMP1->CK_PRCVEN  := U_HCCVAL(aOrc[3])
  	    TMP1->CK_XDIAS   := val(aOrc[4])
  	    TMP1->CK_DSCTEC  := u_matatec(aOrc[1]) 
  	    TMP1->CK_OBS     := aOrc[6]      	    
  	    TMP1->CK_NUMREF  := aOrc[7]
  	    TMP1->CK_PV      := aOrc[8]
        TMP1->CK_ITEMCLI := aOrc[9]                       
        
        TMP1->CK_VALOR   := TMP1->CK_QTDVEN*TMP1->CK_PRCVEN
        TMP1->CK_ENTREG  := DATE() + val(aOrc[4])
        TMP1->CK_TABPRC	 := "INF"
        TMP1->CK_FILENT  :=SM0->M0_CODFIL
        TMP1->CK_FILVEN  :=SM0->M0_CODFIL 
        TMP1->CK_FONTE   := "000000"
        TMP1->CK_DTVALID := DATE()+30
        //PREENCHE DADOS VINDOS DE PRODUTOS (SB1)
		If (FieldPos("CK_UM") > 0 )
			TMP1->CK_UM       := SB1->B1_UM
		EndIf
		If (FieldPos("CK_TES") > 0 )
			If (!Empty(RetFldProd(SB1->B1_COD,"B1_TS")))
				TMP1->CK_TES      := RetFldProd(SB1->B1_COD,"B1_TS")
			Else
				TMP1->CK_TES      := A415TesPad()
			EndIf
		EndIf
		if Posicione("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_IPI")="S"
		  TMP1->CK_IPI=5.00
		ELSE
		  TMP1->CK_IPI=0
		ENDIF    
		If (FieldPos("CK_LOCAL") > 0 )
			TMP1->CK_LOCAL    := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		EndIf
		If (FieldPos("CK_COMIS1") > 0 )
			TMP1->CK_COMIS1   := SB1->B1_COMIS
		EndIf
		If (FieldPos("CK_DESCRI") > 0 )
			TMP1->CK_DESCRI   := SB1->B1_DESC
		EndIf
		If (FieldPos("CK_CONTRAT") > 0 )
			TMP1->CK_CONTRAT := ""
		EndIf
		If (FieldPos("CK_ITEMCON") > 0 )
			TMP1->CK_ITEMCON := ""
		EndIf        
        
        MsUnlock("TMP1")
      Else 
        MsgAlert("Tamanho do registro iniciado em "+ aOrc[1] +" invแlido !")		  
      EndIf
      nRegLido++
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

FClose(nLog)
fClose(nHdl)                
RestArea(aArea)
Close(oLeTxt)               
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ AbreArq  บ Autor ณ AP5 IDE            บ Data ณ  29/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Abre janela para selecao do arquivo a ser importado,       บฑฑ
ฑฑบ          ณ retornando seu path                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static function AbreArq()
cArqTxt:= cGetFile("*.csv|*.csv","Importacao de Or็amento",1,"C:\",.F.,GETF_LOCALHARD) //"Selecione um arquivo"
//("*.csv|*.csv","Importacao de Or็amento",0,"C:\",.F.,0)
If Empty(cArqTxt)
	Return .F.
EndIf
cArqTxt = ALLTRIM(cArqTxt)
return (cArqTxt)   