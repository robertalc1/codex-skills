# Codex Skills

Colectia privata a lui Robert: **58 de skill-uri din 6 surse**, disponibile global in Codex CLI pe Windows. Fisierele si resursele sunt incluse in repository; nu trebuie reinstalat fiecare skill separat.

| Colectie | Numar | Utilizare |
|---|---:|---|
| Taste Skill | 13 | Design frontend, redesign, stiluri vizuale |
| Emil Kowalski | 13 | Interfete, animatii, design engineering |
| Playwright CLI | 1 | Automatizare si verificare in browser |
| Superpowers | 15 | Planificare, debugging, teste, review |
| Remotion | 12 | Video cu React si fluxuri Remotion |
| Site Clone | 4 | Analiza, reconstructie si personalizare site-uri |

[Catalog complet, surse, licente si versiuni](SOURCES.md)

## Instalare pe un calculator nou

Ai nevoie de Git si de acces la acest repository privat. Codex CLI se instaleaza separat. Ruleaza in **CMD**, dintr-un folder unde doresti sa pastrezi colectia:

```bat
git clone https://github.com/robertalc1/codex-skills.git
cd codex-skills
setup.cmd
install-tools.cmd
codex.cmd
```

In PowerShell, foloseste `./setup.cmd` si `./install-tools.cmd`. Autentifica-te in GitHub daca Git iti cere. Nu introduce tokenuri in comanda sau in repository.

`setup.cmd` creeaza legaturi de tip junction in `%USERPROFILE%\.agents\skills`, cate una pentru fiecare skill. Nu necesita administrator. Verifica intai toate destinatiile si se opreste la conflicte; nu suprascrie skill-uri existente. Poate fi rulat de mai multe ori. **Pastreaza checkout-ul in acelasi loc**: legaturile trimit catre el.

Launcherul `.cmd` permite executarea scriptului PowerShell numai in procesul de instalare; nu schimba permanent Execution Policy. `install-tools.cmd` instaleaza separat versiunea fixata `@playwright/cli@0.1.21` si necesita Node.js LTS si acces la npm. Browserul si celelalte dependinte specifice proiectului se configureaza la utilizare.

## Folosire

In Codex ruleaza `/skills` sau mentioneaza skill-ul cu `$`. Exemplu:

```text
$emil-design-eng Imbunatateste animatiile acestei interfete.
$playwright-cli Verifica formularul din aplicatia mea locala.
$remotion-best-practices Creeaza un videoclip pentru produsul meu.
$clone-site Analizeaza site-ul indicat si pregateste o reconstructie.
```

Numele invocabil vine din campul `name` din SKILL.md; poate diferi de numele folderului. Porneste o sesiune noua daca skill-urile nu apar. Global inseamna disponibil in toate proiectele, nu activat la fiecare mesaj. Cu multe skill-uri instalate, Codex poate prescurta lista initiala; foloseste `/skills` si mentionarea explicita pentru selectie.

## Actualizare pe alt calculator

Dupa ce modificarile au ajuns in acest repository, ruleaza din checkout:

```bat
update.cmd
```

Actualizeaza prin `git pull --ff-only`, apoi adauga legaturi pentru skill-urile noi. Skill-urile existente citesc imediat fisierele actualizate. Scriptul nu sterge legaturi vechi si nu suprascrie conflicte. Nu exista un serviciu de sincronizare automata sau actualizare automata la fiecare pornire.

## Ce este inclus

- Directoarele complete de skill-uri, cu scripturi si referinte auxiliare; instructiunile upstream nu sunt rescrise.
- Ambele versiuni Taste disponibile upstream, inclusiv v1 si v2 experimental: alege una potrivita, nu le invoca impreuna.
- Toate cele patru skill-uri Site Clone, necesare pentru referintele dintre ele.
- Superpowers ca set de skill-uri; hook-urile si integrarea completa de plugin nu sunt instalate. Unele fluxuri depind de suportul multi-agent al sesiunii.
- Nu sunt activate automat servicii MCP, conturi, telemetrie sau scripturi ale skill-urilor la instalare. Skill-urile pot solicita aceste instrumente cand sunt folosite.
- Remotion nu include o licenta explicita in snapshot-ul acestui repository upstream; pastram nota din `sources/remotion/LICENSE-NOTE.md`, fara a atribui o licenta inventata. Colectia este privata.

## Versiuni si intretinere

`sources.lock.json` fixeaza commit-urile upstream. `update.cmd` preia schimbarile din **acest repository**, nu cele mai noi versiuni de la autori. Actualizarea upstream se face separat, cu verificarea fisierelor, licentelor si catalogului. Nu adauga credentiale sau date de lucru.

Fisierele copiate raman sub termenii autorilor lor; licentele si README-urile originale sunt pastrate in `sources/`.
