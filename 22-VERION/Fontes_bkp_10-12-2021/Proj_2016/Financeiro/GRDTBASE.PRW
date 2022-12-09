User Function GRDTBASE()

Return(Strzero(Day(DDataBase),2)+Strzero(Month(DDataBase),2)+Substr(Str(Year(DDataBase),4),3,2))


User Function GRDTBAS4()

Return(Strzero(Day(DDataBase),2)+Strzero(Month(DDataBase),2)+Str(Year(DDataBase),4))


User Function GRDTVENR()

Return(Strzero(Day(SE2->E2_VENCREA),2)+Strzero(Month(SE2->E2_VENCREA),2)+Substr(Str(Year(SE2->E2_VENCREA),4),3,2))


User Function GRDTVEN4()

Return(Strzero(Day(SE2->E2_VENCREA),2)+Strzero(Month(SE2->E2_VENCREA),2)+Str(Year(SE2->E2_VENCREA),4))


User Function VLDOCTO()

_VlrDocto := STRZERO(INT(SE2->E2_VALOR*100),13)

Return(_VlrDocto)


User Function VLPAGTO()

_VlPagto := STRZERO(INT((SE2->E2_VALOR*100)-(SE2->E2_DECRESC*100)+(SE2->E2_JUROS*100)+(SE2->E2_MULTA*100)),13)

Return(_VlPagto)
