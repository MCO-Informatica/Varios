#include "protheus.ch"
#include "rwmake.ch"
/*
|================================================================|
|Programa.: 	PCLib  				    		 |
|Autor....:	Alcouto						 |
|Data.....: 26/06/2021						 |
|Descricao: 	Rotina utilizada para ajustar a data de entrega	 |
|  			1) Opcao para confirmar	                 |
|			2) Opcao cancelar                        |
|			3) Valida acesso a rotina		 |
|Uso......: 	Renova Energia				         |
|================================================================|
*/

User function PClib()

Local _aArea  := GetArea()
Local _cNumPC := SC7->C7_NUM
//Local _cLibPC := Alltrim(GetMV('MV_XLIBPC'))// CRIAR PARAMETRO para pegar o codigo dos usuários que tem acesso a ajustar a data do pedido de compras.
Local oButton1
Local oGet1
Local dGet1 := Date()
Local oSay1
Local oSay2
Local _lOk  := .F.
Local _lOk1 := .F.
Static oDlg

//_lOk := (__CUSERID) $ _cLibPC    // USUARIO 000722/000711
//If !_lOk
  //  MsgInfo("Colaborador sem Permissão de acesso a Rotina")
	//Return
//EndIf

_lOK1 := SC7->C7_QUJE == 0 .and. SC7->C7_QTDACLA == 0
If !_lOk1
    MsgInfo("Pedido ja sofreu movimentação, AJUSTE NÃO PERMITIDO")
	Return
EndIf
        //STYLE DS_MODALFRAME remove o botão fechar
        DEFINE MSDIALOG oDlg TITLE "Ajustar Data de Entrega" FROM 000, 000  TO 180, 200 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
        oDlg:lEscClose := .F. // remove a opção Esc
        //@ 248, 249 SAY oSay1 PROMPT "oSay1" SIZE 025, 009 OF oDlg COLORS 0, 16777215 PIXEL
        @ 016, 009 SAY oSay2 PROMPT "Nova Data de Entrega" SIZE 084, 011 OF oDlg COLORS 0, 16777215 PIXEL
        @ 032, 009 MSGET oGet1 VAR dGet1 SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL
        //oButton1:= TButton():New(057,009, "Confirmar",oDlg,{||oDlg:End()}, 80,009,,,.F.,.T.,.F.,,.F.,,,.F. )
        @ 052,009 BUTTON "Confirmar" SIZE 075,010 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL 
        @ 072,009 BUTTON "Cancelar " SIZE 075,010 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL                       

    ACTIVATE MSDIALOG oDlg CENTERED

        If nOpc == 1 //Botão confirmar
                nOk := Aviso("Atencao!","Ao confirmar este processo as datas de entrega serão atualizadas. Confirma a Nova Data ? ",{"Cancelar","Confirma"},2)
                If  nOk == 2 .AND. dGet1 > dDataBase // Confirma a nova data

                        DbSelectArea("SC7")
                        SC7->(dbSetOrder(1))
                        SC7->(dbSeek(XFilial("SC7")+_cNumPC))
                        
                        While !SC7->(Eof()) .and. SC7->C7_FILIAL == XFilial("SC7") .and. SC7->C7_NUM == _cNumPC
                            RecLock("SC7", .F.)
                            SC7->C7_DATPRF  := dGet1
                            MsUnlock()
                            DbSkip()
                        Enddo
                        MsgInfo("Data Ajustada com Sucesso!!!")
                elseif  nOk == 1
                        MsgInfo("Ajuste Cancelado!!!")
                else
                        MsgInfo("Não foi possivel ajustar a data para o Pedido de compras: "+SC7->C7_NUM+Chr(13)+Chr(10)+;
			                    "A data selecionada precisa ser MAIOR QUE A DATA DE HOJE!!!")
                Endif
        Endif
RestArea(_aArea)
Return
