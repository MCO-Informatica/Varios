#INCLUDE "PROTHEUS.CH"
Static cBDGSTQ	:= AllTrim(Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		))
Static nTeste   := Iif(cBDGSTQ <> "TESTE", 1, 0)

/*/{Protheus.doc} User Function SD1140E
    ()
    @alert("teste")type  Function
    @author user
    @since 14/10/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SD1140E()
Local aAreaSD1  := SD1->(GetArea())

DbSelectArea("SD1")
SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM

If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))

    _aResult := TCSPExec("sp_nf_ent_exclui_gestoq",;
                         SF1->F1_FILIAL ,;
                         SF1->F1_DOC    ,;
                         SF1->F1_SERIE  ,;
                         SF1->F1_FORNECE,;
                         SF1->F1_LOJA   ,;
                         SM0->M0_CGC    ,;
                         nTeste)
                        
    While SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .AND. ;
          SD1->(!Eof()) 
        If !Empty(SD1->D1_IDMOVGS)
            _aResult := TCSPExec("SP_MOV_GESTOQ_ESTORNO"             ,;
                                Iif(cBDGSTQ <> "TESTE", 1, 0),;
                                SD1->D1_IDMOVGS              ,;
                                0                             ;
                                )

            If ValType(_aResult) <> "A"
                MSGAlert("Movimento não integrado com o Gestoq, entre em contato com o departamento de TI.", "Erro na integração de Estoque")
            Else
                RecLock("SD1", .F.)
                    SD1->D1_IDMOVGS := _aResult[1]
                SD1->(MsUnLock())
            EndIf
        EndIf
        SD1->(DbSkip())
    EndDo
EndIf

RestArea(aAreaSD1)
Return 
