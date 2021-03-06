Test text wrapping for multibyte characters

  $ mkdir t
  $ cd t

define commands to display help text

  $ cat << EOF > show.py
  > # Japanese full-width characters:
  > def show_full_ja(ui, **opts):
  >     u'''\u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051 \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051 \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051
  > 
  >     \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051 \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051 \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051 \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051
  > 
  >     \u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051\u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051\u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051\u3042\u3044\u3046\u3048\u304a\u304b\u304d\u304f\u3051
  >     '''
  > 
  > # Japanese half-width characters:
  > def show_half_ja(ui, *opts):
  >     u'''\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79
  > 
  >     \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79 \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79
  > 
  >     \uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79\uff71\uff72\uff73\uff74\uff75\uff76\uff77\uff78\uff79
  >     '''
  > 
  > # Japanese ambiguous-width characters:
  > def show_ambig_ja(ui, **opts):
  >     u'''\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb
  > 
  >     \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb
  > 
  >     \u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb\u03b1\u03b2\u03b3\u03b4\u03c5\u03b6\u03b7\u03b8\u25cb
  >     '''
  > 
  > # Russian ambiguous-width characters:
  > def show_ambig_ru(ui, **opts):
  >     u'''\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438
  > 
  >     \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438
  > 
  >     \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438
  >     '''
  > 
  > cmdtable = {
  >     'show_full_ja': (show_full_ja, [], ""),
  >     'show_half_ja': (show_half_ja, [], ""),
  >     'show_ambig_ja': (show_ambig_ja, [], ""),
  >     'show_ambig_ru': (show_ambig_ru, [], ""),
  > }
  > EOF

"COLUMNS=60" means that there is no lines which has grater than 58 width

(1) test text wrapping for non-ambiguous-width characters

(1-1) display Japanese full-width characters in cp932

  $ COLUMNS=60 hg --encoding cp932 --config extensions.show=./show.py help show_full_ja
  hg show_full_ja
  
  \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf (esc)
  
      \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf (esc)
      \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf (esc)
  
      \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf\x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf\x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf (esc)
      \x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8\x82\xa9\x82\xab\x82\xad\x82\xaf (esc)
  
  use "hg -v help show_full_ja" to show more info

(1-2) display Japanese full-width characters in utf-8

  $ COLUMNS=60 hg --encoding utf-8 --config extensions.show=./show.py help show_full_ja
  hg show_full_ja
  
  \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 (esc)
  
      \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 (esc)
      \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 (esc)
  
      \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91\xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91\xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 (esc)
      \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91 (esc)
  
  use "hg -v help show_full_ja" to show more info


(1-3) display Japanese half-width characters in cp932

  $ COLUMNS=60 hg --encoding cp932 --config extensions.show=./show.py help show_half_ja
  hg show_half_ja
  
  \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 (esc)
  
      \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 (esc)
      \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 (esc)
  
      \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 (esc)
      \xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9 (esc)
  
  use "hg -v help show_half_ja" to show more info

(1-4) display Japanese half-width characters in utf-8

  $ COLUMNS=60 hg --encoding utf-8 --config extensions.show=./show.py help show_half_ja
  hg show_half_ja
  
  \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 (esc)
  
      \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 (esc)
      \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 (esc)
  
      \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9\xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9\xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9\xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9\xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9\xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 (esc)
      \xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9\xef\xbd\xb1\xef\xbd\xb2\xef\xbd\xb3\xef\xbd\xb4\xef\xbd\xb5\xef\xbd\xb6\xef\xbd\xb7\xef\xbd\xb8\xef\xbd\xb9 (esc)
  
  use "hg -v help show_half_ja" to show more info



(2) test text wrapping for ambiguous-width characters

(2-1) treat width of ambiguous characters as narrow (default)

(2-1-1) display Japanese ambiguous-width characters in cp932

  $ COLUMNS=60 hg --encoding cp932 --config extensions.show=./show.py help show_ambig_ja
  hg show_ambig_ja
  
  \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
  
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
  
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
  
  use "hg -v help show_ambig_ja" to show more info

(2-1-2) display Japanese ambiguous-width characters in utf-8

  $ COLUMNS=60 hg --encoding utf-8 --config extensions.show=./show.py help show_ambig_ja
  hg show_ambig_ja
  
  \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
  
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
  
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
  
  use "hg -v help show_ambig_ja" to show more info

(2-1-3) display Russian ambiguous-width characters in cp1251

  $ COLUMNS=60 hg --encoding cp1251 --config extensions.show=./show.py help show_ambig_ru
  hg show_ambig_ru
  
  \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  
  use "hg -v help show_ambig_ru" to show more info

(2-1-4) display Russian ambiguous-width characters in utf-8

  $ COLUMNS=60 hg --encoding utf-8 --config extensions.show=./show.py help show_ambig_ru
  hg show_ambig_ru
  
  \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  
  use "hg -v help show_ambig_ru" to show more info


(2-2) treat width of ambiguous characters as wide

(2-2-1) display Japanese ambiguous-width characters in cp932

  $ COLUMNS=60 HGENCODINGAMBIGUOUS=wide hg --encoding cp932 --config extensions.show=./show.py help show_ambig_ja
  hg show_ambig_ja
  
  \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
  
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
  
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b\x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
      \x83\xbf\x83\xc0\x83\xc1\x83\xc2\x83\xd2\x83\xc4\x83\xc5\x83\xc6\x81\x9b (esc)
  
  use "hg -v help show_ambig_ja" to show more info

(2-2-2) display Japanese ambiguous-width characters in utf-8

  $ COLUMNS=60 HGENCODINGAMBIGUOUS=wide hg --encoding utf-8 --config extensions.show=./show.py help show_ambig_ja
  hg show_ambig_ja
  
  \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
  
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
  
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b\xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
      \xce\xb1\xce\xb2\xce\xb3\xce\xb4\xcf\x85\xce\xb6\xce\xb7\xce\xb8\xe2\x97\x8b (esc)
  
  use "hg -v help show_ambig_ja" to show more info

(2-2-3) display Russian ambiguous-width characters in cp1251

  $ COLUMNS=60 HGENCODINGAMBIGUOUS=wide hg --encoding cp1251 --config extensions.show=./show.py help show_ambig_ru
  hg show_ambig_ru
  
  \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
      \xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8 (esc)
  
  use "hg -v help show_ambig_ru" to show more info

(2-2-4) display Russian ambiguous-width charactes in utf-8

  $ COLUMNS=60 HGENCODINGAMBIGUOUS=wide hg --encoding utf-8 --config extensions.show=./show.py help show_ambig_ru
  hg show_ambig_ru
  
  \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8\xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
      \xd0\x9d\xd0\xb0\xd1\x81\xd1\x82\xd1\x80\xd0\xbe\xd0\xb9\xd0\xba\xd0\xb8 (esc)
  
  use "hg -v help show_ambig_ru" to show more info
