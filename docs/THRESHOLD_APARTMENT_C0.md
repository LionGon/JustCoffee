# Le Seuil — Threshold Apartment Cycle 0 (ISSUE-602)

> **Status:** AI draft assets + Godot scaffold — **human art review required** before closing #41.  
> **Style lock:** [`VISUAL_STYLE.md`](VISUAL_STYLE.md) §1, §3.1, §5, §10, §12  
> **Mood reference:** [`assets/cafe-scene.png`](../assets/cafe-scene.png) (atmosphere only)

---

## Delivered files

| File | Role |
|---|---|
| `assets/backgrounds/threshold_apartment_cycle0.png` | 1920×1080 composite |
| `assets/backgrounds/layers/threshold_plant_cycle0.png` | Healthy plant layer |
| `assets/backgrounds/layers/threshold_window_cycle0.png` | Window + city layer |
| `assets/backgrounds/layers/threshold_phone_cycle0.png` | Phone + message layer |
| `assets/backgrounds/layers/threshold_mug_cycle0.png` | Coffee mug layer |
| `assets/backgrounds/layers/threshold_vinyl_cycle0.png` | Vinyl player layer |
| `scenes/districts/threshold/threshold_apartment_cycle0.tscn` | Godot scaffold + hotspots |

---

## Human review checklist

- [ ] Open `assets/backgrounds/threshold_apartment_cycle0_hotspot_debug.png` — green DETECT boxes should cover objects
- [ ] Palette reads **warm amber** and distinct from exterior districts
- [ ] Hopper framing: ≥ 40% negative space, single dominant light pool
- [ ] Phone message legible: *"T'as survécu ? 🙂"* (FR) — EN variant deferred to Dialogic
- [ ] All 5 hotspots outside HUD safe zones (§10)
- [ ] Layer PNGs use **alpha cutouts** aligned pixel-perfect to composite (current layers are isolated AI objects on dark backgrounds — **not yet compositable**)
- [ ] Surfaces worn/grunge — not hygge/cozy, not pastel
- [ ] No character rig in frame (ISSUE-606)

---

## Hotspot coordinates (1920×1080)

Polygons are `CollisionPolygon2D` in `threshold_apartment_cycle0.tscn`. Tune after human art pass.

| `interactable_id` | Approx. center | Polygon bounds (x, y) | HUD clearance |
|---|---|---|---|
| `window` | (212, 355) | 0–425 × 0–710 | Clear ✓ |
| `plant` | (235, 570) | 155–315 × 490–650 | Windowsill |
| `mug` | (282, 752) | 190–375 × 700–805 | Counter left |
| `phone` | (645, 797) | 505–785 × 720–875 | Counter center |
| `vinyl` | (1620, 640) | 1340–1900 × 490–790 | Clear ✓ |

Coordinates derived from pixel analysis of `threshold_apartment_cycle0.png` (not manual guess).
Re-run `python3 scripts/extract_threshold_layers.py` after bbox edits to refresh alpha layers.

**Tune in Godot:** select each `*Hotspot/CollisionPolygon2D`, edit polygon points over the composite (1 px = 1 unit, origin top-left).

---

## Pipeline local automatisé (Gemma4 + rembg)

```bash
# 1. Bboxes hotspots (Ollama gemma4:31b vision)
python3 scripts/detect_threshold_hotspots_ollama.py --apply

# 2. Layers PNG transparentes 1920×1080
python3 -m venv .venv-art
.venv-art/bin/pip install -r scripts/requirements-art.txt
.venv-art/bin/python3 scripts/extract_threshold_layers_alpha.py
```

| Layer | Méthode |
|---|---|
| `threshold_window_cycle0` | Bbox rectangulaire (rembg détruit vitre/ville) |
| plant, mug, phone, vinyl | **rembg** sur crop paddé → collé sur canvas plein |

Vérif visuelle : `assets/backgrounds/threshold_apartment_cycle0_layers_debug.png`

**Limites :** edges peints sombres (ombre mug/vinyle) peuvent être mangés ; composite IA reste un draft art.

---

## Outils — PSD et transparence

### Ce que l’agent Cursor peut faire seul

| Capacité | Outil |
|---|---|
| Bboxes hotspots | `detect_threshold_hotspots_ollama.py` (gemma4 vision) |
| Alpha objets isolés | `extract_threshold_layers_alpha.py` (rembg) |
| Scène Godot 1920×1080 | `threshold_apartment_cycle0.tscn` |
| Composite + repaint final | Humain (Krita) — toujours requis pour #41 sign-off |

### Ce qu’il faut pour des layers correctes (humain ou outil dédié)

| Outil | Rôle | Coût |
|---|---|---|
| **Krita** | PSD, calques, export PNG alpha | Gratuit — recommandé si pas Photoshop |
| **Photoshop** | Référence industrie, calques nommés | Abonnement |
| **GIMP** | Calques + PNG transparent | Gratuit |
| **Procreate** (iPad) | Peinture → export PSD | One-time |

### Workflow PSD attendu (VISUAL_STYLE.md §12)

```
1. Peindre le composite 1920×1080 (tous calques visibles)
2. Exporter → threshold_apartment_cycle0.png (aplatir)
3. Par objet (plant, window, phone, mug, vinyl) :
   - Masquer les autres calques
   - Découper l’objet (gomme / masque de calque)
   - Exporter PNG 32-bit avec transparence
   - Garder la même taille canvas 1920×1080 (objet à sa position exacte)
4. Optionnel : livrer le .psd source dans assets/backgrounds/source/
```

**Important :** les layers doivent être des **cutouts sur canvas 1920×1080** (pas des sprites isolés sur fond noir) pour que Godot les superpose sans repositionner.

### Si tu veux m’aider à automatiser depuis ici

| Tu fournis | Je peux |
|---|---|
| Fichier `.psd` dans le repo | Extraire calques via script (`psd-tools` + Pillow) |
| PNG avec alpha déjà découpés (1920×1080) | Mettre à jour la scène Godot, vérifier alignement |
| Coordonnées depuis l’éditeur Godot | Mettre à jour le `.tscn` |
| **ImageMagick** installé (`brew install imagemagick`) | Aide basique au traitement batch |

Sans PSD ni cutouts alpha, je reste bloqué sur des drafts IA non composables — d’où le label `executor:human` / `tool:art` de l’issue.

---

### HUD safe zones (do not place critical detail here)

```
Narrative zone:     y 0–820 (hotspots live here)
Inner monologue:    y 820–940, x 360–1560
Verb bar:           x 0–420,   y 940–1080
Inventory bar:      x 420–1500, y 960–1080
Location + cycle:   x 1500–1920, y 940–1080
```

---

## AI generation prompts (iteration brief)

Use for Krita/Photoshop/Procreate/Midjourney/DALL·E refinement. Reference `assets/cafe-scene.png` for painted density and lamp warmth — **not** café layout.

### Composite — `threshold_apartment_cycle0.png`

```
Interior apartment scene, 1920x1080, Urban Grunge Expressionism, Edward Hopper
isolation framing. Warm amber morning light, single large window on the left
showing grey rainy city below. Worn domestic surfaces — stained plaster walls,
scuffed wooden counter spanning foreground. Objects for hotspots: white coffee
mug on counter (center-left), healthy potted plant on window sill, vinyl record
player on wooden shelf (right, in shadow), smartphone on counter with French
text "T'as survécu ? 🙂" on lit screen. Painted texture like Disco Elysium,
geometric composition like Kentucky Route Zero. Darker urban tone — not cozy
hygge, not pastel. ≥40% negative space on right wall. Dramatic single light
pool from window. No characters. Matte worn surfaces, not glossy.
```

### Per-layer exports (alpha cutout, align to composite)

| Layer file | Prompt addendum |
|---|---|
| `threshold_window_cycle0` | Window frame + warm morning light + grey rainy city; transparent outside glass/frame |
| `threshold_plant_cycle0` | Healthy green potted plant, terracotta pot; transparent background |
| `threshold_mug_cycle0` | White ceramic mug, slight steam; transparent background |
| `threshold_phone_cycle0` | Smartphone, screen: "T'as survécu ? 🙂"; transparent background |
| `threshold_vinyl_cycle0` | Vintage turntable + black vinyl disc; transparent background |

**Layer workflow:** Paint composite first → duplicate → erase non-layer pixels → export PNG with alpha. Do **not** paint separate Reflection Mode variants (shader only, ISSUE-306).

---

## Godot test

1. Open `scenes/districts/threshold/threshold_apartment_cycle0.tscn`
2. Run scene (F6) — confirms `EventBus.district_changed("threshold")` in debugger
3. Toggle `show_dev_hotspot_outlines` on root node to verify hotspot placement
4. Toggle `show_layer_overlays` to compare layer alignment (expects human-aligned cutouts)

---

## Known gaps (agent delivery)

1. **Composite is AI draft** — not production art; human repaint in Krita required for #41 sign-off.
2. **Layers are rectangular bbox crops** — not semantic alpha cutouts. Do not ship as final; paint PSD layers instead.
3. **Hotspot rects** — edit `HOTSPOT_RECTS` in `threshold_apartment_cycle0.gd` or use debug PNG to verify.
4. **No `.import` metadata committed** — Godot regenerates on first editor open.

## What I need from you to finish properly

| Option | You provide | Result |
|---|---|---|
| **A — fastest** | Open debug PNG, tell me if green boxes are OK or send corrected pixel coords | I update `HOTSPOT_RECTS` |
| **B — art** | Krita/PSD with named layers exported at 1920×1080 | Production layers + composite |
| **C — API** | Confirm `EACHLABS_API_KEY` works | I run `background-removal` skill for clean alpha |
