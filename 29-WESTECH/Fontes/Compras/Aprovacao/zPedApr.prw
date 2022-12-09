#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"
#include 'protheus.ch'
#include 'parmtype.ch'


User Function zPedApr()

	Local _cQuery 	:= ""
	Local QUERY		:= ""
	Private cTPSC7 := GetNextAlias() 
	Private cCadastro := "Aprovacao Ordem de Compra"
	Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
	Private cCargo 	:= PSWRET()[1][13]
	Private cUsuario := AllTrim(RetCodUsr())
	Private cColab2	 := AllTrim(UsrFullName(RetCodUsr()))
	Private cData2	 := ctod("21/05/2018")
	//Local cGrupo := AllTrim(UsrRetGRP(RetCodUsr()))

	Private aRotina := {}
	/*
	BeginSql Alias cTPSC7
		SELECT DISTINCT C7_NUM, C7_EMISSAO, C7_FORNECE, A2_NREDUZ, C7_ITEMCTA, C7_XCTRVB  
		FROM SC7010 
		INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA 
		WHERE SC7010.D_E_L_E_T_ <> '*' AND C7_ENCER <> 'E' 
	EndSQL		
	*/
	AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" ,'U_pAPC7Manut',0,2})	
	AADD( aRotina, {"Legenda" ,'U_pStatusSC7',0,3})
	AADD( aRotina, {"Aprovar" ,'U_pAPC7Manut',0,4})
	AADD( aRotina, {"Imprimir" ,'u_PedComPo()',0,5})
	

	aCores:={{"C7_XCTRVB = '1' ","BR_VERDE"},;
			{"C7_XCTRVB = '2' ","BR_AMARELO"},;
			{"C7_XCTRVB = '3' " ,"BR_BRANCO"},;
			{"C7_XCTRVB = '4' " ,"BR_VERMELHO"}}
			
	//SET FILTER TO alltrim(SC7->C7_ENCER) <> "E" .AND. SC7->C7_EMISSAO >= cData2
	
	MBrowse(,,,,"SC7",,"C7_XCTRVB",,,3,aCores)
	
Return

User Function pAPC7Manut(cAlias, nReg, nOpc)

Local cChave := ""
Local nCols  := 0
Local i      := 0
Local lRet   := .F.
Local nSoma  := 0
Local nI	 := 0
Local nTDespes:= 0
Local oObj     := GetObjBrow()

Private cColab2	 := AllTrim(UsrFullName(RetCodUsr()))
Private dData2	 := dtos(dDatabase)
Private cUsuario := AllTrim(RetCodUsr())
Private cUsuario2 := AllTrim(RetCodUsr())

//local x :=  SZ4->( dbSeek( xFilial("SZ4")+cData2+cColab2) )

// Parametros da funcao Modelo2().·
Private cTitulo  := cCadastro
Private aREG    := {}
Private aC       := {}                 // Campos do Enchoice.
Private aR       := {}                 // Campos do Rodape.
Private aCGD     := {}                 // Coordenadas do objeto GetDados.
Private cLinOK   := ""                 // Funcao para validacao de uma linha da GetDados.
Private cAllOK   := "u_pTudOK()"     // Funcao para validacao de tudo.
Private aGetsGD  := {}
Private bF4      := {|| }              // Bloco de Codigo para a tecla F4.
//Private cIniCpos := "+Z4_ITEM"         // String com o nome dos campos que devem inicializados ao pressionar
                                       // a seta para baixo. "+Z4_ITEM+Z4_xxx+Z4_yyy"
Private nMax     := 99                 // Nr. maximo de linhas na GetDados.
Private lMaximized := .T.

//Private aCordW   := {}
//Private lDelGetD := .T.
Private aHeader  := {}                 // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                 // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}

Private cNumero  := Space(6)
Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
Private aAlt     := {}

Private cCargo 	 := alltrim(PSWRET()[1][12])


Private cNum		:= ""
Private dEmissao	:= ""
Private cFornece	:= ""
Private cNomFor		:= ""
Private nTotal		:= 0
Private cCond		:= ""
Private cCondDesc	:= ""
Private cMoeda		:= ""
Private cContato	:= ""

Private nTotalProd	:= 0
Private nTotalSTrb	:= 0
Private nTotalDesc	:= 0
Private nTotalDesp	:= 0
Private nTotalSeg	:= 0
Private nTotalFrete	:= 0
Private nTotalICMSRET	:= 0
Private nTotalVALIPI	:= 0
Private nTotalCom	:= 0

// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
dbSelectArea(cAlias)


For i := 1 To FCount()
    M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
    // Assim tambem funciona: M->&(FieldName(i)) := CriaVar(FieldName(i), .T.)
Next

/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

   If X3Uso(SX3->X3_Usado)    .And.;                  					// O Campo é usado.
      cNivel >= SX3->X3_Nivel                  					// Nivel do Usuario é maior que o Nivel do Campo.
      	// Campos que ficarao na parte da Enchoice.

      AAdd(aHeader, {Trim(SX3->X3_Titulo),;
                     SX3->X3_Campo       ,;
                     SX3->X3_Picture     ,;
                     SX3->X3_Tamanho     ,;
                     SX3->X3_Decimal     ,;
                     SX3->X3_Valid       ,;
                     SX3->X3_Usado       ,;
                     SX3->X3_Tipo        ,;
                     SX3->X3_Arquivo     ,;
                     SX3->X3_Context})

   EndIf

   SX3->(dbSkip())

End

/////////////////////////////////////////////////////////////////////
// Cria o vetor aCols: contem os dados dos campos da tabela.       //
// Cada linha de aCols é uma linha da GetDados e as colunas sao as //
// colunas da GetDados.                                            //
/////////////////////////////////////////////////////////////////////

// Se a opcao nao for INCLUIR, atribui os dados ao vetor aCols.
// Caso contrario, cria o vetor aCols com as caracteristicas de cada campo.

	cNum 		:= (cAlias)->C7_NUM
	dEmissao 	:= (cAlias)->C7_EMISSAO
	cFornece	:= (cAlias)->C7_FORNECE
	cNomFor	 	:= Posicione("SA2",1,xFilial("SA2") + cFornece,"A2_NOME")
	cCond		:= (cAlias)->C7_COND
	cCondDesc	:= ALLTRIM(Posicione("SE4",1,xFilial("SE4") + cCond,"E4_DESCRI"))
	cMoeda		:= (cAlias)->C7_MOEDA
	cContato	:= (cAlias)->C7_CONTATO
	
   If nOpc == 4 .AND. !ALltrim(PSWRET()[1][12]) $ "Contratos/Diretoria/Contabilidade/Controladoria" 
   		msgInfo ( "Usuário não tem permissao para Aprovar Ordem de Compra." )
   		Return .F.
   		
   ELSEIf nOpc == 4 .AND. !EMPTY(SC7->C7_XAPRN1) //****************

   		msgInfo ( "Aprovacao da Ordem de Compra ja realizada pelo coordenador." )
   ELSEIf nOpc == 4 .AND. !EMPTY(SC7->C7_XAPRN2) //****************

   		msgInfo ( "Aprovacao da Ordem de Compra ja realizada pela diretoria." )		
   		
   Endif//***********

	dbSelectArea( cAlias )
	dbSetOrder(1)
	dbSeek( xFilial(cAlias) + cNum )
	
	While ! (cAlias)->( EOF() ) .AND. ( (cAlias)->C7_FILIAL == xFilial(cAlias) .AND. (cAlias)->C7_NUM == cNum )  .AND. (cAlias)->C7_FORNECE == cFornece
		AADD( aREG, SZ4->( RecNo() ) )
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )

		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"

				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)

			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
				
			Endif
			
		Next nI
		
		aCOLS[ Len( aCOLS ), Len( aHeader ) + 1 ] := .F. //Adicionando o campo do Delete
		
		(cAlias)->(dbSkip())

	EndDo

	u_pTudOK()

	//ENDIF
 
//EndIf

if nOpc = 4 .OR. nOpc = 2
	AAdd(aC, {"cNum"		,{0020,0010}, "Numero"		  		, "@!"      		, , , .F.      })
	AAdd(aC, {"dEmissao"	,{0020,0140}, "Data de Emissao"		, "99/99/99"   		, , , .F.      })
	AAdd(aC, {"cFornece" 	,{0040,0010}, "Cod.Fornecedor"      , "@!"      		, , , .F.      })
	AAdd(aC, {"cNomFor" 	,{0040,0140}, "Fornecedor"  		, "@!"      		, , , .F.      })
	AAdd(aC, {"cCond" 		,{0020,0240}, "Cond.Pagto"  		, "@!"      		, , , .F.      })
	AAdd(aC, {"cCondDesc" 	,{0020,0320}, ""  					, "@!"      		, , , .F.      })
	AAdd(aC, {"cMoeda" 		,{0020,0450}, "Moeda"  				, "@!"      		, , , .F.      })
	AAdd(aC, {"cContato" 	,{0020,0550}, "Contato"				, "@!"      		, , , .F.      })
	AAdd(aC, {"nTotalDesp" 	,{0060,0010}, "Despesas"			, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalSeg" 	,{0060,0120}, "Seguro"				, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalFrete"	,{0060,0220}, "Frete"				, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalVALIPI",{0060,0320}, "Total IPI"			, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalDesc",{0060,0450}, "Total Desconto"		, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalDesc",{0060,0560}, "ICMS Subst.Trib."		, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalProd" 	,{0080,0010}, "Total Produtos"  	, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalCom",{0080,0130}, "Total Ordem de Compra"	, "999,9999,999.99" , , , .F.      })
	AAdd(aC, {"nTotalSTrb" 	,{0080,270}, "Total s/ Tributos"	, "999,9999,999.99" , , , .F.      })
	
endif

	// Coordenadas do objeto GetDados.
	aCGD := {200,5,300,500}

	// Executa a funcao Modelo2().
	//lRet := Modelo2(cTitulo, aC	   , aR		, aCGD, nOpc, , , , , , nMax,,,lMaximized)
	lRet := Modelo2(cTitulo, aC	   , aR		, aCGD, nOpc, , , , , , nMax,,,lMaximized)
			//Modelo2(cTitulo, aCabec, aRodape, aGD, nOp, cLineOk, cAllOk, aGetsGD, bF4, cIniCpos, nMax, aCordW, lDelGetD, lMaximized, aButtons)

	if nOpc == 4 .AND. !EMPTY(SC7->C7_XAPRN1) .and. nTotalCom > 5000 .OR. (cAlias)->C7_ITEMCTA == "ADMINISTRACAO" .AND. !EMPTY(SC7->C7_XAPRN1)
		msgInfo ( "Ordem de Compra requer aprovação da Diretoria ." )
	endif

	If lRet  // Confirmou.
	
	   If nOpc == 4   // Alteracao
	
	           If MsgYesNo("Confirma a aprovação?", cTitulo)
	              	if alltrim(PSWRET()[1][12]) == "Contratos" 
						Processa({||C7Alter(cAlias)}, cTitulo, "Coordenador - Alterando os dados, aguarde...")
						
					elseif  alltrim(PSWRET()[1][12]) == "Diretoria"  .OR. ALltrim(PSWRET()[1][12]) == "Contabilidade" .OR. ALltrim(PSWRET()[1][12]) == "Controladoria" 
						Processa({||C7Alter(cAlias)}, cTitulo, "Diretoria - Alterando os dados, aguarde...")
					else
						msgInfo ( "Usuário não tem permissao para Aprovar Ordem de Compra." )
						Return .F.

					endif
        
	           EndIf
	  
	   EndIf
	  
	EndIf
	
	(cAlias)->(DbCloseArea())
	

Return nil
//----------------------------------------------------------------------------------------------------------------//
Static Function C7Alter()

	Local i 		:= 0
	Local y 		:= 0
	Local cCTRVB	:= ""
	Local nX
	
//*****************************************************************
	dbSelectArea("SC7")
	dbGoTop()
	dbSetOrder(1)
			
	If SC7->( dbSeek(xFilial("SC7")+cNum) )
				 
        For nX := 1 To Len( aCOLS )
            
            //If !aCOLS[ nX, Len(aHeader)+1 ]
               
               While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum
               
				RecLock("SC7",.F.)  
				    if alltrim(PSWRET()[1][12]) == "Contratos"  
				    	SC7->C7_XAPRN1 := AllTrim(RetCodUsr())
				    	if SC7->C7_XCTRVB == "2"
				    	 	SC7->C7_XCTRVB := "4"
				    	elseif SC7->C7_XCTRVB == "1"
				    	 	SC7->C7_XCTRVB := "1"
				    	elseif SC7->C7_XCTRVB == "3"
				    	 	SC7->C7_XCTRVB := "3"
				    	endif 
				    elseif alltrim(PSWRET()[1][12]) == "Diretoria" .OR. AllTrim(RetCodUsr()) == "000063" .OR. AllTrim(RetCodUsr()) == "000016" 
				    	SC7->C7_XAPRN2 := AllTrim(RetCodUsr())
				    	if SC7->C7_XCTRVB == "1" 
				    	 	SC7->C7_XCTRVB := "4"
				    	elseif SC7->C7_XCTRVB == "2"
				    	 	SC7->C7_XCTRVB := "4"
				    	elseif SC7->C7_XCTRVB == "3"
				    	 	SC7->C7_XCTRVB := "4"
				    	endif 
				    endif
				MsUnlock()  
				
				SC7->( dbSkip() )
        
				EndDo
			//endif
          
        Next nX
    EndIf

DbCloseArea("SC7")

Return Nil

//----------------------------------------------------------------------------------------------------------------//


//----------------------------------------------------------------------------------------------------------------//
User Function pTudOK()

Local lRet 		:= .T.
Local nI 		:= 0
Local nTotProd 	:= 0
Local nTotSI 	:= 0
Local nTotDesc 	:= 0
Local nTotDesp 	:= 0
Local nTotSeg 	:= 0
Local nTotFrete	:= 0
Local nTotICMSRET := 0
Local nTotValIPI := 0

	//nPrcven :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_QTD"})
	nTotProd	:=  AScan(aHeader,{|x| Trim(x[2])=="C7_TOTAL"})
	nTotSI 		:=  AScan(aHeader,{|x| Trim(x[2])=="C7_XTOTSI"})
	
	nTotDesp 	:=  AScan(aHeader,{|x| Trim(x[2])=="C7_DESPESA"})
	nTotSeg 	:=  AScan(aHeader,{|x| Trim(x[2])=="C7_SEGURO"})
	nTotFrete 	:=  AScan(aHeader,{|x| Trim(x[2])=="C7_VALFRE"})
	nTotValIPI 	:=  AScan(aHeader,{|x| Trim(x[2])=="C7_VALIPI"})
	
	nTotICMSRET :=  AScan(aHeader,{|x| Trim(x[2])=="C7_ICMSRET"})
	nTotDesc 	:=  AScan(aHeader,{|x| Trim(x[2])=="C7_VLDESC"})
		
	nTotal := 0

	For nI := 1 To Len( aCOLS )
		
		/*
		If aCOLS[nI,Len(aHeader)+1]
			Loop
		Endif
		*/
		nTotalProd += Round( aCOLS[ nI, nTotProd ] , 2 )
		nTotalSTrb += Round( aCOLS[ nI, nTotSI ] , 2 )
		
		nTotalDesp += Round( aCOLS[ nI, nTotDesp ] , 2 )
		nTotalSeg  += Round( aCOLS[ nI, nTotSeg ] , 2 )
		nTotalFrete += Round( aCOLS[ nI, nTotFrete ] , 2 )
		nTotalVALIPI += Round( aCOLS[ nI, nTotValIPI ] , 2 )
		
		nTotalDesc += Round( aCOLS[ nI, nTotDesc ] , 2 )
		nTotalICMSRET += Round( aCOLS[ nI, nTotICMSRET ] , 2 )
		
	Next nI
	
	nTotalCom	+= (nTotalProd + nTotalVALIPI + nTotalSeg + nTotalDesp + nTotalFrete ) - (nTotalDesc + nTotalICMSRET)



Return ( lRet )


//----------------------------------------------------------------------------------------------------------------//

User Function pSTATUSSC7()
								
   BrwLegenda(cCadastro,"Valores",{{"BR_VERDE","1.Requer Aprovação - Contratos - maior ou igual a 5000"},;
									{"BR_AMARELO","2.Requer Aprovação - Contratos - menor que 5000"},;
									{"BR_BRANCO","3.Requer Aprovação - Administração"},;
									{"BR_VERMELHO","4.Aprovado"}})
return
