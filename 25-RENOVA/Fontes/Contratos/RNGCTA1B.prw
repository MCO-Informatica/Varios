#INCLUDE "PROTHEUS.CH"    
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RNGCTA1B º Autor                       º Data ³  Set/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Alteracoes na tabela CN9.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Renova                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RNGCTA1B()

Local oLabel1		:= Nil 
Local oLabel2		:= Nil 
Local oLabel3		:= Nil 
Local oLabel4		:= Nil 
Local oLabel5		:= Nil 
Local oLabel6		:= Nil 
Local oLabel7		:= Nil 
Local oLabel8		:= Nil 
Local oLabel9		:= Nil 
Local oLabel10		:= Nil 
Local oLabel11		:= Nil 
Local oLabel12		:= Nil 
Local oLabel13		:= Nil 
Local oLabel14		:= Nil 
Local oLabel15		:= Nil 
Local oLabel16		:= Nil 
Local oLabel17		:= Nil 
Local oLabel18		:= Nil 
Local oLabel19		:= Nil 
Local oLabel20		:= Nil
Local oLabel21		:= Nil
Local oLabel22		:= Nil
 
Local ocContra		:= Nil 
Local ocRevisa		:= Nil 
Local odDtIni		:= Nil 
Local odDtFim		:= Nil 
Local odDtAss		:= Nil 
Local onVigenc		:= Nil 
Local ocUnVig		:= Nil 
Local ocTpCto		:= Nil 
Local ocCodObj		:= Nil 
Local ocCondPg		:= Nil 
Local ocIndice		:= Nil 
Local ocReaj		:= Nil 
Local ocXTipo		:= Nil 

Local onXPerAd		:= Nil 

Local cContra		:= "" 
Local cRevisa		:= "" 
Local dDtIni		:= CTOD("") 
Local dDtFim		:= CTOD("") 
Local dDtAss		:= CTOD("") 
Local nVigenc		:= 0
Local cUnVig		:= "" 
Local cTpCto		:= "" 
Local cCodObj		:= "" 
Local cCondPg		:= "" 
Local cIndice		:= "" 
Local cReaj			:= "" 
Local cXTipo		:= "" 
Local nXPerAd		:= 0 
Local cCPDir		:= ""

Local cMemo_Obj		:= ""
 
Local _cAlias    	:= "CN9"
Local _nReg      	:= Recno()
Local _nOpc      	:= 4                               
Local _aCpos     	:= {}
Local _lOk       	:= .F.
Local _aSize     	:= MsAdvSize()
Local _aPosObj   	:= {}
Local _aObjects  	:= {}
Local _cCadastro 	:= "Manutencao de Contratos - Alteracao especifica"
Local _aTela     	:= {}
Local _aGets     	:= {}
Local _oDlg
Local _nOpcA     	:= 0

Local aTela[0][0]
Local aGets[0]
Local _nCntFor 		:= 0
Local _nPosCpo 		:= 0

Local lOk 			:= .F.
Local aItens		:= {"Sim","Nao"}
Local aItens2		:= {"Sim","Nao"}
Local oCombo1		:= Nil
Local oCombo2		:= Nil
Local lContinua		:= .T.

Private oDlg		:= Nil 
Private ocXCodGe	:= Nil 
Private ocXGrpRe	:= Nil 
Private ocXGesto	:= Nil 
Private ocXCodUs	:= Nil 
Private ocXUnidR	:= Nil 
Private ocAprov		:= Nil
Private ocNature	:= Nil 

Private cXCodGe		:= "" 
Private cXGrpRe		:= "" 
Private cXGesto		:= "" 
Private cXCodUs		:= "" 
Private cXUnidR		:= "" 
Private cAprov		:= ""
Private cNature		:= ""

Private aRet		:= {}

// Faz a carga do vetor com todos os usuarios do sistema para a validacao do código do usuario
//aRet := AllUsers() 

//DEF_TRAALT "039"
lContinua := CN240VldUsr(CN9->CN9_NUMERO,"039",.T.)//Visualiza Contrato

If	!lContinua
	Return
EndIf


cContra		:= CN9->CN9_NUMERO 
cRevisa		:= CN9->CN9_REVISA
dDtIni		:= CN9->CN9_DTINIC 
dDtFim		:= CN9->CN9_DTFIM
dDtAss		:= CN9->CN9_DTASSI
nVigenc		:= CN9->CN9_VIGE
cUnVig		:= ""	//CN9->CN9_UNVIGE
cTpCto		:= CN9->CN9_TPCTO
cCodObj		:= ""	//CN9->CN9_OBJCTO
cCondPg		:= CN9->CN9_CONDPG
cIndice		:= CN9->CN9_INDICE
cReaj		:= ""	//CN9->CN9_FLGREJ
cXTipo		:= CN9->CN9_XTIPO
cXCodGe		:= CN9->CN9_XCODGE
cXGrpRe		:= CN9->CN9_XGRPRE
cXGesto		:= CN9->CN9_XGESTO
nXPerAd		:= CN9->CN9_XPERAD
cXCodUs		:= CN9->CN9_XCODUS
cXUnidR		:= CN9->CN9_XUNIDR
cAprov		:= CN9->CN9_APROV
cCPDir		:= ""
cNature		:= CN9->CN9_NATURE


// Unidade de Vigencia
// 1=Dias;2=Meses;3=Anos;4=Indeterminada
Do 	Case
	Case CN9->CN9_UNVIGE == "1"
		 cUnVig	:= "Dias"

	Case CN9->CN9_UNVIGE == "2"
		 cUnVig	:= "Meses"

	Case CN9->CN9_UNVIGE == "3"
		 cUnVig	:= "Anos"

	Case CN9->CN9_UNVIGE == "4"
		 cUnVig	:= "Indeterminada"

EndCase


// Reajuste S/N
If	CN9->CN9_FLGREJ == ""
	cReaj	:= aItens[2]
	
Else
	If 	CN9->CN9_FLGREJ == "1"
		cReaj	:= aItens[1]
	EndIf

	If 	CN9->CN9_FLGREJ == "2"
		cReaj	:= aItens[2]
	EndIf

EndIf

// Objeto do contrato - MEMO
cCodObj := MSMM(CN9->CN9_CODOBJ)

/*
// Compra Direta S/N
If	CN9->CN9_XCPDIR == ""
	cCPDir	:= aItens2[2]
	
Else
	If 	CN9->CN9_XCPDIR == "1"
		cCPDir	:= aItens2[1]
	EndIf

	If 	CN9->CN9_XCPDIR == "2"
		cCPDir	:= aItens2[2]
	EndIf

EndIf  
 */

// Monta tela
DEFINE MSDIALOG oDlg TITLE _cCadastro From _aSize[7],00 To _aSize[6],_aSize[5] OF oMainWnd PIXEL


oLabel1			 := TSay():New( 35	,25	,{|| "Nro do Contrato" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,78,13)
oLabel2			 := TSay():New( 35	,100,{|| "Revisao" 			},	oDlg,,,.F.,.F.,.F.,.T.,,,53,13)
oLabel8			 := TSay():New( 35	,175,{|| "Tp. Contrato" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,62,13)

oLabel3			 := TSay():New( 60	,25	,{|| "Data Inicio" 		},	oDlg,,,.F.,.F.,.F.,.T.,,,55,13)
oLabel4			 := TSay():New( 60	,100,{|| "Data Final " 		},	oDlg,,,.F.,.F.,.F.,.T.,,,55,13)
oLabel5			 := TSay():New( 60	,175,{|| "Data Assinatura"	},	oDlg,,,.F.,.F.,.F.,.T.,,,49,13)

oLabel6			 := TSay():New( 85	,25	,{|| "Vigencia" 		},	oDlg,,,.F.,.F.,.F.,.T.,,,39,13)
oLabel7			 := TSay():New( 85	,100,{|| "Un. Vigencia" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,59,13)

oLabel9			 := TSay():New( 110	,25	,{|| "Objeto" 			},	oDlg,,,.F.,.F.,.F.,.T.,,,33,13)


oLabel10		 := TSay():New( 165	,25 ,{|| "Cond. Pagto." 	},	oDlg,,,.F.,.F.,.F.,.T.,,,64,13)
oLabel11		 := TSay():New( 165	,100,{|| "Indice" 			},	oDlg,,,.F.,.F.,.F.,.T.,,,29,13)
//oLabel21		 := TSay():New( 165	,175,{|| "Compra Direta ?"	},	oDlg,,,.F.,.F.,.F.,.T.,,,59,13)

oLabel12		 := TSay():New( 190	,25	,{|| "Reajuste S/N" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,63,13)
//oLabel13		 := TSay():New( 210	,100,{|| "Pref Num Con" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,66,13)
oLabel17		 := TSay():New( 190	,100,{|| "% Adiantamen" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,71,13)
oLabel22		 := TSay():New( 190	,175,{|| "Natureza" 		},	oDlg,,,.F.,.F.,.F.,.T.,,,65,13)

oLabel19		 := TSay():New( 215	,25 ,{|| "Unid. Requis" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,60,13)
oLabel14		 := TSay():New( 215	,100,{|| "Cod.Gestor" 		},	oDlg,,,.F.,.F.,.F.,.T.,,,55,13)
oLabel16		 := TSay():New( 215	,175,{|| "Gestor Contr" 	},	oDlg,,,.F.,.F.,.F.,.T.,,,62,13)

oLabel15		 := TSay():New( 240	,25 ,{|| "Aprov.  Rev." 	},	oDlg,,,.F.,.F.,.F.,.T.,,,62,13)
oLabel18		 := TSay():New( 240	,100,{|| "Cod.Usuario" 		},	oDlg,,,.F.,.F.,.F.,.T.,,,59,13)
oLabel20		 := TSay():New( 240	,175,{|| "Grupo Aprov." 	},	oDlg,,,.F.,.F.,.F.,.T.,,,65,13)


ocContra		 := TGet():New( 45	,25	,	bSETGET( cContra 	),	oDlg,60,10,"@!",,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
ocRevisa		 := TGet():New( 45	,100,	bSETGET( cRevisa 	),	oDlg,30,10,"@!",,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
odDtIni			 := TGet():New( 70	,25	,	bSETGET( dDtIni 	),	oDlg,60,10,,,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
odDtFim			 := TGet():New( 70	,100,	bSETGET( dDtFim 	),	oDlg,60,10,,,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
odDtAss			 := TGet():New( 70	,175,	bSETGET( dDtAss 	),	oDlg,60,10,,,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
onVigenc		 := TGet():New( 95	,25	,	bSETGET( nVigenc 	),	oDlg,30,10,,,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
ocUnVig			 := TGet():New( 95	,100,	bSETGET( cUnVig 	),	oDlg,60,10,,,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.) 
ocTpCto			 := TGet():New( 45	,175,	bSETGET( cTpCto 	),	oDlg,60,10,,,,,,.F.,,.T.,,.T.,{||.F.},,,,.F.)


SE4->(DbSetOrder(1))	//  E4_FILIAL +  E4_CODIGO
CN6->(DbSetOrder(1))	// CN6_FILIAL + CN6_CODIGO
SZ2->(DbSetOrder(1))	//  Z2_FILIAL +  Z2_COD
SAL->(DbSetOrder(1))	//  AL_FILIAL +  AL_COD
SY3->(DbSetOrder(1))	//  Y3_FILIAL +  Y3_COD


@ 120,25 	GET ocCodObj 	VAR cCodObj MEMO SIZE 230, 40 PIXEL OF oDlg 

																						
@ 175,25  	MSGET ocCondPg 	VAR cCondPg 	F3 "SE4"	;
			Valid SE4->(DbSeek(xFilial("SE4")+ Alltrim(cCondPg))) .AND. Alltrim(cCondPg) == Alltrim(SE4->E4_CODIGO)	;					
			PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
			
@ 175,100	MSGET ocIndice 	VAR cIndice 	F3 "CN6"	;
			Valid CN6->(DbSeek(xFilial("CN6")+ Alltrim(cIndice))) .AND. Alltrim(cIndice) == Alltrim(CN6->CN6_CODIGO) ;	
			PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
			
oCombo2 := TComboBox():New(175,175,{|u|if(PCount()>0,cCPDir:=u,cCPDir)},aItens2,60,10,oDlg,,,,,,.T.,,,,,,,,,'cCPDir')

oCombo1 := TComboBox():New(200,25,{|u|if(PCount()>0,cReaj:=u,cReaj)},aItens,60,10,oDlg,,,,,,.T.,,,,,,,,,'cReaj')

//@ 220,100	MSGET ocXTipo 	VAR cXTipo	 	F3 "SZ2"	Valid Empty(cXTipo) .OR. SZ2->(DbSeek(xFilial("SZ2")+ Alltrim(cXTipo)))		PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
@ 200,100	MSGET onXPerAd 	VAR nXPerAd 				Valid IIF((nXPerAd)>30,(MsgAlert("So e permitido adiantamento igual ou inferior a 30% do valor do contrato!!!"),.F.),.T.) 	PICTURE "@E 999" 	SIZE 60, 10 OF oDlg PIXEL HASBUTTON
@ 200,175 	MSGET ocNature 	VAR cNature 	F3 "SED"	;
			Valid SED->(DbSeek(xFilial("SED")+ Alltrim(cNature) ) )		; 
			PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON



@ 225,25	MSGET ocXUnidR 	VAR cXUnidR 	F3 "SY3"	;
			Valid SY3->(DbSeek(xFilial("SY3")+ Alltrim(cXUnidR))) .AND. Alltrim(cXUnidR) == Alltrim(SY3->Y3_COD) .AND. U_RNVlUnid() ;	
			PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
			
@ 225,100 	MSGET ocXCodGe 	VAR cXCodGe														When .F.	PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
@ 225,175	MSGET ocXGesto 	VAR cXGesto 													When .F.	PICTURE "@!" 		SIZE 80, 10 OF oDlg PIXEL HASBUTTON

@ 250,25	MSGET ocXGrpRe 	VAR cXGrpRe		F3 "SAL"										When .F.	PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
@ 250,100 	MSGET ocXCodUs 	VAR cXCodUs 	F3 "USR"	Valid UsrExist(cXCodUs)				When .F.    PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON
@ 250,175	MSGET ocAprov 	VAR cAprov 		F3 "SAL"	 									When .F.	PICTURE "@!" 		SIZE 60, 10 OF oDlg PIXEL HASBUTTON



_aPosEnch := { 1,  1,oDlg:nClientHeight /3 + 65, 655 }


ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()}))

If	lOk
	

	RecLock("CN9",.F.)
	  
	CN9->CN9_CONDPG 	:= cCondPg
	CN9->CN9_INDICE 	:= cIndice    
	CN9->CN9_FLGREJ 	:= iIf( cReaj == "Sim","1","2")
	CN9->CN9_XTIPO		:= cXTipo
	CN9->CN9_XCODGE 	:= cXCodGe
	CN9->CN9_XGRPRE 	:= cXGrpRe
	CN9->CN9_XGESTO 	:= cXGesto
	CN9->CN9_XPERAD 	:= nXPerAd
	CN9->CN9_XCODUS 	:= cXCodUs
	CN9->CN9_XUNIDR 	:= cXUnidR
	CN9->CN9_APROV  	:= cAprov
 //	CN9->CN9_XCPDIR		:= iIf( cCPDir == "Sim","1","2")
	CN9->CN9_NATURE		:= cNature

	CN9->(MsUnlock())


	MSMM(,60,,cCodObj,1,,,"CN9","CN9_CODOBJ")
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RNVlUnid º Autor ³ Fabio Jadao Caires  º Data ³  10/10/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescr.    ³ Funcao que valida a unidade e dispara os demais gatilhos   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Renova                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RNVlUnid()


cXCodGe := SY3->Y3_XAPROV
cAprov	:= SY3->Y3_GRAPROV
cXGesto	:= Alltrim( UsrFullName(SY3->Y3_XAPROV) ) 
cXGrpRe := SY3->Y3_GRAPROV


ocXCodGe:Buffer := cXCodGe
ocAprov :Buffer	:= cAprov
ocXGesto:Buffer	:= cXGesto
ocXGrpRe:Buffer	:= cXGrpRe

ocXCodGe:Refresh()
ocAprov :Refresh()
ocXGesto:Refresh()
ocXGrpRe:Refresh()


Return

