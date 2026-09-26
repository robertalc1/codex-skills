# Codex Skills

Colectie personala de skill-uri Codex, pastrata intr-un repository privat pentru utilizare pe mai multe calculatoare.

## Stare

Repository initializat. Skill-urile vor fi adaugate dupa ce sunt furnizate de proprietar. Nu sunt inca instalate skill-uri si nu este configurata sincronizarea automata.

## Organizare

Fiecare skill va avea propriul director:

```text
skills/
  nume-skill/
    SKILL.md
    scripts/       # optional
    references/    # optional
    assets/        # optional
```

## Utilizare pe calculatoare

1. Autentificare GitHub si clonarea acestui repository pe fiecare calculator, o singura data.
2. Configurarea skill-urilor pentru descoperire globala de Codex din directorul utilizatorului `.agents/skills`. Pasul de configurare va fi adaugat odata cu primele skill-uri.
3. Actualizarea copiei locale folosind `git pull --ff-only` din directorul repository-ului.
4. Verificarea skill-urilor in Codex cu `/skills`; repornirea sesiunii daca schimbarile nu apar.

Codex foloseste fisierele locale. Autentificarea in acelasi cont ChatGPT nu cloneaza automat acest repository. Programele si conexiunile cerute de un skill se configureaza separat pe fiecare calculator.

## Reguli pentru adaugare

- Pastram instructiunile, resursele si scripturile necesare fiecarui skill.
- Pastram informatiile despre sursa si licenta skill-urilor externe.
- Nu includem parole, tokenuri, fisiere de autentificare sau date personale de lucru.
- Configurarea viitoare trebuie sa pastreze skill-urile locale deja existente si sa semnaleze conflictele de nume.
