#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ? CSPCO025 ? Autor ? Joao Goncalves de Oliveira ? Data ? 11/08/14 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ? Rotina de Atualizacao do Detalhe a Partir de Planilha CSV  	   潮?
泵哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ? U_CSPCO025()                  				          		   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? Nenhum 														   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ? Nenhum												   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3

User Function CSPCO025()

Local aTRB := {}
Local aHeadMBrow := {}
Local aParamBox := {}
Local bConfGrav := {|| .T.}
Local aButtPara := {}
Local lCentPara := .T.
Local cTituRoti := "Manuten玢o do Detalhe dos Movimentos Realizados"
Local nPosiHori
Local nPosiVert
Local cLoadPerg := "CSPCO025"
Local lSalvPara := .T.
Local lUserSave := .T.
Local cTabeGrav := ""
Local cTipoResu := ""
Local cTipoMovi := ""

Static aPergReto := {}

Private cCadastro := "Manuten玢o do Detalhe dos Movimentos Realizados"
Private aRotina := {}
Private bBuscArqu := {|| CSPCO25A()}

aAdd(aParamBox,{1,"Pasta para Leitura do Arquivo",Padr("",150),"@!","IIf(Empty(mv_par01),Eval(bBuscArqu),mv_par01)",,"",120,.T.})
aAdd(aParamBox,{1,"Data Inicial",CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data Final " ,CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{2,"Tipo de Contas ",1, {"Despesas","Receitas","Capex","Todas"} , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Tipo Movimento",2, {"Or鏰do","Realizado"}  , 50, '.T.', .T.})


If ParamBox(aParamBox, cTituRoti, aPergReto, bConfGrav, aButtPara, lCentPara, nPosiHori,nPosiVert,, cLoadPerg, lSalvPara, lUserSave)
	For nContItem := 1 to Len(aParamBox)
		If aParamBox[nContItem,1] == 2 .And. ValType(&("mv_par"+StrZero(nContItem,2))) <> "N"
			&("mv_par"+StrZero(nContItem,2)) := aScan(aParamBox[nContItem,4],&("mv_par"+StrZero(nContItem,2)))
		EndIf
	Next
	
	cTabeGrav := "CSPCO010_" + StrZero(Year(mv_par02),4)                   
	cTipoResu := IIf(mv_par04 == 3,"C",IIf(mv_par04 == 1,"D",IIf(mv_par04 == 2,"R","T")))
	cTipoMovi := IIf(mv_par05 == 2,"R","O")
	               
	Processa({|| CSPCO25B(mv_par01,DTOS(mv_par02),DTOS(mv_par03),cTabeGrav,cTipoResu,cTipoMovi)},"Efetuando Atualizacao conforme Arquivo CSV...")

EndIf

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ? CSPCO25A ? Autor ? Joao Goncalves de Oliveira ? Data ? 10/12/15 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ? Busca Arquivo para processamento                 		       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ? CSPCO25A()								         	   		   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? Nenhum 														   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ? Nenhum 														   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

Static Function CSPCO25A()
Local cCamiArqu

cCamiArqu := cGetFile('Arquivo CSV|*.CSV','Selecione Arquivo',1,'C:\',.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE,.F.)

mv_par01 := cCamiArqu
Return                                  


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ? CSPCO25B ? Autor ? Joao Goncalves de Oliveira ? Data ? 26/09/16 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ? Efetua leitura e atualizacao do campo Detalhe nos Registros	   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ? CSPCO25B(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)	   	   		   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? ExpC1 - Caminho do Arquivo a ser importado 					   潮?
北?          ? ExpC2 - DAta Inicial de Processamento 						   潮?
北?          ? ExpC3 - Data Final de Processamento 	 					       潮?
北?          ? ExpC4 - Tabela de Grava玢o dos Dados 	 					   潮?
北?          ? ExpC5 - Tipo de Contas 					 					   潮?
北?          ? ExpC6 - Tipo de Movimenta玢o (Or鏰do ou Realizado 			   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ? ExpA1 - Vetor com os dados a serem gravados  		   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

Static Function CSPCO25B(cCamiArqu,cDataInic,cDataFina,cTabeGrav,cTipoResu,cTipoMovi)

	Local nContLinh := 0
	Local aLinhDado := {}
	Local cLinhArqu := ""
	Local aDadoArqu := {}
	Local aDadoGrav := {}


	Ft_FUse(cCamiArqu)
	ProcRegua(Ft_FLastRec())

	Ft_FGoTop()

	While ! Ft_FEof()

		IncProc("Varrendo arquivo de importa玢o ... " + StrZero(nContLinh ++,4))

		If nContLinh >= 2
			cLinhArqu := Ft_FReadLn()
			aLinhDado := CSPCO25C(cLinhArqu,";")
			Aadd(aDadoArqu,{aLinhDado[21],aLinhDado[IIf(mv_par05 == 1,27,26)]})
		EndIf	
		Ft_FSkip()

	End

	Ft_FUse()

	If Len(aDadoArqu) > 0


		Processa({|| CSPCO25D(cDataInic,cDataFina,cTabeGrav,aDadoArqu,cTipoResu,cTipoMovi)},"Gravando Detalhes nos Registros Realizados ...")

	Else

		MsgInfo('N鉶 foram encontrados registros para importa玢o',cCadastro)

	EndIf

Return



/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ? CSPCO25C ? Autor ? Joao Goncalves de Oliveira ? Data ? 01/09/16 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri玢o ? Converte Texto em Vetor utilizado o delimitador passado como    潮?
北?  		 ? par鈓etro 													   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ? CSPCO25C(ExpC1,ExpC2)									       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? ExpC1 - Caminho do Arquivo a ser importado 					   潮?
北?          ? ExpC2 - Campo Delimitador 									   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ? ExpA1 - Vetor com os dados a serem gravados  		   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

Static Function CSPCO25C(cTextLinh ,cDeliText)

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//? Declaracao de Variaveis                                             ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

	Local aVetoReto := {}
	Local nContItem := 0
	Local cTrecAux1 := ""
	Local cTrecAux2 := ""
	Local cAbreCamp := ""

	/*BEGINDOC
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪腀?
	//砎erifica se o delimitador foi passado por parametro.?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪腀?
	//ENDDOC*/
	cDeliText := IIf(ValType(cDeliText) == "C", cDeliText, ";,")

	/*BEGINDOC
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?0?
	//砇etira os espacos do comeco e do fim?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?0?
	//ENDDOC*/
	cTextLinh := AllTrim(cTextLinh)

	For nContItem := 1 to Len(cTextLinh)

		/*BEGINDOC
		//谀哪哪哪哪哪哪哪哪哪哪哪哪目
		//砅ega o caracter da posi玢o?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪馁
		//ENDDOC*/
		cTrecAux1 := SubStr(cTextLinh ,nContItem ,1)

		/*BEGINDOC
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//砈e for o primeiro caracter do campo, verifica se abre com aspas?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//ENDDOC*/
		If Empty(cTrecAux2) .And. (cTrecAux1 == "'" .Or. cTrecAux1 == '"')
			cAbreCamp := cTrecAux1
		EndIf

		/*BEGINDOC
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪奶?
		//矨diciona o caracter da posi玢o?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪奶?
		//ENDDOC*/
		cTrecAux2 += cTrecAux1

		/*BEGINDOC
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//砎erifica se acabou o campo ou se acabou a linha?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//ENDDOC*/
		If nContItem == Len(cTextLinh) .Or.;
		(cTrecAux1 $ cDeliText .And. At(cAbreCamp + cTrecAux1, cTrecAux2) != 0)

			/*BEGINDOC
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//矨diciona o campo na matriz que sera retornada.?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			//ENDDOC*/
			aAdd(aVetoReto;
			,Substr(cTrecAux2 ,1 ,Len(cTrecAux2) - IIf(nContItem == Len(cTextLinh);
			.And. !(cTrecAux1 $cDeliText) ,0 ,1)))

			cTrecAux2 := ""
			cAbreCamp := ""
		Endif

	Next nContItem
Return(aVetoReto)


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 ? CSPCO25D ? Autor ? Joao Goncalves de Oliveira ? Data ? 26/09/16 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o ? Verifica lan鏰mentos que foram exclu韉os e efetua a exclus鉶 na 潮?
北?          ? Tabela para Gravacao dos Dados de Or鏰mento e/ou Realizado      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 ? CSPCO25D(ExpN1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)	 		       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros? ExpC1 - Data Inicial de Processamento						   潮?
北?          ? ExpC2 - Data Final de Processamento 							   潮?
北?          ? ExpC3 - Tabela de Grava玢o dos Dados 						   潮?
北?          ? ExpC4 - Vetor com os Dados a serem registrados 			   	   潮?
北?          ? ExpC5 - Tipo de Conta Cont醔il  								   潮?
北?          ? ExpC6 - Tipo de Movimenta玢o (O = Or鏰do ou R = Realizado) 	   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   ? Nenhum												   		   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

Static Function CSPCO25D(cDataInic,cDataFina,cTabeGrav,aListDado,cTipoResu,cTipoMovi)
                                                                                  
Local cQuryUpda := ""

For nContItem := 1 to Len(aListDado)
	cQuryUpda := " UPDATE " + cTabeGrav 
	cQuryUpda += " SET DETALHE = '" + aListDado[nContItem,2] + "'"
	cQuryUpda += " WHERE REC = '" +  aListDado[nContItem,1] + "'"
	cQuryUpda += " AND DATALCT >= '" + cDataInic + "'"
	cQuryUpda += " AND DATALCT <= '" + cDataFina + "'"
	cQuryUpda += " AND D_E_L_E_T_ = ' '"   
	                                                                      
	If cTipoResu == "D"                                    
		cQuryUpda += " AND MODELO = 'Despesas'"
	EndIf	
	If cTipoResu == "R"
		cQuryUpda += " AND MODELO = 'Receitas'"
	EndIf
	If cTipoResu == "C"			           
		cQuryUpda += " AND MODELO = 'Capex'"
	EndIf 
	If cTipoMovi == "O"                        
		cQuryUpda += " AND CLAS = 'Orcado'"
	Else                                   
		cQuryUpda += " AND CLAS = 'Realizado'"
	EndIf
	
	If ! U_CSPCO10N(cQuryUpda,"na atualiza玢o dos detalhes do registro " + Str(nContItem),.T.)
		Return
	EndIf
	IncProc("Atualizando Registro " + AllTrim(Str(nContItem)) + " da Tabela " + cTabeGrav)
Next                

Aviso("Atencao","Processamento concluido com exito",{"Ok"})	
Return