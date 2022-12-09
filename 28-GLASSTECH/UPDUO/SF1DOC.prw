USER FUNCTION SF1DOC()

If !Empty(M->F1_SERIE) .AND. VAL(M->F1_SERIE) >= 0 .AND. VAL(M->F1_SERIE) <= 9
 
M->F1_SERIE := StrZero(VAL(M->F1_SERIE),3)
cSerie := StrZero(VAL(cSerie),3)
Endif  

Return(.T.)
