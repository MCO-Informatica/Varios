#INCLUDE "protheus.ch"  
#Include "TopConn.ch"                     

#DEFINE nOCORREN 1 //posicao da ocorrencia no array aProc
#DEFINE nASSUNTO 2 //posicao do assunto no array aProc
#DEFINE nDESCOCO 3 //posicao da descricao da ocorrencia no array aProc
#DEFINE nGRUPO   4 //posicao do grupo no array aProc
#DEFINE nDESGRU  5 //posicao da descricao do gurpo no array aProc
#DEFINE nPERGUNT 6 //posicao da pergunta no array aProc
#DEFINE nRESPOST 7 //posicao da resposta no array aProc  
#DEFINE nPRODUTO 8 //posicao da resposta no array aProc
#DEFINE nDESCPRO 9 //posicao da resposta no array aProc
#DEFINE nSZLREC 10 //posicao do registro na tabela              

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fonte com  rotinas de cadastro e visualiza��o de FAQ do chat           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MBrwSZL     �  OPVS                    � Data �  14/09/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Trata o cadastro de FAQ do chat, tabela SZL                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MBrwSZL


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Cadastro de FAQ"


Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZL"               

Private aCampos := {  {"Ocorrencia","ZL_OCORREN"},;
					  {"Assunto","ZL_ASSUNTO"},;
					  {"Grupo","ZL_GRUPO"},;
					  {"Produto","ZL_PRODUTO"},;    
					  {"Pergunta","ZL_PERGUNT"},;
					  {"Resposta","ZL_RESPOST"} }


dbSelectArea("SZL")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,aCampos)

Return

//User Function 
                      


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F3SZL �Autor  �OPVS                    � Data �  16/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Busca especifica para o cadastro de FAQ                     ���
���          �agendamento de internacao.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Chat - Service Desk                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F3SZL()  

Local cResp := ""
Local cSqlRet	:= ""        
Private  oButton
Private oCombo
Private oCond


Private aProc		:= {}		// Vetor utilizado para trazer os procedimentos
Private nOpcI		:= 2
Private cTitulo	:= "Consulta FAQ"
Private nRecno	:= 0
Private aOrd		:= {'Ocorrencia + Assunto', 'Grupo + Produto','Descricao da Ocorrencia'} //ordens de pesquisa
Private cCombo	:= aOrd[1]
Private cCond		:= Space(40) 

Private cCadastro := "Cadastro de FAQ"      
 


   
cSqlRet := "SELECT SZL.ZL_OCORREN, SZL.ZL_ASSUNTO ,SZL.ZL_DESCOCO, SZL.ZL_GRUPO, SZL.ZL_DESCGRU, SZL.ZL_PERGUNT, SZL.ZL_RESPOST"
cSqlRet += ", SZL.ZL_PRODUTO, SZL.ZL_DESCPRO, SZL.R_E_C_N_O_ SZLREC FROM " + RetSqlName("SZL") + " SZL"
cSqlRet += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' AND SZL.D_E_L_E_T_ = ' '"

cSqlRet += " ORDER BY ZL_OCORREN "

cSqlRet := ChangeQuery(cSqlRet)
TCQUERY cSqlRet NEW ALIAS "TMPSZL"


DbSelectArea("TMPSZL")



If TMPSZL->(!Eof())
	TMPSZL->(DbGoTop())
	While TMPSZL->(!Eof())
		Aadd( aProc,{TMPSZL->ZL_OCORREN,;
		TMPSZL->ZL_ASSUNTO,; 
		TMPSZL->ZL_DESCOCO,;        
		TMPSZL->ZL_GRUPO,; 
		TMPSZL->ZL_DESCGRU,; 
		TMPSZL->ZL_PERGUNT,;                                                                                              
		TMPSZL->ZL_RESPOST,;
		TMPSZL->ZL_PRODUTO,;
		TMPSZL->ZL_DESCPRO,;
		TMPSZL->SZLREC})
		//SZL->ZL_REGPOS})
		TMPSZL->(DbSkip())
	End
	
	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+ 
	
	If Len( aProc ) == 0
		Aviso( cTitulo, "N�o existe FAQs a consultar", {"Ok"} )
		Return(.F.)
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 320,500 PIXEL
	
	oCombo 	:= tComboBox():New(10, 10, {|x| If(PCount() > 0, cCombo := x, cCombo)}, aOrd, 100, 20, oDlg, , {|| HS_MudaOrd(cCombo, @aProc, @oLbx, @oLbx2)},,,,.T.,,,,,,,,,'cCombo')
	@ 25, 10 MSGET oCond VAR cCond PICTURE "@!" SIZE 180, 10 OF oDlg PIXEL
	oButton := tButton():New(25, 195, 'Pesquisar', oDlg, {|| HS_ProcPro(cCombo, cCond, @aProc, @oLbx, @oLbx2)}, 45, 12, , , , .T.)// /*.F. Caracter .T. pixel*/, /*Reservado*/, /*Reservado*/, /*Reservado*/, /*Bloco de Codigo*/, /*Reservado*/, /*Reservado*/)
	
	//ListBox para busca por Grupo
	@ 40,10 LISTBOX oLbx2 FIELDS HEADER ;
	"Grupo", "Produto","Desc Produto","Pergunta", "Resposta";
	SIZE 230,095 OF oDlg PIXEL ON DblClick(cResp := aProc[oLbx2:nAt,nRESPOST],oDlg:End())
	
	oLbx2:SetArray( aProc )
	oLbx2:bLine := {||{aProc[oLbx:nAt,nGRUPO],;
	aProc[oLbx2:nAt,nPRODUTO],;
	aProc[oLbx2:nAt,nDESCPRO],;
	aProc[oLbx2:nAt,nPERGUNT],;
	aProc[oLbx2:nAt,nRESPOST]}}	
	oLbx2:hide()
	
	//ListBox para busca por Ocorrencia
	@ 40,10 LISTBOX oLbx FIELDS HEADER ;
	"Ocorrencia", "Assunto","Desc. Ocorrencia", "Pergunta", "Resposta";
	SIZE 230,095 OF oDlg PIXEL ON DblClick(cResp := aProc[oLbx:nAt,nRESPOST],oDlg:End())
	

	oLbx:SetArray( aProc )
	oLbx:bLine := {||{aProc[oLbx:nAt,nOCORREN],;
	aProc[oLbx:nAt,nASSUNTO],;
	aProc[oLbx:nAt,nDESCOCO],;
	aProc[oLbx:nAt,nPERGUNT],;
	aProc[oLbx:nAt,nRESPOST]}}
	
	//bota visualizar
	@ 137,120 BUTTON oButtView Prompt  "Visualizar"	 SIZE 40,12 PIXEL OF oDlg ACTION	{|| IIF(cCombo == "Grupo + Produto";
		, x:= oLbx2, x:= oLbx), dbSelectArea("SZL"),dbGoto(aProc[x:nAt,nSZLREC]),;
		AxVisual("SZL",aProc[x:nAt,nSZLREC],1) }
                     
	//botao ok
	DEFINE SBUTTON FROM 137,183 TYPE 1 ACTION {|| IIF(cCombo == "Grupo + Produto",cResp := aProc[oLbx2:nAt,nRESPOST],cResp := aProc[oLbx:nAt,nRESPOST]);
	,oDlg:End()} ENABLE OF oDlg	
	//botao cancelar
	DEFINE SBUTTON FROM 137,213 TYPE 2 ACTION {|| nOpcI := 2, oDlg:End()} ENABLE OF oDlg			
	ACTIVATE MSDIALOG oDlg CENTER
	
	

EndIf

DbSelectArea("TMPSZL")
TMPSZL->(DbCloseArea())

Return  cResp


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HS_MudaOrd�Autor  �OPVS                � Data �  19/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao criada que modifica a ordem da consulta de  FAQ      ���
���          �Por ocorrencia ou grupo                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Chat - Service Desk                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HS_MudaOrd(cCombo, aProc, oLbx, oLbx2)




If cCombo == "Grupo + Produto"
  
	//ordenando grupo + produto
	aProc := aSort(aProc,,,{|x,y| x[nGRUPO] < y[nGRUPO]})              
	aProc := aSort(aProc,,,{|x,y| IIF (x[nGRUPO] == y[nGRUPO], x[nPRODUTO] < y[nPRODUTO], x[nGRUPO] < y[nGRUPO]) })
	
	oLbx2:nAt := 1
	oLbx2:SetArray( aProc )
	oLbx2:bLine := {	||{aProc[oLbx2:nAt,nGRUPO],;
	aProc[oLbx2:nAt,nPRODUTO],;
	aProc[oLbx2:nAt,nDESCPRO],;
	aProc[oLbx2:nAt,nPERGUNT],;
	aProc[oLbx2:nAt,nRESPOST]}}
	

    oLbx:hide()
	oLbx2:Show()
	oLbx2:Refresh()   
	oLbx2:SetFocus()             
	
	

	
Else

	IF cCombo == "Ocorrencia + Assunto"
	
		//ordenando ocorrencia + assunto
		aProc := aSort(aProc,,,{|x,y| x[nOCORREN] < y[nOCORREN]})
		aProc := aSort(aProc,,,{|x,y| IIF (x[nOCORREN] == y[nOCORREN], x[nASSUNTO] < y[nASSUNTO], x[nOCORREN] < y[nOCORREN]) })
	Else                                                         
	
		aProc := aSort(aProc,,,{|x,y| x[nDESCOCO] < y[nDESCOCO]})
	
	Endif
	
	oLbx:nAt := 1
	oLbx:SetArray( aProc )
	oLbx:bLine := {||{aProc[oLbx:nAt,nOCORREN],;
	aProc[oLbx:nAt,nASSUNTO],;
	aProc[oLbx:nAt,nDESCOCO],;
	aProc[oLbx:nAt,nPERGUNT],;
	aProc[oLbx:nAt,nRESPOST]}}
	
	oLbx2:hide()
	oLbx:Show()
	oLbx:Refresh()   
	oLbx:SetFocus()
	

EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HS_ProcPro�Autor  �Opvs                � Data �  19/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pesquisa o FAQ de acordo com a selecao do combo             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Chat - Service Desk                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HS_ProcPro(cCombo, cCond, aProc, oLbx, oLbx2)
 
Local nPosCond	:= 1       
Local nPlus := 0    
Local aBusca := {}



cCond :=  Alltrim(cCond) 

aBusca := STRTOKARR(cCond,"+")



If cCombo == "Grupo + Produto"    

	IF (len(aBusca) > 1)
                  
	    nPosCond := aScan (aProc, {|x| SubStr(x[nGRUPO],1,len(aBusca[1])) == Alltrim (aBusca[1]) .AND.;
							SubStr(x[nPRODUTO],1,len(aBusca[2])) == Alltrim (aBusca[2])})
	
	Else

	nPosCond := aScan(aProc, {|x| SubStr(x[nGRUPO],1,Len(cCond)) == cCond}) 
	EndIF

	
		
ElseIf cCombo == "Ocorrencia + Assunto"   
    
	IF (len(aBusca) > 1)
                  
	    nPosCond := aScan (aProc, {|x| SubStr(x[nOCORREN],1,len(aBusca[1])) == Alltrim (aBusca[1]) .AND.;
						   	SubStr(x[nASSUNTO],1,len(aBusca[2])) == Alltrim (aBusca[2])})
	
	Else                                                                                           
		nPosCond := aScan(aProc, {|x| SubStr(x[nOCORREN],1,Len(cCond)) == cCond})
	
	Endif
	
	
Else

	nPosCond := aScan(aProc, {|x| SubStr(x[nDESCOCO],1,Len(cCond)) == cCond})
EndIf


//��������������������������������������������������������������������������Ŀ
//� Atualiza browse...                                                       �
//����������������������������������������������������������������������������
If nPosCond > 0
	
	
	If cCombo == "Grupo + Produto"   
	    
		oLbx2:nAt := nPosCond	
		oLbx2:SetArray(aProc)   
		oLbx2:bLine := {||{aProc[oLbx2:nAt,nGRUPO],;
		aProc[oLbx2:nAt,nPRODUTO],;
		aProc[oLbx2:nAt,nDESCPRO],;
		aProc[oLbx2:nAt,nPERGUNT],;
		aProc[oLbx2:nAt,nRESPOST]}}
		oLbx2:Refresh()
		oLbx2:SetFocus()
		
		
	
	Else
	
		oLbx:nAt := nPosCond	
		oLbx:SetArray(aProc) 
		oLbx:bLine := {||{aProc[oLbx:nAt,nOCORREN],;
		aProc[oLbx:nAt,nASSUNTO],;
		aProc[oLbx:nAt,nDESCOCO],;
		aProc[oLbx:nAt,nPERGUNT],;
		aProc[oLbx:nAt,nRESPOST]}}
		oLbx:Refresh()
		oLbx:SetFocus()                    
		
	Endif
	
	
Else
	
EndIf
Return
