# Theme Keycloak `asn-v2`

Theme login Keycloak 24.0.3 untuk **SSO ASN Pemkab Ponorogo** (branding KORPRI /
Ponorogo, dark mode, particles background).

Penerus theme `asn`. Dibuat terpisah agar `asn` lama **tidak terganggu** dan bisa
jadi fallback. Aktifkan lewat Realm Settings → Themes → Login Theme = `asn-v2`
saat sudah siap.

## Kenapa theme baru? (masalah di `asn`)

Theme `asn` menulis tiap halaman sebagai **HTML penuh standalone** tanpa
`template.ftl` dan tanpa `<@layout.registrationLayout>`. Akibatnya hanya ~8
halaman yang dibuat manual yang berfungsi; semua form lain yang dibutuhkan
Keycloak (reset password, reset OTP, recovery codes, update profile, verify
email, select authenticator, page-expired, terms, code, dll.) **jatuh ke parent
`base`** yang hanya berisi logika FreeMarker tanpa chrome → halaman rusak / error.
Itu sebab muncul error saat reset OTP, reset password, dsb.

## Arsitektur `asn-v2`

- **`parent=keycloak`** → mewarisi SEMUA form template Keycloak. Halaman yang
  tidak kita override pun tetap tampil rapi.
- **`login/template.ftl`** → satu chrome bersama (logo, particles, dark mode,
  footer, alert). Signature macro `registrationLayout` + semua block `<#nested>`
  **identik** dengan base 24.0.3, jadi semua form ikut chrome ini otomatis.
- **`login/theme.properties`** → memetakan tiap `kc*Class` ke utility Tailwind.
  Inilah yang membuat form bawaan (yang tidak kita sentuh) tampil ter-styling.
- **`login/messages/messages_id.properties`** → label & instruksi Bahasa
  Indonesia untuk semua form (termasuk yang tidak di-override `.ftl`-nya).
- **Override branded** (konten/branding khusus): `login.ftl` (NIP),
  `login-config-totp.ftl` (QR + Google Authenticator), `info.ftl`, `error.ftl`,
  `logout-confirm.ftl`.

## Build CSS (Tailwind v3)

Dari direktori `subapps/sso/keycloak`:

```bash
npm install            # sekali saja
npm run build:asn-v2   # build styles.css (minified)
npm run watch:asn-v2   # mode watch saat development
```

`styles.css` di-`.gitignore`? **Tidak** — di-commit, karena image Docker tidak
menjalankan build Tailwind (lihat Dockerfile). Selalu `npm run build:asn-v2`
sebelum commit/deploy bila mengubah `.ftl` / `theme.properties`.

## Preview cepat (tanpa Keycloak)

```bash
npm run preview:asn-v2          # generate preview/*.html
# buka preview/index.html di browser; tombol "Toggle dark" tiap halaman
```

Preview = replika visual statis (BUKAN render FreeMarker asli) untuk cek layout,
warna, dan dark mode tiap halaman dengan cepat.

## Deploy

Theme di-bake ke image via `Dockerfile`:
`COPY themes/asn-v2 /opt/keycloak/themes/asn-v2`. Build ulang image keycloak:

```bash
docker compose -f subapps/sso/keycloak/docker-compose.yml build keycloak_web
docker compose -f subapps/sso/keycloak/docker-compose.yml up -d keycloak_web
```

Lalu set Login Theme = `asn-v2` di Realm Settings.

> Catatan: `start-dev` me-`cache` template. Saat iterasi theme di server dev,
> restart container atau set `KC_SPI_THEME_CACHE_THEMES=false` /
> `KC_SPI_THEME_STATIC_MAX_AGE=-1` agar perubahan langsung terlihat.

## Daftar halaman tercakup

Override langsung: `login`, `login-config-totp`, `info`, `error`,
`logout-confirm`.

Diwarisi & ter-styling via `template.ftl` + `theme.properties` (tidak perlu
override): `login-otp`, `login-reset-password`, `login-reset-otp`,
`login-update-password`, `login-update-profile`, `login-verify-email`,
`select-authenticator`, `login-recovery-authn-code-config`,
`login-recovery-authn-code-input`, `login-page-expired`, `terms`, `code`,
`webauthn-*`, dan form lain yang ditambah Keycloak di masa depan.
