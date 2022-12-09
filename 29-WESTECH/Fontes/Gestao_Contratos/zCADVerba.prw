#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"


User Function zCADVerba()

//+--------------------------------------------------------------------+
//| Rotina | xModelo2 | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Fun��o exemplo do prot�tipo Modelo2. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

Private cCadastro := "Verba Adicional"
Private cColab	 := AllTrim(UsrFullName(RetCodUsr()))
Private cCargo 	:= ""
Private cUsuario := AllTrim(RetCodUsr())
Private cColab2	 := AllTrim(UsrFullName(RetCodUsr()))
Private cData2	 := dtos(dDatabase)
	//Local cGrupo := AllTrim(UsrRetGRP(RetCodUsr()))

	PswOrder(2)
	If PswSeek(alltrim(RetCodUsr()), .T. )
		cCargo := alltrim(PSWRET()[1][13])
	endif

	Private aRotina := {}
	AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" ,'U_ZZGManut',0,2})
	AADD( aRotina, {"Incluir" ,'U_ZZGManut',0,3})
	AADD( aRotina, {"Alterar" ,'U_ZZGManut',0,4})
	//AADD( aRotina, {"Excluir" ,'U_ZZGManut',0,5})
	//AADD( aRotina, {"Legenda" ,'U_StatusSZ4',0,7})
	//AADD( aRotina, {"Aprovacao" ,'U_FMark',0,8})
	//AADD( aRotina, {"Contabilizar" ,'U_FMarcContabil',0,9})

	dbSelectArea("ZZG")
	/*
	if cColab == "ADMIN" .or. cColab == "ADMINISTRADOR" .or. cCargo == "1101" .or. cCargo == "4101"  .or. cCargo == "2101"
		SET FILTER TO SZ4->Z4_Filial = "01"
	end if
	*/

	/*
	if cUsuario <> "000046" .or. cUsuario <> "000000" .or. cUsuario <> "000006" 
		SET FILTER TO SZ4->Z4_IDCOLAB = cUsuario
	end if
	*/
	dbSetOrder(1)
	dbGoTop()

	MBrowse(,,,,"ZZG",,,,,,)

Return

User Function ZZGManut(cAlias, nReg, nOpc)

Local cChave := ""
Local nCols  := 0
Local i      := 0
//Local lRet   := .F.
Local nSoma  := 0
Local nTotReg


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
Private cAllOK   := "u_ZG2TudOK()"     // Funcao para validacao de tudo.
Private aGetsGD  := {}
Private bF4      := {|| }              // Bloco de Codigo para a tecla F4.
Private cIniCpos := ""         // String com o nome dos campos que devem inicializados ao pressionar
                                       // a seta para baixo. "+Z4_ITEM+Z4_xxx+Z4_yyy"
Private nMax     := 99                 // Nr. maximo de linhas na GetDados.
Private lMaximized := .T.

//Private aCordW   := {}
//Private lDelGetD := .T.
Private aHeader  := {}                 // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                 // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}
Private dData    := dtos(dDatabase)
Private cNumero  := Space(13)
Private aAlt     := {}


Private nXACPR := 0
Private nXCUPRR := 0
Private nXVBAD := 0


// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
dbSelectArea(cAlias)

For i := 1 To FCount()
    M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
    // Assim tambem funciona: M->&(FieldName(i)) := CriaVar(FieldName(i), .T.)
Next

/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("CTD")
CTD->( dbSetOrder(1) )



dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

   If X3Uso(SX3->X3_Usado)    .And.;                  					// O Campo � usado.
      cNivel >= SX3->X3_Nivel .And.;                  					// Nivel do Usuario � maior que o Nivel do Campo.
      !Trim(SX3->X3_Campo) $ "ZZG_ITEMIC"   	// Campos que ficarao na parte da Enchoice.

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

 If ! AllTrim(RetCodUsr()) $ "000006/000046/000077" .AND. nOpc <> 2

   		msgInfo ( "Usuario nao tem permissao para adicao de verba." )
   		Return .F.

 endif

If nOpc <> 3 
		
	cNumero := (cAlias)->ZZG_ITEMIC
	cUsuario := AllTrim(RetCodUsr()) //(cAlias)->Z4_IDCOLAB
	
	dbSelectArea( cAlias )
	dbSetOrder(1)
	dbSeek( xFilial(cAlias) + cNumero )

	While ! (cAlias)->( EOF() ) .AND. ( (cAlias)->ZZG_FILIAL == xFilial(cAlias) .AND. (cAlias)->ZZG_ITEMIC == cNumero )  
		AADD( aREG, ZZG->( RecNo() ) )
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


 Else              // Opcao INCLUIR.

   // Atribui � variavel o inicializador padrao do campo.
   //cNumero := GetSXENum("SZ4", "Z4_IDAPTHR","Z4_IDAPTHR"+cEmpAnt)

   If ZZG->( dbSeek( xFilial("ZZG")+cNumero) )
   	
	   	dbSelectArea( cAlias )
		dbSetOrder(1)
		dbSeek( xFilial(cAlias) + cNumero )
	
		While ! (cAlias)->( EOF() ) .AND. ( (cAlias)->ZZG_FILIAL == xFilial(cAlias) .AND. (cAlias)->ZZG_ITEMIC == cNumero )  
			AADD( aREG, ZZG->( RecNo() ) )
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
   
   else

	 	M->ZZG_ITEMIC := cNumero
	
	   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
	   AAdd(aCols, Array(Len(aHeader)+1))
	   For i := 1 To Len(aHeader)
	       aCols[1][i] := CriaVar(aHeader[i][2])
	
	   Next
	
	   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	   aCols[1][Len(aHeader)+1] := .F.
	
	   // Atribui 01 para a primeira linha da GetDados.
	  // aCols[1][AScan(aHeader,{|x| Trim(x[2])=="ZZG_ITEM"})] := "01"
  endif


EndIf

nXACPR := Posicione("CTD",1,xFilial("CTD") + cNumero,"CTD_XACPR")
nXCUPRR := Posicione("CTD",1,xFilial("CTD") + cNumero,"CTD_XCUPRR") 
nXVBAD := Posicione("CTD",1,xFilial("CTD") + cNumero,"CTD_XVBAD") 


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

if nOpc = 3
	AAdd(aC, {"cNumero", {15,10}, "Item Conta"        		  		, "@!"      		, , "CTD" , .T.      })
	AAdd(aC, {"nXCUPRR", {15,150}, "Custo de Producao Rev." , "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXACPR", {15,300}, "Custo Atual"        		, "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXVBAD", {15,450}, "Verba adicional"        		, "@E 999,999,999.99"      		, ,  , .F.      })
end if

if nOpc = 4
	AAdd(aC, {"cNumero", {15,10}, "Item Conta"        		  , "@!"      		, ,  , .F.      })
	AAdd(aC, {"nXCUPRR", {15,150}, "Custo de Producao Rev." , "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXACPR", {15,300}, "Custo Atual"        		, "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXVBAD", {15,450}, "Verba adicional"        		, "@E 999,999,999.99"      		, ,  , .F.      })
end if

if nOpc = 2
	AAdd(aC, {"cNumero", {15,10}, "Item Conta"        		  , "@!"      		, , "CTD" , .T.      })
	AAdd(aC, {"nXCUPRR", {15,150}, "Custo de Producao Rev." , "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXACPR", {15,300}, "Custo Atual"        		, "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXVBAD", {15,450}, "Verba adicional"        		, "@E 999,999,999.99"      		, ,  , .F.      })
end if

if nOpc = 5
	AAdd(aC, {"cNumero", {15,10}, "Item Conta"        		  , "@!"      		, , "CTD" , .T.      })
	AAdd(aC, {"nXCUPRR", {15,150}, "Custo de Producao Rev." , "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXACPR", {15,300}, "Custo Atual"        		, "@E 999,999,999.99"      		, ,  , .F.      })
	AAdd(aC, {"nXVBAD", {15,450}, "Verba adicional"        		, "@E 999,999,999.99"      		, ,  , .F.      })
end if

	// Coordenadas do objeto GetDados.
	aCGD := {60,5,128,500}

	// Validacao na mudanca de linha e quando clicar no botao OK.
	//cLinOK := "ExecBlock('AllwaysTrue',.F.,.F.)"     // ExecBlock verifica se a funcao existe.
cLinOK := ""     // ExecBlock verifica se a funcao existe.


	// Executa a funcao Modelo2().
	lRet := Modelo2(cTitulo, aC	   , aR		, aCGD, nOpc, , , , , , nMax,,,lMaximized)
			//Modelo2(cTitulo, aCabec, aRodape, aGD, nOp, cLineOk, cAllOk, aGetsGD, bF4, cIniCpos, nMax, aCordW, lDelGetD, lMaximized, aButtons)


//zzVldSZ4()

If lRet  // Confirmou.
	
		
	   	If      nOpc == 3 
	   		   If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
	              // Cria um dialogo com uma regua de progressao.
	              Processa({||ZG2Inclu(cAlias)}, cTitulo, "Gravando os dados, aguarde...")
	              //msginfo ( "opcao 3.1" )
			   //elseif nTotal > 10
			   	  //RollBackSX8()
	           else
	           	  RollBackSX8()
	           EndIf
	
	    ElseIf nOpc == 4   // Alteracao
	
	           If MsgYesNo("Confirma a alteracao dos dados?", cTitulo)
	              // Cria um dialogo com uma regua de progressao.
	              Processa({||ZG2Alter(cAlias)}, cTitulo, "Alterando os dados, aguarde...")
	           EndIf
	           //msginfo ( "opcao 4.1" )
	    ElseIf nOpc == 5   // Exclusao
	
	           If MsgYesNo("Confirma a exclusao dos dados?", cTitulo)
	              // Cria um dial�ogo com uma regua de progressao.
	              Processa({||ZG2Exclu(cAlias)}, cTitulo, "Excluindo os dados, aguarde...")
	           EndIf
	   EndIf
	
Else
	
	   RollBackSX8()

EndIf


//TR1->(DbCloseArea())
(cAlias)->(DbCloseArea())

Return Nil


//----------------------------------------------------------------------------------------------------------------//
Static Function ZG2Inclu(cAlias)

Local i := 0
Local y := 0
Local nTotalVerba := 0


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

       (cAlias)->ZZG_Filial  := xFilial(cAlias)
       (cAlias)->ZZG_ITEMIC := cNumero
      

       MSUnlock()

    EndIf

Next

dbSelectArea(cAlias)
dbGoTop()
dbSetOrder(1)

		
		If (cAlias)->( dbSeek(xFilial(cAlias)+cNumero) )		
			While (cAlias)->( ! EOF() ) 
			   if ZZG->ZZG_ITEMIC == cNumero 
				   nTotalVerba	+= (cAlias)->ZZG_VERBA
				   
			   endif
			   (cAlias)->( dbSkip() )     
			EndDo
		endif	
		
		
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		If CTD->( dbSeek(xFilial("CTD")+cNumero) )
			RecLock("CTD",.F.)
				CTD->CTD_XVBAD := nTotalVerba
			MsUnLock()
		endif

(cAlias)->(DbCloseArea())

//oDlg:End()

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ZG2Alter(cAlias)

Local i := 0
Local y := 0

Local nTotalVerba := 0

		
		
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

				(cAlias)->ZZG_Filial 	:= xFilial(cAlias)
		        (cAlias)->ZZG_ITEMIC 	:= cNumero
		        
			Endif
			MsUnLock()

		Next nX

dbSelectArea(cAlias)
dbGoTop()
dbSetOrder(1)
		
		If (cAlias)->( dbSeek(xFilial("ZZG")+cNumero) )
			
			While (cAlias)->( ! EOF() ) 
		        if ZZG->ZZG_ITEMIC == cNumero 
				   nTotalVerba	+= (cAlias)->ZZG_VERBA
				   
			   endif
			   (cAlias)->( dbSkip() )
		    EndDo

		endif
		
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		If CTD->( dbSeek(xFilial("CTD")+cNumero) )
			RecLock("CTD",.F.)
				CTD->CTD_XVBAD := nTotalVerba
			MsUnLock()
		endif
		


(cAlias)->(DbCloseArea())

//*****************************************************************

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ZG2Exclu(cAlias)

dbSelectArea( "ZZG" )
dbSetOrder(1)
dbSeek( xFilial("ZZG") + cNumero )

While !EOF()
	
	if ZZG->ZZG_ITEMIC == cNumero 
		RecLock(("ZZG"), .F.)
			dbDelete()
		MsUnLock()
	
	endif
	ZZG->(dbSkip())
	
End

	If ZZG->( dbSeek(xFilial("ZZG")+cNumero) )
			
			While ZZG->( ! EOF() ) 
		        if ZZG->ZZG_ITEMIC == cNumero 
				   nTotalVerba	+= (cAlias)->ZZG_VERBA
				   
			   endif
			   (cAlias)->( dbSkip() )
		    EndDo
		
		endif
		
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		If CTD->( dbSeek(xFilial("CTD")+cNumero) )
			RecLock("CTD",.F.)
				CTD->CTD_XVBAD := nTotalVerba
			MsUnLock()
		endif

ZZG->(DbCloseArea())

Return Nil

//----------------------------------------------------------------------------------------------------------------//
User Function ZG2TudOK()

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
/*
User Function AllwaysTrue()


If aCols[n][5] == 0
   MsgAlert("Qt. nao pode ser zero 1.", "Aten�ao!")
   Return .F.
EndIf

If Empty(aCols[n][4])
   MsgAlert("Tarefa deve ser informada.", "Aten�ao!")
   Return .F.
EndIf

If Empty(aCols[n][10])
   MsgAlert("Descricao deve ser informada.", "Aten�ao!")
   Return .F.
EndIf

//zzVldSZ4()

Return .T.

User Function STATUSSZ4()

	BrwLegenda(cCadastro,"Valores",{{"BR_VERDE","Nao Aprovado"},;
									{"BR_VERMELHO","Aprovado"},;
									{"BR_AZUL","Contabilizado"}})

return

*/

