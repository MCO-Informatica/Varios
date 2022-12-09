#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 � CSPCO025 � Autor � Joao Goncalves de Oliveira � Data � 11/08/14 ���
������������������������������������������������������������������������������Ĵ��
���Descri??o � Rotina de Atualizacao do Detalhe a Partir de Planilha CSV  	   ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 � U_CSPCO025()                  				          		   ���
������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum 														   ���
������������������������������������������������������������������������������Ĵ��
�� Retorno   � Nenhum												   		   ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
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
Local cTituRoti := "Manuten��o do Detalhe dos Movimentos Realizados"
Local nPosiHori
Local nPosiVert
Local cLoadPerg := "CSPCO025"
Local lSalvPara := .T.
Local lUserSave := .T.
Local cTabeGrav := ""
Local cTipoResu := ""
Local cTipoMovi := ""

Static aPergReto := {}

Private cCadastro := "Manuten��o do Detalhe dos Movimentos Realizados"
Private aRotina := {}
Private bBuscArqu := {|| CSPCO25A()}

aAdd(aParamBox,{1,"Pasta para Leitura do Arquivo",Padr("",150),"@!","IIf(Empty(mv_par01),Eval(bBuscArqu),mv_par01)",,"",120,.T.})
aAdd(aParamBox,{1,"Data Inicial",CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data Final " ,CTOD(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{2,"Tipo de Contas ",1, {"Despesas","Receitas","Capex","Todas"} , 50, '.T.', .T.})
aAdd(aParamBox,{2,"Tipo Movimento",2, {"Or�ado","Realizado"}  , 50, '.T.', .T.})


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
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 � CSPCO25A � Autor � Joao Goncalves de Oliveira � Data � 10/12/15 ���
������������������������������������������������������������������������������Ĵ��
���Descri??o � Busca Arquivo para processamento                 		       ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CSPCO25A()								         	   		   ���
������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum 														   ���
������������������������������������������������������������������������������Ĵ��
�� Retorno   � Nenhum 														   ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

Static Function CSPCO25A()
Local cCamiArqu

cCamiArqu := cGetFile('Arquivo CSV|*.CSV','Selecione Arquivo',1,'C:\',.T.,GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE,.F.)

mv_par01 := cCamiArqu
Return                                  


/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 � CSPCO25B � Autor � Joao Goncalves de Oliveira � Data � 26/09/16 ���
������������������������������������������������������������������������������Ĵ��
���Descri??o � Efetua leitura e atualizacao do campo Detalhe nos Registros	   ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CSPCO25B(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)	   	   		   ���
������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Caminho do Arquivo a ser importado 					   ���
���          � ExpC2 - DAta Inicial de Processamento 						   ���
���          � ExpC3 - Data Final de Processamento 	 					       ���
���          � ExpC4 - Tabela de Grava��o dos Dados 	 					   ���
���          � ExpC5 - Tipo de Contas 					 					   ���
���          � ExpC6 - Tipo de Movimenta��o (Or�ado ou Realizado 			   ���
������������������������������������������������������������������������������Ĵ��
�� Retorno   � ExpA1 - Vetor com os dados a serem gravados  		   		   ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
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

		IncProc("Varrendo arquivo de importa��o ... " + StrZero(nContLinh ++,4))

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

		MsgInfo('N�o foram encontrados registros para importa��o',cCadastro)

	EndIf

Return



/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 � CSPCO25C � Autor � Joao Goncalves de Oliveira � Data � 01/09/16 ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � Converte Texto em Vetor utilizado o delimitador passado como    ���
���  		 � par�metro 													   ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CSPCO25C(ExpC1,ExpC2)									       ���
������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Caminho do Arquivo a ser importado 					   ���
���          � ExpC2 - Campo Delimitador 									   ���
������������������������������������������������������������������������������Ĵ��
�� Retorno   � ExpA1 - Vetor com os dados a serem gravados  		   		   ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

Static Function CSPCO25C(cTextLinh ,cDeliText)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local aVetoReto := {}
	Local nContItem := 0
	Local cTrecAux1 := ""
	Local cTrecAux2 := ""
	Local cAbreCamp := ""

	/*BEGINDOC
	//�����������������������������������������������������@�
	//�Verifica se o delimitador foi passado por parametro.�
	//�����������������������������������������������������@�
	//ENDDOC*/
	cDeliText := IIf(ValType(cDeliText) == "C", cDeliText, ";,")

	/*BEGINDOC
	//�������������������������������������0�
	//�Retira os espacos do comeco e do fim�
	//�������������������������������������0�
	//ENDDOC*/
	cTextLinh := AllTrim(cTextLinh)

	For nContItem := 1 to Len(cTextLinh)

		/*BEGINDOC
		//��������������������������Ŀ
		//�Pega o caracter da posi��o�
		//����������������������������
		//ENDDOC*/
		cTrecAux1 := SubStr(cTextLinh ,nContItem ,1)

		/*BEGINDOC
		//���������������������������������������������������������������Ŀ
		//�Se for o primeiro caracter do campo, verifica se abre com aspas�
		//�����������������������������������������������������������������
		//ENDDOC*/
		If Empty(cTrecAux2) .And. (cTrecAux1 == "'" .Or. cTrecAux1 == '"')
			cAbreCamp := cTrecAux1
		EndIf

		/*BEGINDOC
		//�������������������������������̿
		//�Adiciona o caracter da posi��o�
		//���������������������������������
		//ENDDOC*/
		cTrecAux2 += cTrecAux1

		/*BEGINDOC
		//�����������������������������������������������Ŀ
		//�Verifica se acabou o campo ou se acabou a linha�
		//�������������������������������������������������
		//ENDDOC*/
		If nContItem == Len(cTextLinh) .Or.;
		(cTrecAux1 $ cDeliText .And. At(cAbreCamp + cTrecAux1, cTrecAux2) != 0)

			/*BEGINDOC
			//����������������������������������������������Ŀ
			//�Adiciona o campo na matriz que sera retornada.�
			//������������������������������������������������
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
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 � CSPCO25D � Autor � Joao Goncalves de Oliveira � Data � 26/09/16 ���
������������������������������������������������������������������������������Ĵ��
���Descri??o � Verifica lan�amentos que foram exclu�dos e efetua a exclus�o na ���
���          � Tabela para Gravacao dos Dados de Or�amento e/ou Realizado      ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 � CSPCO25D(ExpN1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)	 		       ���
������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Data Inicial de Processamento						   ���
���          � ExpC2 - Data Final de Processamento 							   ���
���          � ExpC3 - Tabela de Grava��o dos Dados 						   ���
���          � ExpC4 - Vetor com os Dados a serem registrados 			   	   ���
���          � ExpC5 - Tipo de Conta Cont�bil  								   ���
���          � ExpC6 - Tipo de Movimenta��o (O = Or�ado ou R = Realizado) 	   ���
������������������������������������������������������������������������������Ĵ��
�� Retorno   � Nenhum												   		   ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
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
	
	If ! U_CSPCO10N(cQuryUpda,"na atualiza��o dos detalhes do registro " + Str(nContItem),.T.)
		Return
	EndIf
	IncProc("Atualizando Registro " + AllTrim(Str(nContItem)) + " da Tabela " + cTabeGrav)
Next                

Aviso("Atencao","Processamento concluido com exito",{"Ok"})	
Return