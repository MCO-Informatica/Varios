#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

//Documentação PE Afterlogin
//@https://tdn.totvs.com/pages/viewpage.action?pageId=6815186
User Function AfterLogin()

SQLSD2()

Return

static function SQLSD2()


Begin Transaction

     
    //Monta o Update
    cQryUpd := " UPDATE SD2010 "
    cQryUpd += " SET D2_CUSTO1 = D2_TOTAL " 
    cQryUpd += " WHERE "
    cQryUpd += " D2_CUSTO1 = 0 "
    
 
    //Tenta executar o update
    nErro := TcSqlExec(cQryUpd)
     
    //Se houve erro, mostra a mensagem e cancela a transação
    If nErro != 0
        MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
        DisarmTransaction()
    EndIf
End Transaction


RETURN
