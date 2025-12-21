# 🎾 PlayServe
Aplikasi kami bernama PlayServe, sebuah aplikasi yang dirancang khusus untuk para pemain tenis dengan tambahan elemen _gamification_. Aplikasi akan menyediakan beberapa fitur untuk pemain tenis, mulai dari pengelolaan profil pribadi dengan sistem _rank_ yang disesuaikan dari jumlah kemenangan, pencarian pasangan bermain berdasarkan _rank_ dan radius lokasi, pemesanan lapangan secara _online_, komunitas untuk berbagi informasi, hingga ulasan lapangan yang membantu pemain lain dalam memilih tempat bermain.

## 📑 Daftar Isi
- [Anggota Kelompok](#anggota-kelompok)
- [Modul](#modul)
- [Jenis Pengguna Aplikasi](#jenis-pengguna-aplikasi)
- [Link](#link)

## 👥 Anggota Kelompok
1. Annisa Fakhira Cendekia - 2406354606
2. Deltakristiano Kurniaputra - 2406425810
3. Jonathan Yitskhaq Rundjan - 2406435231
4. Marco Imanuel - 2406411824
5. Muhammad Nadhif Ibrahim - 2406398324

## 📦 Modul

### 1. Profile (Annisa Fakhira Cendekia).
- Informasi dasar seperti _username_, lokasi (_drop-down_), dan media sosial.
- Menyediakan 5 avatar untuk profil.
- _Rank_ pemain yang ditentukan berdasarkan jumlah kemenangan.

### 2. Match Making (Muhammad Nadhif Ibrahim).  
- Algoritma pencocokan berdasarkan _rank_ dan lokasi.
- Rekomendasi otomatis pemain yang sedang mencari partner. Apabila _match_ diterima maka akan diberikan informasi profilnya dan interaksi dapat berlanjut di media sosial masing-masing pemain.

### 3. Booking Lapangan (player) dan Add New Field (admin) (Deltakristiano Kurniaputra).
- Pencarian lapangan berdasarkan lokasi, harga, dan kategori lainnya.
- Kalender ketersediaan lapangan.
- Penambahan lapangan baru oleh admin.

### 4. Community (Jonathan Yitskhaq Rundjan).
- Pencarian komunitas.
- Sistem _post_ dan _reply_ yang dikhususkan untuk anggota komunitas.
- Komunitas dibuat dan dihapus oleh admin.

### 5. Review (Marco Imanuel).
- Sistem _rating_ dengan angka dan komentar.
- Sistem _sorting_ untuk _rating_ dari review.

## 👤 Jenis Pengguna aplikasi
1. Admin untuk menambahkan lapangannya agar dapat reservasi secara _online_. Selain itu, admin dapat menambahkan dan menghapus komunitas ataupun profil _player_ yang melanggar aturan.
2. _Player_, _role_ untuk para pemain tenis. Semua fitur selain Add New Field pada daftar modul dimiliki oleh _player_.


## Alur Pengintegrasian dengan Web Service
1. Aplikasi Django menyediakan REST API yang mengembalikan data dalam format JSON.
2. Flutter mengirim request HTTP ke endpoint API Django menggunakan package seperti `http`.
3. Django memproses request, menjalankan logika bisnis, dan mengambil data dari database.
4. Django mengembalikan respons JSON ke Flutter.
5. Flutter mem-parsing respons tersebut lalu menampilkan hasilnya di UI.

Alur ini memungkinkan aplikasi terhubung dan berinteraksi dengan aplikasi web Django yang telah dibuat sebelumnya.

## 🔗 Link
- [Dataset](https://catalog.data.gov/dataset/tenis-courts)
- [Design](https://www.figma.com/design/Ov2RsMYx9U1vhZXtw1lSY4/UI-UX-WEB?node-id=0-1&t=r3axZEDkETmZLSoK-1)
- [Aplikasi](https://app.bitrise.io/app/faa47591-ce25-453a-a3a1-b6e40ac1cf11/installable-artifacts/11b3a9b306627536/public-install-page/0ad59190567c457c7d6f908317e3c059)
- [Video](https://youtu.be/8o7zU8Cc1ss)
