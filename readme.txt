Kako koristiti aplikaciju.
Nakon instalacije i odgovarajućeg postavljanja antivirusa aplikacija je spremna za korištenje.
Da bi se koristila treba pripremiti excel fileove u txt formatu.
Excell tablice CROPEX i MjernoMjesto spremiti kao txt:
	1) U svakom od excella otici u Filie -> Save as -> odabrati tip (tab delimited .txt)
	2) Svakom pridodati ime (moj prijedlog je cost.txt za CROPEX i energy.txt za MjernoMjesto)
Nakon toga staviti cost.txt i energy.txt u prazan folder.
Navigirati se u taj folder u FileExploreru.
U adresnu liniju foldera upisati "cmd". To će pokrenuti komandnu ljiniju.

U komandnoj liniji napisati:
"SOLEKUM-merger -c cost.txt -e energy.txt"

Ovo će izvršiti kalkulacije i kao rezultat dati "results.csv" file koji je excell tablica.