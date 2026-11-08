<#--
  Email theme "kisara" — kerangka HTML semua email SSO (reset kata sandi,
  verifikasi email, pembaruan akun, notifikasi keamanan). Isi tiap email
  datang dari messages_*.properties lewat <#nested>.

  Sengaja TANPA gambar: banyak klien email memblokir gambar secara bawaan,
  SVG tidak didukung Gmail/Outlook, dan alamat sumber daya Keycloak berubah
  tiap deploy (logo di email lama akan rusak). Merek dibangun dari teks +
  tabel berwarna, jadi selalu tampil. Semua gaya inline (syarat klien email).
-->
<#-- table-layout:fixed + overflow-wrap pada isi: tautan token reset sangat
     panjang tanpa spasi; tanpa ini kartu melebar melewati 560px dan email
     harus digeser ke samping di HP. -->
<#macro emailLayout>
<!DOCTYPE html>
<html lang="id" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="color-scheme" content="light only" />
  <title>Kisara SSO</title>
</head>
<body style="margin:0; padding:0; background-color:#f1f5f9; font-family:Inter,Segoe UI,Arial,Helvetica,sans-serif; color:#1e293b;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#f1f5f9; padding:28px 12px;">
    <tr>
      <td align="center">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:560px; table-layout:fixed; background-color:#ffffff; border-radius:20px; overflow:hidden; border:1px solid #e2e8f0;">

          <#-- Garis empat warna Kisara (tabel, bukan gradien: didukung semua klien) -->
          <tr>
            <td style="padding:0; font-size:0; line-height:0;">
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="25%" height="4" style="background-color:#1f6fb2; height:4px; font-size:0; line-height:0;">&nbsp;</td>
                  <td width="25%" height="4" style="background-color:#0f8b8d; height:4px; font-size:0; line-height:0;">&nbsp;</td>
                  <td width="25%" height="4" style="background-color:#2f9e6b; height:4px; font-size:0; line-height:0;">&nbsp;</td>
                  <td width="25%" height="4" style="background-color:#e0a82e; height:4px; font-size:0; line-height:0;">&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>

          <#-- Merek: ikon (PNG di alamat TETAP, lihat kisaraLogoUrl di theme.properties)
               + tulisan. Bila klien email memblokir gambar, tulisannya tetap
               membawa merek; bila alamat ikon belum diisi, ikon tidak dirender. -->
          <tr>
            <td style="padding:24px 32px 8px;">
              <table role="presentation" cellpadding="0" cellspacing="0">
                <tr>
                  <#if (properties.kisaraLogoUrl!'')?has_content>
                    <td style="vertical-align:middle; padding-right:12px;">
                      <img src="${properties.kisaraLogoUrl}" width="40" height="40" alt="" style="display:block; width:40px; height:40px; border:0;" />
                    </td>
                  </#if>
                  <td style="vertical-align:middle;">
                    <div style="font-size:22px; line-height:1.2; letter-spacing:-0.2px;"><span style="color:#64748b;">Kisara</span> <span style="font-weight:700; color:#0f172a;">SSO</span></div>
                    <div style="font-size:12px; color:#64748b; margin-top:2px;">Pemerintah Kabupaten Ponorogo</div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <#-- Isi email -->
          <tr>
            <td style="padding:16px 32px 28px; font-size:15px; line-height:1.65; color:#334155; word-break:break-word; overflow-wrap:anywhere;">
              <#nested>
            </td>
          </tr>

          <#-- Kaki -->
          <tr>
            <td style="padding:18px 32px 22px; background-color:#f8fafc; border-top:1px solid #e2e8f0; font-size:12px; line-height:1.6; color:#64748b;">
              Email ini dikirim otomatis oleh Kisara SSO, layanan masuk ASN Pemerintah Kabupaten Ponorogo. Mohon tidak membalas email ini.<br />
              Butuh bantuan? <a href="https://rakaca.ponorogo.go.id/bantuan" style="color:#0f8b8d; font-weight:600; text-decoration:none;">rakaca.ponorogo.go.id/bantuan</a><br />
              &copy; ${.now?string('yyyy')} Pemerintah Kabupaten Ponorogo &mdash; Dinas Komunikasi, Informatika dan Statistik
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
</#macro>
