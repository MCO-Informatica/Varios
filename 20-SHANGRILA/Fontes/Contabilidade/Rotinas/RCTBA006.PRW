#Include "Totvs.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

User Function RCTBA006()

    Local nX
    Local aArea := GetArea()
    Local nDoc := 1
    Local lRet := .T.
    Local aCab := {}
    Local aItens := {}
    Local aLinha := {}
    Local dDataLanc := DATE()


    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.
    Private CTF_LOCK := 0
    Private lSubLote := .T.


    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01 " MODULO "CTB" TABLES "CT2"

    aCab := {}


    aAdd(aCab, {'DDATALANC' ,dDataBase ,NIL} )
    aAdd(aCab, {'CLOTE' ,'333333' ,NIL} )
    aAdd(aCab, {'CSUBLOTE' ,'001' ,NIL} )
    aAdd(aCab, {'CDOC' ,'000001' ,NIL} )
    aAdd(aCab, {'CPADRAO' ,'' ,NIL} )
    aAdd(aCab, {'NTOTINF' ,0 ,NIL} )
    aAdd(aCab, {'NTOTINFLOT' ,0 ,NIL} )

    //lançamento 1
    aAdd(aItens,  { {'CT2_FILIAL' ,'01' , NIL},;
        {'CT2_LINHA' , '001' , NIL},;
        {'CT2_MOEDLC' ,'01' , NIL},;
        {'CT2_DC' ,'3' , NIL},;
        {'CT2_DEBITO' ,'529999991' , NIL},;
        {'CT2_CREDIT' ,'529999991' , NIL},;
        {'CT2_VALOR' , 1 , NIL},;
        {'CT2_CCC' ,'500050299' , NIL},;
        {'CT2_CCD' ,'500040401' , NIL},;
        {'CT2_ORIGEM' ,'MSEXECAUT' , NIL},;
        {'CT2_HP' ,'' , NIL},;
        {'CT2_CONVER' ,'12221' , NIL},;
        {'CT2_HIST' ,'MSEXECCT2' , NIL} } )

    //lançamento 2
    aAdd(aItens, { {'CT2_FILIAL' ,'01' , NIL},;
        {'CT2_LINHA' , '002' , NIL},;
        {'CT2_MOEDLC' ,'01' , NIL},;
        {'CT2_DC' ,'3' , NIL},;
        {'CT2_DEBITO' ,'529999991' , NIL},;
        {'CT2_CREDIT' ,'529999991' , NIL},;
        {'CT2_VALOR' , 4000 , NIL},;
        {'CT2_CCC' ,'500050299' , NIL},;
        {'CT2_CCD' ,'500030406' , NIL},;
        {'CT2_ORIGEM' ,'MSEXECAUT' , NIL},;
        {'CT2_HP' ,'' , NIL},;
        {'CT2_CONVER' ,'12221' , NIL},;
        {'CT2_HIST' ,'MSEXECCT2LINHA2' , NIL} })

    //adicionar ao array aItens a quantidade necessária de lançamentos que deseja efetuar

    MSExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)

    If lMsErroAuto
        lMsErroAuto := .F.
        MsgAlert("ERRO Lançamento" , "Teste Carga CT2")
        mostraErro()
        //Exit
    Endif
    RestArea(aArea)

    RESET ENVIRONMENT

Return
