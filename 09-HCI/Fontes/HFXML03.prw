#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HFXML03   � Autor � AP6 IDE            � Data �  28/04/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function HFXML03()
Local lValidEmp := .T.
Private cCadastro := "Cadastro de Amarra��o Produto do Fornecedor/Cliente X Nosso Produto"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZB5"

    dVencLic := Stod(Space(8))
 	lUsoOk := U_HFXML00X("HF000001","101",SM0->M0_CGC,@dVencLic)  

//lUsoOk := U_HFXML00X("HF000001","101",SM0->M0_CGC)

If !lUsoOk
	Return(Nil)
EndIf


DbSelectArea("ZB5")
DbSetOrder(1)


DbSelectArea(cString)
MBrowse( 6,1,22,75,cString)

Return


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_HFXML03()
	EndIF
Return(lRecursa)