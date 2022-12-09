#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ISCOM01   º Autor ³ Rodrigo Correa 	 º Data ³  03/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ MAPA DE COTAÇÕES CUSTOMIZADO COMO NO VS                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ISCOM01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvT("_cCotDe,_cCotAte")
cDesc1     := "Este Programa Tem Como Objetivo Imprimir Um Relatorio "
cDesc2     := "De Acordo Com Os Parametros Informados Pelo Usuario."
cDesc3     := "Mapa de Cotações"
cPict      := ""
titulo     := "MAPA DE COTACOES"
nLin       := 80
imprime    := .T.
//aOrd       := {"Analitico: Natureza","Analitico: Centro de Custo"}
lEnd       := .F.
lAbortPrint:= .F.
CbTxt      := ""
limite     := 220
tamanho    := "G"
nomeprog   := "ISCOM01" // Coloque aqui o nome do programa para impressao no cabecalho
nTipo      := 15
aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey   := 0
_cPerg     := "ISCOM0"
m_pag      := 01
wnrel      := "ISCOM01" // Coloque aqui o nome do arquivo usado para impressao em disco
cString    := "SC8"
_nTotCli   := 0
_nTotal    := 0
nOrdem     := 1	

dbSelectArea("SC8")
dbSetOrder(1)

ValidPerg() // Valida as Perguntas

Pergunte(_cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| RCOM01() },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RCOM01    º Autor ³ Fernanda/Rodrigo   º Data ³  29/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RCOM01()

_cCotDe    := mv_par01             // Cotação de
_cCotAte   := mv_par02             // Cotação Ate

Cabec1 :=    "ITEM   CODIGO     DESCRICAO DO                               UNID  QTDE     FORNECEDOR 1                 FORNECEDOR 2                 FORNECEDOR 3                 FORNECEDOR 4                 FORNECEDOR 5               "
Cabec2 :=    "       PRODUTO    PRODUTO                                                   VL.  UNIT.     VL. TOTAL     VL.  UNIT.     VL. TOTAL     VL.  UNIT.     VL. TOTAL     VL.  UNIT.     VL. TOTAL     VL.  UNIT.     VL. TOTAL    " 

             //         1         2         3         4         5         6         7         8         9         0         11        12        13       14        15        16        17        18        19        20        21        22
	        //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        //Item   Codigo     Descrição do                               Unid	 Qtde     Fornecedor 1                 Fornecedor 2                 Fornecedor 3                 Fornecedor 4                 Fornecedor 5
	        // 4         8                     40                            4     6      XXXXXXXXXXXXXXXXXXXXXXXXXX
	        //       Produto    Produto                                                   Vl. Unit.        Vl. Total      Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total
	        //9999   99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   9999  999999   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o Arquivo utilizando um Select                        ³          
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SC8")
dbSetOrder(1)
cFilTrab   := CriaTrab("",.F.)
cCondicao  := "C8_FILIAL=='"+xFilial("SC8")+"'.And."
cCondicao  += "C8_NUM>='"+_cCotDe+"'.And.C8_NUM<='"+_cCotAte+"'"
IndRegua("SC8",cFilTrab,C8_NUM,,cCondicao,"Filtrando")    // "Selecionando Registros..."


//DbSelectArea("SC8") // TABELA DE COTACOES
//aStru  := SC8->(dbStruct())
//DbCloseArea()

//	cQuery :=          "SELECT * " 
//	cQuery := cQuery + "FROM "+RetSQLName("SC8")+"( NOLOCK INDEX ="+RetSQLName("SC8")+"1 )"
//	cQuery := cQuery + "WHERE  C8_FILIAL   = '"  + xFilial("SC8")  + "' AND"
//	cQuery := cQuery +       " C8_NUM     >= '"  + _cCotDe	       + "' AND" 
//	cQuery := cQuery +       " C8_NUM     <= '"  + _cCotAte	       + "' AND" 
//    cQuery := cQuery +       " D_E_L_E_T_ <> '*' " 
//    cQuery := cQuery +   	 " ORDER BY C8_NUM"    
 
//cQuery := ChangeQuery(cQuery)

//DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SC8",.F.,.F.)

//For ni := 1 to Len(aStru)
//	If aStru[ni,2] != 'C'
//		TCSetField('SC8', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
 //	Endif
//Next
                                   
DbGoTop()
SetRegua(RecCount())
While !Eof() 
	IncRegua()
	nLin := 65
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//
	// Criacao das variaves do top
	//

    _cEmpresa := SM0->M0_NOMECOM 
	_cNum     := SC8->C8_NUM 
    _dEmissao := SC8->C8_EMISSAO
    _aCot     := {}
	_aTot     := {}
    _cCotNum  := SC8->C8_NUM 
    _I        := 0        
    
    While !Eof() .and. _cCotNum = SC8->C8_NUM   
        Aadd(_aCot,Array(20))
        _I          := _I + 1
		_aCot[_I,1] := SUBSTR(SC8->C8_ITEM,1,4) 
		_aCot[_I,2] := SUBSTR(SC8->C8_PRODUTO,1,8)
		_aCot[_I,3] := SUBSTR(Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_DESC"),1,35)
		_aCot[_I,4] := SC8->C8_UM 
		_aCot[_I,5] := SC8->C8_QUANT 
   
    	_cCodPro   := SC8->C8_PRODUTO
        _nPos      := 6   
        _nValTot   := 0
    	_TOTCIPI   := 0
    	While !Eof() .and. _cCodPro = SC8->C8_PRODUTO
			_aCot[_I,_nPos]   := SC8->C8_FORNECE+SC8->C8_LOJA
			_aCot[_I,_nPos+1] := SC8->C8_PRECO 
			_TOTCIPI := (SC8->C8_TOTAL + SC8->C8_VALIPI)
			_aCot[_I,_nPos+2] := _TOTCIPI //(SC8->C8_TOTAL + SC8->C8_VALIPI) 
			_nPos             := _nPos + 3
			
			_cCodFor  := SC8->C8_FORNECE+SC8->C8_LOJA
			_nPosForn := Ascan(_aTot, { |x| x[1] == _cCodFor })
			
			If _nPosForn = 0     
				If !Empty(SC8->C8_COND) 
					_aCond := Condicao(_TOTCIPI,SC8->C8_COND,0,SC8->C8_EMISSAO)
					//_aCond := Condicao(SC8->C8_TOTAL,SC8->C8_COND,0,SC8->C8_EMISSAO)
					
					_dVencto := _aCond[1,1]
		        	Aadd(_aTot, {_cCodFor,SC8->C8_PRAZO,SC8->C8_COND,_dVencto,_TOTCIPI})
		        	//Aadd(_aTot, {_cCodFor,SC8->C8_PRAZO,SC8->C8_COND,_dVencto,SC8->C8_TOTAL})  
		        Else
					Aadd(_aTot, {_cCodFor,SC8->C8_PRAZO,SC8->C8_COND,ctod("01/01/10"),_TOTCIPI})
					//Aadd(_aTot, {_cCodFor,SC8->C8_PRAZO,SC8->C8_COND,ctod("01/01/10"),SC8->C8_TOTAL}) 
		        EndIf	
			Else
		        _aTot[_nPosForn,5] := _aTot[_nPosForn,5] + _TOTCIPI//SC8->C8_TOTAL
			Endif
			
 			DbSelectArea("SC8")
			DbSkip()
        End
	End

	//
	// Impressão
	//
    

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif

    
		@nLin,000 PSAY "EMPRESA: " + _cEmpresa + "                           COTACAO: " + _cCotNum + "                                           DATA: " + DTOC(_dEmissao) + "                                            GRUPO: "  + Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC")
		
		nLin := nLin + 4

		@ nLin,000 PSAY "FORNECEDORES --------------------------------------------------->"
        _nCol := 76

    	i := 1  
		For i := 1 to Len(_aTot) 
		  	@ nLin,_nCol PSAY 	_aTot[i,1] + "-" + SUBSTR(Posicione("SA2",1,xFilial("SA2")+_aTot[I,1],"A2_NOME"),1,15) 
		    _nCol := _nCol + 29
	   	Next
	  
  		nLin := nLin + 4
  
            //          1         2         3         4         5         6         7         8         9         10        11        12        13       14        15        16        17        18        19        20        21        22
	        //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        //Item   Codigo     Descrição do                               Unid	 Qtde     Fornecedor 1                 Fornecedor 2                 Fornecedor 3                 Fornecedor 4                 Fornecedor 5
	        //       Produto    Produto                                                   Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total      Vl. Unit.     Vl. Total
	        //9999   99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   xxxx  999999   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   9.999.999,99  9.999.999,99   

		i := 1
	
		For i := 1 To Len(_aCot) 
			@nLin,000 PSAY 	_aCot[i,1]
			@nLin,007 PSAY  _aCot[i,2]
			@nLin,018 PSAY  _aCot[i,3] 
			@nLin,061 PSAY  _aCot[i,4]     
	        @nLin,067 PSAY  _aCot[i,5]  
	        //@nLin,078 PSAY  _aCot[i,6] //A
	        @nLin,076 PSAY  _aCot[i,7]  PICTURE "@E 999,999.99" // B
	        @nLin,090 PSAY  _aCot[i,8]  PICTURE "@E 999,999.99" // C
	        //@nLin,121 PSAY  _aCot[i,9] //A
	        @nLin,105 PSAY  _aCot[i,10] PICTURE "@E 999,999.99" //B 
	       	@nLin,119 PSAY  _aCot[i,11] PICTURE "@E 999,999.99"//C 		
	        //@nLin,165 PSAY  _aCot[i,12]//A 
	        @nLin,134 PSAY  _aCot[i,13] PICTURE "@E 999,999.99"//B 
	        @nLin,148 PSAY  _aCot[i,14] PICTURE "@E 999,999.99"//C 
	        //@nLin,208 PSAY  _aCot[i,15]//A 
			@nLin,163 PSAY  _aCot[i,16] PICTURE "@E 999,999.99"//B 
	        @nLin,177 PSAY  _aCot[i,17] PICTURE "@E 999,999.99"//C 
			//@nLin,208 PSAY  _aCot[i,15]//A 
			@nLin,192 PSAY  _aCot[i,16] PICTURE "@E 999,999.99"//B    
			@nLin,206 PSAY  _aCot[i,17] PICTURE "@E 999,999.99"//C
	        nLin := nLin + 1   

			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
			Endif

	   Next
	
	
		If nLin > 38 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif
		
   	   nLin := nLin + 5 	 // Avanca a linha de impressao
           @nLin,000 PSAY	"********************************************************************************** T O T A I S     D A S     C O T A C O E S ***********************************************************************************************"
	   nLin := nLin + 4 
	
	//
	//  Imprime os Totais dos Fornecedores
	//    	
    // Lembrando que as posicoes do Array _aTot é a abaixo:
    // E cada linha é um fornecedor diferente
    //
    //{_cCodFor,SC8->C8_PRAZO,SC8->C8_COND,_dVencto,SC8->C8_TOTAL}) 
                                                                                 
	//
	// Linha 1
	// Imprime o Codigo
	//                
	
	@ nLin,000 PSAY "FORNECEDORES --------------------------------------------------->"
	_nCol := 76
	
	
	i := 1  
	For i := 1 to Len(_aTot) 
		@ nLin,_nCol PSAY 	_aTot[i,1]+ "-" + SUBSTR(Posicione("SA2",1,xFilial("SA2")+_aTot[I,1],"A2_NOME"),1,15) //_cNomefor
	    _nCol := _nCol + 29
    Next

	nLin := nLin + 4 	 // Avanca a linha de impressao

	//
	// Linha 2
	// Imprime O PRAZO DE ENTREGA
	//

    @ nLin,000 PSAY "PRAZO DE ENTREGA: ---------------------------------------------->" 
    _nCol := 91
	I := 1  
	For i := 1 to  Len(_aTot) 
		IF !EMPTY(_aTot[i,2])  
		    @ nLin,_nCol PSAY 	Transform(_aTot[I,2],"@R 9999") + " DIAS"
	        _nCol := _nCol + 29
	    Else    
	        @ nLin,_nCol PSAY  " IMEDIATO"
	        _nCol := _nCol + 29
	    EndIF    
    Next

	nLin := nLin + 1 	 // Avanca a linha de impressao
	
	//
	// Linha 3
	// Imprime a Cond Pagamento
	//

    @ nLin,000 PSAY "CONDICAO PAGTO: ------------------------------------------------>" 
    _nCol := 80
	I := 1  
	For i := 1 to  Len(_aTot) 
		@ nLin,_nCol PSAY 	ALLTRIM(SUBSTR(Posicione("SE4",1,xFilial("SE4")+_aTot[I,3],"E4_DESCRI"),1,15)  + " DIAS")
	    _nCol := _nCol + 29
    Next

    nLin := nLin + 1 	 // Avanca a linha de impressao
	
	//
	// Linha 4
	// IMPRIME O VENCIMENTO 
	//
	 @ nLin,000 PSAY "DT. PREVISAO PAGTO: -------------------------------------------->"     
    _nCol := 92
	I := 1  
	For i := 1 to Len(_aTot) 
		@ nLin,_nCol PSAY 	_aTot[I,4]PICTURE "@E 999,999.99"
	    _nCol := _nCol + 29
    Next

    nLin := nLin + 4 	 // Avanca a linha de impressao
	
	//
	// Linha 5
	// Imprime a Total 
	// Lembrando que esta ja foi somado na Montagem do Array _aTot posicao 5
	//
	 @ nLin,000 PSAY "VALOR TOTAL: --------------------------------------------------->"     
    _nCol := 90
	I := 1  
	For i := 1 to Len(_aTot) 
		@ nLin,_nCol PSAY 	_aTot[I,5]PICTURE "@E 999,999.99"
	    _nCol := _nCol + 29
    Next

    nLin := nLin + 5	 // Avanca a linha de impressao


	@nLin,000 PSAY "APROVACAO: ----------------------------------------------------->               ________________________________________                                       _________________________________________ "  
    nLin := nLin + 1
	@nLin,000 PSAY "                                                                                        ENCARREGADO DE COMPRAS                                                                 AUTORIZACAO               "  

    nLin := nLin + 5
    @nLin,000 PSAY "OBSERVACAO: " + SC8->C8_OBS
    

    dbSelectarea("SC8")
	DbSkip()
End

dbSelectarea("SC8")
dbCloseArea("SC8")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                      


SET PRINTER TO
OurSpool(wnrel)

MS_FLUSH()

Return   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ValidPerg ³ Autor ³ Denilson Correa      ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida se existe as Perguntas no SX1                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local cAlias:=Alias(), aPerg := {} 
_cPerg := PADR(_cPerg,10)
//Local nI
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Cotacao De                           ¦
//¦ mv_par02             // Cotacao Ate                          ¦ 
//+--------------------------------------------------------------+
Aadd(aPerg,{"01","Cotação de              ?","","","mv_ch1","C",06,"G","mv_par01","","","","","","","","","","","",""})
Aadd(aPerg,{"02","Cotação ate             ?","","","mv_ch2","C",06,"G","mv_par02","","","","","","","","","","","",""})
 			  
dbSelectArea("SX1")
dbSetOrder(1)
For nI := 1 To Len(aPerg)
	If !dbSeek(_cPerg+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With _cPerg
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
		Replace X1_CNT02	With aPerg[nI,17]
		Replace X1_DEF03	With aPerg[nI,18]
		Replace X1_DEFSPA3	With aPerg[nI,19]
		Replace X1_DEFENG3	With aPerg[nI,20]
		Replace X1_F3    	With aPerg[nI,21]
		MsUnlock()
	EndIf
Next
DbSelectArea(cAlias)
Return
