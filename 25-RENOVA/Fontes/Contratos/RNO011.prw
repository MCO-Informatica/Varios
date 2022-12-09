#Include 'Protheus.ch'
#include "RNO010.CH"
#include 'FWBROWSE.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} 

@author Bruno Melo
@since 08/05/2019
@version 12.1.17
/*/
//Log de Interface de Importacção Codigo de Barras Financeiro
//-------------------------------------------------------------------


User Function RNO011()

                Local aArea   := GetArea()
                Local cTitulo       := "Log de Interface de Importacção Codigo de Barras Financeiro"
                Local cFunBkp := FunName()
                Local oBrowse
                
                SetFunName("RNO011")
                
                oBrowse := FWMBrowse():New()
                
                oBrowse:SetAlias("ZZP")
                oBrowse:SetDescription(cTitulo)
                oBrowse:Activate()
                
                SetFunName(cFunBkp)
                RestArea(aArea)

Return

/* MenuDef */
Static Function MenuDef()

                Local aRotina := {}
                
                ADD OPTION aRotina TITLE "Pesquisar"               ACTION 'PesqBrw'                           OPERATION 1 ACCESS 0
                ADD OPTION aRotina TITLE "Visualizar"                ACTION "VIEWDEF.RNO011" OPERATION 2 ACCESS 0
                
Return aRotina

/* ModelDef */
Static Function ModelDef()

                Local oStruZZP := FWFormStruct( 1, 'ZZP' )
                Local oModel 

                oModel := MPFormModel():New('RNO011M' )
                oModel:AddFields( 'ZZPMASTER', /*cOwner*/, oStruZZP)
                oModel:SetDescription( 'Registro de Log de Interface de Importacao Codigo de Barras Financeiro' )
                oModel:SetPrimaryKey({})

Return oModel

/* ViewDef */
Static Function ViewDef()
                
                Local oModel := FWLoadModel( 'RNO011' )
                Local oStruZZP := FWFormStruct( 2, 'ZZP' )
                Local oView

                oView := FWFormView():New()
                oView:SetModel( oModel )
                oView:AddField( 'VIEW_ZZP', oStruZZP, 'ZZPMASTER' )
                oView:CreateHorizontalBox( 'MAIN' , 100 )
                oView:SetOwnerView( 'VIEW_ZZP', 'MAIN' )

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} 

@author Bruno Melo
@since 08/05/2019
@version 12.1.17
/*/
//Grava log importação Codigo de Barras Financeiro - Contas a pagar.
//-------------------------------------------------------------------
				
User Function RNOLOG(cTitu,cFornec,cLoja,lRetCad,cArqTrab,cFilPg)

	If lRetCad ==1 
	 	cStatus := STR0016//Cod de Barras Incluido com Sucesso
	ElseIf lRetCad == 2 
		cStatus := STR0018//Erro na Inclusão Verificar Numero do Titulo 
	ElseIf lRetCad == 3 
		cStatus := STR0024+cCampo//Erro na Inclusão Verificar Campo	 	
	EndIf

	dbSelectarea("ZZP")
	dbSetOrder(2)
	If empty(dbSeek(xFilial("ZZP")+cFornec+cLoja+cTitu+cArqTrab,))
		RecLock("ZZP",.T.) 
		ZZP->ZZP_FILIAL	:= xFilial("ZZP")
		ZZP->ZZP_NUM     	:= cTitu
		ZZP->ZZP_FORNEC	:= cFornec
		ZZP->ZZP_LOJA		:= cLoja
		ZZP->ZZP_STATUS 	:= cStatus
		ZZP->ZZP_DATA  	:= Ddatabase
		ZZP->ZZP_HOR     	:= Time()
		ZZP->ZZP_CHAVE    := cArqTrab
		ZZP->ZZP_FILPAG    := cFilPg
		MsUnlock()
	EndIf
	
	dbSelectArea("ZZP")
	dbCloseArea()


	
Return

User Function RNOCLOGV(cArqTrb)
Local cAlias		:= GetNextAlias()
Local aOp         := {}

BeginSql Alias cAlias

SELECT * FROM %Table:ZZP% ZZP
WHERE ZZP_CHAVE=%Exp:cArqTrb% 


EndSql

	(cAlias)->(DBGOTOP())
	While !(cAlias)->(EOF())
		AADD(aOp,{(cAlias)->(ZZP_NUM),(cAlias)->(ZZP_FORNEC),(cAlias)->(ZZP_LOJA),(cAlias)->(ZZP_STATUS),(cAlias)->(ZZP_HOR)})
	(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())
 	
 	U_LgCampos(aOp)	
	
	

Return



User Function LgCampos(aCampFa)

Local aBotoes	:= {}    
Local oBtnSlv     
Private oLista                    
Private aCabecalho  := {}         
Private aColsEx 	:= {}         

 
    DEFINE MSDIALOG oDlg TITLE "CONSULTA LOG IMPORTAÇÃO CÓDIGO DE BARRAS FINANCEIRO" FROM 000, 000  TO 300, 700  PIXEL
        //chamar a função que cria a estrutura do aHeader
        CarHead()
 
        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 053, 078, 415, 180, /*GD_INSERT+GD_DELETE+GD_UPDATE*/, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", "AllwaysTrue",0, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
 
        //Carregar os itens que irão compor o conteudo do grid
        CarCamps(aCampFa)
 
        //Alinho o grid para ocupar todo o meu formulário
        oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
 
       // Ao abrir a janela o cursor está posicionado no meu objeto
        oLista:oBrowse:SetFocus()
 
        //Crio o menu que irá aparece no botão Ações relacionadas
        //aadd(aBotoes,{"NG_ICO_IMP", {||LgCampIm(aCampFa)},"Impressão","Impressão"})
 		//@ 127, 004 BUTTON oBtnSlv PROMPT "&Salvar em .txt" SIZE 051, 019 ACTION (LgCampIm(aCampFa)) OF oDlgMens PIXEL
        EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)
 
    ACTIVATE MSDIALOG oDlg CENTERED
Return

Static Function CarCamps(aCampFa)

Local i := 0
      
    For i := 1 to len(aCampFa)

           aadd(aColsEx,{aCampFa[i,1],aCampFa[i,2],aCampFa[i,3],aCampFa[i,4],aCampFa[i,5],.F.})

    Next
 
    //Setar array do aCols do Objeto.
    oLista:SetArray(aColsEx,.T.)
 
    //Atualizo as informações no grid
    oLista:Refresh()
Return


Static Function CarHead()

    Aadd(aCabecalho, {;
                  "NUMERO",;//X3Titulo()
                  "NUMERO",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  9,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "COD_FORNECEDOR",;//X3Titulo()
                  "COD_FORNECEDOR",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  9,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "LOJA",;//X3Titulo()
                  "LOJA",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  2,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "STATUS",;	//X3Titulo()
                  "STATUS",;  	//X3_CAMPO
                  "@!",;		//X3_PICTURE
                  20,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  " ",;		//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN

    
    Aadd(aCabecalho, {;
                  "HORA",;	//X3Titulo()
                  "HORA",;  	//X3_CAMPO
                  "@!",;		//X3_PICTURE
                  8,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  " ",;		//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN    

Return





