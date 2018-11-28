
{ Logik }
{ Lucia Tódová, 1. ročník, 41. skupina }
{ zimný semester 2016/17 }
{ Programování NPRG030 }

program project1;
uses sysutils, crt;

 var variacie: array[1..1296] of string; {vsetky mozne variacie}
                                         {v kazdom cykle (po kazdej nasej odpovedi na otazku programu) sa niektore "vyhodia" - nahradia nulou}
     vsetkyMoznosti: array[1..1296] of string; {vsetky mozne variacie, prvky tohto pola sa po deklaracii nemenia}
     odpoved: array [1..4] of integer; {v tomto poli je nacitana nasa odpoved, v kazdom cykle sa meni}
     vsetkyOdpovede: array[1..14] of string; {pole vsetkych moznych odpovedi, ktore mozeme dostat}
     prazdnyRiadok: string; {pouzity v procedure vsetkyVariacie, inak nie je nikde pouzity}
     poradieRiadku: integer; {pouzity v procedure vsetkyVariacie, inak nie je nikde pouzity}
     vysledok: string; {kym si program nie je isty hadanou kombinaciou, je to '', potom je do tejto premennej dosadene hadana kombinacia}
     pocetZostavajucichMoznosti: integer; {zacina ako 1296, pri kazdom vyhodeni kombinacie sa znizi
                                          je to vlastne pocet nenulovych miest v poli variacie
                                          je tu len na to, aby vysetrovala pripad, ked nam zostane len 1 moznost - rovno ju vypise}
     pocetPokusov: integer; {po deklaracii 0, v kazdom cykle sa zvysi o 1, rata, na kolko pokusov program uhadne nasu kombinaciu}
     k: integer; {pouzite iba ako pomocna premenna, na prehladavanie/nacitavanie do pola v hlavnej casti programu}
     chr: char; {pouziva sa na ukoncenie programu (stlac lubovolnu klavesnicu na ukoncenie)}


procedure zoradOdpoved(); {zoradi pole s nasou odpovedou podla velkosti cisel, najprv 2ky, 1ky, posledne 0}
 var i, j, pom: integer;
begin
  {bubble sort algoritmus}
  for i:= 1 to 4 do
   for j:= 1 to 3 do
     if odpoved[j] < odpoved[j+1] then
       begin
         pom:= odpoved[j];
         odpoved[j]:= odpoved[j+1];
         odpoved[j+1]:= pom;
       end;
end;
                          {robi priamo s globalnou premennou odpoved}

procedure nacitajVsetkyMozneOdpovedeDoPola(); {do glob. pola vsetkyOdpovede nacita vsetky mozne odpovede, ako mozeme odpovedat (po zoradeni)}
begin
  {moznosti 2222 a 2221 chybaju (2221 nikdy nemoze nastat, 2222 znamena, ze su vsetky spravne - to sa osetruje uz na zaciatku)}
  vsetkyOdpovede[1]:= '2211';
  vsetkyOdpovede[2]:= '2200';
  vsetkyOdpovede[3]:= '2111';
  vsetkyOdpovede[4]:= '2110';
  vsetkyOdpovede[5]:= '2100';
  vsetkyOdpovede[6]:= '2000';
  vsetkyOdpovede[7]:= '1111';
  vsetkyOdpovede[8]:= '1110';
  vsetkyOdpovede[9]:= '1100';
  vsetkyOdpovede[10]:= '1000';
  vsetkyOdpovede[11]:= '0000';
  vsetkyOdpovede[12]:= '2211';
  vsetkyOdpovede[13]:= '2220';
  vsetkyOdpovede[14]:= '2210';
end;

procedure vsetkyVariacie(var riadok: string; k, n: integer) {rekurzivne najde vsekty variacie k prvkov z n, zapisuje ich do pola variacie};
  var i: integer;
      riadokPOM: string;
begin
  if k = 0 then
     begin {ak mame variaciu ulozenu v premennej riadok, zapiseme ju do pola variacie}
       variacie[poradieRiadku]:= riadok;
       inc(poradieRiadku);
     end
  else
    begin
      {rekurzia}
      for i:= 1 to n do
      begin
        riadokPOM:= riadok;
        riadok:= riadok + IntToStr(i);
        vsetkyVariacie(riadok, k-1, n);
        riadok:= riadokPOM;
      end;
    end;
end;

function zmenCiselnuVariaciuNaPismena(var ret: string): string; {funkcia cisto pre vypis, cisla 1-6 ulozene v poli variacie/vsetkyMoznosti zmeni na pismena A-F}
  var i: integer;
      pismeno: char;
      novy: string;
begin
  novy:= '';
  for i:= 1 to 4 do
   begin
     case ret[i] of
       '1': pismeno:= 'A';
       '2': pismeno:= 'B';
       '3': pismeno:= 'C';
       '4': pismeno:= 'D';
       '5': pismeno:= 'E';
       '6': pismeno:= 'F';
     end;
     novy:= novy + pismeno + ' ';
   end;
  zmenCiselnuVariaciuNaPismena:= novy;
end;

function porovnajOdpovede(var spravnaOdpoved: array of integer; s1, s2: string): boolean; {porovna dve variacie, a napise ich 'vysledok', ten porovna so spravnou odpovedou}
 { spravnaOdpoved - je to pole s odpovedou, ktoru sme zadali mi na predchadzajucu otazku, uz je zoradene pomocou zoradOdpoved()
   s1, s2 - su to dve ciselne variacie, s1 je variacia, na ktoru sme sa pytali v predchadzajucom kroku, s2 je variacia s ktorou to porovnavame
   priebeh funkcie - vezme stringy s1, s2, navzajom ich porovna, v miestach kde sa uplne zhoduju da 2, da 1, pokial sa zhoduju ale cislo je
                     na inom mieste, 0 pokial su cisla uplne rozdielne. Tento vysledok (4miestne cislo) ulozi do lokalnej premennej
                     vysledok, ktoru potom porovna so spravnou odpovedou - pokial je tato tato odpoved rovnaka, funkcia nadobudne hodnotu true,
                     v opacnom pripade nadobudne hodnotu false }

 var l, j, miesto: integer; {l, j sluzia iba na prehladavanie retazcov, miesto je index v poli vysledok, ktoremu chceme priradit ciselnu hodnotu}
     vysledok: array [1..4] of integer;
     res: boolean; {pouzivame miesto toho aby sme priamo pouzivali porovnajOdpovede, na konci porovnajOdpovede nadobudne hodnotu, aku ma res}
begin
  miesto:= 1;
  for l:= 1 to 4 do vysledok[l]:= 0; {zaciname s tym, ze je vsade 0}
  {ako prve ideme zaplnat dvojkami, aby bolo pole vysledok zoradene a teda by sme ho mohli rovno porovnavat s polom spravnaOdpoved
   nasledujuci for cyklus prejde oba stringy a porovna ich, pokial su na ich miestach rovnake cisla,
   do vysledku da 2 a tieto miesta vynuluje aby sa predislo problemom neskor}
  for l:= 1 to 4 do
    if s1[l] = s2[l] then
       begin
         s1[l]:= '0';
         s2[l]:= '0';
         vysledok[miesto]:= 2;
         inc(miesto);
       end;
  {uz mame 2ky, pokracujeme jednotkami
   nasledujuce for cykly prechadzaju oba retazce, porovnavaju kazdy znak s kazdym a pokial tento znak nie je 0 a znaky sa rovnaju,
   znamena to, ze sa tieto cisla nachadzaju v oboch poliach len na inom mieste - preto sa do pola vysledok prida 1ka a tieto miesta
   v stringoch sa vynuluju}
  for l:= 1 to 4 do
    for j:= 1 to 4 do
      if ((s1[l]= s2[j]) and (s1[l]<>'0') and (s2[j]<>'0')) then
        begin
          s1[l]:= '0';
          s2[j]:= '0';
          vysledok[miesto]:= 1;
          inc(miesto);
        end;
  {nasledujuci while cyklus doplni do zvysnych miest pola vysledok nuly}
  while miesto < 4 do
    begin
      vysledok[miesto]:= 0;
      inc(miesto);
    end;
  {uz mame pole vysledok, prechadzame teraz na porovnavanie dvoch poli
   premennu res si nastavime defaultne na true, prechadzame polia pomocou premennej l
   pokial sa niektore miesto v jednom poli nezhoduje s tym istym v druhom, res sa nastavi na false}
  res:= true;
  for l:= 1 to 4 do
    begin
      if vysledok[l] <> spravnaOdpoved[l-1] then {l-1 tam musi byt z toho dovodu, ze spravnaOdpoved je dynamicke pole - ine indexovanie}
        res:= false;
    end;
  porovnajOdpovede:= res;
end;

function nacitajOdpoved(): boolean; {do glob. pola odpoved nacitava odpoved na otazku, nie je zoradena, je true ak je odpoved 2222, inak false}
  var pom, i: integer; {i pouzivame iba na prechadzanie cyklu, pom je pomocna premenna pomocou ktorej nacitavame}
      spravna: boolean; {defaulte je true, pokial vsak je akekolvek miesto v poli odpoved ine ako 2, meni sa na false}
begin
  spravna:= true;
  for i:= 1 to 4 do
   begin
     read(pom);
     {nasledujuci while cyklus zabezpecuje, ze program vypise chybu, pokial sa zada chybna odpoved}
     while ((pom<>1) and (pom<>2) and (pom<>0)) do
       begin
         writeln('Zadal si zlu odpoved, skus znova');
         read(pom);
       end;
      odpoved[i]:= pom;
      if pom <> 2 then spravna:= false; {meni sa na false, ak je lubovolne miesto v poli ine ako 2}
   end;
  nacitajOdpoved:= spravna;
end;

function ZistiMinimumEliminovanychMoznosti(var moznost: string): integer; {zistuje, kolko moznosti sa prinajhorsom eliminuje, keby je moznost najblizsi tip}
 {premenna moznost ma v sebe ulozenu variaciu z pola vsetkyMoznosti (4miestne cislo)
  priebeh funkcie: pouzivame pole vsetkyOdpovede, ktore obsahuje vsetky mozne odpovede, ktore mozu nastat
                   ku kazdej z tychto odpovedi priradime cislo, kolko by sa eliminovalo moznosti z pola variacie, keby nastane tato odpoved
                   tieto cisla ukladame do pomocneho lokalneho pola pocetMoznosti
                   najmensie cislo z pola pocetMoznosti bude teda minimum eliminovanych moznosti}

  var pocetMoznosti: array[1..14] of integer;
      jednaOdpoved: array[1..4] of integer; {string jednaOd zmenime na pole pre lahsie prehladavanie}
      i, l, minimum: integer; {i, l su pomocne premenne len na prehladavanie poli, minimum obsahuje minimum eliminovanych moznosti celkovo}
      jednaOd: string; {jedna odpoved z pola vsetkyOdpovede}
begin
  {deklaracia}
  minimum:= 1296; {viacej moznosti sa urcite dat eliminovat nemoze dat}
  for i:= 1 to 14 do
   pocetMoznosti[i]:= 0;

  {pomocou premennej i prechadzame pole vsetkych moznych odpovedi}
  for i:= 1 to 14 do
   begin
     {nacitanie jednej odpovede do pola jednaOdpoved}
     jednaOd:= vsetkyOdpovede[i];
     for l:= 1 to 4 do jednaOdpoved[l]:= StrToInt(jednaOd[l]);

     {pomocou premennej l prechadzame pole variacie, pokial je ine ako 0, zistime pomocou porovnajOdpovede(),
      ci by tato odpoved eliminovala tuto variaciu, pokial ano, zvysime pocetMoznosti, ktore by tato odpoved eliminovala
      (z toho dovodu inc(pocetMoznosti[i]))}
     for l:= 1 to 1296 do
     begin
       if variacie[l]<>'0' then
        if porovnajOdpovede(jednaOdpoved, variacie[l], moznost) = false then
         inc(pocetMoznosti[i]);
     end;
     {pokial je pocetMoznosti pre tuto jednu odpoved mensi ako minimum, pocetMoznosti musi byt nove minimum}
     if pocetMoznosti[i] < minimum then minimum:= pocetMoznosti[i];
   end;
  zistiMinimumEliminovanychMoznosti:= minimum;
end;

function ZistiDalsiTip(): string {funkcia, ktora zisti najlepsi dalsi tip};
 {priebeh funkcie: ku kazdej z moznosti v poli vsetkyMoznosti (co je pole vsetkych moznych variacii, ktore mozu nastat)
  priradime cislo, ktore reprezentuje, kolko minimalne moznosti z pola variacie by sa eliminovalo, keby sa na tuto otazku spytame
  toto robime pomocou funkcie zistiMinimumEliminovanychMoznosti, touto funkciou teda prebehne kazda jedna kombinacia z pola vsetkyMoznosti
  a jej vysledky sa ukladaju do lokalnej premennej pocetMoznosti
  z tohto pola potom vyberieme najvacsie cislo (pokial je ich viac, vyberame prve) a kombinaciu,
  ku ktorej je priradene - na tuto kombinaciu sa potom spytame}
  var i, max: integer; {i - pomocna premenna na prechadzanie pola, max - maximalny pocet eliminovanych moznosti}
      miesto: integer; {je to index, na ktorom sa nachadza najvacsie cislo v poli pocetMoznosti a teda index miesta vo vsetkyMoznosti -
                        na konci funkcie, ked uz mame zisteny dalsi tip, sa tento tip vymaze z pola vsetkyMoznosti, aby sa zabranilo
                        opakovanemu tipovaniu toho isteho cisla}
      maxTip: string; {variacia v poli vsetkyMoznosti, ku ktorej patri cislo max}
      pocetMoznosti: array[1..1296] of integer;
begin
  {deklaracia, zaciname od 0}
  max:= 0;
  maxTip:= '';
  {prechadzame pomocou premennej i pole vsetkyMoznosti}
  for i:= 1 to 1296 do
  begin
    pocetMoznosti[i]:= zistiMinimumEliminovanychMoznosti(vsetkyMoznosti[i]);
    {pokial je to variacia so zatial najvacsim poctom eliminovanych moznosti a na tuto moznost sme sa este nepytali,
     dosadime si tuto do maxTip a pocet nou eliminovanych moznosti za max - zatial je to najvhodnejsi najblizsi tip}
    if pocetMoznosti[i] > max then
      if vsetkyMoznosti[i]<>'0' then
        begin
          max:= pocetMoznosti[i];
          maxTip:= vsetkyMoznosti[i];
          miesto:= i;
        end;
  end;
  {v maxTip je teraz ulozena variacia, pomocou ktorej eliminujeme najviac moznosti - cize sa na nu chceme spytat}
  ZistiDalsiTip:= maxTip;
  vsetkyMoznosti[miesto]:= '0'; {sluzi preto, aby sme sa na tuto otazku uz nespytali}
end;

procedure spravDalsiTip(); {procedura prevedie dalsi tip - spyta sa, nacita odpoved, vyhodi nehodiace sa variacie z pola variacie}
 var i: integer; {pomocna premenna pouzita len na prechadzanie pola}
     otazka: string; {nova otazka, na ktoru sa program spyta}
begin
  {pokial je pocetZostavajucichMoznosti 1, znamena to, ze je uz len jedna moznost, ktora by to mohla byt
   v tomto pripade prejdeme cele pole variacie, najdeme tu jednu kombinaciu ktora to je, a tu ulozime do glob. premennej vysledok
   tymto funkcia konci}
  if pocetZostavajucichMoznosti = 1 then
   begin
     for i:= 1 to 1296 do
       if variacie[i]<> '0' then
        vysledok:= variacie[i];
   end
  else
  {pripad ze pocetZostavajucichMoznosti je iny ako 1, treba teda zistit novy tip}
   begin
     otazka:= zistiDalsiTip(); {do otazky si nacitame novy tip pomocou funkcie zistiDalsiTip()}
     inc(pocetPokusov); {kedze mame novu otazku na ktoru sa ideme pytat, musi byt aj pocet pokusov vacsi}
     writeln(zmenCiselnuVariaciuNaPismena(otazka)); {spytame sa}
     {nacitame odpoved pomocou nacitajOdpoved(), pokial je true, cize su vsetky 2ky, nasli sme nasu kombinaciu a funkcia sa tu moze skoncit
      pokial nie, prejdeme do else}
     if nacitajOdpoved() = true then
      vysledok:= zmenCiselnuVariaciuNaPismena(otazka)
     else
      begin
        zoradOdpoved();
        {opat musime prejst pole variacie a "vyhodit" z neho nehodiace sa moznosti - co robi nasledujuci for cyklus}
        for i:= 1 to 1296 do
          if variacie[i]<> '0' then
            if porovnajOdpovede(odpoved, variacie[i], otazka) = false then
              begin
                variacie[i]:= '0';
                dec(pocetZostavajucichMoznosti);
              end;
      end;
   end;
end;


begin

  {privitanie, predstavenie hry}

  writeln ('Vitaj v hre logik!');
  writeln ('Pravidla su nasledujuce: ');
  writeln ('1. Napis si kombinaciu styroch pismen A-F na papier (pismena sa mozu opakovat)');
  writeln ('2. Program polozi tip - kombinacia styroch pismen');
  writeln ('3. Odpovedaj cislami:');
  writeln('0 - pismeno sa v tvojej kombinacii nenachadza, 1 - nachadza sa tam, ale je na zlom mieste, 2 - nachadza sa na spravnom mieste');
  writeln('4. Pokracuj, dokym program neuhadne spravnu kombinaciu, ktoru vzapati s poctom pokusov vypise');

  {deklaracia premennych}

  pocetZostavajucichMoznosti:= 1296;
  vysledok:= '';
  pocetPokusov:= 0;
  nacitajVsetkyMozneOdpovedeDoPola(); //do pola vsetkyOdpovede

  {nacitanie do pola variacie a vsetkyMoznosti}

  poradieRiadku:= 1;
  prazdnyRiadok:= '';
  vsetkyVariacie(prazdnyRiadok, 4, 6);
  //naplnime tymi istymi kombinaciami aj pole vsetkyMoznosti
  for k:= 1 to 1296 do
   vsetkyMoznosti[k]:= variacie[k];

  {zaciatok programu, pyta sa na ako prvu kombinaciu AABB}

  writeln('A A B B');
  inc(pocetPokusov); {prvy krat sa spytal, pocet pokusov sa musi zvacsit}

  {zistuje odpoved od hraca pomocou funkcie nacitajOdpoved()
   ak je true, cize ak su vsetky 2ky, vypise, ze bola najdena odpoved
   ak je false, odpoved je uz nacitana, a moze zistovat dalej}
  if nacitajOdpoved() = true then
    begin
      vysledok:= 'A A B B';
      writeln('Tvoja kombinacia je ' + vysledok);
      writeln('Program ju uhadol na ' + IntToStr(pocetPokusov) {bude 1} + ' pokus.');
    end
  else
    begin
      zoradOdpoved();

      {dalej "vyhodi" z pola variacie tie moznosti, ktore by pri nasej odpovedi na otazku AABB nedavali zmysel - vid funkcia porovnajOdpovede}
      for k:= 1 to 1296 do
      begin
        if porovnajOdpovede(odpoved, variacie[k], '1122') = false then
          begin
            variacie[k]:= '0';
            dec(pocetZostavajucichMoznosti); {pocet nenulovych miest v poli variacie sa znizi o 1}
          end;
      end;

      {vstupujeme do while cyklu,
       tu sa program pyta na nové kombinacie, robi dokym nema odpoved - cize dokym je vysledok ''}
      while vysledok = '' do
        spravDalsiTip();
      {pokial sa uz skoncil while cyklus, znamena to, ze mame vysledok}
      writeln('Tvoja kombinacia je ' + vysledok);
      writeln('Program ju uhadol na ' + IntToStr(pocetPokusov) + ' pokusov.');
    end;
  writeln('Stlac lubovolnu klavesu na ukoncenie programu');
  chr:= readkey;
end.



