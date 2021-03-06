/*D***********************************************************
 * Modul:     DBI - database select
 *            get a HOST DLG_PARTS from a DL
 *
 * Copyright: yafra.org, Basel, Switzerland     
 **************************************************************/
#include <mpmain.h>
#include <mpproapi.h>		/* Prototypes f�r ANSI-C */
#include <mpsqlsel.h>

static char rcsid[]="$Header: /yafra/cvsroot/mapo/source/api/SelectTDL.c,v 1.2 2008-11-02 19:55:48 mwn Exp $";

/*************************************************************
 * function:  get a HOST-TDL from a DL
 *
 * return:    found/ok or not found
 *************************************************************/
int MPAPIselectTDL(int dl_id, DLG_PART *Ptdl)
{
	extern MEMOBJ apimem;
	extern char sqlquery[];
	DLG_DLG *Pdl_dl;
	DLG_PART tdl;
	int id;
	int anzahl;
	int status = (int)MPOK;

	(void)sprintf(sqlquery, _SEL_DLDLG, dl_id);
	status = MPAPIdb_sqlquery((int)_DLG_DLG, &apimem.buffer, sqlquery,
	       &anzahl, &apimem.datalen, &apimem.alloclen);
	if (status == (int)MPOK && anzahl > 0)
		{
		Pdl_dl = (DLG_DLG *)apimem.buffer;
		id = MPAPIselectOneId((int)_DLG_PART, Pdl_dl[0].dl_id, (char *)Ptdl);
		if (id != (int)_UNDEF && Ptdl->h_dl_id != (int)_UNDEF)
			id = MPAPIselectOneId((int)_DLG_PART, Ptdl->h_dl_id, (char *)Ptdl);
		if (id == (int)_UNDEF)
			status = (int)MPERROR;
		}
	else
		status = (int)MPERROR;

	return(status);
}

/*************************************************************
 * function:  make a bez-string for TDL
 *
 * return:    found/ok or not found
 *************************************************************/
int MPAPIselectTDLbez(int tdlid, int sid, char *bezeichnung, int len)
{
	extern DLG_PART tdl;

	int status = (int)MPOK;
	int id;
	char tmp_bez1[_BEZLEN+1];
	char tmp_bez2[_BEZLEN+1];
	struct tm DateTime;

	id = MPAPIselectOneId((int)_DLG_PART, tdlid, (char *)&tdl);
	if (id != (int)_UNDEF)
		{
		(void)memset((void *)&DateTime, NULL, sizeof(DateTime));
		DateTime.tm_min  = (int)_UNDEF;
		DateTime.tm_hour = (int)_UNDEF;
		DateTime.tm_mday = (int)_UNDEF;
		DateTime.tm_mon  = (int)_UNDEF;
		DateTime.tm_year = (int)_UNDEF;

		(void)SelectBez((int)_DLG_PART, sid, tdl.bez_id, tmp_bez2);
		(void)copyTextTo(tmp_bez1, (char *)tmp_bez2, (int)_BEZLEN);
		(void)WriteDate(&DateTime, (time_t *)&tdl.a_zeit, tmp_bez2);
		(void)sprintf(bezeichnung, "%s%s%s%s%s", tmp_bez1, TRENNER, tmp_bez2);
		}
	else
		status = MPE_NOENTRYFOUND;

	return(status);
}
