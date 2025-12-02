# GeppEmoji
---

Another small **Desktop Emoji Picker** written in Python + GTK3

![Python](https://img.shields.io/badge/python-3.10%2B-blue)  ![GTK](https://img.shields.io/badge/GTK-3-lightgrey)  ![Platform](https://img.shields.io/badge/platform-Linux-success)  ![Project Status](https://img.shields.io/badge/status-active-brightgreen)  ![License](https://img.shields.io/badge/license-MIT-green)  ![GitHub stars](https://img.shields.io/github/stars/FranzBias/GeppEmoji)

GeppEmoji è un piccolo **emoji picker da desktop** scritto in Python + GTK3,
pensato per funzionare bene su Linux (Cinnamon, GNOME, ecc.) e integrarsi
con il flusso di lavoro tramite una scorciatoia globale.

L’idea è semplice:

> **apri GeppEmoji**
> **scegli** una o più emoji, e...
> lui le **incolla automaticamente** nella finestra che stavi usando prima.

![Finestra principale](assets/People&Body.png)

**Ci sono altre ottime app che fanno un lavoro praticamente uguale**, come [Smile](https://github.com/mijorus/smile) e [Emote](https://github.com/tom-james-watson/Emote).
Ma a me mancava sempre qualcosa:  
o niente incolla automatico (perché non uso GNOME 🙅‍♂️), o nessuna ricerca nella mia lingua, o impossibilità di modificare le keyword di ricerca…

Quindi, con l’aiuto della mia adorata AI “Geppetto”, è nata **GeppEmoji**:
un’emoji picker cucita su misura per il mio modo di lavorare – e, spero,
anche per il tuo. 

Se ti torna utile, una ⭐ sul repository fa sempre molto piacere 😊

---

## Screenshot

|                                      |                                                                       |
| ------------------------------------ | --------------------------------------------------------------------- |
| **"Recent" category**                | !["Recent" category](assets/Recent.png)                               |
| **Edit keyword**                     | ![Keyword editor](assets/Edit.png)                                    |
| **Preferences**                      | ![Preferences](assets/Pref.png)                                       |
| **Shortcuts**                        | ![Shortcuts](assets/Shortcuts.png)                                    |
| **Update Emoji database**            | ![Update Emoji database](assets/Update.png)                           |

---

## Caratteristiche principali (Features)

### 🔍 Ricerca intelligente e localizzabile

- Ricerca rapida per **nome** o **parola chiave**.
- Supporto a keyword in più lingue tramite `emoji_translations.json`.
- All’apertura la categoria selezionata è **Recent**, ma appena inizi a scrivere
  la ricerca viene fatta automaticamente su **tutte** le emoji.
- La ricerca usa:
  - nomi ufficiali
  - keyword in inglese
  - keyword nelle lingue configurate (es. italiano, tedesco)
  - keyword personalizzate aggiunte dall’utente.

---

### 🗂️ Categorie, recenti e preferiti

- Categorie principali:
  - `All`, `Recent`, `Favorites`  
  - più i gruppi Unicode (Smileys & Emotion, People & Body, Animals & Nature, ecc.).
- Alla partenza GeppEmoji mostra **Recent** e mette subito a fuoco il campo di ricerca.
- **Recent** tiene le ultime emoji usate (numero configurabile da `config.json`).
- **Preferiti**:
  - puoi marcare un’emoji come preferita con `Ctrl + F`
  - i preferiti vengono salvati e ricaricati tra una sessione e l’altra.

---

### 👆 Skin tone selector

- Le emoji con varianti di **colore pelle** vengono mostrate **una sola volta**.
- Il colore visualizzato è quello scelto nel selettore in basso:

  `Skin tone:  🖐  🖐🏻  🖐🏼  🖐🏽  🖐🏾  🖐🏿`

- Puoi cambiare skin tone:
  - dalla barra in basso (toggle button)
  - dal menù `Menu → Skin tone…`.
- Quando cambi tono, le emoji visualizzate e quelle incollate usano automaticamente il nuovo colore.

---

### 🧠 Keyword personalizzabili (per lingua)

![Editor parole chiave](assets/Edit.png)

- Click **centrale** su un’emoji oppure **Shift + T** → apre **l’editor di keyword**.
- Puoi aggiungere le tue parole chiave, separate da virgola.
- Le keyword sono **per lingua**, e vengono salvate in `emoji_translations.json` sotto `by_char`
- L’editor mostra:
  - emoji selezionata
  - keyword personali modificabili
  - keyword di default (lette dal database Unicode).

---

### 📌 Buffer multi-emoji e incolla automatico

- **Click sinistro** o **Enter**:
  - aggiunge l’emoji al buffer,
  - incolla **tutte** le emoji accumulate nella finestra precedente,
  - chiude GeppEmoji.
- **Shift + click sinistro**, **click destro** o **Shift + Enter**:
  - aggiunge l’emoji al buffer,
  - **non** incolla e **non** chiude.
- Il contenuto del buffer viene mostrato nella **status bar** in basso.

---

### 🧾 Status bar

- Mostra in tempo reale:
  - quante emoji sono visibili dopo il filtro,
  - il contenuto del buffer (emoji accumulate in attesa di essere incollate).

Esempio:  
`48 emoji shown  |  Buffer: 😁🤩🐧`

---

### 🛠️ Aggiornamento del database Emoji

![Finestra Update Emoji database](assets/Update.png)

Dal menù `Menu → Update Emoji database`:

1. viene mostrata una finestra con:
   - link ufficiale a `emoji-test.txt` (Unicode)
   - percorso della cartella dove salvare il file.
2. Dopo aver scaricato e messo `emoji-test.txt` nella cartella della app,
   puoi premere **Run import**.
3. Lo script `build_emoji_db.py` viene eseguito:
   - legge `emoji-test.txt`
   - genera/aggiorna `emoji_data.json`
   - ricarica il database senza bisogno di riavviare il programma.

---

### 🎛️ Preferenze e configurazione

Dal menù `Menu → Preferences` puoi configurare:

- **Tema**:
  - `System` (predefinito), `Light`, `Dark`.
- **Numero colonne** per la griglia di emoji.
- **Numero massimo di recenti** visibili.
- **Dimensione del font emoji**.
- **Lingua dell’interfaccia**:
  - `System default` oppure una delle lingue disponibili in `locales/*.json`
    (es. `en`, `it`, `de`).
- **Debug log**:
  - se attivo, abilita log extra su stderr
  - le tooltip diventano più “ricche” (categoria, keyword, ecc.).

Inoltre, dalla stessa finestra puoi:

- Aprire direttamente con il tuo editor:
  - `emoji_translations.json`
  - `config.json`
- Creare un **backup** (zip) con:
  - `emoji_recent.json`
  - `emoji_translations.json`
  - `config.json`
- **Ripristinare** un backup da un file `.zip`.

---

## 🏗️ Struttura dei file

- `geppemoji.py`  
  Applicazione principale GTK: finestra, FlowBox, ricerca, menù, editor di keyword,
  buffer multi-emoji, incolla automatica, skin tone, status bar, preferenze, backup/restore.

- `build_emoji_db.py`  
  Script che:
  1. legge `emoji-test.txt` (locale, scaricato da Unicode)
  2. genera `emoji_data.json`
  3. applica eventuali override da `emoji_translations.json`.

- `emoji_data.json`  
  Database emoji **generato automaticamente** dallo script (non modificarlo a mano).

- `emoji_translations.json`  
  File opzionale per **override e traduzioni locali**, ad esempio:

```json
  {
    "by_shortcode": {
      ":red_heart:": {
        "keywords": {
          "it": ["cuore", "amore"]
        }
      }
    },
    "by_char": {
      "❤️": {
        "keywords": {
          "it": ["cuore", "amore", "passione"]
        }
      }
    }
  }
```

- `emoji_recent.json`  
    Ultime emoji usate (gestito automaticamente).
    
- `emoji_favorites.json`  
    Set di emoji preferite.
    
- `config.json`  
    Configurazione utente (tema, colonne, lingua, dimensione font, debug, ecc.).
    
- `locales/*.json`  
    File di traduzione dell’interfaccia (es. `en.json`, `it.json`, `de.json`).

---

## #️⃣ Keyword italiane preconfigurate

Nel file di esempio `emoji_translations.json` sono già presenti alcune  
corrispondenze comode in italiano, ad esempio:

- Gruppo **cuore / amore**  
    Emoji come  
    `🥰 😘 ❤️ 😍 😻 💌 💘 💝 💖 💗 💓 💟 ❣️ 💔 ❤️‍🔥 ❤️‍🩹 🩷 🧡 💛 💚 💙 🩵 💜 🤎 🖤 🩶 🤍 🫶 🫀 💑 👩‍❤️‍👨 👨‍❤️‍👨 👩‍❤️‍👩`  
    possono essere trovate con keyword come:  
    `cuore`, `amore`, `innamorato`, `passione`, ecc.
    
- Gruppo **palla / globo / punto**  
    Emoji come  
    `🔺 🔻 ⚠️ ‼️ ⁉️ ❓️ ❔️ ❕️ ❗️ ⚽️ ⚾️ 🥎 🏀 🏐 🏈 🏉 🎱 🪩 🌍️ 🌎️ 🌏️ 🌐`  
    possono essere trovate con keyword come:  
    `palla`, `globo`, `punto`, `interrogativo`, `esclamativo`, `biliardo`, ecc.
    

Naturalmente puoi modificare tutto:

- cancellare i gruppi che non ti piacciono,
    
- creare nuove famiglie di keyword (tristezza, cibo, animali, lavoro, musica…),
    
- usare l’editor interno per adattare le parole chiave al tuo modo di cercare.
    

---

## 📦 Requisiti

- **Python 3.10+**
    
- **GTK 3 + PyGObject**
    
- **xdotool** (per incollare automaticamente nella finestra precedente)
    

Per i pacchetti Python, vedi `requirements.txt`.

---

##  🚀 Installazione rapida

Clone del repository:
```bash
git clone https://github.com/FranzBias/GeppEmoji.git cd GeppEmoji
```

Installazione dipendenze (opzionale ma consigliata in virtualenv):
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Generazione del database emoji:
```bash
python3 build_emoji_db.py
```
Avvio dell’app:
```bash
python3 geppemoji.py
```
Nel tuo ambiente desktop (es. Cinnamon) puoi creare una  
**scorciatoia da tastiera globale** con il comando sopra che lanci `geppemoji.py`.

---

## 🖱️ Uso rapido & scorciatoie

- **Freccette**: muoversi tra le emoji.
- **Enter**: inserisce e incolla l’emoji corrente (più quelle nel buffer) e chiude.
- **Shift + Enter**: aggiunge l’emoji al buffer, non incolla.
- **Click sinistro**: inserisce e incolla, e chiude.
- **Shift + click sinistro**: aggiunge al buffer, non incolla.
- **Click destro**: aggiunge al buffer, non incolla.
- **Click centrale** o **Shift + T**: apre l’editor di keyword per l’emoji selezionata.
- **Ctrl + F**: attiva/disattiva l’emoji come preferita.
- **Esc**: chiude la finestra senza incollare nulla.    

---

## 🙏Come contribuire

Ogni aiuto è benvenuto: dai piccoli typo alle grandi idee per nuove funzioni 😄

### Segnalare un bug

Quando qualcosa non funziona:

1. Apri una **Issue** sul repository GitHub.
    
2. Indica:
    
    - versione di Python;
        
    - desktop environment (Cinnamon, GNOME, ecc.);
        
    - come hai lanciato GeppEmoji (da terminale? da scorciatoia?).
        
3. Se possibile:
    
    - incolla l’output del terminale;
        
    - allega uno screenshot (come quelli qui sopra);
        
    - se hai attivato `debug` in `Preferences → Debug log`, copia anche eventuali log utili.
        

Più dettagli → più facile (e veloce) capire cosa succede.

---

### Proporre nuove keyword / traduzioni

Hai trovato un abbinamento migliore per alcune emoji? Vuoi proporre nuove “famiglie”  
come _tristezza_, _cibo_, _animali carini_, _lavoro_, _musica_?

Hai due strade:

1. **Issue su GitHub**
    
    - scrivi quali emoji e quali keyword vorresti aggiungere;        
    - specifica la lingua (es. `it`, `en`, `de`).
    
2. **Pull Request**
    
    - modifica `emoji_translations.json` seguendo la struttura già esistente;        
    - cerca di mantenere keyword brevi, intuitive e coerenti con quelle esistenti.

---

### Aggiungere una nuova lingua a questo progetto

Vuoi tradurre l’interfaccia in un’altra lingua?

1. Copia uno dei file esistenti in `locales`, ad es.:
   `cp locales/en.json locales/fr.json`
2. Traduci i testi mantenendo **le stesse chiavi**.
3. Avvia GeppEmoji, apri `Menu → Preferences` e nel campo **Language**  
    dovresti vedere automaticamente la nuova lingua (`fr` in questo esempio).
4. Se tutto funziona, puoi aprire una **Pull Request** con il nuovo file di lingua.

---

## ☕ Vuoi offrimi un caffè?

Se **GeppEmoji** ti è utile e vuoi sostenere lo sviluppo,  puoi offrirmi un caffè (o una pizza, se proprio vuoi esagerare 😁).

👉 **Link per una offerta tramite PayPal**:  
[https://www.paypal.com/donate/?hosted_button_id=HUF5MYDG465RY](https://www.paypal.com/donate/?hosted_button_id=HUF5MYDG465RY)

Oppure inquadra questo QR-code:

![Donate QR-Code](assets/DonaQR-Code.png) 

Grazie di cuore per qualsiasi contributo, anche solo una stellina su GitHub fa la differenza 💙
![GitHub stars](https://img.shields.io/github/stars/FranzBias/GeppEmoji)

---

## Ringraziamenti

- A [Smile](https://github.com/mijorus/smile?utm_source=chatgpt.com) e a [Emote](https://github.com/tom-james-watson/Emote) che mi hanno ispirato questo progetto.
- A “Geppetto”, la mia AI di fiducia, che mi ha aiutato a mettere insieme codice e idee.
- A chiunque userà GeppEmoji ogni giorno per dare un po’ più di espressività ai propri testi 🙂

----
