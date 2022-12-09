Static cBDGSTQ	:= AllTrim(Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		))
Static nTeste   := Iif(cBDGSTQ <> "TESTE", 1, 0)
/*/{Protheus.doc} User Function SF1140I
    (long_description)
    @type  Function
    @author user
    @since 25/09/2020
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @see (links_or_references)
/*/
User Function SF1140I()
Local lInclui   := PARAMIXB[1]
Local lAltera   := PARAMIXB[2]
Local _aResult  := {}
Local aAreaSD1  := SD1->(GetArea())
Local nIdNotaG  := 0

/* Chamada da Proc
 exec sp_mov_gestoq(@PRODUTO    (VARCHAR(15))  ,
					@QTD		(INT)  ,
					@VLR_UN		(FLOAT),
					@DOC		(INT)  ,
					@CGC_EMP	VARCHAR(18),
					@ID_FORNEC	INT		,
					@DATA		DATETIME,
					@AMBPROD	BIT)
*/

If lInclui
    DbSelectArea("SD1")
    SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM


    If !AllTrim(RetCodUsr()) $ "000115|000110|000004" 
        nIdNotaG := IntegraNF(SF1->(Recno()))

        If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
            While SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .AND. SD1->(!Eof())
                If Empty(SD1->D1_TES)
                    _aResult := TCSPExec("sp_mov_gestoq"    ,;
                                        SD1->D1_COD         ,;
                                        SD1->D1_QUANT       ,;
                                        SD1->D1_VUNIT       ,;
                                        Val(SD1->D1_DOC)         ,;
                                        SM0->M0_CGC         ,;
                                        Val(SD1->D1_FORNECE),;
                                        dDataBase           ,;
                                        Iif(cBDGSTQ <> "TESTE", 1, 0),;
                                        nIdNotaG,;
                                        SD1->D1_LOTEFOR,;
                                        0;
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
    EndIf



ElseIf lAltera .AND. !Empty(SD1->D1_IDMOVGS)
    DbSelectArea("SD1")
    SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM

    If !AllTrim(RetCodUsr()) $ "000115|000110|000004|" 
        If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
            
            nIdNotaG := IntegraNF(SF1->(Recno()))

            While SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .AND. SD1->(!Eof())
                If Empty(SD1->D1_TES)
                    _aResult := TCSPExec(;
                                            "sp_mov_gestoq_alt"             ,;
                                            SD1->D1_COD                     ,;
                                            SD1->D1_QUANT                   ,;
                                            SD1->D1_VUNIT                   ,;
                                            Val(SD1->D1_DOC)                ,;
                                            SM0->M0_CGC                     ,;
                                            Val(SD1->D1_FORNECE)            ,;
                                            dDataBase                       ,;
                                            Iif(cBDGSTQ <> "TESTE", 1, 0)   ,;
                                            SD1->D1_IDMOVGS                 ,;
                                            SD1->D1_LOTEFOR                  ;
                                        )

                    If ValType(_aResult) <> "A"
                        MSGAlert("Movimento não integrado com o Gestoq, entre em contato com o departamento de TI.", "Erro na integração de Estoque")
                    Else
                        //RecLock("SD1", .F.)
                            //SD1->D1_IDMOVGS := _aResult[1]
                        //SD1->(MsUnLock())
                    EndIf
                EndIf

                SD1->(DbSkip())
            EndDo
        EndIf
    EndIf
EndIf

RestArea(aAreaSD1)
Return

/*/{Protheus.doc} IntegraNF
    (Efetua a integração de NF, Item e Lote para o gestoq)
    @type  Static Function
    @author Pirolo
    @since 29/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function IntegraNF(nRecnF1)
Local aAreaSF1 := SF1->(GetArea())
Local aAreaSD1 := SD1->(GetArea())

//Posiciona no Cabaçalho da NF
SF1->(DbGoto(nRecnF1))

_aResult := TCSPExec("sp_nf_ent_cabec_gestoq",;
                     SF1->F1_FILIAL ,;
                     SF1->F1_DOC    ,;
                     SF1->F1_SERIE  ,;
                     SF1->F1_FORNECE,;
                     SF1->F1_LOJA   ,;
                     SM0->M0_CGC    ,;
                     nTeste         ,;
                     0)

If ValType(_aResult) <> "A"
    MSGAlert("Falha na integração de NFs no Gestoq, entre em contato com a TI.", "Erro na integração Gestoq")
Else
    //Id da NF no Gestoq
    nIdNotaGst := _aResult[1]

    //Integra os itens da NF
    If SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
        While SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .AND. SD1->(!Eof())
            _aResult := TCSPExec("sp_nf_ent_item_gestoq",;
                                                            SD1->(RECNO()),;
                                                            nTeste,;
                                                            nIdNotaGst,;
                                                            0)

            //Verifica se a integração ocorreu com sucesso
            If ValType(_aResult) <> "A"
                MSGAlert("Falha na integração do item ."+SD1->D1_COD, "Erro na integração de Estoque")
            EndIf

            SD1->(DbSkip())
        
        EndDo

    EndIf

EndIf

RestArea(aAreaSF1)
RestArea(aAreaSD1)
Return nIdNotaGst
