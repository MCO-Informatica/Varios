USER FUNCTION A410CONS
    Local _aBut:= {}

    Aadd(_aBut,{"NOTE",{|| U_RFATA03(SC5->C5_CLIENTE)},"Liberar","Obs. Coml."})
    if !INCLUI .and. !ALTERA
       Aadd(_aBut,{"NOTE",{|| U_RFATA08(m->c5_num) },"Forma Pagto","Forma Pagto Diversos"})
    endif

Return (_aBut)
