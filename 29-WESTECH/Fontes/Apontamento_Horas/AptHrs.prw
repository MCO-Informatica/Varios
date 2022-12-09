#Include 'Protheus.ch'
#INCLUDE "TopConn.ch"
#include "rwmake.ch"


User Function AptHrs()

//+--------------------------------------------------------------------+
//| Rotina | xModelo2 | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Fun��o exemplo do prot�tipo Modelo2. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

Private cCadastro := "Apontamento de Horas"
Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
//Private cCargo 	:= PSWRET()[1][13]
Private cUsuario := AllTrim(RetCodUsr())
Private cColab2	 := AllTrim(UsrFullName(RetCodUsr()))
Private cData2	 := dtos(dDatabase)

Private cCargo 	 := ""

PswOrder(1)
If PswSeek(RetCodUsr(), .T. )
	cCargo := PSWRET()[1][13]
endif
	//Local cGrupo := AllTrim(UsrRetGRP(RetCodUsr()))

	Private aRotina := {}
	AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" ,'U_Mod2Manut',0,2})
	AADD( aRotina, {"Incluir" ,'U_Mod2Manut',0,3})
	AADD( aRotina, {"Alterar" ,'U_Mod2Manut',0,4})
	AADD( aRotina, {"Excluir" ,'U_Mod2Manut',0,5})
	AADD( aRotina, {"Legenda" ,'U_StatusSZ4',0,7})
	//AADD( aRotina, {"Aprovacao" ,'U_FMark',0,8})
	//AADD( aRotina, {"Contabilizar" ,'U_FMarcContabil',0,9})



	aCores:={{"Z4_STATUS=='1'","BR_VERDE"},;
			{"Z4_STATUS=='2'","BR_VERMELHO"},;
			{"Z4_LA==' '","BR_AZUL"}}

	dbSelectArea("SZ4")
	/*
	if cColab == "ADMIN" .or. cColab == "ADMINISTRADOR" .or. cCargo == "1101" .or. cCargo == "4101"  .or. cCargo == "2101"
		SET FILTER TO SZ4->Z4_Filial = "01"
	end if
	*/


	if cUsuario <> "000046" .or. cUsuario <> "000000" .or. cUsuario <> "000006" .or. cUsuario <> "000073"  .or. cUsuario <> "000007"
		SET FILTER TO SZ4->Z4_IDCOLAB = cUsuario
	end if

	dbSetOrder(4)
	dbGoTop()



	MBrowse(,,,,"SZ4",,"Z4_STATUS",,,7,aCores)


Return

User Function Mod2Manut(cAlias, nReg, nOpc)
	
	Local aMatrizN 	:= Nil
	Local nICont	:= 0
	
	// Variaveis de Analise de Verba
	Local aMatriz2 		:= {}
	Local aMatriz		:= {}
	Local nI 			:= 0
	Local nI2 			:= 0
	Local nI3 			:= 0
	Local cItemConta 	:= ""
	Local cMensagem 	:= ""
	Local cItemICM 		:= ""
	Local nTotal 		:= 0
	Local nTotalHrs		:= 0
	Local nTotalHrsR	:= 0
	Local nTotalAPT		:= 0
	Local nTotalAPT2	:= 0
	Local nTotalAPT5	:= 0
	Local nTotACPR 		:= 0
	Local nTotCUPR 		:= 0
	Local nQtdHrs
	Local nDiasUteis	:= 0
	Local nHrsDia		:= 0
	
	local nVBXENGBR := 0
	local nVBXMOCTR := 0
	local nVBXINSPD := 0
	local nVBXLABOR := 0
									 
	local nVBXENGBA := 0
	local nVBXMOCTA := 0
	local nVBXINSPA := 0
	local nVBXLABOA := 0
	
	Local nENGBR	:= 0
	Local nMOCTR	:= 0
	Local nINSPD	:= 0
	Local nLABOR	:= 0
		
	Local nENGBA	:= 0
	Local nMOCTA	:= 0
	Local nINSPA	:= 0
	Local nLABOA	:= 0
	
	Local cMSENGBR 	:= ""
	Local cMSMOCTR 	:= ""
	Local cMSINSPD 	:= ""
	Local cMSLABOR 	:= "" 
	
	Local nTotQTD_EBR := 0
	Local nTotQTD_CTR := 0
	Local nTotQTD_IDL := 0
	Local nTotQTD_LAB := 0
	
	Local nTQTD_EBR := 0
	Local nTQTD_CTR := 0
	Local nTQTD_IDL := 0
	Local nTQTD_LAB := 0
	
	Local nTQTD_EBR0 := 0
	Local nTQTD_CTR0 := 0
	Local nTQTD_IDL0 := 0
	Local nTQTD_LAB0 := 0
	
	Local nTotQTD_EBR2 := 0
	Local nTotQTD_CTR2 := 0
	Local nTotQTD_IDL2 := 0
	Local nTotQTD_LAB2 := 0
	
	Local nTotQTD_EBR3 := 0
	Local nTotQTD_CTR3 := 0
	Local nTotQTD_IDL3 := 0
	Local nTotQTD_LAB3 := 0
	//**********************************

Local cChave := ""
Local nCols  := 0
Local i      := 0
//Local lRet   := .F.
Local nSoma  := 0
Local nTotReg

Local dDTCad		:= SUBSTR(DTOS(dDataBase),5,2) + "/" + SUBSTR(DTOS(dDataBase),1,4)
Private cColab2	 	:= AllTrim(UsrFullName(RetCodUsr()))
Private dData2	 	:= dtos(dDatabase)
Private cUsuario 	:= AllTrim(RetCodUsr())
Private cUsuario2 	:= AllTrim(RetCodUsr())
Private lRet   		:= .F.

//local x :=  SZ4->( dbSeek( xFilial("SZ4")+cData2+cColab2) )

// Parametros da funcao Modelo2().�
Private cTitulo  := cCadastro
Private aREG    := {}
Private aC       := {}                 // Campos do Enchoice.
Private aR       := {}                 // Campos do Rodape.
Private aCGD     := {}                 // Coordenadas do objeto GetDados.
Private cLinOK   := ""                 // Funcao para validacao de uma linha da GetDados.
Private cAllOK   := "u_Md2TudOK()"     // Funcao para validacao de tudo.
Private aGetsGD  := {}
Private bF4      := {|| }              // Bloco de Codigo para a tecla F4.
Private cIniCpos := "+Z4_ITEM"         // String com o nome dos campos que devem inicializados ao pressionar
                                       // a seta para baixo. "+Z4_ITEM+Z4_xxx+Z4_yyy"
Private nMax     := 99                 // Nr. maximo de linhas na GetDados.
Private lMaximized := .T.

//Private aCordW   := {}
//Private lDelGetD := .T.
Private aHeader  := {}                 // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                 // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}
Private dData    //:= dtos(DataValida(dDatabase))
Private cNumero  := Space(6)
Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
Private aAlt     := {}

Private cCargo 	 := alltrim(substr(PSWRET()[1][13],1,4))
Private cCompID  := alltrim(substr(PSWRET()[1][13],6,8))
Private cCentroCusto  := Space(13)
Private cClasseValor  := Space(13)

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

   If X3Uso(SX3->X3_Usado)    .And.;                  					// O Campo � usado.
      cNivel >= SX3->X3_Nivel .And.;                  					// Nivel do Usuario � maior que o Nivel do Campo.
      !Trim(SX3->X3_Campo) $ "Z4_IDAPTHR|Z4_IDCOLAB|Z4_COLAB|Z4_XXCC"   	// Campos que ficarao na parte da Enchoice. |Z4_DATA

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
// Cada linha de aCols � uma linha da GetDados e as colunas sao as //
// colunas da GetDados.                                            //
/////////////////////////////////////////////////////////////////////

// Se a opcao nao for INCLUIR, atribui os dados ao vetor aCols.
// Caso contrario, cria o vetor aCols com as caracteristicas de cada campo.

If nOpc <> 3 
	
	cNumero := alltrim((cAlias)->Z4_IDAPTHR)
	cUsuario := alltrim(AllTrim(RetCodUsr())) //(cAlias)->Z4_IDCOLAB
	cStatus	:= (cAlias)->Z4_STATUS
	cUsuario := alltrim((cAlias)->Z4_IDCOLAB)
	cColab	:= (cAlias)->Z4_COLAB
	cCargo  := (cAlias)->Z4_XXCC
	dData	:= (cAlias)->Z4_DATA

   If nOpc == 4 .AND. cStatus == "2" .OR. cStatus == "3" //***********
  			
   		msgInfo ( "Apontamento nao pode ser alterado." )
   		Return .F.

   ELSEIf nOpc == 4 .AND. cColab <> cColab2 .AND. cColab2 <> "Administrador"  //***********
   		
   		msgInfo ( "Apontamento nao pode ser alterado." )
   		Return .F.

   ELSEIf nOpc == 5 .AND. cStatus == "2" .OR. cStatus == "3" //****************

   		msgInfo ( "Apontamento nao pode ser excluido." )
   		Return .F.

   Else //***********

   dbSelectArea( cAlias )
	dbSetOrder(1)
	dbSeek( xFilial(cAlias) + cNumero + cUsuario )
	

	While ! (cAlias)->( EOF() ) .AND. alltrim((cAlias)->Z4_IDAPTHR) == Alltrim(cNumero) ; // .AND.  (cAlias)->Z4_FILIAL == xFilial(cAlias) .AND. alltrim((cAlias)->Z4_IDAPTHR) == Alltrim(cNumero)  ;
	 	.AND. alltrim((cAlias)->Z4_IDCOLAB) == alltrim(cUsuario) //.AND. dtos((cAlias)->Z4_DATA) == dtos(dData)
		
		AADD( aREG, (cAlias)->( RecNo() ) )
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

	ENDIF
 Else              // Opcao INCLUIR.

   // Atribui � variavel o inicializador padrao do campo.
   //cNumero := GetSXENum("SZ4", "Z4_IDAPTHR","Z4_IDAPTHR"+cEmpAnt)
     
   	BEGINSQL ALIAS "TR1"
	     SELECT * FROM SZ4010 WHERE D_E_L_E_T_ <> '*'
	ENDSQL

	nTotReg := Contar("TR1","!Eof()") + 1
 	cNumero := cValToChar(STRZERO(nTotReg,15)) 

 	M->Z4_IDAPTHR := cNumero

   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
   AAdd(aCols, Array(Len(aHeader)+1))
   For i := 1 To Len(aHeader)
       aCols[1][i] := CriaVar(aHeader[i][2])

   Next

   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
   aCols[1][Len(aHeader)+1] := .F.

   // Atribui 01 para a primeira linha da GetDados.
   aCols[1][AScan(aHeader,{|x| Trim(x[2])=="Z4_ITEM"})] := "01"

   

EndIf



/////////////////////////////////////////////////////////////////////
// Cria o vetor Enchoice.                                          //
/////////////////////////////////////////////////////////////////////

// aC[n][1] = Nome da variavel. Ex.: "cCliente"
// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.
// aC[n][3] = Titulo do campo
// aC[n][4] = Picture
// aC[n][5] = Validacao
// aC[n][6] = F3
// aC[n][7] = Se o campo � editavel, .T., senao .F.

//msginfo ( dData )

if nOpc == 3
	AAdd(aC, {"cNumero", {15,10}, "ID"        		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cUsuario",{15,150}, "ID Colab."		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cColab" , {15,260}, "Colaborador"      , "@!"      		, , , .F.      })
	//AAdd(aC, {"dData"  , {15,700}, "DATA"			  , "99/99/99" 	    , , , .F. 		})
	AAdd(aC, {"cCargo" , {15,550}, "Centro de Custo"  , "@!"      		, , , .F.      })
	//AAdd(aC, {"nTotal" , {15,700}, "Total"  		  , "@!"      		, , , .F.      })
	
end if

if nOpc == 4
	AAdd(aC, {"cNumero", {15,10}, "ID"        		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cUsuario",{15,150}, "ID Colab."		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cColab" , {15,260}, "Colaborador"      , "@!"      		, , , .F.      })
	//AAdd(aC, {"dData"  , {15,700}, "DATA"			  , "99/99/99" 	    , , , .F.})
	AAdd(aC, {"cCargo" , {15,550}, "Centro de Custo"  , "@!"      		, , , .F.      })
	//AAdd(aC, {"nTotal" , {15,700}, "Total"  		  , "@!"      		, , , .F.      })
	
end if

if nOpc == 2
	AAdd(aC, {"cNumero", {15,10}, "ID"        		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cUsuario",{15,150}, "ID Colab."		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cColab" , {15,260}, "Colaborador"      , "@!"      		, , , .F.      })
	//AAdd(aC, {"dData"  , {15,700}, "DATA"			  , "99/99/99" 	    , , , .F.})
	AAdd(aC, {"cCargo" , {15,550}, "Centro de Custo"  , "@!"      		, , , .F.      })
	//AAdd(aC, {"nTotal" , {15,700}, "Total"  		  , "@!"      		, , , .F.      })
	
end if

if nOpc == 5
	AAdd(aC, {"cNumero", {15,10}, "ID"        		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cUsuario",{15,150}, "ID Colab."		  , "@!"      		, , , .F.      })
	AAdd(aC, {"cColab" , {15,260}, "Colaborador"      , "@!"      		, , , .F.      })
	//AAdd(aC, {"dData"  , {15,700}, "DATA"			  , "99/99/99" 	    , , , .F.})
	AAdd(aC, {"cCargo" , {15,550}, "Centro de Custo"  , "@!"      		, , , .F.      })
	//AAdd(aC, {"nTotal" , {15,700}, "Total"  		  , "@!"      		, , , .F.      })
	
end if

	// Coordenadas do objeto GetDados.
	aCGD := {60,5,128,500}

	// Validacao na mudanca de linha e quando clicar no botao OK.
	cLinOK := "ExecBlock('AllwaysTrue',.F.,.F.)"     // ExecBlock verifica se a funcao existe.
if nOpc == 3
	dData := dDataBase
end if

/*
if nOpc = 4	.or. nOpc = 2
	dData := (cAlias)->Z4_DATA
end if
*/
	// Executa a funcao Modelo2().
	lRet := Modelo2(cTitulo, aC	   , aR		, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax,,,lMaximized)
			//Modelo2(cTitulo, aCabec, aRodape, aGD, nOp, cLineOk, cAllOk, aGetsGD, bF4, cIniCpos, nMax, aCordW, lDelGetD, lMaximized, aButtons)

//zzVldSZ4()

If lRet  // Confirmou.

	if nOpc == 3 .OR. nOpc == 4
		// Analise de Verba
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		/*
		dbSelectArea("SZ4")
		SZ4->( dbSetOrder(8) )
		SZ4->(dbgotop())
		*/
			
		
		for nI=1 to Len( aCOLS )
			AAdd( aMatriz,  ALLTRIM(aCols[nI][2]),nI )
			if ascan(aMatriz2,aMatriz[nI]) = 0 
				aadd(aMatriz2,aMatriz[nI]) 
			endif     
		next      
		
		//for nI=1 to len(aMatriz2) 
		
			//cMensagem += aMatriz2[nI] + chr(13) + chr(10)
		//next 
		/********************************************/
		for nI3 = 1 to Len(aMatriz2)
			nTotal := 0
			cItemICM := alltrim(aMatriz2[nI3])
			
			nTQTD_EBR := nTQTD_EBR0 
			nTQTD_CTR := nTQTD_CTR0 
			nTQTD_IDL := nTQTD_IDL0 
			nTQTD_LAB := nTQTD_LAB0
					
			// Soma de valores do Item Conta
			for nI2=1 to Len( aCOLS )
				if ALLTRIM(aCols[nI2][2]) == cItemICM .AND. ! ALLTRIM(aCols[nI2][2]) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
					nTotal += aCols[nI2][7]
				endif
			
			next
			
			//msginfo(cItemICM + " - " + cValtoChar(nTotal))
			
			if ! ALLTRIM(cItemICM) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
				
				if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
				
					 nTotACPR := CTD->CTD_XACPR + nTotal 
					 nTotCUPR := CTD->CTD_XCUPRR 
					 
					 /************************/
					/* 
					nVBXENGBR := round(CTD->CTD_XENGBR,2)
					nVBXMOCTR := round(CTD->CTD_XMOCTR,2)
					nVBXINSPD := round(CTD->CTD_XINSPD,2)
					nVBXLABOR := round(CTD->CTD_XLABOR,2)
														 
					nVBXENGBA := round(CTD->CTD_XENGBA,2)
					nVBXMOCTA := round(CTD->CTD_XMOCTA,2)
					nVBXINSPA := round(CTD->CTD_XINSPA,2)
					nVBXLABOA := round(CTD->CTD_XLABOA,2)
					// Soma de valores do Item Conta
					
					for nI2=1 to Len( aCOLS )
						
						if ALLTRIM(aCols[nI2][2]) == cItemICM .AND. ! ALLTRIM(aCols[nI2][2]) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
							
							nTotal += aCols[nI2][7]
							
							if ALLTRIM(aCols[nI2][4]) == "CE"
								nENGBR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "EE"
								nENGBR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "LB"
								nLABOR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "PB"
								nENGBR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "DT"
								nENGBR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "DC"
								nENGBR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "OU"
								nENGBR += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "DI"
								nINSPD += aCols[nI2][7]
								
							elseif ALLTRIM(aCols[nI2][4]) == "SC"
								nINSPD += aCols[nI2][7]
								
							else
								nMOCTR += aCols[nI2][7]
							endif
						endif
					
					next
					*/
					/************ Mensagems de Aviso **************/
					/*
					if nENGBR > 0
						cMSENGBR :=  "Verba Atual Engenharia BR: '" +  cValToChar(Transform(nVBXENGBR,"@E 999,999,999.99")) + CRLF +;
							    	 "Apontamento Atual Engenharia BR: '" +  cValToChar(Transform(nVBXENGBA,"@E 999,999,999.99")) + CRLF +;
									 "Apontamento realizado Engenharia BR: '" +  cValToChar(Transform(nENGBR,"@E 999,999,999.99")) + CRLF + ; 
									 CRLF + "'"
					else
						cMSENGBR := ""
					endif
					
					if nMOCTR > 0
						cMSMOCTR :=  "Verba Atual Contratos: '" +  cValToChar(Transform(nVBXMOCTR,"@E 999,999,999.99")) + CRLF +;
									 	 "Apontamento Atual Contratos: '" +  cValToChar(Transform(nVBXMOCTA,"@E 999,999,999.99")) + CRLF +;
									 	 "Apontamento realizado Contratos: '" +  cValToChar(Transform(nMOCTR,"@E 999,999,999.99")) + CRLF +;
									 	 CRLF + "'"
					else
						cMSMOCTR := ""
					endif
					
					if nINSPD > 0
						cMSINSPD :=  "Verba Atual Inspe��o/Dilig.: '" +  cValToChar(Transform(nVBXINSPD,"@E 999,999,999.99")) + CRLF +;
									 	 "Apontamento Atual Inspe��o/Dilig.: '" +  cValToChar(Transform(nVBXINSPA,"@E 999,999,999.99")) + CRLF +;
									 	 "Apontamento realizado Inspe��o/Dilig.: '" +  cValToChar(Transform(nINSPD,"@E 999,999,999.99")) + CRLF +;
									 	 CRLF + "'"
					else
						cMSINSPD := ""
					endif
					
					if nLABOR > 0
						cMSLABOR :=   "Verba Atual Laborat�rio: '" +  cValToChar(Transform(nVBXLABOR,"@E 999,999,999.99")) + CRLF +;
									 	 "Apontamento Atual Inspe��o/Dilig.: '" +  cValToChar(Transform(nVBXLABOA,"@E 999,999,999.99")) + CRLF +;
									 	 "Apontamento realizado Laborat�rio: '" +  cValToChar(Transform(nLABOR,"@E 999,999,999.99")) + CRLF +;
									 	 CRLF + "'"
					else
						cMSLABOR := ""
					endif
					*/
					/************ Fim Mensagems de Aviso **************/
					/************************/
					 
					 if round(nTotACPR,2) > round(nTotCUPR,2)
					   	/*round((nVBXENGBA+nENGBR),2) > round(nVBXENGBR,2) .AND. cMSENGBR <> "" .OR.;
					 	round((nVBXMOCTA+nMOCTR),2) > round(nVBXMOCTR,2) .AND. cMSMOCTR <> "" .OR.;
					 	round((nVBXINSPA+nINSPD),2) > round(nVBXINSPD,2) .AND. cMSINSPD <> "" .OR.;
					 	round((nVBXLABOA+nLABOR),2) > round(nVBXLABOR,2) .AND. cMSLABOR <> "" .OR.;*/
					 	alert("Apontamento realizado supera verba disponibilizada para Contrato " + cItemICM + ;
					 	". Informe o Coordenador do Contrato ou solicite verba adicional a Diretoria."+ CRLF + CRLF +;
					 	CRLF + "Operacao sera cancelada. ")
					 	TR1->(DbCloseArea())
					 	//return .F.
					 	//lRet := .F.
					 	//RollBackSX8()
					 	Return .F.
	
					 	/*cMSENGBR + ;
					 	cMSMOCTR + ;
					 	cMSINSPD + ;
					 	cMSLABOR + ;*/ 
					 	
					 endif
					
				endif
				
			endif
			nTotal := 0
			/*******************/
			nENGBR		:= 0
			nMOCTR		:= 0
			nINSPD		:= 0
			nLABOR		:= 0
				
			nENGBA		:= 0
			nMOCTA		:= 0
			nINSPA		:= 0
			nLABOA		:= 0
			
			nVBXENGBR 	:= 0
			nVBXMOCTR 	:= 0
			nVBXINSPD	:= 0
			nVBXLABOR	:= 0
									 
			nVBXENGBA 	:= 0
			nVBXMOCTA 	:= 0
			nVBXINSPA 	:= 0
			nVBXLABOA 	:= 0
			
			cMSENGBR	:= ""
			cMSMOCTR	:= ""
			cMSINSPD	:= ""
			cMSLABOR	:= ""
			/******************/
		next
		
	endif
	
	//***************************************
	
	if nOpc == 2 .OR. nOpc == 3 .OR. nOpc == 4
	
		SZ4->( dbSetOrder(8) )
		SZ4->(dbgotop())
		if SZ4->(dbseek(cUsuario+dtos(dData))) //SZ4->( dbSeek( xFilial("SZ4")+cNumero+cUsuario) )
			if SZ4->Z4_STATUS = "2"
				MsgInfo("Apontamento nao pode ser realizado pois o Mes esta fechado", cTitulo)
				lRet := .F.
			endif
		endif
	
		nTotalHrs  :=  AScan(aHeader,{|x| Trim(x[2])=="Z4_QTDHRS"})
		For nI := 1 To Len( aCOLS )

				If aCOLS[nI,Len(aHeader)+1]
					Loop
				Endif

				nTotalHrsR += Round( aCOLS[ nI, nTotalHrs ] , 2 )
		Next nI
		
		SZ4->(dbsetorder(8)) 
		SZ4->(dbgotop())
		SZ4->(dbseek(cUsuario+dtos(dData),.T.))
		while SZ4->(!eof()) 
			if dtos(SZ4->Z4_DATA) = dtos(dData) .and. alltrim(SZ4->Z4_IDCOLAB) == alltrim(cUsuario)
				nTotalAPT += SZ4->Z4_QTDHRS
			endif
			SZ4->(dbskip())
		enddo
		
		SZ4->(dbsetorder(8)) 
		SZ4->(dbgotop())
		SZ4->(dbseek(cUsuario+dtos(dData),.T.))
		while SZ4->(!eof()) 
			if dtos(SZ4->Z4_DATA) >= dtos(FirstDate(dData)) .and. dtos(SZ4->Z4_DATA) <= dtos(LastDate(dData)) .and. alltrim(SZ4->Z4_IDCOLAB) == alltrim(cUsuario)
				nTotalAPT2 += SZ4->Z4_QTDHRS
			endif
			SZ4->(dbskip())
		enddo
		
		if alltrim(cCargo) == "4105"
			nHrsDia := 6
		else
			nHrsDia := 24
		endif
		
		nDiasUteis := DateWorkDay(FirstDate(dData), LastDate(dData),.F.,.F.,.F. )
		
		cDiasUteis	:= cValToChar(nDiasUteis)
		//msginfo ("dias uteis: " + cDiasUteis)
		
		cTotalAPT3 := cValtoChar(nDiasUteis*nHrsDia)
		//msginfo ("Horas a serem Apontadas no m�s: " + cTotalAPT3)
		
		cTotalAPT2 := cValtoChar(nTotalAPT2)
		//msginfo ("Total de horas Apontadas: " + cTotalAPT2)
		
		cTotalAPT4 := cValtoChar((nDiasUteis*nHrsDia)-nTotalAPT2)
		//msginfo ("Faltam apontar: " + cTotalAPT2 + " horas")
		
		
		nTotalAPT5 := nTotalHrsR+nTotalAPT
		cTotalAPT5 := cValtoChar(nTotalAPT5)
		//msginfo ("xxxxx: " + cTotalAPT5)
		//cTotalAPT2
		
		msgalert("Ja foi apontada nesta data " + cValtoChar(nTotalAPT) + " horas." + chr(13) + chr(10) + ;
		"Dias uteis do mes: " + cDiasUteis + chr(13) + chr(10) + ;
		"Horas a serem Apontadas no mes: " + cTotalAPT3 + chr(13) + chr(10) + ;
		"Total de horas Apontadas: " + cTotalAPT2 + chr(13) + chr(10) + ;
		"Faltam apontar: " + cTotalAPT4 + " horas")
		
		/*if nTotalAPT5 > nHrsDia .and. nOpc <> 4
			msginfo ("Limite de apontamento de horas por dia sao de " + cValToChar(nHrsDia) + " horas. Cadastro sera cancelado.")
			//lRet := .F.
			TR1->(DbCloseArea())
			Return .F.
		end if
		
		if (nTotalHrsR+nTotalAPT2) > (nDiasUteis*nHrsDia)
			aLERT ("Limite de apontamento de horas do mes foi execido. Cadastro sera cancelado.")
			//lRet := .F.
			TR1->(DbCloseArea())
			Return .F.
		end if*/
		
		//nTotal2 := cValToChar(nTotal+nTotalAPT)
		//msginfo (nTotal2)
		
	ENDIF
	//****************************************

	   	If      nOpc == 3 
	   	
	   		   If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
	              // Cria um dialogo com uma regua de progressao.
	              Processa({||Md2Inclu(cAlias)}, cTitulo, "Gravando os dados, aguarde...")
	              //msginfo ( "opcao 3.1" )
	           EndIf
	
	    ElseIf nOpc == 4   // Alteracao

	           If MsgYesNo("Confirma a alteracao dos dados?", cTitulo)
	              // Cria um dialogo com uma regua de progressao.
	              Processa({||Md2Alter(cAlias)}, cTitulo, "Alterando os dados, aguarde...")
	           EndIf
	           //msginfo ( "opcao 4.1" )
	    ElseIf nOpc == 5   // Exclusao
	
	           If MsgYesNo("Confirma a exclusao dos dados?", cTitulo)
	              // Cria um dial�ogo com uma regua de progressao.
	              Processa({||Md2Exclu(cAlias)}, cTitulo, "Excluindo os dados, aguarde...")
	           EndIf
	   EndIf
	
Else
	
	   RollBackSX8()

EndIf

TR1->(DbCloseArea())
(cAlias)->(DbCloseArea())

Return Nil


//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Inclu(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)

For i := 1 To Len(aCols)

    IncProc()
    
   
    If !aCols[i][Len(aHeader)+1]  // A linha nao esta deletada, logo, deve ser gravada.

       RecLock(cAlias, .T.)

       For y := 1 To Len(aHeader)
           FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
       Next

       (cAlias)->Z4_Filial  := xFilial(cAlias)
       (cAlias)->Z4_IDAPTHR := cNumero
       (cAlias)->Z4_IDCOLAB	:= cUsuario
       (cAlias)->Z4_COLAB  	:= cColab
       (cAlias)->Z4_XXCC  	:= cCargo
       //(cAlias)->Z4_DATA 	:= dData
       (cAlias)->Z4_STATUS 	:= "1"

       MSUnlock()

    EndIf

Next

(cAlias)->(DbCloseArea())

//oDlg:End()

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Alter(cAlias)

Local i := 0
Local y := 0
Local nX
Local nI
	
//*****************************************************************
		dbSelectArea(cAlias)
		dbSetOrder(1)
		
			

		For nX := 1 To Len( aCOLS )

			If nX <= Len( aREG )
				dbGoto( aREG[nX] )

				RecLock(cAlias,.F.)
					If aCOLS[ nX, Len( aHeader ) + 1 ]
						dbDelete()
					Endif
			Else
				If !aCOLS[ nX, Len( aHeader ) + 1 ]
					//msginfo( "3." + nTotal )
					RecLock( cAlias, .T. )
				Endif
			Endif

			If !aCOLS[ nX, Len(aHeader)+1 ]

				For nI := 1 To Len( aHeader )
					FieldPut( FieldPos( Trim( aHeader[ nI, 2] ) ),;
					aCOLS[ nX, nI ] )
				Next nI

				(cAlias)->Z4_Filial 	:= xFilial(cAlias)
		        (cAlias)->Z4_IDAPTHR 	:= cNumero
		        (cAlias)->Z4_IDCOLAB 	:= cUsuario
		        (cAlias)->Z4_COLAB 	:= cCOLAB
		        //(cAlias)->Z4_DATA 	:= dData

			Endif


			MsUnLock()

		Next nX
		


(cAlias)->(DbCloseArea())

//*****************************************************************

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Exclu(cAlias)

dbSelectArea( "SZ4" )
dbSetOrder(1)
dbSeek( xFilial("SZ4") + cNumero )

While !EOF()
	
	if alltrim(SZ4->Z4_IDAPTHR) == alltrim(cNumero) .AND. alltrim(SZ4->Z4_IDCOLAB) == alltrim(cUsuario) .AND. SZ4->Z4_STATUS = "1" .AND. DTOS(SZ4->Z4_DATA) == DTOS(dData)
		RecLock(("SZ4"), .F.)
			dbDelete()
		MsUnLock()
	
	endif
	SZ4->(dbSkip())
	
End


Return Nil

//----------------------------------------------------------------------------------------------------------------//
User Function Md2TudOK()

Local lRet 		:= .T.
Local i    		:= 0
Local nDel 		:= 0
Local nTotal 	:= 0
Local vHrIni	:= 0
Local vHrFin	:= 0
Local cUsuario2  := AllTrim(RetCodUsr())
Local dDataOK   := dtos(dDataBase)
//Local dDataOK   := substr(dtos(dDataBase),7,4) + "/" +  substr(dtos(dDataBase),5,2) + "/" + substr(dtos(dDataBase),1,4)
Local nTotal2	:= 0
Local dDTCad	:= SUBSTR(DTOS(dDataBase),5,2) + "/" + SUBSTR(DTOS(dDataBase),1,4)


//****************************************

For i := 1 To Len(aCols)
    If aCols[i][Len(aHeader)+1]
       nDel++
    EndIf
Next


If nDel == Len(aCols)
   MsgInfo("Para excluir todos os itens, utilize a opcao EXCLUIR", cTitulo)
   lRet := .F.
EndIf

Return lRet

//----------------------------------------------------------------------------------------------------------------//
User Function AllwaysTrue()

/*
if nTotal > 8
	MsgAlert("Quantidade Total de horas por dia n�o pode ultrapassar a 10.", "Aten�ao!")
   	Return .T.
endif
*/
/*
If aCols[n][4] == 0
   MsgAlert("Qt. nao pode ser zero 1.", "Aten�ao!")
   Return .F.
EndIf
*/

If aCols[n][6] == 0
   MsgAlert("Qt. nao pode ser zero 0.", "Atencao!")
   Return .F.
EndIf

If aCols[n][6] > 24
   MsgAlert("Qt. nao pode ser maior que 24.", "Atencao!")
   Return .F.
EndIf

If Empty(aCols[n][5])
   MsgAlert("Tarefa deve ser informada.", "Atencao!")
   Return .F.
EndIf

If Empty(aCols[n][9])
   MsgAlert("Codigo do Cliente deve ser informado.", "Atencao!")
   Return .F.
EndIf

If Empty(aCols[n][10])
   MsgAlert("Informe Codigo do Cliente valido.", "Atencao!")
   Return .F.
EndIf

If Empty(aCols[n][11])
   MsgAlert("Descricao deve ser informada.", "Atencao!")
   Return .F.
EndIf

//zzVldSZ4()

Return .T.

User Function STATUSSZ4()

	BrwLegenda(cCadastro,"Valores",{{"BR_VERDE","Nao Aprovado"},;
									{"BR_VERMELHO","Aprovado"},;
									{"BR_AZUL","Contabilizado"}})

return



static function zzVldSZ4()

	// Variaveis de Analise de Verba
	Local aMatriz2 		:= {}
	Local aMatriz		:= {}
	Local nI 			:= 0
	Local nI2 			:= 0
	Local nI3 			:= 0
	Local cItemConta 	:= ""
	Local cMensagem 	:= ""
	Local cItemICM 		:= ""
	Local nTotal 		:= 0
	Local nTotACPR 		:= 0
	Local nTotCUPR 		:= 0
	//**********************************
	
	// Analise de Verba
	dbSelectArea("CTD")
	CTD->( dbSetOrder(1) )
	
	for nI=1 to Len( aCOLS )
		AAdd( aMatriz,  ALLTRIM(aCols[nI][2]),nI )
		if ascan(aMatriz2,aMatriz[nI]) = 0 
			aadd(aMatriz2,aMatriz[nI]) 
		endif     
	next      
	
	for nI=1 to len(aMatriz2) 
		//alert(aMatriz2[nI]+"aaa")
		cMensagem += aMatriz2[nI] + chr(13) + chr(10)
	next 
	
	for nI3 = 1 to Len(aMatriz2)
		nTotal := 0
		cItemICM := alltrim(aMatriz2[nI3])
		
		// Soma de valores do Item Conta
		for nI2=1 to Len( aCOLS )
			if ALLTRIM(aCols[nI2][2]) == cItemICM .AND. ! ALLTRIM(aCols[nI2][2]) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
				nTotal += aCols[nI2][7]
			endif
		next
		if ! ALLTRIM(cItemICM) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")
			if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
			
				 nTotACPR := CTD->CTD_XACPR + nTotal 
				 nTotCUPR := CTD->CTD_XCUPRR
				 
				 if nTotACPR > nTotCUPR
				 	msginfo("Apontamento realizado supera verba do Contrato" + cItemICM + ". Solicite verba adicional a Diretoria ")
				 	return .F.
				 	lRet := .F.
				 endif
				
			endif
		endif
	
	next
	//**********************************
		
	//msginfo (cValtoChar(nTotal))

return


 