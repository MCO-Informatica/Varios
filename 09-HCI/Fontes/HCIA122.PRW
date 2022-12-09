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
User Function AtuaEnt

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
@ 26,018  Say " da Compra ativa                                       "
@ 34,018  Say " Sequencia de campos:                                  "
@ 42,018  Say " Coluna (A) --> Codigo Prod Protheus                   "
@ 50,018  Say " Coluna (B) --> Quantidade                             "
@ 58,018  Say " Coluna (C) --> R$ Unitario                            "
@ 130,50  Get ArqProds                       Size 100,10 when.F.
@ 130,145 BUTTON "..."                       SIZE 10,10 ACTION ArqProds := AbreArq()
@ 160,128 BMPBUTTON TYPE 01 ACTION U_OkENTxt()
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

User Function OkENTxt

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
Processa({|| U_RuncIN() },"Processando...")
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

User Function RuncIN
                           
Local aArea		:= GetArea()
Local nTamFile, cBuffer, nBtLidos, cCod
Local nIni, nFim, nPos, nSize
Local lPode:=.T.
Local aOrc := array(10)                    
Local cItSD1:="0000" 
Local nAcols 
Local nUnit
Local nQuant
Local nUsado
Local cTes

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto lido  :                                บ
//ฬออออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Descri็ใo                                      บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ CK_PRODUTO     ณ Codigo do Produto                              บnPos = 1
//บ CK_NUMREF      ณ Referencia do Produto no Cliente               บnPos = 2
//บ CK_QTDVEN      ณ Quantidade do Produto                          บnPos = 3
//ศออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออผ
/* 
@ 42,018  Say " Coluna (01) --> Codigo Prod Protheus                   "
@ 50,018  Say " Coluna (02) --> Quantidade                             "
@ 58,018  Say " Coluna (03) --> R$ Unitario                            "
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

		If (Substr(cBuffer, nFim, 1)==Chr(13)) //Fim da Linha sai do laco
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
			MsgAlert("Produto "+ aOrc[1] +" inexistente.... Incluindo!")	
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
              MsgAlert("Produto "+ aOrc[1] +" Impossivel de ser incluido!")	
              lpode:=.f.
            endif      
	EndIf	                     	
	nUsado:=Len(aHeader)
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
				aCols[nAcols,nCntFor] := aOrc[1]+SPACE(15-LEN(AORC[1]))
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "D1_XDESCRI" )
				aCols[nAcols,nCntFor] := Posicione("SB1",1,xFilial("SB1")+aOrc[1],"B1_DESC")
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "D1_UM" )
				aCols[nAcols,nCntFor] := Posicione("SB1",1,xFilial("SB1")+aOrc[1],"B1_UM")
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_QUANT" )
				aCols[nAcols,nCntFor] := VAL(aOrc[2]) 
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_VUNIT" )
				aCols[nAcols,nCntFor] := VAL(aOrc[3])
    		Case ( AllTrim(aHeader[nCntFor,2]) == "D1_LOCAL" )
   				aCols[nAcols,nCntFor] := "01"	
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_TOTAL" )
				aCols[nAcols,nCntFor] := VAL(aOrc[2])*VAL(aOrc[3])
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_QTDETI" )
				aCols[nAcols,nCntFor] := 1
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_CONTA" )
				aCols[nAcols,nCntFor] := "1.1.3.01            "
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_FORNECE" )
				aCols[nAcols,nCntFor] := CA100FOR
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_LOJA" )
			 	aCols[nAcols,nCntFor] := CLOJA
		//	Case ( AllTrim(aHeader[nCntFor,2]) == "D1_GRUPO" )
     	//		aCols[nAcols,nCntFor] := SD1->D1_GRUPO
		//	Case ( AllTrim(aHeader[nCntFor,2]) == "D1_TIPO" )
		//		aCols[nAcols,nCntFor] := SD1->D1_TIPO
		//	Case ( AllTrim(aHeader[nCntFor,2]) == "D1_TP" )
		//		aCols[nAcols,nCntFor] := SD1->D1_TP
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_CLASFIS" )
				aCols[nAcols,nCntFor] := Posicione("SB1",1,xFilial("SB1")+aOrc[1],"B1_POSIPI")
		//	Case ( AllTrim(aHeader[nCntFor,2]) == "D1_VISUAL" )
	   //			aCols[nAcols,nCntFor] := SD1->D1_VISUAL 
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_DOC" )
				aCols[nAcols,nCntFor] := CNFISCAL
			Case ( AllTrim(aHeader[nCntFor,2]) == "D1_SERIE" )
				aCols[nAcols,nCntFor] := cSerie
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
			dbSelectArea("SB2")
            dbSetOrder(1)
            If !MsSeek(XFILIAL("SB2")+aOrc[1]+SPACE(15-LEN(AORC[1]))+"01")
              CriaSB2(aOrc[1]+SPACE(15-LEN(AORC[1])),"01",XFILIAL("SB2"))
	        EndIf
	Next nCntFor   	
	
	/*	
	if (lPode=.t.)
      if cItem<>"0001"
	    Aadd(aCols,Array(nUsado+1))
	  endif
	  nAcols := Len(aCols)
	  aCols[nAcols,nUsado+1] := .F.
	  nUnit:=0
	  nQuant:=0
	  For nCntFor := 1 To nUsado
	    Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_ITEM" )
				aCols[nAcols,nCntFor] := cItem  
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_PRODUTO" )
				aCols[nAcols,nCntFor] := aOrc[1]
				A120PRODUTO(aOrc[1])
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C7_QUANT" )
	   			aCols[nAcols,nCntFor] := U_HCCVAL(aOrc[2])
		   	    nQuant:=U_HCCVAL(aOrc[2])
		   	   //A120QUANT(aOrc[2])
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C7_PRECO" )
				aCols[nAcols,nCntFor] := U_HCCVAL(aOrc[3])
				nUnit:=U_HCCVAL(aOrc[3])
			   // A120PRECO(nUnit) 
            Case ( AllTrim(aHeader[nCntFor,2]) == "C7_DIAS" )
				aCols[nAcols,nCntFor] := val(aOrc[4])
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_TECNICO" )
			    aCols[nAcols,nCntFor] := u_matatec(aOrc[1]) 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_OBS" )
			 	aCols[nAcols,nCntFor] := aOrc[6] 
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_TOTAL" )
				aCols[nAcols,nCntFor] := nQuant*nUnit
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_DATPRF" )
				aCols[nAcols,nCntFor] := DATE() + val(aOrc[4])
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_UM" )
				aCols[nAcols,nCntFor] := SB1->B1_UM
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_TES" )
			   	If (!Empty(RetFldProd(SB1->B1_COD,"B1_TS")))
			    	aCols[nAcols,nCntFor]:= RetFldProd(SB1->B1_COD,"B1_TE")
		      	Else
				   	aCols[nAcols,nCntFor]:= "101"
			    EndIf
			    cTes:=aCols[nAcols,nCntFor] 
			    MaAvalTes("E",cTes)
			    MaFisRef("IT_TES","MT120",cTes)                        
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_IPI" ) 
				if Posicione("SF4",1,xFilial("SF4")+cTes,"F4_IPI")="S"
		 		 	aCols[nAcols,nCntFor]=5.00
				ELSE
		  			aCols[nAcols,nCntFor]=0
				ENDIF 
     		Case ( AllTrim(aHeader[nCntFor,2]) == "C7_LOCAL" )
				aCols[nAcols,nCntFor] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_DESCRI" )
				aCols[nAcols,nCntFor] := SB1->B1_DESC
			CASE (AllTrim(aHeader[nCntFor,2]) ==  "C7_VLDESC")
				aCols[nAcols,nCntFor] := 0
			CASE (AllTrim(aHeader[nCntFor,2]) ==  "C7_QTDSOL")
				aCols[nAcols,nCntFor] := 0	
			CASE (AllTrim(aHeader[nCntFor,2]) ==  "C7_PROVENT")
  				aCols[nAcols,nCntFor] := 0		
  			CASE (AllTrim(aHeader[nCntFor,2]) ==  "C7_ALI_WT")
  				aCols[nAcols,nCntFor] := "SC7"			
  			CASE (AllTrim(aHeader[nCntFor,2]) ==  "C7_REC_WT")
  				aCols[nAcols,nCntFor] := 0			
			OtherWise
				aCols[nAcols,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	  Next nCntFor   	 
	  A120LINOK()
	  //MaFisAdd(aCols[n][nPosCod],"",aCols[n][nPosQuant],aCols[n][nPosPrc],aCols[n][nPosDsc],"","",,0,0,0,0,aCols[n][nPosTotal])
	  //MaFisAlt("IT_FRETE",SC3->C3_VALFRE,n)
	  //A120Tabela("C7_QUANT",If(nTipoPed!=2,SC1->C1_QUANT-SC1->C1_QUJE,SC3->C3_QUANT-SC3->C3_QUJE))
	  //MaColsToFis(aHeader,aCols,n,"MT120",.T.)
	 cItem := Soma1(cItem)
     
     // MsUnlock("TMP1")
    Else 
      MsgAlert("Tamanho do registro iniciado em "+ aOrc[1] +" invแlido !")		  
    EndIf
*/
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

FClose(nLog)
fClose(nHdl)                
RestArea(aArea)
/*for x:=1 to nAcols-1
For nCntFor := 1 To nUsado-2
	    Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_PRODUTO" )
				A120PRODUTO(aCols[x,nCntFor])
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C7_QUANT" )
	   		    //A120QUANT(aCols[x,nCntFor])
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C7_PRECO" )
			    //A120PRECO(aCols[x,nCntFor]) 
            OtherWise
				aCols[x,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	  Next nCntFor   	 
next x
*/
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
cArqTxt:= cGetFile("*.csv|*.csv","Importacao de arquivo",1,"C:\",.F.,GETF_LOCALHARD) //"Selecione um arquivo"
//("*.csv|*.csv","Importacao de Or็amento",0,"C:\",.F.,0)
If Empty(cArqTxt)
	Return .F.
EndIf
cArqTxt = ALLTRIM(cArqTxt)
return (cArqTxt)   